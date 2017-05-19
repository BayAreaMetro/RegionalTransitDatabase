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
  am_routes["Peak_Period"] <-"AM Peak"
  
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
  pm_routes["Peak_Period"] <-"PM Peak"
  
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

fix_arrival_time <- function(df) {
  t1 <- df$arrival_time
  if (!(typeof(t1) == "character")) {
    stop("column not a character string--may already be fixed")
  }
  df$arrival_time <- sapply(t1,FUN=fix_hour)
  df$arrival_time <- as.POSIXct(df$arrival_time, format= "%H:%M:%S")
  df
}

format_new_hour_string <- function(x,hour_replacement) {
  xl <- length(unlist(strsplit(x,":")))
  if (xl > 3){
    stop("unexpected time string")
  }
  hour <- as.integer(unlist(strsplit(x,":"))[[1]])
  minute <- as.integer(unlist(strsplit(x,":"))[[2]])
  second <- as.integer(unlist(strsplit(x,":"))[[3]])
  x <- paste(c(hour,minute,second),collapse=":")
  return(x)
}

fix_hour <- function(x) {
  # use:
  #   t1 <- stop_times$arrival_time
  #   stop_times$arrival_time <- sapply(t1,FUN=fix_hour)
  if(!is.na(x)) {
    hour <- as.integer(unlist(strsplit(x,":"))[[1]])
    if(!is.na(hour) & hour > 23) {
      hour <- hour-24
      x <- format_new_hour_string(x,hour)
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

count_trips_by_route <- function(rt_df) {
  rt_df %>%
    group_by(agency_id,
             route_id,
             direction_id,
             trip_headsign,
             stop_id) %>%
    count(stop_sequence) %>%
    mutate(Headways = round(240/n,0)) ->
    rt_df_out
  return(rt_df_out)
}

select_distinct_on_agency_route_direction <- function(rt_df) {
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

get_bus_service <- function(df_in,max_hdwy=16) {
  #4C
  df2 <- count_trips_by_route(df_in)

  #4D Rename count col. (n) to Trips
  names(df2)[6]<-"Trips"

  #4E Select High Frequency Bus Service Routes (15 min or better headways)
  df3 <- subset(df2,
                df2$Headways < max_hdwy)

  #4F Select Distinct Records based upon Agency Route Direction values.  Removes stop ids from output.
  df_out <- select_distinct_on_agency_route_direction(df3)

  #4G Add Peak_Period Column
  df_out["Peak_Period"] <-"AM Peak"

  #4H Drop Duplicate Columns from DF
  df_out <- df_out[-c(7:9)]
  return(df_out)
}

join_high_frequency_routes_to_stops <- function(am_stops,pm_stops,am_routes,pm_routes){
  # Combine Weekday High Frequency Bus Service Data Frames for AM/PM Peak Periods
  df1 <- rbind(am_routes,
               pm_routes)

  # Add a ID to be used later in ESRI
  df1$Route_Pattern_ID<-paste0(df1$agency_id,
                               "-",df1$route_id,"-",
                               df1$Peak_Period)

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

  df5 <- rbind(am_stops,pm_stops) %>%
    arrange(agency_id, route_id, direction_id,arrival_time,stop_sequence)

  # 6G. Join Weekday_Peak_Bus_Routes with df3 to generate a stop schedule for all AM/PM Peak Period stops that have headways of 15 mins. or better.
  df6 <- list(df5,df4)
  df7 <- Reduce(inner_join,df6) %>%
    select(agency_id, route_id, direction_id, trip_headsign, stop_id, stop_sequence, arrival_time, Total_Trips, Headway, Peak_Period, TPA_Criteria) %>%
    arrange(agency_id, route_id, direction_id, Peak_Period, arrival_time, stop_sequence )

  # 6G-1. Reformat arrival_time col. to hour | min format prior to export to Data Table.
  df7$arrival_time <- strftime(df7$arrival_time, format = "%H:%M")

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


