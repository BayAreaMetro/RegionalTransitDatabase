#be sure to set the project path
PROJECT_PATH <- "C:/projects/RTD/RegionalTransitDatabase"

GTFS_PATH <- paste0(PROJECT_PATH,"/data/05_2017_511_GTFS/",collapse="")
R_HELPER_FUNCTIONS_PATH <- paste0(PROJECT_PATH,"/R/r511.R",collapse="")
source(R_HELPER_FUNCTIONS_PATH)

# if (!require(devtools)) {
#   install.packages('devtools')
# }
# devtools::install_github('ropensci/gtfsr')

library(gtfsr)
library(dplyr)

setwd(GTFS_PATH)

gtfs_obj <- import_gtfs("MA.zip", local=TRUE)

df_sr <- join_all_gtfs_tables(gtfs_obj)
df_sr <- make_arrival_hour_less_than_24(df_sr)

time_start <- "06:00:00"
time_end <- "09:59:00"
am_stops <- filter_by_time(df_sr,
                           time_start,
                           time_end)

am_stops <- remove_duplicate_stops(am_stops) #multiple identical stop time at the same stop
am_stops <- count_trips(am_stops)
am_stops_hdwy <- subset(am_stops,
              am_stops$Headways < 16)
am_routes <- get_routes(am_stops_hdwy)

am_routes <- get_bus_service(am_stops) 
if (!(is.data.frame(am_routes) && nrow(am_routes)==0)){
  am_routes["Peak_Period"] <-"AM Peak"
} else 
{
  am_routes$Peak_Period <-  am_routes$route_id
}

###########################################################################################
# Section 5. Create PM Peak Headways from Weekday Trips
time_start <- "15:00:00"
time_end <- "18:59:00"
pm_stops <- filter_by_time(df_sr,
                           time_start,
                           time_end)
pm_stops <- remove_duplicate_stops(pm_stops) #multiple identical stop time at the same stop
pm_stops <- count_trips(pm_stops)
pm_stops_hdwy <- subset(pm_stops,
              pm_stops$Headways < 16)
pm_routes <- get_routes(pm_stops_hdwy)

if (!(is.data.frame(pm_routes) && nrow(pm_routes)==0)){
  pm_routes["Peak_Period"] <-"PM Peak"
} else 
{
  pm_routes$Peak_Period <-  pm_routes$route_id
}

###########################################################################################
# Section 6. Build Weekday High Frequency Bus Service Dataset

df_rt_hf <- join_high_frequency_routes_to_stops(am_stops,pm_stops,am_routes,pm_routes)

###########################################################################################
# Section 7. Build Weekday High Frequency Bus Service Stops for Route Building using NA Tools

#clear out arrival time--not clear its necessary below and not typed correctly
df_rt_hf$arrival_time <- NULL

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

#Select Distinct Records based upon Agency Route Direction values.  Removes stop ids from output.
df_stp_rt_hf <- group_by(df_stp_rt_hf,
                         agency_id, route_id, direction_id, Route_Pattern_ID,trip_headsign,
                         stop_id, stop_sequence, Total_Trips, Headway, Peak_Period,
                         TPA_Criteria, stop_lon, stop_lat) %>%
  distinct(agency_id, route_id, direction_id, Route_Pattern_ID,
           trip_headsign, stop_id, stop_sequence, Total_Trips,
           Headway, Peak_Period, TPA_Criteria, stop_lon, stop_lat)

#Remove select cols.
df_stp_rt_hf <- df_stp_rt_hf[-c(1:13)]