PROJECT_PATH <- getwd() #assumes your working directory is just the root of the RegionalTransitDatabase git folder
GTFS_PATH <- paste0(PROJECT_PATH,"/data/05_2017_511_GTFS/AC.zip",collapse="")
R_HELPER_FUNCTIONS_PATH <- paste0(PROJECT_PATH,"/R/r511.R",collapse="")
source(R_HELPER_FUNCTIONS_PATH)

# if (!require(devtools)) {
#   install.packages('devtools')
# }
# devtools::install_github('ropensci/gtfsr')

library(gtfsr)
library(dplyr)

gtfs_obj <- import_gtfs(GTFS_PATH, local=TRUE)

df_sr <- get_stops_by_route(gtfs_obj)

df_sr <- fix_arrival_time(df_sr)

df_sr$direction_id[df_sr$direction_id == 0] <- "Outbound"
df_sr$direction_id[df_sr$direction_id == 1] <- "Inbound"

time_start <- paste(c(format(Sys.Date(), "%Y-%m-%d"),
                      "06:00:00"),collapse=" ")
time_end <- paste(c(format(Sys.Date(), "%Y-%m-%d"),
                    "09:59:00"),collapse=" ")

#4A Filter Stops to AM Peak Bus Routes
am_stops <- filter_by_time(df_sr,
                           time_start,
                           time_end)

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

time_start <- paste0(c(format(Sys.Date(), "%Y-%m-%d"),
                       "15:00:00"),collapse=" ")

time_end <- paste(c(format(Sys.Date(), "%Y-%m-%d"),
                    "18:59:00"),collapse=" ")

#5A Filter Stops
pm_stops <- filter_by_time(df_sr,
                           time_start,
                           time_end)

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
