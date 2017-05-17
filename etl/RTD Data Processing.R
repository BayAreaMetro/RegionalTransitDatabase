#This script builds a RTD dataset using 511 data from the API. 
#The data must first be downloaded as zip archives and extracted to the working directory.
library(lubridate)
library(readr)
library(plyr)
library(dplyr)
library(DT)
library(tidyr)
library(stringr)
###########################################################################################
# Section 1. Functions

#Add Agency_ID for Route.  Author: Tom Buckley
build_table <- function(some_path, col_names=TRUE, col_types=NULL) {
  operator_df = read_csv(some_path, col_names, col_types)
  operator_prefix <- strsplit(some_path, "/")[[1]][2]
  x <- vector(mode="character", length=nrow(operator_df))
  x[1:length(x)] = operator_prefix
  operator_df["agency_id"] <- operator_prefix
  return(operator_df)
}

######################
##Begin Common Bus Route Frequency Functions
######################

filter_by_time <- function(rt_df, start_filter,end_filter) {
  subset(rt_df, rt_df$monday == 1 
         & rt_df$tuesday == 1
         & rt_df$wednesday == 1
         & rt_df$thursday == 1
         & rt_df$friday == 1
         & rt_df$route_type == 3
         & rt_df$arrival_time >start_filter
         & rt_df$arrival_time < end_filter)-> rt_df_out
  return(rt_df_out)
}

remove_duplicate_stops <- function(rt_df){
  rt_df %>%
    distinct(agency_id, route_id, direction_id, 
             trip_headsign, stop_id, stop_sequence, arrival_time) %>%
    arrange(agency_id, route_id, direction_id,
            arrival_time,stop_sequence)->rt_df_out
  return(rt_df_out)
}

count_trips_by_route <- function(rt_df) {
  rt_df %>% 
    group_by(agency_id, 
             route_id, 
             direction_id, 
             trip_headsign, 
             stop_id) %>% 
    count(stop_sequence) %>% 
    mutate(Headways = round(240/n,0)) -> 
    rt_df_out
  return(rt_df_out)
}

select_distinct_on_agency_route_direction <- function(rt_df) {
  group_by(rt_df, 
           agency_id, 
           route_id, 
           direction_id,
           trip_headsign) %>%
    mutate(Total_Trips = round(mean(Trips),0), 
           Headway = round(mean(Headways),0)) %>%
    distinct(agency_id, 
             route_id, 
             direction_id, 
             trip_headsign, 
             Total_Trips, 
             Headway) -> 
    rt_df_out
  return(rt_df_out)
}

get_bus_service <- function(df_in,max_hdwy=16) {
  #4C
  df2 <- count_trips_by_route(df_in)
  
  #4D Rename count col. (n) to Trips
  names(df2)[6]<-"Trips"
  
  #4E Select High Frequency Bus Service Routes (15 min or better headways)
  df3 <- subset(df2, 
                df2$Headways < max_hdwy) 
  
  #4F Select Distinct Records based upon Agency Route Direction values.  Removes stop ids from output.
  df_out <- select_distinct_on_agency_route_direction(df3)
  
  #4G Add Peak_Period Column
  df_out["Peak_Period"] <-"AM Peak"
  
  #4H Drop Duplicate Columns from DF
  df_out <- df_out[-c(7:9)]
  return(df_out)
}

######################
##End Common Route Frequency Functions
######################

######################
##Begin Common ETL Functions
######################c

load_multiple_gtfs <- function(gtfs_data_path="~/Documents/MTC/_Section/Planning/Projects/rtd_2017/REGION/data_2017") {

  #Set workspace where gtfs datasets are stored.  These datasets shoud have the txt file extension.
  setwd(gtfs_data_path)
  
  ## 2A. Bind all operator tables together. Append Agency_ID column to each GTFS Table,
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
  
  stop_times$arrival_time <- as.POSIXct(stop_times$arrival_time, format= "%H:%M:%S")
  stop_times$departure_time <- as.POSIXct(stop_times$departure_time, format= "%H:%M:%S")
  routes_joined <- reduce_to_rtes(stops,stop_times,trips,calendar,routes)
  return(routes_joined)
}

reduce_to_rtes <- function(stops,stop_times,trips,calendar,routes) {
  # 3B. Join the data together.  Need to verify the join function for these records.  
  df<- list(stops,stop_times,trips,calendar,routes)
  Reduce(inner_join,df) %>%
    select(agency_id, stop_id, trip_id, service_id, 
           monday, tuesday, wednesday, thursday, friday, 
           route_id, trip_headsign, direction_id, 
           arrival_time, stop_sequence, 
           route_type, stop_lat, stop_lon) %>%
    arrange(agency_id, trip_id, service_id, 
            monday, tuesday, wednesday, thursday, friday, 
            route_id, trip_headsign, direction_id, 
            arrival_time, stop_sequence) -> df_sr
  #clean up source data
  rm(df)
  return(df_sr)
}

######################
##End Common ETL Functions
######################

###########################################################################################
# Section 2. Raw GTFS Data Import and Export

# This makes reading data in from text files much more logical.
options(stringsAsFactors = FALSE)

