#' Make a dataframe GTFS tables all joined together for route frequency calculations
#' @param a GTFSr object for a given provider with routes, stops, stop_times, etc
#' @return a mega-GTFSr data frame with stops, stop_times, trips, calendar, and routes all joined
join_all_gtfs_tables <- function(g) {
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

######
##Custom Time Format Functions
######

#' Make a dataframe GTFS arrival_time column into standard time variable
#' @param dataframe containing a GTFS-style "arrival_time" column (time values at +24:00:00)
#' @return dataframe containing a GTFS-style "arrival_time" column (no time values at +24:00:00)
make_arrival_hour_less_than_24 <- function(df) {
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

#' Format GTFS Time strings as standard time string
#' @param a GTFS Time string
#' @return Time string with no hours greater than 24
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
#' @param a mega-GTFSr dataframe made with the join_all_gtfs_tables() function
#' @param period - "AM" or "PM"
#' @return a mega-GTFSr dataframe filtered to TPA peak periods and flagged as AM or PM peak
flag_and_filter_peak_periods_by_time <- function(mega_df, period) {
  if (period=="AM"){
    time_start <- "06:00:00"
    time_end <- "09:59:00"
  } else {
    time_start <- "15:00:00"
    time_end <- "18:59:00"
  }
  
  mega_df <- filter_by_time(mega_df,
                                  time_start,
                                  time_end)
  
  if (!(is.data.frame(mega_df) && nrow(mega_df)==0) && period=="AM"){
    mega_df["Peak_Period"] <-"AM Peak"
  } else if (!(is.data.frame(mega_df) && nrow(mega_df)==0) && period=="PM" ) {
    mega_df["Peak_Period"] <-"PM Peak" 
  } else
  {
  mega_df$Peak_Period <-  mega_df$route_id
  }
  return(mega_df)
}

#' Filter a mega-GTFSr dataframe to rows/stops that occur on all weekdays, are buses, and
#' have a stop_time between 2 time periods
#' @param a dataframe made by joining all the GTFS tables together
#' @param a start time filter hh:mm:ss
#' @param an end time filter hh:mm:ss
#' @return a mega-GTFSr dataframe filtered to rows of interest
filter_by_time <- function(rt_df, start_filter,end_filter) {
  time_start <- paste(c(format(Sys.Date(), "%Y-%m-%d"),
                        start_filter),collapse=" ")
  time_end <- paste(c(format(Sys.Date(), "%Y-%m-%d"),
                      end_filter),collapse=" ")
  rt_df_out <- subset(rt_df, rt_df$monday == 1
                           & rt_df$tuesday == 1
                           & rt_df$wednesday == 1
                           & rt_df$thursday == 1
                           & rt_df$friday == 1
                           & rt_df$route_type == 3
                           & rt_df$arrival_time >time_start
                           & rt_df$arrival_time < time_end)
  return(rt_df_out)
}

#' for a mega-GTFSr dataframe, remove rows with duplicate stop times 
#' @param a dataframe of stops with a stop_times column 
#' @return a dataframe of stops with a stop_times column in which there are no duplicate stop times for a given stop
remove_duplicate_stops <- function(rt_df){
  rt_df %>%
    distinct(agency_id, route_id, direction_id,
             trip_headsign, stop_id, stop_sequence, arrival_time, Peak_Period) %>%
    arrange(agency_id, route_id, direction_id,
            arrival_time,stop_sequence)->rt_df_out
  return(rt_df_out)
}

#' for a mega-GTFSr dataframe, count the number of trips a bus takes through a given stop within a given time period
#' @param a mega-GTFSr dataframe
#' @return a dataframe of stops with a "Trips" variable representing the count trips taken through each stop for a route within a given time frame
count_trips<- function(rt_df) {
  rt_df_out <- rt_df %>%
    group_by(agency_id,
             route_id,
             direction_id,
             trip_headsign,
             stop_id,
             Peak_Period) %>%
    count(stop_sequence) %>%
    mutate(Headways = round(240/n,0))
  colnames(rt_df_out)[colnames(rt_df_out)=="n"] <- "Trips"
  return(rt_df_out)
}

#' for a mega-GTFSr dataframe, reduce it to just a listing of routes
#' @param a mega-GTFSr dataframe
#' @return a dataframe of routes  
get_routes <- function(rt_df) {
  group_by(rt_df,
           agency_id,
           route_id,
           direction_id,
           trip_headsign,
           Peak_Period) %>%
    mutate(Total_Trips = round(mean(Trips),0),
           Headway = round(mean(Headways),0)) %>%
    distinct(agency_id,
             route_id,
             direction_id,
             trip_headsign,
             Total_Trips,
             Headway) ->
    rt_df_out
}

#' 
#' @param a mega-GTFSr dataframe filtered to AM peak commute period stops
#' @param a mega-GTFSr dataframe filtered to PM peak commute period stops
#' @param a mega-GTFSr get_routes reduced dataframe filtered to AM peak commute period stops
#' @param a mega-GTFSr get_routes reduced dataframe filtered to PM peak commute period stops
#' @return a dataframe of stops/routes flagged as TPA eligible or not
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


#' 
#' @param a mega-GTFSr dataframe 
#' @param a mega-GTFSr get_routes reduced dataframe
#' @return a dataframe of stops/routes flagged as TPA eligible, with some of the variables dropped from the stops table above joined back on the table
join_mega_and_hf_routes <- function(df_sr,df_rt_hf){
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
  return(df_stp_rt_hf)
}

#` Select Distinct Records based upon Agency Route Direction values.  Removes stop ids from output.
#' @param a dataframe output by join_mega_and_hf_routes()
#' @return a deduplicated version of the input dataframe
deduplicate_final_table <- function(df_stp_rt_hf) {
  df_stp_rt_hf <- group_by(df_stp_rt_hf,
                           agency_id, route_id, direction_id, Route_Pattern_ID,trip_headsign,
                           stop_id, stop_sequence, Total_Trips, Headway, Peak_Period,
                           TPA_Criteria, stop_lon, stop_lat) %>%
    distinct(agency_id, route_id, direction_id, Route_Pattern_ID,
             trip_headsign, stop_id, stop_sequence, Total_Trips,
             Headway, Peak_Period, TPA_Criteria, stop_lon, stop_lat)
  return(df_stp_rt_hf)
}

##################
#geospatial work
###############

#' Return a spatial dataframe with the geometries of high frequency routes
#' @param am_routes is a dataframe of high frequency routes for the am period
#' @param pm_routes is a dataframe of high frequency routes for the pm period
#' @param gtfs_obj is a gtfsr list of gtfs dataframes
#' @return a list including:spatial data frame for tpa eligible routes, and an accompanying table to map them to routes
get_hf_geoms <- function(df1,gtfs_obj,hf_stops) {
    #am peak and pm peak headways and counts should be on 
  g1 <- group_by(df1,route_id)
  df2 <- distinct(g1,direction_id,trip_headsign)
  
  #attempt at subsetting service by a single date
  ###########
  gtfs_obj$calendar_df$start_date <- as.Date(gtfs_obj$calendar_df$start_date, format= "%Y%m%d")
  gtfs_obj$calendar_df$end_date <- as.Date(gtfs_obj$calendar_df$end_date, format= "%Y%m%d")
  
  weekday_subset <- gtfs_obj$calendar_df$monday==1 & 
    gtfs_obj$calendar_df$tuesday==1 & 
    gtfs_obj$calendar_df$wednesday==1 & 
    gtfs_obj$calendar_df$thursday==1 & 
    gtfs_obj$calendar_df$friday==1
  
  chosen_services <- gtfs_obj$calendar_df[weekday_subset,c("service_id")]
  #there are still multiple services for this subset...
  #but this should reduce some duplicates anyway
  ######
  
  df_sp <- get_routes_sldf(gtfs_obj,names(table(hf_stops$route_id)),NULL,NULL)
  
  l1 <- list(df2,df_sp$shapes_routes_df,chosen_services)
  df3 <- Reduce(inner_join,l1)
  rm(l1)
  #reducing drops headway and total trips
  #in order to keep these, 
  #might make more sense to join geometries to am/pm and direction
  
  g1 <- group_by(df3, shape_id)
  df4 <- distinct(g1, route_id, shape_id, service_id, direction_id)
  #would prefer to have inbound and outbound ID on here, but not sure where they went--service will have to do
  
  #fix column name
  names(df_sp$gtfslines) <- c("shape_id")
  l1 <- list()
  l1$sldf <- df_sp$gtfslines
  l1$df <- df4
  l1$df_s <- df1
  return(l1)
}


#' Return the geometries for a route as single line
#' @param a route_id
#' @param a list output by get_hf_geoms 
#' @return linestring with an id
get_single_route_geom <- function(x,hf_l) {
  r_id <- x["route_id"]
  d_id <- x["direction_id"]
  rd_id <- paste(r_id,d_id,sep="-")
  t1 <- as.data.frame(hf_l$df[hf_l$df$route_id == r_id & hf_l$df$direction_id == d_id,"shape_id"])
  dfsp1 <- hf_l$sldf[hf_l$sldf$shape_id %in% t1[,1],]
  g1 <- geometry(dfsp1)
  g2 <- gLineMerge(g1,byid=FALSE,id=rd_id)
  if(length(g2)>1){stop("more than 1 sp Line after merge of gtfs shapes for route")}
  l1 <- Line(coordinates(g2))
  l2 <- Lines(list(l1),ID=rd_id)
  return(l2)
}



#' make high frequency routes spatial df
#' @param a list output by get_hf_geoms 
#' @return a dataframe of routes by direction with geometries from source gtfs
route_id_indexed_sldf <- function(l2, dfx) {
  df1 <- get_route_stats(l2$df_s)
  w1 <- apply(df1,1,get_single_route_geom,l2)
  w2 <- SpatialLines(w1)
  Sldf <- SpatialLinesDataFrame(w2,data=df1)
}

#' make high frequency routes df into just routes and directions df, for use in construction geoms by route and direction sldf
#' @param a dataframe made of am_routes and pm_routes
#' @return a dataframe of routes by direction with headway stats for peak periods
get_route_stats <- function(df1) {
  df2 <- dcast(df1,route_id+direction_id~Peak_Period, value.var="Headway", fun.aggregate=mean)
  names(df2)[3:4] <- c("am_headway","pm_headway")
  df3 <- dcast(df1,route_id+direction_id~Peak_Period, value.var="Total_Trips", fun.aggregate=mean)
  names(df3)[3:4] <- c("am_trips","pm_trips")
  df4 <- inner_join(df2,df3)
  row.names(df4) <- paste(df2$route_id,df2$direction_id,sep="-")
  return(df4)
}

#' get a Route Pattern ID
#' @param dataframe
#' @returns a vector which combines the agency id, route id, and direction id in a string 
get_route_pattern_id <- function(df) {
  df$Route_Pattern_ID<-paste0(df$agency_id,
                                 "-",df$route_id,"-",
                                 df$direction_id)
}
