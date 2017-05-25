#######################
#Section 1. Set up your path and environment
#
#Set the path below to the root of the local git project folder for the RTD scripts
#You might need to install dplyr and gtfs packages if they aren't already installed

PROJECT_PATH <- "~/Documents/Projects/rtd"

GTFS_PATH <- paste0(PROJECT_PATH,"/data/05_2017_511_GTFS/",collapse="")
R_HELPER_FUNCTIONS_PATH <- paste0(PROJECT_PATH,"/R/r511.R",collapse="")

#source many of the functions used below
#note that these are available to review in the file at this path
source(R_HELPER_FUNCTIONS_PATH)

#install gtfs r
# if (!require(devtools)) {
#   install.packages('devtools')
# }
# devtools::install_github('ropensci/gtfsr') - on windows try the fork on MTC's github page, which does not require leaflet

library(gtfsr)
library(dplyr)

setwd(GTFS_PATH)

results <- list()

############################
# Section 2, read the zip files in the GTFS data directory and look through them
# be sure you don't have any zip files that aren't GTFS zip files in this folder

all_providers_df = NULL

for (txt in dir(pattern = ".zip$",full.names=TRUE,recursive=TRUE)){
  operator_prefix <- strsplit(strsplit(txt, "/")[[1]][[2]],".zip")[[1]]
  ################################################
  # Section 3. Read a single provider set using GTFSr
  
  gtfs_obj <- import_gtfs(txt, local=TRUE)

  result = tryCatch({

    ###############################################
    # Section 4. Join all the GTFS provider tables into 1 table based around stops

    df_sr <- join_all_gtfs_tables(gtfs_obj)
    df_sr <- make_arrival_hour_less_than_24(df_sr)

    ###########################################################################################
    # Section 5. Create Peak Headway tables for weekday trips

    am_stops <- flag_and_filter_peak_periods_by_time(df_sr,"AM")
    am_stops <- remove_duplicate_stops(am_stops) #todo: see issue 20
    am_stops <- count_trips(am_stops)
    am_stops_hdwy <- subset(am_stops,
                            am_stops$Headways < 16)
    am_routes <- get_routes(am_stops_hdwy)

    pm_stops <- flag_and_filter_peak_periods_by_time(df_sr,"PM")
    pm_stops <- remove_duplicate_stops(pm_stops) #todo: see issue 20
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

    ####
    ####

    peak_routes_filename <- paste0(c(operator_prefix,"_peak_bus_routes.csv"),collapse="")
    all_providers_df <- rbind(all_providers_df, df_stp_rt_hf)
    write.csv(df_stp_rt_hf,file=peak_routes_filename, row.names=FALSE)

    },
    error=function(cond) {
      message(paste("The following provider had errors:", operator_prefix))
      message("Here's the original error message:")
      message(cond)
      return(cond)
    },
    warning=function(cond) {
      message(paste("The following provider had a warning:", operator_prefix))
      message("Here's the original warning message:")
      message(cond)
      return(cond)
    },
    finally={
      message(paste("Processed operator:", operator_prefix))
    }
  )    
  results[[operator_prefix]] <- result
}

write.csv(all_providers_df,file="Weekday_Peak_Routes_Builder.csv", row.names=FALSE)

