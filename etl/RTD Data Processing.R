#This script builds a RTD dataset using 511 data from the API. 
#The data must first be downloaded as zip archives and extracted to the working directory.
#Check your packages to ensure that these libraries are available.  Install them if needed.
library(lubridate)
library(readr)
library(plyr)
library(dplyr)
library(DT)
library(tidyr)
library(stringr)

#Function to Add Agency_ID for Route.  Author: Tom Buckley
build_table <- function(some_path, col_names=TRUE, col_types=NULL) {
  operator_df = read_csv(some_path, col_names, col_types)
  operator_prefix <- strsplit(some_path, "/")[[1]][2]
  x <- vector(mode="character", length=nrow(operator_df))
  x[1:length(x)] = operator_prefix
  operator_df["agency_id"] <- operator_prefix
  return(operator_df)
}


# This makes reading data in from text files much more logical.
options(stringsAsFactors = FALSE)

#set working directory for datasets.  This is the path to where the extracted datasets are stored.
#See github repo for more details (https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/tree/master/python)
#Data can be downloaded from this location: https://mtcdrive.box.com/s/pkw8e0ng3n02b47mufaefqz5749cv5nm

# Set workspace where gtfs datasets are stored.  These datasets shoud have the txt file extension.
setwd("~/Documents/MTC/_Section/Planning/Projects/rtd_2017/REGION/data_2017")

## bind all operator tables together
routes = NULL
for (txt in dir(pattern = "routes.txt$",full.names=TRUE,recursive=TRUE)){
  routes = rbind(routes, build_table(txt))
}
#write.csv(routes, file="routes.csv", row.names=FALSE)

stops = NULL
for (txt in dir(pattern = "stops.txt$",full.names=TRUE,recursive=TRUE)){
  stops = rbind(stops, build_table(txt))
}
#write.csv(stops, file="stops.csv", row.names=FALSE)
#rm(stops) # drop large dataframe
stop_times = NULL
##Need to check values for stop_times to adjust time values for records that are greater than the 24 hour clock
## See errors listed in this link: file:///Users/ksmith/Documents/GIS%20Data/Transit/RTD_2017/R%20Scripts/rtd_2017.html.  Fix should be included in loop
for (txt in dir(pattern = "stop_times.txt$",full.names=TRUE,recursive=TRUE)){
  
  stop_times = rbind(stop_times, build_table(txt, col_types= 
                                               cols(
                                                 trip_id = col_character(),
                                                 arrival_time = col_character(),
                                                 departure_time = col_character(),
                                                 stop_id = col_character(),
                                                 stop_sequence = col_integer())))
}
#write.csv(stop_times, file="stop_times.csv", row.names=FALSE)
#rm(stop_times) # drop large dataframe
trips = NULL
for (txt in dir(pattern = "trips.txt$",full.names=TRUE,recursive=TRUE)){
  trips = rbind(trips, build_table(txt))
}
#write.csv(trips, file="trips.csv", row.names=FALSE)
calendar = NULL
for (txt in dir(pattern = "calendar.txt$",full.names=TRUE,recursive=TRUE)){
  calendar = rbind(calendar, build_table(txt))
}
#write.csv(calendar, file="calendar.csv", row.names=FALSE)

agency = NULL
for (txt in dir(pattern = "agency.txt$",full.names=TRUE,recursive=TRUE)){
  agency = rbind(agency, build_table(txt))
}
#write.csv(agency, file="agency.csv", row.names=FALSE)

shapes = NULL
for (txt in dir(pattern = "shapes.txt$",full.names=TRUE,recursive=TRUE)){
  shapes = rbind(shapes, build_table(txt, col_types =
                                       cols(
                                         shape_id = col_character(),
                                         shape_pt_lon = col_double(),
                                         shape_pt_lat = col_double(),
                                         shape_pt_sequence = col_integer(),
                                         shape_dist_traveled = col_double())))
}
#write.csv(shapes, file="shapes.csv", row.names=FALSE)
rm(txt)

# Convert character values for arrival time to Date Time class
stop_times$arrival_time <- as.POSIXct(stop_times$arrival_time, format= "%H:%M:%S")
stop_times$departure_time <- as.POSIXct(stop_times$departure_time, format= "%H:%M:%S")

# Note: When running this script, be sure to change the filter date for arrival_time.
# See Sections 'All Monday AM Peak Bus Routes', 'All Monday PM Peak Bus Routes', 'All AM Peak Bus Routes', 'All PM Peak Bus Routes'

# Join the data together.  Need to verify the join function for these records.  
df<- list(stops,stop_times,trips,calendar,routes)
Reduce(inner_join,df) %>%
  select(agency_id, stop_id, trip_id, service_id, monday, tuesday, wednesday, thursday, friday, route_id, trip_headsign, direction_id, arrival_time, stop_sequence, route_type) %>%
  arrange(agency_id, trip_id, service_id, monday, tuesday, wednesday, thursday, friday, route_id, trip_headsign, direction_id, arrival_time, stop_sequence) -> rtes
