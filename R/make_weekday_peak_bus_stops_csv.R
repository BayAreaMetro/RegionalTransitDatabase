######################
#SET THE PROJECT PATH BEFORE USE
#######################

PROJECT_PATH <- "C:/projects/RTD/RegionalTransitDatabase/"
GTFS_PATH <- paste0(PROJECT_PATH,"data/05_2017_511_GTFS",collapse="")
R_HELPER_FUNCTIONS_PATH <- paste0(PROJECT_PATH,"R/r511.R",collapse="")

#This script builds a RTD dataset using 511 data from the API.
#The data must first be downloaded as zip archives and extracted to the working directory.
library(lubridate)
library(readr)
library(plyr)
library(dplyr)
library(DT)
library(tidyr)
library(stringr)
source(R_HELPER_FUNCTIONS_PATH)

###########################################################################################
# Section 2. Raw GTFS Data Import and Export

# This makes reading data in from text files much more logical.
options(stringsAsFactors = FALSE)

#set working directory for datasets.  This is the path to where the extracted datasets are stored.
#See github repo for more details (https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/tree/master/python)
#Data can be downloaded from this location: https://mtcdrive.box.com/s/pkw8e0ng3n02b47mufaefqz5749cv5nm

options(warn=-1)
df_sr <- load_multiple_gtfs(GTFS_PATH)
options(warn=0)

###########################################################################################
# Section 3. Field Customization and Data Type Handling

# 3C. Update direction_id. 0 = Outbound, 1 = Inbound
df_sr$direction_id[df_sr$direction_id == 0] <- "Outbound"
df_sr$direction_id[df_sr$direction_id == 1] <- "Inbound"

#Review Routes
#View(df_sr)
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
am_stops <- filter_by_time(df_sr,
                           arrival_time_filter,
                           departure_time_filter)
#4B remove duplicates due to multiple entries for the same stop
am_stops <- remove_duplicate_stops(am_stops)

am_routes <- get_bus_service(am_stops)
am_routes["Peak_Period"] <-"AM Peak"

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

#5A Filter Stops
pm_stops <- filter_by_time(df_sr,
                           arrival_time_filter,
                           departure_time_filter)

#5B Remove any duplicates due to multiple entries for the same stop
pm_stops <- remove_duplicate_stops(pm_stops)

pm_routes <- get_bus_service(pm_stops)
pm_routes["Peak_Period"] <-"PM Peak"

###################
#####End PM Processing
###################

###########################################################################################
# Section 6. Build Weekday High Frequency Bus Service Dataset

df_rt_hf <- join_high_frequency_routes_to_stops(am_stops,pm_stops,am_routes,pm_routes)

###########################################################################################
# Section 7. Build Weekday High Frequency Bus Service Stops for Route Building using NA Tools

#arrival_time on df_rt_hf appears to be null and prevents the join below
df_rt_hf$arrival_time <- NULL

#Step 7A.
df<- list(df_sr,df_rt_hf)

df_stp_rt_hf <- Reduce(inner_join,df) %>%
  group_by(agency_id, route_id, direction_id, trip_id,Peak_Period, Route_Pattern_ID,
           trip_headsign, stop_id, stop_sequence, Total_Trips, Headway, Peak_Period,
           TPA_Criteria, stop_lon, stop_lat) %>%
    select(agency_id, route_id, direction_id, trip_id, Route_Pattern_ID,
           trip_headsign, stop_id, stop_sequence, Total_Trips,
           Headway, Peak_Period, TPA_Criteria,
           stop_lon, stop_lat) %>%
      arrange(agency_id, route_id, direction_id,
              trip_id, Peak_Period, stop_sequence)

rm(df)


#Step 7B. Select Distinct Records based upon Agency Route Direction values.  Removes stop ids from output.
df_stp_rt_hf <- group_by(df_stp_rt_hf,
         agency_id, route_id, direction_id, Route_Pattern_ID,trip_headsign,
         stop_id, stop_sequence, Total_Trips, Headway, Peak_Period,
         TPA_Criteria, stop_lon, stop_lat) %>%
  distinct(agency_id, route_id, direction_id, Route_Pattern_ID,
           trip_headsign, stop_id, stop_sequence, Total_Trips,
           Headway, Peak_Period, TPA_Criteria, stop_lon, stop_lat)

# Step 7C. Remove select cols.
df_stp_rt_hf <- df_stp_rt_hf[-c(1:13)]

#Step 7D. Write out to csv table
write.csv(df_stp_rt_hf,file="Weekday_Peak_Bus_Routes_Stops_Builder.csv", row.names=FALSE)

###########################################################################################
# Step 8. Table Cleanup