#set working directory for datasets.  This is the path to where the extracted datasets are stored.
#See github repo for more details (https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/tree/master/python)
#Data can be downloaded from this location: https://mtcdrive.box.com/s/pkw8e0ng3n02b47mufaefqz5749cv5nm  

df_sr <- load_multiple_gtfs(getwd())

###########################################################################################
# Section 3. Field Customization and Data Type Handling

# 3C. Update direction_id. 0 = Outbound, 1 = Inbound
df_sr$direction_id[rtes$direction_id == 0] <- "Outbound"
df_sr$direction_id[rtes$direction_id == 1] <- "Inbound"

# 3D. Add new column values for distinct Agency, Route, Trip, Service Ids for record count (Not really used)
df_sr$Route_Pattern_ID<-
  paste0(rtes$agency_id,"-",
         rtes$route_id,"-", 
         rtes$direction_id)

#Review Routes
#View(rtes)
#write.csv(rtes, file="Route_Pattern_Stop_Schedule.csv", row.names=FALSE)


###########################################################################################
# Section 4. Create AM Peak Headways from Weekday Trips

######################
##Begin AM Processing
######################

arrival_time_filter <- paste(c(format(Sys.Date(), "%Y-%m-%d"),
                               "06:00:00"),collapse=" ")
departure_time_filter <- paste(c(format(Sys.Date(), "%Y-%m-%d"),
                                 "09:59:00"),collapse=" ")

#4A Filter Stops to AM Peak Bus Routes
AM_Peak_Bus_Routes <- filter_by_time(df_sr,
                                     arrival_time_filter,
                                     departure_time_filter)
#4B remove duplicates due to multiple entries for the same stop
AM_Peak_Bus_Routes <- remove_duplicate_stops(AM_Peak_Bus_Routes)

Weekday_AM_Peak_High_Frequency_Bus_Service <- 
  get_bus_service(AM_Peak_Bus_Routes)

#4I DF Cleanup
rm(arrival_time_filter)
rm(departure_time_filter)

###################
#####End AM Processing
###################

###########################################################################################
# Section 5. Create PM Peak Headways from Weekday Trips

arrival_time_filter <- paste0(c(format(Sys.Date(), "%Y-%m-%d"),
                                "15:00:00"),collapse=" ")

departure_time_filter <- paste(c(format(Sys.Date(), "%Y-%m-%d"),
                                 "18:59:00"),collapse=" ")

#4A Filter Stops 
PM_Peak_Bus_Routes <- filter_by_time(df_sr,
                                     arrival_time_filter,
                                     departure_time_filter)

#4B Remove any duplicates due to multiple entries for the same stop
PM_Peak_Bus_Routes <- remove_duplicate_stops(PM_Peak_Bus_Routes)

Weekday_PM_Peak_High_Frequency_Bus_Service <- 
  get_bus_service(PM_Peak_Bus_Routes)

###################
#####End PM Processing
###################

# 5H-1. Add column values for distinct Agency, Route, Direction and Peak Period for record count
Weekday_AM_Peak_High_Frequency_Bus_Service$Route_Pattern_ID<-paste0(Weekday_AM_Peak_High_Frequency_Bus_Service$agency_id,"-",Weekday_AM_Peak_High_Frequency_Bus_Service$route_id,"-", Weekday_AM_Peak_High_Frequency_Bus_Service$Peak_Period)
Weekday_PM_Peak_High_Frequency_Bus_Service$Route_Pattern_ID<-paste0(Weekday_PM_Peak_High_Frequency_Bus_Service$agency_id,"-",Weekday_PM_Peak_High_Frequency_Bus_Service$route_id,"-", Weekday_PM_Peak_High_Frequency_Bus_Service$Peak_Period)

###########################################################################################
# Section 6. Build Weekday High Frequency Bus Service Dataset

# 6A. Combine Weekday High Frequency Bus Service Data Frames for AM/PM Peak Periods
rbind(Weekday_AM_Peak_High_Frequency_Bus_Service,Weekday_PM_Peak_High_Frequency_Bus_Service) %>%
  arrange(Route_Pattern_ID) -> Weekday_High_Frequency_Bus_Service

# 6B. Count number of routes that operate in both directions during peak periods.
      #TPA_Criteria = 2 or 3 then Route operates in both directions during peak periods
      #TPA Criteria = 1 possible loop route or route only operates in ection during peak periods.

Total_By_Direction <- Weekday_High_Frequency_Bus_Service %>%
  group_by(agency_id, route_id, Peak_Period, Route_Pattern_ID) %>%
  summarise(TPA_Criteria = n())

# 6C. Join Total By Direction with Weekday High Frequency Bus Service tables to flag those routes that meet the criteria.
df<- list(Weekday_High_Frequency_Bus_Service,Total_By_Direction)
Reduce(inner_join,df) %>%
  select(agency_id, route_id, direction_id, trip_headsign,Total_Trips, Headway, Peak_Period, TPA_Criteria) %>%
  arrange(agency_id, route_id, direction_id, Peak_Period) -> Weekday_High_Frequency_Bus_Service_Review
