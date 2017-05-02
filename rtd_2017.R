library(readr)

## bind all tables together

#setwd("C:/temp/RegionalTransitDatabase/data/gtfs_csvkit")
routes = NULL
for (txt in dir(pattern = "routes.txt$",full.names=TRUE,recursive=TRUE)){
  print(txt)
  routes = rbind(routes, read_csv(txt))
}
write.csv(routes, file="all_routes.csv")

stops = NULL
for (txt in dir(pattern = "stops.txt$",full.names=TRUE,recursive=TRUE)){
  stops = rbind(stops, read_csv(txt))
}
write.csv(stops, file="all_stops.csv")
rm(stops) # drop large dataframe
stop_times = NULL
##Need to check values for stop_times to adjust time values for records that are greater than the 24 hour clock
## See errors listed in this link: file:///Users/ksmith/Documents/GIS%20Data/Transit/RTD_2017/R%20Scripts/rtd_2017.html.  Fix should be included in loop
for (txt in dir(pattern = "stop_times.txt$",full.names=TRUE,recursive=TRUE)){
  ## Add if statement here to check values of specific cols.
  ##or just cast as text and fix in sql.
  
  
  stop_times = rbind(stop_times, read_csv(txt, col_types= 
                                                cols(
                                                  trip_id = col_character(),
                                                  arrival_time = col_character(),
                                                  departure_time = col_character(),
                                                  stop_id = col_character(),
                                                  stop_sequence = col_integer())))
}
write.csv(stop_times, file="all_stop_times.csv")
rm(stop_times) # drop large dataframe
trips = NULL
for (txt in dir(pattern = "trips.txt$",full.names=TRUE,recursive=TRUE)){
  trips = rbind(trips, read_csv(txt))
}
write.csv(trips, file="all_trips.csv")
calendar = NULL
for (txt in dir(pattern = "calendar.txt$",full.names=TRUE,recursive=TRUE)){
  calendar = rbind(calendar, read_csv(txt))
}
write.csv(calendar, file="all_calendar.csv")

agency = NULL
for (txt in dir(pattern = "agency.txt$",full.names=TRUE,recursive=TRUE)){
  agency = rbind(agency, read_csv(txt))
}
write.csv(agency, file="all_agency.csv")

## Several errors found during table bind due to malformed values.  See errors below.
shapes = NULL
for (txt in dir(pattern = "shapes.txt$",full.names=TRUE,recursive=TRUE)){
  shapes = rbind(shapes, read_csv(txt, col_types =
                                  cols(
                                    shape_id = col_character(),
                                    shape_pt_lon = col_double(),
                                    shape_pt_lat = col_double(),
                                    shape_pt_sequence = col_integer(),
                                    shape_dist_traveled = col_double())))
}
write.csv(shapes, file="all_shapes.csv")

