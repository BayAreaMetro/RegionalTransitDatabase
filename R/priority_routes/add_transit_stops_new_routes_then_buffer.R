#' get a Route Pattern ID
#' @param dataframe
#' @returns a vector which combines the agency id, route id, and direction id in a string 

# if (!require(devtools)) {
#   install.packages('devtools')
# }
# devtools::install_github("rtopojson", username="tombuckley")

library(readr)
library(rgdal)
library(gdalUtils)
library(rjson)
library(rtopojson)
library(rgeos)

d1 <- "C:/projects/RTD/RegionalTransitDatabase"
setwd(d1)

#from http://services3.arcgis.com/i2dkYWmb4wHvYPda/arcgis/rest/services/TPAs_2016_Draft_2016_8_5/FeatureServer/0
#docs http://mtc.maps.arcgis.com/home/item.html?id=f1d073078d13450f92b362bdb9cc7827
spdf1 <- readOGR(dsn="data/hf_bus_routes_source.gdb",layer = "tpa_transit_stops_2016")

j1 <- fromJSON(readLines("http://projects.planbayarea.org/assets/js/rtpLines.json"))

name <- names(j1$objects)
geometries <- j1$objects[[name]]$geometries
arcs <- j1$arcs
scale <- j1$transform$scale
translate <- j1$transform$translate

spdf2 <- arcs2sp.line(arcs,scale,translate)

#get shape index (18) in browser, with text filter, add 1, b/c r indexes at 1
geneva_arcs <- j1$objects$linesRTP$geometries[[18+1]]$arcs

#filter both sources down to just what needs to be added
spdf2 <- spdf2[(geneva_arcs+1),]
spdf1 <- spdf1[spdf1$system %in% c("Cable Car","Ferry","Light Rail","Rail"),]
spdf3 <- readOGR(dsn="data/hf_bus_routes_source.gpkg", layer = "hfbus_routes")

proj4string(spdf2) <- CRS("+proj=longlat +datum=WGS84")
spdf1 <- spTransform(spdf1, CRS("+init=epsg:26910"))
spdf2 <- spTransform(spdf2, CRS("+init=epsg:26910"))
spdf3 <- spTransform(spdf3, CRS("+init=epsg:26910"))

spdf1_b <- gBuffer(spdf1,width=804.672)
spdf2_b <- gBuffer(spdf2,width=804.672)

spdf1_b <- SpatialPolygonsDataFrame(spdf1_b,data=data.frame(x=1,row.names=row.names(spdf1_b)))
spdf2_b <- SpatialPolygonsDataFrame(spdf2_b,data=data.frame(x=1,row.names=row.names(spdf2_b)))

writeOGR(spdf1_b,"rail_and_ferry_buffer_half_mile.gpkg",driver="GPKG",layer = "rail_and_ferry_buffer_half_mile", overwrite_layer = TRUE)
writeOGR(spdf2_b,"new_bus_projects_buffer_half_mile.gpkg",driver="GPKG",layer = "new_bus_projects_buffer_half_mile.gpkg", overwrite_layer = TRUE)

#the following results in:
#TopologyException: No forward edges found in buffer subgraph
#spdf3_b <- gBuffer(spdf3,width=804.672)
#did it in arcmap w/buffer tool
# writeOGR(spdf3,"hf_bus_routes_26910.gpkg",driver="GPKG",layer = "hfbus_routes_26910", overwrite_layer = TRUE)
# 
# spdf_hm <- readOGR(dsn="data/hf_bus_routes_source.gdb",layer = "hfbus_routes_buffer_half_mile")
# spdf_qm <- readOGR(dsn="data/hf_bus_routes_source.gdb",layer = "hfbus_routes_buffer_quarter_mile")
# spdf_hm <- spTransform(spdf_hm, CRS("+init=epsg:26910"))
# spdf_qm <- spTransform(spdf_qm, CRS("+init=epsg:26910"))

# the following fails with:
# 1: In RGEOSUnaryPredFunc(spgeom, byid, "rgeos_isvalid") :
#   Too few points in geometry component at or near point 557223.20008970005 4159970.0829471298
# 2: In RGEOSUnaryPredFunc(spgeom, byid, "rgeos_isvalid") :
#   Too few points in geometry component at or near point 556587.23055016994 4176184.56738385
# 3: In RGEOSUnaryPredFunc(spgeom, byid, "rgeos_isvalid") :
#   Too few points in geometry component at or near point 561814.53269999998 4195979.1284999996
# 4: In RGEOSUnaryPredFunc(spgeom, byid, "rgeos_isvalid") :
#   Too few points in geometry component at or near point 552981.20852661994 4172855.6808179901
# spdf_union_hm <- union(spdf_union,spdf_hm)
# spdf_union_qm <- union(spdf_union,spdf_qm)

