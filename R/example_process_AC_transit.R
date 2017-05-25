#be sure to set the project path
PROJECT_PATH <- "~/Documents/Projects/rtd"

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

################################################
# Section 3. Read a single provider set using GTFSr

gtfs_obj <- import_gtfs("AC.zip", local=TRUE)

###############################################
# Section 4. Join all the GTFS provider tables into 1 table based around stops

df_sr <- join_all_gtfs_tables(gtfs_obj)
df_sr <- make_arrival_hour_less_than_24(df_sr)

###########################################################################################
# Section 5. Create Peak Headway tables for weekday trips

am_stops <- flag_and_filter_peak_periods_by_time(df_sr,"AM")
am_stops <- remove_duplicate_stops(am_stops) #todo: see https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/issues/31
am_stops <- count_trips(am_stops)
am_stops_hdwy <- subset(am_stops,
                        am_stops$Headways < 16)
am_routes <- get_routes(am_stops_hdwy)

pm_stops <- flag_and_filter_peak_periods_by_time(df_sr,"PM")
pm_stops <- remove_duplicate_stops(pm_stops) #todo: see https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/issues/31
pm_stops <- count_trips(pm_stops)
pm_stops_hdwy <- subset(pm_stops,
                        pm_stops$Headways < 16)
pm_routes <- get_routes(pm_stops_hdwy)

###########################################################################################
# Section 6. Join the calculated am and pm peak routes (tpa eligible) back to stop tables

df_rt_hf <- join_high_frequency_routes_to_stops(am_stops,pm_stops,am_routes,pm_routes)

###########################################################################################
# Section 7. Join original stops mega-GTFSr data frame to Selected Routes for export to solve routes in Network Analyst

df_stp_rt_hf <- join_mega_and_hf_routes(df_sr, df_rt_hf)

df_stp_rt_hf <- deduplicate_final_table(df_stp_rt_hf)

#Remove select cols.
df_stp_rt_hf <- df_stp_rt_hf[-c(1:13)]

