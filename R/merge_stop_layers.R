setwd("~/Documents/Projects/RegionalTransitDatabase/R")
library(sf)
library(data.table)

#data exported from agol as geojson from here: https://github.com/BayAreaMetro/RegionalTransitDatabase/blob/master/docs/transit_priority_areas.md#outcome
#and cached in this git repo
df_non_bus <- st_read("../data/TPA_Non_Bus_Eligible_Stops_2017.geojson")
df_bus <- st_read("../data/High_Frequency_Bus_Stops_GEOJSON.geojson")
names(df_non_bus)
names(df_bus)
shared_headers <- names(df_bus)[names(df_bus) %in% names(df_non_bus)]

df_bus <- st_read("../data/High_Frequency_Bus_Stops_GEOJSON.geojson")

#drop bus stops that dont intersect (.2 mile neighbors) other high frequency stops
df_bus <- df_bus[df_bus$lgcl_adjacent_hf_routes==1,]

#set/clarify headers before merge
#those that don't contain information
df_non_bus_att <- as.data.frame(df_non_bus)
setnames(df_non_bus_att, "stop_name", "stop_name_or_id")
setnames(df_non_bus_att, "system", "system_type")
setnames(df_non_bus_att, "status", "project_status")
setnames(df_non_bus_att, "Project_Description", "project_description")
setnames(df_non_bus_att, "Stop_Description", "stop_description")

#set the geometry columns to x and y
#this makes merging possible/easier
df_non_bus_att['longitude'] <- st_coordinates(df_non_bus)[,'X']
df_non_bus_att['latitude'] <- st_coordinates(df_non_bus)[,'Y']

#drop columns
#these are empty and not necessary
#the exceptions are:
#agency_name, which we could consider keeping but dont have equivalent for bus right now
#and geometry, which is replaced above with X/Y
df_non_bus_att <- subset(df_non_bus_att, select = -c(OBJECTID,
													 geometry,
													 agency_name,
													 TPA_Eligible,
													 Delete_Stop,
													 Distance_Eligible,
													 Buffer_Distance,
													 Avg_Weekday_PM_Headway,
													 Avg_Weekday_AM_Headway))

##explicitly add null bus columns
#stricly not necessary but to clarify intent
df_non_bus_att['bus_headway'] <- 'NA'
df_non_bus_att['bus_peak_period'] <- 'NA'
df_non_bus_att['bus_headsign'] <- 'NA'
df_non_bus_att['bus_headway'] <- 'NA'
df_non_bus_att['bus_total_trips'] <- 'NA'
df_non_bus_att['bus_direction_id'] <- 'NA'

####
##set up bus table for merge
###
df_bus_att <- as.data.frame(df_bus)

#prepare bus columns for merge
setnames(df_bus_att, "Headway", "bus_headway")
setnames(df_bus_att, "trip_headsign", "bus_headsign")
setnames(df_bus_att, "stop_id", "stop_name_or_id")
setnames(df_bus_att, "Total_Trips", "bus_total_trips")
setnames(df_bus_att, "Peak_Period", "bus_peak_period")
setnames(df_bus_att, "Route_Pattern_ID", "agency_stop_id")
setnames(df_bus_att, "direction_id", "bus_direction_id")

#set the geometry columns to x and y
#this makes merging possible/easier
df_bus_att['longitude'] <- st_coordinates(df_bus)[,'X']
df_bus_att['latitude'] <- st_coordinates(df_bus)[,'Y']

df_bus_att <- subset(df_bus_att, select = -c(OBJECTID,
											 geometry,
											 lgcl_adjacent_hf_routes,
											 cnt_adjacent_hf_routes,
											 stop_sequence))

df_bus_att['stop_description'] <- 'NA'
df_bus_att['project_status'] <- 'Existing/Built'
df_bus_att['project_description'] <- 'NA'
df_bus_att['system_type'] <- 'Bus'

#check that columns match
names(df_non_bus_att)[!names(df_non_bus_att) %in% names(df_bus_att)]
names(df_bus_att)[!names(df_bus_att) %in% names(df_non_bus_att)]

df_all <- merge(df_bus_att,df_non_bus_att, all=TRUE)


