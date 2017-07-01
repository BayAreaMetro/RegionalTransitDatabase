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

df_mtc_trips <- make_mtc_tpa_trips_table(gtfs_obj)
df_mtc_trips$arrival_time <- make_hour_less_than_24(df_mtc_trips$arrival_time)

df_mtc_trips <- flag_tpa_candidate_trips(df_mtc_trips)
#verification:
print(as.data.frame(table(df_mtc_trips[,c('f_am_peak','f_pm_peak','f_weekday','f_bus_stop')])))
#there are no stops in both am and pm, which is good!

#store the result in the gtfsr object for any later use and output for diagnostics
gtfs_obj$mtc_trips_df <- df_mtc_trips
rm(df_mtc_trips)

gtfs_obj$mtc_am_peak_stop_headways <- count_trips_at_stops(gtfs_obj$mtc_trips_df,
                                 time_start = "06:00:00",
                                 time_end="09:59:00")

gtfs_obj$mtc_pm_peak_stop_headways <- count_trips_at_stops(gtfs_obj$mtc_trips_df,
                                 time_start = "15:00:00",
                                 time_end="18:59:00")

