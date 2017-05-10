#This script builds a RTD dataset using 511 data from the API. 
#The data must first be downloaded as zip archives and extracted to the working directory.
library(lubridate)
library(readr)
library(plyr)
library(dplyr)



#Function to Add Agency_ID for Route
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

setwd("~/Documents/GIS Data/Transit/RTD_2017/gtfs")

## bind all operator tables together
routes = NULL
for (txt in dir(pattern = "routes.txt$",full.names=TRUE,recursive=TRUE)){
  routes = rbind(routes, build_table(txt))
}
write.csv(routes, file="routes.csv", row.names=FALSE)

stops = NULL
for (txt in dir(pattern = "stops.txt$",full.names=TRUE,recursive=TRUE)){
  stops = rbind(stops, build_table(txt))
}
write.csv(stops, file="stops.csv", row.names=FALSE)
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
write.csv(stop_times, file="stop_times.csv", row.names=FALSE)
#rm(stop_times) # drop large dataframe
trips = NULL
for (txt in dir(pattern = "trips.txt$",full.names=TRUE,recursive=TRUE)){
  trips = rbind(trips, build_table(txt))
}
write.csv(trips, file="trips.csv", row.names=FALSE)
calendar = NULL
for (txt in dir(pattern = "calendar.txt$",full.names=TRUE,recursive=TRUE)){
  calendar = rbind(calendar, build_table(txt))
}
write.csv(calendar, file="calendar.csv", row.names=FALSE)

agency = NULL
for (txt in dir(pattern = "agency.txt$",full.names=TRUE,recursive=TRUE)){
  agency = rbind(agency, build_table(txt))
}
write.csv(agency, file="agency.csv", row.names=FALSE)

## Several errors found during table bind due to malformed values.  See errors below.
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
write.csv(shapes, file="shapes.csv", row.names=FALSE)
rm(txt)

#convert character values for arrival time to Date Time class
stop_times$arrival_time <- as.POSIXct(stop_times$arrival_time, format= "%H:%M:%S")
stop_times$departure_time <- as.POSIXct(stop_times$departure_time, format= "%H:%M:%S")


# Join the data together.  Need to verify the join function for these records.  
#The final dataset appears to have dup records for some operator routes.
#Weird Headway values for TriDelta
df<- list(stops,stop_times,trips,calendar,routes)
Reduce(inner_join,df) %>%
  select(agency_id, stop_id, trip_id, service_id, monday, tuesday, wednesday, thursday, friday, route_id, direction_id, arrival_time, stop_sequence, route_type) %>%
  arrange(agency_id, trip_id, service_id, monday, tuesday, wednesday, thursday, friday, route_id, direction_id, arrival_time, stop_sequence) -> rtes
  rm(df)

#Add new column values for distinct Agency, Route, Trip, Service Ids for record count
rtes$Route_Pattern_ID<-paste0(rtes$agency_id,"-",rtes$trip_id,"-", rtes$service_id,"-", rtes$route_id,"-", rtes$direction_id)

# t <- count(rtes, 
#             agency_id, 
#             stop_id, 
#             trip_id, 
#             service_id, 
#             monday, 
#             tuesday,
#             wednesday,
#             thursday, 
#             friday,
#             route_id,
#             direction_id,
#             route_type)



#All Bus Routes
subset(rtes, rtes$monday == 1 
       # & rtes$tuesday == 1 
       # & rtes$wednesday == 1 
       # & rtes$thursday == 1 
       # & rtes$friday == 1 
       & rtes$route_type == 3
       & rtes$arrival_time > "2017-05-10 05:59:00" 
       & rtes$arrival_time < "2017-05-10 09:00:00")-> Monday_AM_Peak_Bus_Routes

#tally trips by route for given time period

