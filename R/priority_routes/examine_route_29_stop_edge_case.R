PROJECT_PATH <- "C:/projects/RTD/RegionalTransitDatabase"

GTFS_PATH <- paste0(PROJECT_PATH,"/data/gtfs_interpolated_05_01_2017/",collapse="")
R_HELPER_FUNCTIONS_PATH <- paste0(PROJECT_PATH,"/R/r511.R",collapse="")
source(R_HELPER_FUNCTIONS_PATH)
CREDENTIALS_PATH <- paste0(PROJECT_PATH,"/credentials.R",collapse="") 

library(gtfsr)
library(dplyr)
library(rgeos)
library(reshape2)
library(sp)

setwd(GTFS_PATH)

provider <- "SF"
zip_path <- paste0(GTFS_PATH,provider,".zip",collapse="")
gtfs_obj <- import_gtfs(zip_path,local=TRUE)

df_sr <- join_all_gtfs_tables(gtfs_obj)

df_sr$arrival_time <- make_hour_less_than_24(df_sr$arrival_time)

#flag key tpa variables on the stops
df_sr$f_weekday <- is_weekday(df_sr)
df_sr$f_bus_stop <-  df_sr$route_type == 3
df_sr$f_am_peak <- is_in_time_period(df_sr$arrival_time,"06:00:00","09:59:00")
df_sr$f_pm_peak <- is_in_time_period(df_sr$arrival_time, "15:00:00","18:59:00")

b1 <- df_sr$f_weekday &
      df_sr$f_bus_stop &
      df_sr$f_am_peak

am_stops <- df_sr[b1,]

#check on stop with 2 am entries
table(am_stops[am_stops$stop_id==16557 & am_stops$f_am_peak==TRUE,]$stop_sequence)
#confirmed that there are 2 sequences in this subset. 
#given that we are doing a distinct operation on stop sequence this might result in another entry
#for this stop--do we drop it? why do we need a distinct on sequence_id?
#why is there one?

am_stops[am_stops$stop_id==16557 & am_stops$f_am_peak==TRUE & am_stops$stop_sequence==27,]
#a look at the sfmta schedule for this route (29) shows that a few trips in the early am skip stops

# tripcount <- count_trips(am_stops[am_stops$stop_id==16557 & am_stops$f_am_peak==TRUE,])
# agency_id route_id direction_id  trip_headsign stop_id f_am_peak f_pm_peak stop_sequence Trips Headways
# <chr>    <chr>        <int>          <chr>   <chr>     <lgl>     <lgl>         <int> <int>    <dbl>
#   1        SF       29            1    Baker Beach   16557      TRUE     FALSE            27     2      120
#   2        SF       29            1    Baker Beach   16557      TRUE     FALSE            62    24       10
#   3        SF       29            1 Noriega Street   16557      TRUE     FALSE            62     4       60

#if we drop the stop_sequence from the count() in the count_trips() function then 
#it counts trips for the route regardless of the stop sequence--this might be a good option
#since it then represents the stops by that route at that stop regardless of any skipping at
#other stops
#agency_id route_id direction_id  trip_headsign stop_id f_am_peak f_pm_peak Trips Headways
#<chr>    <chr>        <int>          <chr>   <chr>     <lgl>     <lgl> <int>    <dbl>
#  1        SF       29            1    Baker Beach   16557      TRUE     FALSE    26        9
#  2        SF       29            1 Noriega Street   16557      TRUE     FALSE     4       60

#and since we take the average over the route later should represent trips on average
#in any case, shouldn't make much of a difference
#count(stop_sequence) %>% --> count() 




