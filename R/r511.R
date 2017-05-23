# library(lubridate)
# library(readr)
# library(plyr)
# library(dplyr)
# library(DT)
# library(tidyr)
# library(stringr)

######
##Calculate Frequent Bus Routes
######
#this is the main function and goal of the r scripts here
#todo: 
#document some of the Reduce calls
#collapse the am and pm filtering to one function and call it

#' Get a dataframe of stops and routes that are TPA eligible from a GTFSr object
#' @param gtfs_obj A GTFS (gtfsr) list object with components agency_df, etc.
#' @return a dataframe of stops for TPA eligible bus routes

get_peak_bus_route_stops <- function(gtfs_obj) {
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
  am_routes <- get_bus_service(am_stops) 
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
  pm_stops <- remove_duplicate_stops(pm_stops)
  pm_routes <- get_bus_service(pm_stops)
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
  return(df_stp_rt_hf)
}

######
##Custom Time Format Functions
######

#' Make a dataframe GTFS arrival_time column into standard time variable
#' @param dataframe containing a GTFS-style "arrival_time" column (time values at +24:00:00)
#' @return dataframe containing a GTFS-style "arrival_time" column (no time values at +24:00:00)
fix_arrival_time <- function(df) {
  t1 <- df$arrival_time
  if (!(typeof(t1) == "character")) {
    stop("column not a character string--may already be fixed")
  }
  df$arrival_time <- sapply(t1,FUN=fix_hour)
  df$arrival_time <- as.POSIXct(df$arrival_time, format= "%H:%M:%S")
  df
}

#' Format a time string in the expected format
#' @param x a GTFS hour string with an hour greater than 24
#' @param hour_replacement the hour to replace the >24 value with
#' @return a string formatted hh:mm:ss 
format_new_hour_string <- function(x,hour_replacement) {
  xl <- length(unlist(strsplit(x,":")))
  if (xl > 3){
    stop("unexpected time string")
  }
  minute <- as.integer(unlist(strsplit(x,":"))[[2]])
  second <- as.integer(unlist(strsplit(x,":"))[[3]])
  x <- paste(c(hour_replacement,minute,second),collapse=":")
  return(x)
}

#' Make a dataframe GTFS arrival_time column into standard time variable
#' @param dataframe containing a GTFS-style "arrival_time" column (time values at +24:00:00)
#' @return dataframe containing a GTFS-style "arrival_time" column (all time values at +24:00:00 set below 24)
fix_hour <- function(x) {
  # use:
  #   t1 <- stop_times$arrival_time
  #   stop_times$arrival_time <- sapply(t1,FUN=fix_hour)
  if(!is.na(x)) {
    hour <- as.integer(unlist(strsplit(x,":"))[[1]])
    if(!is.na(hour) & hour > 23) {
      hour <- hour-24
      x <- format_new_hour_string(x, hour)
      if (hour > 47){
        stop("hour is greater than 47 in stop times")
      }
    }
  }
  x
}

######
##Custom Bus Frequency Functions
######

#' Filter a mega-GTFSr dataframe to rows/stops that occur on all weekdays, are buses, and
#' have a stop_time between 2 time periods
#' @param a dataframe made by joining all the GTFS tables together
#' @param a start time filter
#' @param an end time filter
#' @return a mega-GTFSr dataframe filtered to rows of interest
filter_by_time <- function(rt_df, start_filter,end_filter) {
  subset(rt_df, rt_df$monday == 1
         & rt_df$tuesday == 1
         & rt_df$wednesday == 1
         & rt_df$thursday == 1
         & rt_df$friday == 1
         & rt_df$route_type == 3
         & rt_df$arrival_time >start_filter
         & rt_df$arrival_time < end_filter)-> rt_df_out
  return(rt_df_out)
}

remove_duplicate_stops <- function(rt_df){
  rt_df %>%
    distinct(agency_id, route_id, direction_id,
             trip_headsign, stop_id, stop_sequence, arrival_time) %>%
    arrange(agency_id, route_id, direction_id,
            arrival_time,stop_sequence)->rt_df_out
  return(rt_df_out)
}

count_trips<- function(rt_df) {
  rt_df %>%
    group_by(agency_id,
             route_id,
             direction_id,
             trip_headsign,
             stop_id) %>%
    count(stop_sequence) %>%
    mutate(Headways = round(240/n,0)) ->
    rt_df_out
  colnames(rt_df_out)[colnames(rt_df_out)=="n"] <- "Trips"
  return(rt_df_out)
}

get_routes <- function(rt_df) {
  group_by(rt_df,
           agency_id,
           route_id,
           direction_id,
           trip_headsign) %>%
    mutate(Total_Trips = round(mean(Trips),0),
           Headway = round(mean(Headways),0)) %>%
    distinct(agency_id,
             route_id,
             direction_id,
             trip_headsign,
             Total_Trips,
             Headway) ->
    rt_df_out
  return(rt_df_out)
}

join_high_frequency_routes_to_stops <- function(am_stops,pm_stops,am_routes,pm_routes){
  # Combine Weekday High Frequency Bus Service Data Frames for AM/PM Peak Periods
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

  return(df7)
}

get_stops_by_route <- function(g) {
  df <- list(g$stops_df,g$stop_times_df,g$trips_df,g$calendar_df,g$routes_df)
  Reduce(inner_join,df) %>%
    select(agency_id, stop_id, trip_id, service_id,
           monday, tuesday, wednesday, thursday, friday,
           route_id, trip_headsign, direction_id,
           arrival_time, stop_sequence,
           route_type, stop_lat, stop_lon) %>%
    arrange(agency_id, trip_id, service_id,
            monday, tuesday, wednesday, thursday, friday,
            route_id, trip_headsign, direction_id,
            arrival_time, stop_sequence) -> df_sr
  #clean up source data
  rm(df)
  df_sr$Route_Pattern_ID<-paste0(df_sr$agency_id,
                                 "-",df_sr$route_id,"-",
                                 df_sr$direction_id)
  return(df_sr)
}


