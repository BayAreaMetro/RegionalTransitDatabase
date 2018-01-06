setwd("~/Documents/Projects/rtd3")
library(sf)
library(data.table)

#data exported from agol as geojson from here: https://github.com/BayAreaMetro/RegionalTransitDatabase/blob/master/docs/transit_priority_areas.md#outcome
#and cached in this git repo
df_non_bus <- st_read("TPA_Non_Bus_Eligible_Stops_2017.geojson")
df_bus <- st_read("High_Frequency_Bus_Stops_GEOJSON.geojson")
names(df_non_bus)
names(df_bus)

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




df_all_sf = st_as_sf(df_all, 
                     coords = c("longitude", "latitude"), 
                     crs = 4326)

df_all_sf <- st_transform(df_all_sf, crs=26910)

df_tpa <- st_buffer(df_all_sf,dist=804.672)

df_all_sf <- st_transform(df_all_sf, crs=4326)

df_tpa <- st_transform(df_tpa, crs=4326)

st_write(df_all_sf,"major_stops.geojson")

st_write(df_tpa,"tpa2017.geojson")

########
###buffers
#########

sf_as_wkt_df <- function(sf_df1){
  sf_df1$geometry_wkt <- st_as_text(sf_df1$geometry)
  sf_df1 <- subset(sf_df1, select = -c(geometry))
  sf_df1_att <- as.data.frame(sf_df1)
  return(sf_df1_att)
}

hf_rts_1_2 <- st_read("main_hf_rts_1_2_ml_buf.geojson")
hf_rts_1_2at <- sf_as_wkt_df(hf_rts_1_2)
hf_rts_1_2at <- subset(hf_rts_1_2at, select = -c(OBJECTID, geometry))

new_rts_1_2 <- st_read("geneva_1_2_mile_buffer.geojson")
new_rts_1_2['avg_am_headway'] <- 'NA'
new_rts_1_2['avg_pm_headway'] <- 'NA'
new_rts_1_2['avg_am_trips'] <- 'NA'
new_rts_1_2['avg_pm_trips'] <- 'NA'
new_rts_1_2['route_id'] <- 'Geneva'
new_rts_1_2['agency'] <- 'SF'
new_rts_1_2at <- sf_as_wkt_df(new_rts_1_2)
new_rts_1_2at <- subset(new_rts_1_2at, select = -c(Shape__Area,Shape__Length,x,OBJECTID,geometry))

names(new_rts_1_2at)
names(hf_rts_1_2at)

routes_1_2 <- merge(new_rts_1_2at,hf_rts_1_2at, all=TRUE)

routes_1_2 <- st_as_sf(routes_1_2,wkt='geometry_wkt')
st_write(routes_1_2,"routes_1_2.geojson")

hf_rts_1_4 <- st_read("main_hf_rts_1_4_ml_buf.geojson")
hf_rts_1_4at <- sf_as_wkt_df(hf_rts_1_4)
hf_rts_1_4at <- subset(hf_rts_1_4at, select = -c(OBJECTID, geometry))

new_rts_1_4 <- st_read("geneva_route_1_4_mile.geojson")
new_rts_1_4['avg_am_headway'] <- 'NA'
new_rts_1_4['avg_pm_headway'] <- 'NA'
new_rts_1_4['avg_am_trips'] <- 'NA'
new_rts_1_4['avg_pm_trips'] <- 'NA'
new_rts_1_4at <- sf_as_wkt_df(new_rts_1_4)
new_rts_1_4at <- subset(new_rts_1_4at, select = -c(x,OBJECTID,geometry))

routes_1_4 <- merge(new_rts_1_4at,hf_rts_1_4at, all=TRUE)
routes_1_4 <- st_as_sf(routes_1_4,wkt='geometry_wkt')
st_write(routes_1_4,"routes_1_4.geojson")

