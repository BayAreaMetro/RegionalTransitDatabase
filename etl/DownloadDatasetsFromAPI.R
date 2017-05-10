library(rvest)
library(leaflet)
library(igraph)
library(VennDiagram)
library(lubridate)
library(readr)
library(gtfsr)
library(magrittr)
library(plyr)
library(dplyr)



#Step 1. Download operator 511 API data and store in local working directory

setwd("~/Documents/MTC/_Section/Planning/Projects/RTD_2017_Data_Processing/data_2017")

#download gtfs feed data
ACTA <- import_gtfs("AC.Zip", local = TRUE)
#> [1] "agency.txt"         "calendar.txt"       "calendar_dates.txt"
#> [4] "routes.txt"         "shapes.txt"         "stop_times.txt"    
#> [7] "stops.txt"          "transfers.txt"      "trips.txt"

ACTA$routes_df
ACTA$stop_times_df
ACTA$stops_df
ACTA$calendar_df

ac<- list(ACTA$stop_times_df,ACTA$trips_df,ACTA$calendar_df,ACTA$routes_df)
Reduce(inner_join,ac) %>%
  group_by(agency_id, stop_id, trip_id, service_id, monday, tuesday, wednesday, thursday, friday, route_id, direction_id, arrival_time, stop_sequence, route_type) %>%
  select(agency_id, stop_id, trip_id, service_id, monday, tuesday, wednesday, thursday, friday, route_id, direction_id, arrival_time, stop_sequence, route_type) %>%
  arrange(agency_id, trip_id, service_id, monday, tuesday, wednesday, thursday, friday, route_id, direction_id, stop_sequence, arrival_time ) -> ac_rtes
rm(ac)