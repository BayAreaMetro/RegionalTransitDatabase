library(readr)

build_table <- function(some_path, col_names=TRUE, col_types=NULL) {
  operator_df = read_csv(some_path, col_names, col_types)
  operator_prefix <- strsplit(some_path, "/")[[1]][2]
  x <- vector(mode="character", length=nrow(operator_df))
  x[1:length(x)] = operator_prefix
  operator_df["agency_id"] <- operator_prefix
  return(operator_df)
}

## bind all tables together

setwd("C:/temp/RegionalTransitDatabase/data/gtfs_csvkit")
routes = NULL
for (txt in dir(pattern = "routes.txt$",full.names=TRUE,recursive=TRUE)){
  routes = rbind(routes, build_table(txt))
}
write.csv(routes, file="routes.csv", row.names=FALSE)

stops = NULL
for (txt in dir(pattern = "stops.txt$",full.names=TRUE,recursive=TRUE)){
  stops = rbind(stops, build_table(txt))
}
write.csv(stops, file="stops.csv", row.names=FALSE)
rm(stops) # drop large dataframe
stop_times = NULL
##Need to check values for stop_times to adjust time values for records that are greater than the 24 hour clock
## See errors listed in this link: file:///Users/ksmith/Documents/GIS%20Data/Transit/RTD_2017/R%20Scripts/rtd_2017.html.  Fix should be included in loop
for (txt in dir(pattern = "stop_times.txt$",full.names=TRUE,recursive=TRUE)){
  ## Add if statement here to check values of specific cols.
  ##or just cast as text and fix in sql.
  
  
  stop_times = rbind(stop_times, build_table(txt, col_types= 
                                                cols(
                                                  trip_id = col_character(),
                                                  arrival_time = col_character(),
                                                  departure_time = col_character(),
                                                  stop_id = col_character(),
                                                  stop_sequence = col_integer())))
}
write.csv(stop_times, file="stop_times.csv", row.names=FALSE)
rm(stop_times) # drop large dataframe
trips = NULL
for (txt in dir(pattern = "trips.txt$",full.names=TRUE,recursive=TRUE)){
  trips = rbind(trips, build_table(txt))
}
write.csv(trips, file="trips.csv", row.names=FALSE)
calendar = NULL
for (txt in dir(pattern = "calendar.txt$",full.names=TRUE,recursive=TRUE)){
  calendar = rbind(calendar, build_table(txt))
}
write.csv(calendar, file="calendar.csv", row.names=FALSE)

agency = NULL
for (txt in dir(pattern = "agency.txt$",full.names=TRUE,recursive=TRUE)){
  agency = rbind(agency, build_table(txt))
}
write.csv(agency, file="agency.csv", row.names=FALSE)

## Several errors found during table bind due to malformed values.  See errors below.
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
write.csv(shapes, file="shapes.csv", row.names=FALSE)

