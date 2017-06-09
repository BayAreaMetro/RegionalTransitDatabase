library(readr)
library(rgdal)
library(gdalUtils)
library(rjson)

#' get a Route Pattern ID
#' @param dataframe
#' @returns a vector which combines the agency id, route id, and direction id in a string 

# if (!require(devtools)) {
#   install.packages('devtools')
# }
# devtools::install_github("rtopojson", username="tombuckley")

d1 <- "C:/projects/RTD/RegionalTransitDatabase"
setwd(d1)

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

spdf3 <- readOGR(dsn="data/hf_bus_routes_source.gdb",layer = "hfbus_routes")

proj4string(spdf2) <- CRS("+proj=longlat +datum=WGS84")
spdf2 <- spTransform(spdf2, CRS("+init=epsg:26910"))
spdf3 <- spTransform(spdf3, CRS("+init=epsg:26910"))

spdf1_b <- gBuffer(spdf1,width=804.672)
spdf2_b <- gBuffer(spdf2,width=804.672)
spdf3_b <- gBuffer(spdf3,width=804.672)

spdf_union <-union(spdf1_b, spdf2_b)
spdf_union <- union(spdf_union,spdf3_b)