rm(df)

#Update direction_id. 0 = Outbound, 1 = Inbound
rtes$direction_id[rtes$direction_id == 0] <- "Outbound"
rtes$direction_id[rtes$direction_id == 1] <- "Inbound"

# Add new column values for distinct Agency, Route, Trip, Service Ids for record count (Not really used)
rtes$Route_Pattern_ID<-paste0(rtes$agency_id,"-",rtes$route_id,"-", rtes$direction_id)

# Create Headways from Weekday Trips

#All AM Peak Bus Routes
subset(rtes, rtes$monday == 1 
       & rtes$tuesday == 1
       & rtes$wednesday == 1
       & rtes$thursday == 1
       & rtes$friday == 1
       & rtes$route_type == 3
       & rtes$arrival_time > "2017-05-12 06:00:00" 
       & rtes$arrival_time < "2017-05-12 09:59:00")-> AM_Peak_Bus_Routes

# Remove any duplicates due to multiple entries for the same stop at the same time period.
AM_Peak_Bus_Routes %>%
  distinct(agency_id, route_id, direction_id, trip_headsign, stop_id, stop_sequence, arrival_time) %>%
  arrange(agency_id, route_id, direction_id,arrival_time,stop_sequence)->AM_Peak_Bus_Routes

#count trips by route for given time period
AM_Peak_Bus_Routes %>% 
  group_by(agency_id, route_id, direction_id, trip_headsign, stop_id) %>% 
  count(stop_sequence) %>% mutate(Headways = round(240/n,0)) -> am_peak_hdway

#rename count col. (n) to Trips
names(am_peak_hdway)[6]<-"Trips"

#Select High Frequency Bus Service Routes (15 min or better headways)
subset(am_peak_hdway, am_peak_hdway$Headways <16) -> am_peak_hdway_hfbus

#Select Distinct Records based upon Agency Route Direction values.  Removes stop ids from output.
group_by(am_peak_hdway_hfbus, agency_id, route_id, direction_id,trip_headsign) %>%
  mutate(Total_Trips = round(mean(Trips),0), Headway = round(mean(Headways),0)) %>%
  distinct(agency_id, route_id, direction_id, trip_headsign, Total_Trips, Headway) -> Weekday_AM_Peak_High_Frequency_Bus_Service

#Add Peak_Period Class to DF
Weekday_AM_Peak_High_Frequency_Bus_Service["Peak_Period"] <-"AM Peak"

#Drop Duplicate Columns from DF
Weekday_AM_Peak_High_Frequency_Bus_Service <- Weekday_AM_Peak_High_Frequency_Bus_Service[-c(7:9)]

#DF Cleanup
rm(am_peak_hdway)
rm(am_peak_hdway_hfbus)
#rm(AM_Peak_Bus_Routes)

#All PM Bus Routes
subset(rtes, rtes$monday == 1 
       & rtes$tuesday == 1
       & rtes$wednesday == 1
       & rtes$thursday == 1
       & rtes$friday == 1
       & rtes$route_type == 3
       & rtes$arrival_time > "2017-05-12 15:00:00" 
       & rtes$arrival_time < "2017-05-12 18:59:00")-> PM_Peak_Bus_Routes

# Remove any duplicates due to multiple entries for the same stop at the same time period.
PM_Peak_Bus_Routes %>%
  distinct(agency_id, route_id, direction_id, trip_headsign,stop_id, stop_sequence, arrival_time) %>%
  arrange(agency_id, route_id, direction_id,trip_headsign,arrival_time,stop_sequence)->PM_Peak_Bus_Routes

#count trips by route for given time period
PM_Peak_Bus_Routes %>% 
  group_by(agency_id, route_id, direction_id, trip_headsign,stop_id) %>% 
  count(stop_sequence) %>% mutate(Headways = round(240/n,0)) -> pm_peak_hdway

#rename count col. (n) to Trips
names(pm_peak_hdway)[6]<-"Trips"

#Select High Frequency Bus Service Routes (15 min or better headways)
subset(pm_peak_hdway, pm_peak_hdway$Headways <16) -> pm_peak_hdway_hfbus

#Select Distinct Records based upon Agency Route Direction values.  Removes stop ids from output.
group_by(pm_peak_hdway_hfbus, agency_id, route_id, trip_headsign,direction_id) %>%
  mutate(Total_Trips = round(mean(Trips),0), Headway = round(mean(Headways),0)) %>%
  distinct(agency_id, route_id, direction_id, trip_headsign,Total_Trips, Headway) -> Weekday_PM_Peak_High_Frequency_Bus_Service

#Add Peak_Period Class to DF
Weekday_PM_Peak_High_Frequency_Bus_Service["Peak_Period"] <-"PM Peak"

#Drop Duplicate Columns from DF
Weekday_PM_Peak_High_Frequency_Bus_Service <- Weekday_PM_Peak_High_Frequency_Bus_Service[-c(7:9)]

