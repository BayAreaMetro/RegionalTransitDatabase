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
# Warning: 10508 parsing failures.
# row      col   expected  actual              file
# 99182 shape_id an integer ECR0207 './SM/shapes.txt'
# 99183 shape_id an integer ECR0207 './SM/shapes.txt'
# 99184 shape_id an integer ECR0207 './SM/shapes.txt'
# 99185 shape_id an integer ECR0207 './SM/shapes.txt'
# 99186 shape_id an integer ECR0207 './SM/shapes.txt'

# Warning: 69685 parsing failures.
# row      col               expected actual              file
# 3357 shape_id no trailing characters -MV-10 './MA/shapes.txt'
# 3358 shape_id no trailing characters -MV-10 './MA/shapes.txt'
# 3359 shape_id no trailing characters -MV-10 './MA/shapes.txt'
# 3360 shape_id no trailing characters -MV-10 './MA/shapes.txt'
# 3361 shape_id no trailing characters -MV-10 './MA/shapes.txt'

# Warning: 13635 parsing failures.
# row      col               expected actual              file
# 7539 shape_id no trailing characters  X0042 './GG/shapes.txt'
# 7540 shape_id no trailing characters  X0042 './GG/shapes.txt'
# 7541 shape_id no trailing characters  X0042 './GG/shapes.txt'
# 7542 shape_id no trailing characters  X0042 './GG/shapes.txt'
# 7543 shape_id no trailing characters  X0042 './GG/shapes.txt'

# Warning: 64798 parsing failures.
# row      col               expected actual              file
# 58885 shape_id no trailing characters  L0006 './AC/shapes.txt'
# 58886 shape_id no trailing characters  L0006 './AC/shapes.txt'
# 58887 shape_id no trailing characters  L0006 './AC/shapes.txt'
# 58888 shape_id no trailing characters  L0006 './AC/shapes.txt'
# 58889 shape_id no trailing characters  L0006 './AC/shapes.txt'

