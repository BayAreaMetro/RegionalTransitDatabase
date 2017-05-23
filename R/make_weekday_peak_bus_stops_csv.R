#be sure to set the project path
PROJECT_PATH <- "~/Documents/Projects/rtd1"

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

df_sr <- get_stops_by_route(gtfs_obj)
df_sr <- fix_arrival_time(df_sr)

#make booleans into nicer names
df_sr$direction_id[df_sr$direction_id == 0] <- "Outbound"
df_sr$direction_id[df_sr$direction_id == 1] <- "Inbound"

#filter Stops to AM Peak Bus Routes
time_start <- paste(c(format(Sys.Date(), "%Y-%m-%d"),
                      "06:00:00"),collapse=" ")
time_end <- paste(c(format(Sys.Date(), "%Y-%m-%d"),
                    "09:59:00"),collapse=" ")
am_stops <- filter_by_time(df_sr,
                           time_start,
                           time_end)

am_stops <- remove_duplicate_stops(am_stops) #multiple identical stop time at the same stop
am_stops_dedup <- remove_duplicate_stops(am_stops)
am_stops <- count_trips(am_stops)
am_routes <- subset(am_stops, am_stops$Headways < 16)

if (!(is.data.frame(am_routes) && nrow(am_routes)==0)){
  am_routes["Peak_Period"] <-"AM Peak"
} else 
{
  am_routes$Peak_Period <-  am_routes$route_id
}

###########################################################################################
# Section 5. Create PM Peak Headways from Weekday Trips
time_start <- paste0(c(format(Sys.Date(), "%Y-%m-%d"),
                       "15:00:00"),collapse=" ")

time_end <- paste(c(format(Sys.Date(), "%Y-%m-%d"),
                    "18:59:00"),collapse=" ")
pm_stops <- filter_by_time(df_sr,
                           time_start,
                           time_end)

pm_stops <- remove_duplicate_stops(pm_stops) #multiple identical stop time at the same stop
pm_stops <- count_trips(pm_stops)
pm_stops <- subset(pm_stops, pm_stops$Headways < 16)
pm_routes <- get_routes(pm_stops)

if (!(is.data.frame(pm_routes) && nrow(pm_routes)==0)){
  pm_routes["Peak_Period"] <-"PM Peak"
} else 
{
  pm_routes$Peak_Period <-  pm_routes$route_id
}

###########################################################################################
# Section 6. Build Weekday High Frequency Bus Service Dataset

#df_rt_hf <- join_high_frequency_routes_to_stops(am_stops,pm_stops,am_routes,pm_routes)


########
#####
####
########
#####
####
########
#####
####




df1 <- rbind(am_routes,
             pm_routes)

# This ID is used for grouping and headway counts 
#(same name as another id in here but dropped anyway)
#should probably replace at some point
if (!(is.data.frame(am_routes) && nrow(am_routes)==0)){
  df1$Route_Pattern_ID<-paste0(df1$agency_id,
                               "-",df1$route_id,"-",
                               df1$Peak_Period)
} else 
{
  df1$Route_Pattern_ID <-  df1$Peak_Period
}

# Count number of routes that operate in both directions during peak periods.
#TPA_Criteria = 2 or 3 then Route operates in both directions during peak periods
#TPA Criteria = 1 possible loop route or route only operates in ection during peak periods.

#####seems like df2 below doesn't represent buses that go in both directions during peak periods
##is this because of a change made to process individually or was it also tru in the large join version?

df2 <- df1 %>%
  group_by(agency_id, route_id, Peak_Period, Route_Pattern_ID) %>%
  summarise(TPA_Criteria = n())

# 6C. Join Total By Direction with Weekday High Frequency Bus Service tables to flag those routes that meet the criteria.
df3 <- list(df1,df2)
df4 <- Reduce(inner_join,df3) %>%
  select(agency_id, route_id, direction_id, trip_headsign,Total_Trips, Headway, Peak_Period, TPA_Criteria) %>%
  arrange(agency_id, route_id, direction_id, Peak_Period)

# 6D. Update values in TPA Criteria field. 2,3 = Meets Criteria, 1 = Review for Acceptance
df4$TPA_Criteria[df3$TPA_Criteria==3] <- "Meets TPA Criteria"
df4$TPA_Criteria[df3$TPA_Criteria==2] <- "Meets TPA Criteria"
df4$TPA_Criteria[df3$TPA_Criteria==1] <- "Does Not Meet TPA Criteria"
# 6D-1. Update values in TPA Criteria field.  All Loops in AM/PM Peak periods that have 15 mins or better headways = Meets TPA Criteria
df4$TPA_Criteria[grepl('loop', df3$trip_headsign, ignore.case = TRUE)] <- "Meets TPA Criteria"

df5 <- rbind(am_stops,pm_stops)

# 6G. Join Weekday_Peak_Bus_Routes with df3 to generate a stop schedule for all AM/PM Peak Period stops that have headways of 15 mins. or better.
df6 <- list(df5,df4)
df7 <- Reduce(inner_join,df6) %>%
  select(agency_id, route_id, direction_id, trip_headsign, stop_id, stop_sequence, Total_Trips, Headway, Peak_Period, TPA_Criteria)





########
#####
####
########
#####
####
########
#####
####
########
#####
####
########
#####
####
########
#####
####
########
#####
####
########
#####
####
########
#####
####








###########################################################################################
# Section 7. Build Weekday High Frequency Bus Service Stops for Route Building using NA Tools

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
#df_stp_rt_hf <- df_stp_rt_hf[-c(1:13)]
#return(df_stp_rt_hf)

#}

# 
# 
# for (txt in dir(pattern = "MA.zip$",full.names=TRUE,recursive=TRUE)){
#   result = tryCatch({
#     operator_prefix <- strsplit(strsplit(txt, "/")[[1]][[2]],".zip")[[1]]
#     gtfs_obj <- import_gtfs(txt, local=TRUE)
#     df <- get_peak_bus_route_stops(gtfs_obj)
#     peak_routes_filename <- paste0(c(operator_prefix,"_peak_bus_routes.csv"),collapse="")
#     write.csv(df,file=peak_routes_filename, row.names=FALSE)
#     },
#     error=function(cond) {
#       message(paste("The following provider had errors:", operator_prefix))
#       message("Here's the original error message:")
#       message(cond)
#       return(cond)
#     },
#     warning=function(cond) {
#       message(paste("The following provider had a warning:", operator_prefix))
#       message("Here's the original warning message:")
#       message(cond)
#       return(cond)
#     },
#     finally={
#       message(paste("Processed operator:", operator_prefix))
#     }
#   )    
#   results[[operator_prefix]] <- result
# }
# 
# 