# Add column values for distinct Agency, Route, Direction and Peak Period for record count
Weekday_AM_Peak_High_Frequency_Bus_Service$Route_Pattern_ID<-paste0(Weekday_AM_Peak_High_Frequency_Bus_Service$agency_id,"-",Weekday_AM_Peak_High_Frequency_Bus_Service$route_id,"-", Weekday_AM_Peak_High_Frequency_Bus_Service$Peak_Period)
Weekday_PM_Peak_High_Frequency_Bus_Service$Route_Pattern_ID<-paste0(Weekday_PM_Peak_High_Frequency_Bus_Service$agency_id,"-",Weekday_PM_Peak_High_Frequency_Bus_Service$route_id,"-", Weekday_PM_Peak_High_Frequency_Bus_Service$Peak_Period)

#DF Cleanup
rm(pm_peak_hdway_hfbus)
rm(pm_peak_hdway)
#rm(PM_Peak_Bus_Routes)

#Combine Weekday High Frequency Bus Service Data Frames for AM/PM Peak Periods
rbind(Weekday_AM_Peak_High_Frequency_Bus_Service,Weekday_PM_Peak_High_Frequency_Bus_Service) %>%
  arrange(Route_Pattern_ID) -> Weekday_High_Frequency_Bus_Service

#Count number of routes that operate in both directions during peak periods.
#TPA_Criteria = 2 or 3 then Route operates in both directions during peak periods
#TPA Criteria = 1 possible loop route or route only operates in ection during peak periods.

Total_By_Direction <- Weekday_High_Frequency_Bus_Service %>%
  group_by(agency_id, route_id, Peak_Period, Route_Pattern_ID) %>%
  summarise(TPA_Criteria = n())

#Join Total By Direction with Weekday High Frequency Bus Service tables to flag those routes that meet the criteria.
df<- list(Weekday_High_Frequency_Bus_Service,Total_By_Direction)
Reduce(inner_join,df) %>%
  select(agency_id, route_id, direction_id, trip_headsign,Total_Trips, Headway, Peak_Period, TPA_Criteria) %>%
  arrange(agency_id, route_id, direction_id, Peak_Period) -> Weekday_High_Frequency_Bus_Service_Review
rm(df)

#Update values in TPA Criteria field. 2,3 = Meets Criteria, 1 = Review for Acceptance
Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria[Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria==3] <- "Meets TPA Criteria"
Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria[Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria==2] <- "Meets TPA Criteria"
Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria[Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria==1] <- "Does Not Meet TPA Criteria"
#Update values in TPA Criteria field.  All Loops in AM/PM Peak periods that have 15 mins or better headways = Meets TPA Criteria
Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria[grepl('loop', Weekday_High_Frequency_Bus_Service_Review$trip_headsign, ignore.case = TRUE)] <- "Meets TPA Criteria"


#Combine Peak Period Route Data Frames for AM/PM Peak Periods. This is only for review.
#Add Column for Peak Period Class
AM_Peak_Bus_Routes["Peak_Period"] <-"AM Peak"
PM_Peak_Bus_Routes["Peak_Period"] <-"PM Peak"

#This is the full schedule for all bus routes during the Peak Period
rbind(AM_Peak_Bus_Routes,PM_Peak_Bus_Routes) %>%
  arrange(agency_id, route_id, direction_id,arrival_time,stop_sequence) -> Weekday_Peak_Bus_Routes

#Join Weekday_Peak_Bus_Routes with Weekday_High_Frequency_Bus_Service_Review
df<- list(Weekday_Peak_Bus_Routes,Weekday_High_Frequency_Bus_Service_Review)
Reduce(inner_join,df) %>%
  select(agency_id, route_id, direction_id, trip_headsign, stop_id, stop_sequence, arrival_time, Total_Trips, Headway, Peak_Period, TPA_Criteria) %>%
  arrange(agency_id, route_id, direction_id, Peak_Period, arrival_time, stop_sequence ) -> Weekday_Peak_Bus_Routes_TPA_Listing
rm(df)

#Reformat arrival_time col. to hour | min format prior to export to Data Table.
Weekday_Peak_Bus_Routes_TPA_Listing$arrival_time <- strftime(Weekday_Peak_Bus_Routes_TPA_Listing$arrival_time, format = "%H:%M")

#Create HTML Data Tables
#datatable(Weekday_High_Frequency_Bus_Service_Review)
#datatable(Weekday_Peak_Bus_Routes)
#datatable(Weekday_Peak_Bus_Routes_TPA_Listing)
#Export to table
#write.csv(Weekday_AM_Peak_High_Frequency_Bus_Service, file="Weekday_AM_Peak_High_Frequency_Bus_Service.csv")
#write.csv(Weekday_PM_Peak_High_Frequency_Bus_Service, file="Weekday_PM_Peak_High_Frequency_Bus_Service.csv")
