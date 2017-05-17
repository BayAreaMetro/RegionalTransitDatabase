# library(lubridate)
# library(readr)
# library(plyr)
# library(dplyr)
# library(DT)
# library(tidyr)
# library(stringr)

###########################################################################################
# Section 1. Functions

######################
##String Fixes
######################

build_table <- function(some_path, col_names=TRUE, col_types=NULL) {
  operator_df = read_csv(some_path, col_names, col_types)
  operator_prefix <- strsplit(some_path, "/")[[1]][2]
  operator_df["agency_id"] <- operator_prefix
  return(operator_df)
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
  #   t2 <- stop_times$departure_time
  #   stop_times$arrival_time <- sapply(t1,FUN=fix_hour)
  #   stop_times$departure_time <- sapply(t2,FUN=fix_hour)
  hour <- as.integer(unlist(strsplit(x,":"))[[1]])
  if(!is.na(hour) & hour > 23) {
    hour <- hour-24
    x <- format_new_hour_string(x,hour)
    if (hour > 47){
      stop("hour is greater than 47 in stop times")
    }
  }
  x
}

######################
##End String Fixes
######################

######################
##Begin Bus Route Frequency Functions
######################

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

######################
##End Common Route Frequency Functions
######################

######################
##Begin Common ETL Functions
######################c

load_multiple_gtfs <- function(gtfs_data_path="~/Documents/MTC/_Section/Planning/Projects/rtd_2017/REGION/data_2017") {

  #Set workspace where gtfs datasets are stored.  These datasets shoud have the txt file extension.
  setwd(gtfs_data_path)

  ## 2A. Bind all operator tables together. Append Agency_ID column to each GTFS Table,
  routes = NULL
  for (txt in dir(pattern = "routes.txt$",full.names=TRUE,recursive=TRUE)){
    routes = rbind(routes, build_table(txt))
  }
  #write.csv(routes, file="routes.csv", row.names=FALSE)

  stops = NULL
  for (txt in dir(pattern = "stops.txt$",full.names=TRUE,recursive=TRUE)){
    stops = rbind(stops, build_table(txt))
  }
  #write.csv(stops, file="stops.csv", row.names=FALSE)
  #rm(stops) # drop large dataframe
  stop_times = NULL
  ##Need to check values for stop_times to adjust time values for records that are greater than the 24 hour clock
  ## See errors listed in this link: file:///Users/ksmith/Documents/GIS%20Data/Transit/RTD_2017/R%20Scripts/rtd_2017.html.  Fix should be included in loop
  for (txt in dir(pattern = "stop_times.txt$",full.names=TRUE,recursive=TRUE)){

    stop_times = rbind(stop_times, build_table(txt, col_types=
                                                 cols(
                                                   trip_id = col_character(),
                                                   arrival_time = col_character(),
                                                   departure_time = col_character(),
                                                   stop_id = col_character(),
                                                   stop_sequence = col_integer())))
  }
  #write.csv(stop_times, file="stop_times.csv", row.names=FALSE)
  #rm(stop_times) # drop large dataframe
  trips = NULL
  for (txt in dir(pattern = "trips.txt$",full.names=TRUE,recursive=TRUE)){
    trips = rbind(trips, build_table(txt))
  }
  #write.csv(trips, file="trips.csv", row.names=FALSE)
  calendar = NULL
  for (txt in dir(pattern = "calendar.txt$",full.names=TRUE,recursive=TRUE)){
    calendar = rbind(calendar, build_table(txt))
  }
  #write.csv(calendar, file="calendar.csv", row.names=FALSE)

  agency = NULL
  for (txt in dir(pattern = "agency.txt$",full.names=TRUE,recursive=TRUE)){
    agency = rbind(agency, build_table(txt))
  }
  #write.csv(agency, file="agency.csv", row.names=FALSE)

  shapes = NULL
  for (txt in dir(pattern = "shapes.txt$",full.names=TRUE,recursive=TRUE)){
    shapes = rbind(shapes, build_table(txt, col_types =
                                         cols(
                                           shape_id = col_character(),
                                           shape_pt_lon = col_double(),
                                           shape_pt_lat = col_double(),
                                           shape_pt_sequence = col_integer(),
                                           shape_dist_traveled = col_double())))
  }
  #write.csv(shapes, file="shapes.csv", row.names=FALSE)
  rm(txt)

  stop_times$arrival_time <- as.POSIXct(stop_times$arrival_time, format= "%H:%M:%S")
  stop_times$departure_time <- as.POSIXct(stop_times$departure_time, format= "%H:%M:%S")
  routes_joined <- reduce_to_route_stops(stops,stop_times,trips,calendar,routes)
  return(routes_joined)
}

reduce_to_route_stops <- function(stops,stop_times,trips,calendar,routes) {
  # 3B. Join the data together.  Need to verify the join function for these records.
  df<- list(stops,stop_times,trips,calendar,routes)
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
  return(df_sr)
}

######################
##End Common ETL Functions
######################