#Sql Method
# SELECT      agency_id, agency_name, route_id, direction_id, agency_stop_id, 
# route_type, stop_name, cast(stop_sequence as int) as stop_sequence, 
# stop_lon, stop_lat, COUNT(stop_sequence) AS AM_Peak_Monday_Total_Trips, 
# 240 / COUNT(stop_sequence) AS Monday_AM_Peak_Headway, 
# CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
# into #Monday_AM_Peak_Transit_Stop_Headways
# FROM            route_stop_schedule
# WHERE        (CAST(arrival_time AS time) BETWEEN '06:00:00.0000' AND '09:59:59.0000') AND (Monday = 1)
# GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, route_type, stop_name, stop_sequence, stop_lon, stop_lat 


#R Method
Monday_AM_Peak_Bus_Routes %>% 
  group_by(agency_id, trip_id, service_id, route_id, direction_id, stop_id) %>% 
  count(Route_Pattern_ID) %>% mutate(Headways = round(240/n,0)) -> Monday_AM_Peak_Bus_Headways

#Need to verify the tally method to ensure that the counts of trips by route are accurate

names(Monday_AM_Peak_Bus_Headways)[4]<-"Trips"

#Select High Frequency Bus Service Routes (15 min or better headways)
subset(Monday_AM_Peak_Bus_Headways, Monday_AM_Peak_Bus_Headways$Headways <16)->Monday_AM_Peak_High_Frequency_Bus_Service

#All Mid Day Bus Routes
subset(rtes, rtes$monday == 1 
       # & rtes$tuesday == 1 
       # & rtes$wednesday == 1 
       # & rtes$thursday == 1 
       # & rtes$friday == 1 
       & rtes$route_type == 3
       & rtes$arrival_time > "2017-05-10 06:00:00" 
       & rtes$arrival_time < "2017-05-10 09:59:00")-> Monday_AM_Peak_Bus_Routes

#tally trips by route for given time period
Monday_AM_Peak_Bus_Routes %>% 
  group_by(agency_id, route_id, Route_Pattern_ID) %>% 
  tally() %>% mutate(Headways = round(240/n,0)) -> Monday_AM_Peak_Bus_Headways
#Need to verify the tally method to ensure that the counts of trips by route are accurate

names(Monday_AM_Peak_Bus_Headways)[4]<-"Trips"
#names(Monday_AM_Peak_Bus_Headways)[5]<-"Headways"

#Select High Frequency Bus Service Routes (15 min or better headways)
subset(Monday_AM_Peak_Bus_Headways, Monday_AM_Peak_Bus_Headways$Headways <16)->Monday_AM_Peak_High_Frequency_Bus_Service

#All PM Bus Routes
subset(rtes, rtes$monday == 1 
       #& rtes$tuesday == 1 
       #& rtes$wednesday == 1 
       #& rtes$thursday == 1 
       #& rtes$friday == 1 
       & rtes$route_type == 3
       & rtes$arrival_time > "2017-05-10 15:00:00" 
       & rtes$arrival_time < "2017-05-10 18:59:00")-> Monday_PM_Peak_Bus_Routes

#tally trips by route for given time period
Monday_PM_Peak_Bus_Routes %>% 
  group_by(Route_Pattern_ID) %>%
  tally() -> Monday_PM_Peak_Bus_Trips

Monday_PM_Peak_Bus_Trips <- group_by(Monday_PM_Peak_Bus_Routes,agency_id, route_id, Route_Pattern_ID)

count(Monday_PM_Peak_Bus_Routes, Route_Pattern_ID)

summarise(Monday_PM_Peak_Bus_Trips, )

names(Monday_PM_Peak_Bus_Trips[4])->"Total_Stops"
Monday_PM_Peak_Bus_Trips %>%
  group_by(agency_id, route_id, Route_Pattern_ID) %>%  
  tally() %>% mutate(Headways = round(240/n,0)) -> Monday_PM_Peak_Bus_Headways

#Need to verify the tally method to ensure that the counts of trips by route are accurate

names(Monday_PM_Peak_Bus_Headways)[4]<-"Trips"
names(Monday_PM_Peak_Bus_Headways)[5]<-"Headways"

#Select High Frequency Bus Service Routes (15 min or better headways)
subset(Monday_PM_Peak_Bus_Headways, Monday_PM_Peak_Bus_Headways$Headways <16)->Monday_PM_Peak_High_Frequency_Bus_Service