rm(df)

# 6D. Update values in TPA Criteria field. 2,3 = Meets Criteria, 1 = Review for Acceptance
Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria[Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria==3] <- "Meets TPA Criteria"
Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria[Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria==2] <- "Meets TPA Criteria"
Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria[Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria==1] <- "Does Not Meet TPA Criteria"
  # 6D-1. Update values in TPA Criteria field.  All Loops in AM/PM Peak periods that have 15 mins or better headways = Meets TPA Criteria
  Weekday_High_Frequency_Bus_Service_Review$TPA_Criteria[grepl('loop', Weekday_High_Frequency_Bus_Service_Review$trip_headsign, ignore.case = TRUE)] <- "Meets TPA Criteria"


# 6E. Add Column for Peak Period Class
AM_Peak_Bus_Routes["Peak_Period"] <-"AM Peak"
PM_Peak_Bus_Routes["Peak_Period"] <-"PM Peak"

# 6F. Build full schedule for all bus routes during the Peak Period
rbind(AM_Peak_Bus_Routes,PM_Peak_Bus_Routes) %>%
  arrange(agency_id, route_id, direction_id,arrival_time,stop_sequence) -> Weekday_Peak_Bus_Routes

# 6G. Join Weekday_Peak_Bus_Routes with Weekday_High_Frequency_Bus_Service_Review to generate a stop schedule for all AM/PM Peak Period stops that have headways of 15 mins. or better.
df<- list(Weekday_Peak_Bus_Routes,Weekday_High_Frequency_Bus_Service_Review)
Reduce(inner_join,df) %>%
  select(agency_id, route_id, direction_id, trip_headsign, stop_id, stop_sequence, arrival_time, Total_Trips, Headway, Peak_Period, TPA_Criteria) %>%
  arrange(agency_id, route_id, direction_id, Peak_Period, arrival_time, stop_sequence ) -> Weekday_Peak_Bus_Routes_TPA_Listing
rm(df)
  # 6G-1. Reformat arrival_time col. to hour | min format prior to export to Data Table.
  Weekday_Peak_Bus_Routes_TPA_Listing$arrival_time <- strftime(Weekday_Peak_Bus_Routes_TPA_Listing$arrival_time, format = "%H:%M")

# 6H. Create HTML Data Tables and export datasets for review by PMs
#datatable(Weekday_High_Frequency_Bus_Service_Review)
#datatable(Weekday_Peak_Bus_Routes)
#datatable(Weekday_Peak_Bus_Routes_TPA_Listing)
#Export to table
#write.csv(Weekday_AM_Peak_High_Frequency_Bus_Service, file="Weekday_AM_Peak_High_Frequency_Bus_Service.csv")
#write.csv(Weekday_PM_Peak_High_Frequency_Bus_Service, file="Weekday_PM_Peak_High_Frequency_Bus_Service.csv")

###########################################################################################
# Section 7. Build Weekday High Frequency Bus Service Stops for Route Building using NA Tools
  
  
#Step 7A.
df<- list(rtes,Weekday_High_Frequency_Bus_Service_Review)
Reduce(inner_join,df) %>%
  group_by(agency_id, route_id, direction_id, trip_id,Peak_Period, Route_Pattern_ID,trip_headsign, stop_id, stop_sequence, Total_Trips, Headway, Peak_Period, TPA_Criteria, stop_lon, stop_lat) %>%
  select(agency_id, route_id, direction_id, trip_id, Route_Pattern_ID, trip_headsign, stop_id, stop_sequence, Total_Trips, Headway, Peak_Period, TPA_Criteria, stop_lon, stop_lat) %>%
  arrange(agency_id, route_id, direction_id, trip_id, Peak_Period, stop_sequence ) -> Weekday_Peak_Bus_Routes_Stops_Builder
rm(df)

#Step 7B. Select Distinct Records based upon Agency Route Direction values.  Removes stop ids from output.
group_by(Weekday_Peak_Bus_Routes_Stops_Builder, agency_id, route_id, direction_id, Route_Pattern_ID,trip_headsign, stop_id, stop_sequence, Total_Trips, Headway, Peak_Period, TPA_Criteria, stop_lon, stop_lat) %>%
  distinct(agency_id, route_id, direction_id, Route_Pattern_ID,trip_headsign, stop_id, stop_sequence, Total_Trips, Headway, Peak_Period, TPA_Criteria, stop_lon, stop_lat) -> Weekday_Peak_Bus_Routes_Stops_Builder

# Step 7C. Remove select cols.
Weekday_Peak_Bus_Routes_Stops_Builder <- Weekday_Peak_Bus_Routes_Stops_Builder[-c(1:13)]

#Step 7D. Write out to csv table
write.csv(Weekday_Peak_Bus_Routes_Stops_Builder,file="Weekday_Peak_Bus_Routes_Stops_Builder.csv", row.names=FALSE)

###########################################################################################
# Step 8. Table Cleanup
rm(rtes)
rm(AM_Peak_Bus_Routes)
rm(PM_Peak_Bus_Routes)
rm(Weekday_High_Frequency_Bus_Service)
