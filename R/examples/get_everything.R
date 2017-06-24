#be sure to set the project path
PROJECT_PATH <- "C:/projects/RTD/RegionalTransitDatabase"

GTFS_PATH <- paste0(PROJECT_PATH,"/data/gtfs_interpolated_05_01_20175/",collapse="")
R_HELPER_FUNCTIONS_PATH <- paste0(PROJECT_PATH,"/R/r511.R",collapse="")
source(R_HELPER_FUNCTIONS_PATH)
CREDENTIALS_PATH <- paste0(PROJECT_PATH,"/credentials.R",collapse="") 

# if (!require(devtools)) {
#   install.packages('devtools')
# }
# devtools::install_github('MetropolitanTransportationCommission/gtfsr')

library(gtfsr)
library(dplyr)
library(rgeos)
library(reshape2)
library(sp)

setwd(GTFS_PATH)

library(rjson)
json_file <- paste0(PROJECT_PATH,"/data/orgs.json",collapse="")
providers <- fromJSON(paste(readLines(json_file), collapse=""))

################################################
# Section 3. Read a single provider set using GTFSr

l_gtfs_obj <- list()

l_high_frqncy_stops <- list()
l_high_frqncy_rt_bffrs_1_4 <- list()
l_high_frqncy_rt_bffrs_1_2 <- list()

for (provider in providers) {

  zip_path <- paste0(provider,".zip",collapse="")
  gtfs_obj <- import_gtfs(zip_path, local=TRUE)
  
  l_gtfs_obj[[provider]] <- get_priority_routes(gtfs_obj)
  
  #this is a legacy setup--looping through these lists
  if(exists("gtfs_obj_mtc$mtc_priority_stops") && 
     is.data.frame(get("gtfs_obj_mtc$mtc_priority_stops")) &&
     dim(gtfs_obj_mtc$mtc_priority_stops)[1]>0) {
    l_high_frqncy_stops[[provider]] <- gtfs_obj_mtc$mtc_priority_stops
  }
  #l_high_frqncy_routes[[provider]] <- gtfs_objp$mtc_priority_routes
  
  ##TPA Geometry output - Line Buffers
  if(exists("gtfs_obj_mtc$mtc_priority_routes") && 
     is.data.frame(get("gtfs_obj_mtc$mtc_priority_routes")) &&
     dim(gtfs_obj_mtc$mtc_priority_routes)[1]>0) {
    l_high_frqncy_rt_bffrs_1_4[[provider]] <- get_buffered_tpa_routes(gtfs_obj_mtc$mtc_priority_routes, 
                                                                      gtfs_obj_mtc, 
                                                                      buffer=402.336)
    l_high_frqncy_rt_bffrs_1_2[[provider]] <- get_buffered_tpa_routes(gtfs_obj_mtc$mtc_priority_routes, 
                                                                      gtfs_obj_mtc, 
                                                                      buffer=804.672)
  }
}




#################
#bind routes
#together
################

####
##1/4 mile
####

hf_rts_1_4_ml_buf <- bind_list_of_routes_spatial_dataframes(l_high_frqncy_rt_bffrs_1_4)

####
##1/2 mile
####

hf_rts_1_2_ml_buf <- bind_list_of_routes_spatial_dataframes(l_high_frqncy_rt_bffrs_1_2)

################
#bind stops
#together
###############

hf_stops <- l_high_frqncy_stps[[1]]
hf_stops$agency <- names(l_high_frqncy_stps[1])

for (s in names(l_high_frqncy_stps[2:length(l_high_frqncy_stps)])) {
  tsdf <- l_high_frqncy_stps[[s]]
  tsdf$agency <- rep(s,nrow(tsdf))
  hf_stops <- rbind(hf_stops,tsdf)
}

############
##Write to Files
############

write_to_geopackage_with_date(hf_rts_1_2_ml_buf)
write_to_geopackage_with_date(hf_rts_1_4_ml_buf)

# fix buggy names,
# for why, see: http://r-sig-geo.2731867.n2.nabble.com/Bug-in-writeOGR-MSSQLSpatial-driver-td7583633.html
# row.names(spdfout_stps) <- as.character(1:nrow(spdfout_stps))

write_to_geopackage_with_date(hf_stops)

hf_stops_with_hf_neighbors <- hf_stops[hf_stops$lgcl_adjacent_hf_routes==TRUE,]

hf_stops_with_hf_neighbors_buffer <- SpatialPolygonsDataFrame(
  gBuffer(hf_stops_with_hf_neighbors,width=804.672,byid = TRUE),
  data=hf_stops_with_hf_neighbors@data)

write_to_geopackage_with_date(hf_stops_with_hf_neighbors_buffer)


