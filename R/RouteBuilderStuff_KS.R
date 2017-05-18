# Generate Near Matrix for Transit Stops
# Explore use of R ArcGIS Bridge for this project.
library(readr)
library(gsubfn)
library(stringr)
library(magrittr)
library(dplyr)
require(sqldf)
library(DT)
library(lubridate)
library(foreign)
# This makes reading data in from text files much more logical.
options(stringsAsFactors = FALSE)
setwd("~/Documents/GIS Data/Transit/RTD_2017/Arc/Transit Analysis/gtfs_data")

#Fix bad times in the arrival and departure time fields
stop_times_fix <- read_csv("stop_times.txt", col_types =cols(
  trip_id = col_character(),
  arrival_time = col_character(),
  departure_time = col_character(),
  stop_id = col_character(),
  stop_sequence = col_integer(),
  agency_id = col_character()
))

gsubfn("^24:", "00:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^25:", "01:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^26:", "02:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^27:", "03:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^28:", "04:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^29:", "05:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^30:", "06:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^31:", "07:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^32:", "08:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^33:", "09:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^34:", "10:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^35:", "11:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^36:", "12:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^37:", "13:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^38:", "14:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^39:", "15:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^40:", "16:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^41:", "17:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^42:", "18:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^43:", "19:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^44:", "20:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time

gsubfn("^24:", "00:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^25:", "01:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^26:", "02:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^27:", "03:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^28:", "04:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^29:", "05:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^30:", "06:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^31:", "07:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^32:", "08:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^33:", "09:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^34:", "10:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^35:", "11:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^36:", "12:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^37:", "13:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^38:", "14:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^39:", "15:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^40:", "16:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^41:", "17:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^42:", "18:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^43:", "19:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^44:", "20:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
#Output table fixes
write.csv(stop_times_fix, file="stop_times_fix.txt", row.names=FALSE)
rm(stop_times_fix)
#Import stop_times tbl from repaired output
stop_times <- read_csv("stop_times_fix.txt", col_types =cols(
  trip_id = col_character(),
  arrival_time = col_time(format= "%H:%M:%S"),
  departure_time = col_time(format= "%H:%M:%S"),
  stop_id = col_character(),
  stop_sequence = col_integer(),
  agency_id = col_character()
))

#Import trips tbl
trips <- read_csv("trips.txt", col_types = 
                    cols(
                      route_id = col_character(),
                      service_id = col_integer(),
                      trip_id = col_character(),
                      trip_headsign = col_character(),
                      direction_id = col_integer(),
                      block_id = col_character(),
                      shape_id = col_character(),
                      trip_short_name = col_character(),
                      agency_id = col_character()
                    ))
#Import stops table
stops <- read_csv("stops.txt", col_types = 
                    cols(
                      stop_id = col_character(),
                      stop_name = col_character(),
                      stop_lat = col_double(),
                      stop_lon = col_double(),
                      zone_id = col_character(),
                      agency_id = col_character()
                    ))

#Import routes tbl
routes <- read_csv("routes.txt", col_types = 
                     cols(
                       route_id = col_character(),
                       agency_id = col_character(),
                       route_short_name = col_character(),
                       route_long_name = col_character(),
                       route_type = col_integer(),
                       route_color = col_character(),
                       route_text_color = col_character()
                     ))
#Import calendar tbl
calendar <- read_csv("calendar.txt", col_types = 
                       cols(
                         service_id = col_integer(),
                         monday = col_integer(),
                         tuesday = col_integer(),
                         wednesday = col_integer(),
                         thursday = col_integer(),
                         friday = col_integer(),
                         saturday = col_integer(),
                         sunday = col_integer(),
                         start_date = col_integer(),
                         end_date = col_integer(),
                         agency_id = col_character()
                       ))
#Import agency tbl
agency <- read_csv("agency.txt", col_types = 
                     cols(
                       agency_id = col_character(),
                       agency_name = col_character(),
                       agency_url = col_character(),
                       agency_timezone = col_character(),
                       agency_lang = col_character(),
                       agency_phone = col_double()
                     ))

df<- list(stops,stop_times,trips,calendar,routes)
Reduce(inner_join,df) %>%
  select(agency_id, stop_id, trip_id, service_id, monday, tuesday, wednesday, thursday, friday, route_id, trip_headsign, direction_id, arrival_time, stop_sequence, route_type, stop_lat, stop_lon) %>%
  arrange(agency_id, trip_id, service_id, monday, tuesday, wednesday, thursday, friday, route_id, trip_headsign, direction_id, arrival_time, stop_sequence) -> Route_Pattern_Schedule
rm(df)

#Update direction_id. 0 = Outbound, 1 = Inbound
Route_Pattern_Schedule$direction_id[Route_Pattern_Schedule$direction_id == 0] <- "Outbound"
Route_Pattern_Schedule$direction_id[Route_Pattern_Schedule$direction_id == 1] <- "Inbound"

# Add new column values for distinct Agency, Route, Trip, Service Ids for record count (Not really used)
Route_Pattern_Schedule$Route_Pattern_ID<-paste0(Route_Pattern_Schedule$agency_id,"-",Route_Pattern_Schedule$route_id,"-", Route_Pattern_Schedule$direction_id)

#method to fix time values for comparison
#as.difftime(tim, format= "%H:%M:%S", units="auto")

#All AM Peak Bus Routes
subset(Route_Pattern_Schedule, Route_Pattern_Schedule$monday == 1 
       & Route_Pattern_Schedule$tuesday == 1
       & Route_Pattern_Schedule$wednesday == 1
       & Route_Pattern_Schedule$thursday == 1
       & Route_Pattern_Schedule$friday == 1
       & Route_Pattern_Schedule$route_type == 3
       & Route_Pattern_Schedule$arrival_time > as.difftime("06:00:00", format= "%H:%M:%S", units = "auto") 
       & Route_Pattern_Schedule$arrival_time < as.difftime("09:59:00", format= "%H:%M:%S", units = "auto"))-> AM_Peak_Bus_Routes

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

#All PM Peak Bus Routes
subset(Route_Pattern_Schedule, Route_Pattern_Schedule$monday == 1 
       & Route_Pattern_Schedule$tuesday == 1
       & Route_Pattern_Schedule$wednesday == 1
       & Route_Pattern_Schedule$thursday == 1
       & Route_Pattern_Schedule$friday == 1
       & Route_Pattern_Schedule$route_type == 3
       & Route_Pattern_Schedule$arrival_time > as.difftime("15:00:00", format= "%H:%M:%S", units = "auto") 
       & Route_Pattern_Schedule$arrival_time < as.difftime("18:59:00", format= "%H:%M:%S", units = "auto"))-> PM_Peak_Bus_Routes


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
Weekday_Peak_Bus_Routes_TPA_Listing$arrival_time <- as.character(Weekday_Peak_Bus_Routes_TPA_Listing$arrival_time)

#Build Route Table for High Frequency Bus Service
df<- list(Weekday_High_Frequency_Bus_Service_Review,Route_Builder)
Reduce(inner_join,df) %>%
  select(agency_id, route_id, direction_id, trip_headsign, stop_id, stop_sequence) %>%
  arrange(agency_id, route_id, direction_id, stop_sequence) -> Weekday_Peak_Bus_Routes_Stops
rm(df)

# Remove any duplicates due to multiple entries for the same stop at the same time period.
Weekday_Peak_Bus_Routes_Stops %>%
  distinct(agency_id, route_id, direction_id, trip_headsign, stop_id, stop_sequence)-> Weekday_Peak_Bus_Routes_Stops_Builder


#Create HTML Data Tables
#datatable(Weekday_High_Frequency_Bus_Service_Review)
#datatable(Weekday_Peak_Bus_Routes)
#datatable(Weekday_Peak_Bus_Routes_TPA_Listing)
#Export to table
#write.csv(Weekday_AM_Peak_High_Frequency_Bus_Service, file="Weekday_AM_Peak_High_Frequency_Bus_Service.csv")
#write.csv(Weekday_PM_Peak_High_Frequency_Bus_Service, file="Weekday_PM_Peak_High_Frequency_Bus_Service.csv")


#DF Cleanup
rm(am_peak_hdway)
rm(pm_peak_hdway)
rm(am_peak_hdway_hfbus)
rm(pm_peak_hdway_hfbus)
rm(AM_Peak_Bus_Routes)
rm(PM_Peak_Bus_Routes)
rm(Weekday_AM_Peak_High_Frequency_Bus_Service)
rm(Weekday_PM_Peak_High_Frequency_Bus_Service)
rm(Weekday_High_Frequency_Bus_Service)

#Export Tables for Spatial Analysis.  THanks Tom B. for finding this function.
Route_Pattern_Schedule$arrival_time <- as.character(Route_Pattern_Schedule$arrival_time)
df <- as.data.frame(Route_Pattern_Schedule)
write.dbf(df, "Route_Pattern_Schedule.dbf", factor2char = TRUE, max_nchar = 254)
rm(df)

df <- as.data.frame(agency)
df$agency_phone <- as.character(df$agency_phone)
write.dbf(df, file="agency.dbf", factor2char = TRUE, max_nchar = 254)
rm(df)

df <- as.data.frame(calendar)
write.dbf(df, file="calendar.dbf", factor2char = TRUE, max_nchar = 254)
rm(df)

df<- as.data.frame(routes)
write.dbf(df, file="routes.dbf")
rm(df)

df<- as.data.frame(stop_times)
df$arrival_time <- as.character(df$arrival_time)
df$departure_time <- as.character(df$departure_time)
write.dbf(df, file="stop_times.dbf")
rm(df)

df<- as.data.frame(trips)
write.dbf(df, file="trips.dbf")
rm(df)

df<- as.data.frame(stops)
write.dbf(df, file="stops.dbf")
rm(df)

df<- as.data.frame(Weekday_High_Frequency_Bus_Service_Review)
write.dbf(df, file="Weekday_High_Frequency_Bus_Service_Review.dbf")
rm(df)

df<- as.data.frame(Weekday_Peak_Bus_Routes)
df$arrival_time <- as.character(df$arrival_time)
write.dbf(df, file="Weekday_Peak_Bus_Routes.dbf")
rm(df)
