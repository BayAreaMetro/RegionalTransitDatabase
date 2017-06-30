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

