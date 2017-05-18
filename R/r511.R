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

add_operator_id_to_table <- function(some_path, col_names=TRUE, col_types=NULL) {
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

combine_provider_tables <- function(tablename="routes",gtfs_data_path, col_types=NULL) {
  table_search_string <- paste0(tablename,".txt$")
  print(table_search_string)
  table_csv_name <- paste0(gtfs_data_path,tablename,".csv")
  ## 2A. Bind all operator tables together. Append Agency_ID column to each GTFS Table,
  df1 = NULL
  cachedwd <- getwd()
  setwd(gtfs_data_path)
  for (txt in dir(pattern = table_search_string,full.names=TRUE,recursive=TRUE)){
    {
      df1 = rbind(df1, add_operator_id_to_table(txt))
    }
  }
  write.csv(df1, file=table_csv_name, row.names=FALSE)
  setwd(cachedwd)
}

combine_all_table_types_and_write_to_disk <- function(gtfs_data_path) {
  combine_provider_tables(tablename="routes",gtfs_data_path)
  combine_provider_tables(tablename="stops",gtfs_data_path)
  combine_provider_tables(tablename="calendar",gtfs_data_path)
  combine_provider_tables(tablename="trips",gtfs_data_path)
  combine_provider_tables(tablename="agency",gtfs_data_path)
  combine_provider_tables(tablename="stop_times",
                                             gtfs_data_path,
                                             col_types=
                                               cols(
                                                 trip_id = col_character(),
                                                 arrival_time = col_character(),
                                                 departure_time = col_character(),
                                                 stop_id = col_integer(),
                                                 stop_sequence = col_integer()))
  
  combine_provider_tables(tablename="shapes",
                                         gtfs_data_path,
                                         col_types=
                                           cols(
                                             trip_id = col_character(),
                                             arrival_time = col_character(),
                                             departure_time = col_character(),
                                             stop_id = col_integer(),
                                             stop_sequence = col_integer()))
}

load_merged_csvs <- function(gtfs_data_path) {
  routes <- read_csv(paste0(gtfs_data_path,"routes.csv",collapse=""),col_names=TRUE)
  stops <- read_csv(paste0(gtfs_data_path,"stops.csv",collapse=""),col_names=TRUE)
  calendar <- read_csv(paste0(gtfs_data_path,"calendar.csv",collapse=""),col_names=TRUE)
  trips <- read_csv(paste0(gtfs_data_path,"trips.csv",collapse=""),col_names=TRUE)
  agency <- read_csv(paste0(gtfs_data_path,"agency.csv",collapse=""),col_names=TRUE)
  stop_times <- read_csv(paste0(gtfs_data_path,"stop_times.csv",collapse=""),col_names=TRUE,
                         col_types=
                           cols(
                             trip_id = col_character(),
                             arrival_time = col_character(),
                             departure_time = col_character(),
                             stop_id = col_integer(),
                             stop_sequence = col_integer()))
  stop_times <- fix_stop_times(stop_times)
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


load_multiple_gtfs <- function(gtfs_data_path="~/Documents/MTC/_Section/Planning/Projects/rtd_2017/REGION/data_2017") {
  if(!file.exists(paste0(gtfs_data_path,"/routes.txt"))){
    print("loading from merged csvs")
    load_merged_csvs(gtfs_data_path)
    routes_joined <- reduce_to_route_stops(stops,stop_times,trips,calendar,routes,load_merged_csvs,gtfs_data_path) 
  } else if (file.exists(paste0(gtfs_data_path,"/3D/routes.txt"))) {
    print("loading from multiple providers")
    combine_all_gtfs_tables(gtfs_data_path)
    routes_joined <- reduce_to_route_stops(stops,stop_times,trips,calendar,routes,load_merged_csvs,gtfs_data_path) 
  } else {
    stop("routes.txt for 3d does not exist-have you downloaded and unzipped the source data? see readme for instructions")
    }
  return(routes_joined)
}

reduce_to_route_stops <- function(stops,stop_times,trips,calendar,routes,load_merged_csvs,gtfs_data_path) {
  load_merged_csvs(gtfs_data_path)
  debug()
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
  df_sr$Route_Pattern_ID<-paste0(df_sr$agency_id,
                                 "-",df_sr$route_id,"-",
                                 df_sr$direction_id)
  return(df_sr)
}

fix_arrival_time <- function(df) {
  t1 <- df$arrival_time
  if (!(typeof(t1) == "character")) {
    stop("column not a character string--may already be fixed")
  }
  df$arrival_time <- sapply(t1,FUN=fix_hour)
  df$arrival_time <- as.POSIXct(df$arrival_time, format= "%H:%M:%S")
  df
}

######################
##End Common ETL Functions
######################
