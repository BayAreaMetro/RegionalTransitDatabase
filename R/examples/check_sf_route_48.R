#be sure to set the project path
PROJECT_PATH <- "C:/projects/RTD/RegionalTransitDatabase"

GTFS_PATH <- paste0(PROJECT_PATH,"/data/05_2017_511_GTFS/",collapse="")
R_HELPER_FUNCTIONS_PATH <- paste0(PROJECT_PATH,"/R/r511.R",collapse="")
source(R_HELPER_FUNCTIONS_PATH)
CREDENTIALS_PATH <- paste0(PROJECT_PATH,"credentials.R",collapse="") 

# if (!require(devtools)) {
#   install.packages('devtools')
# }
# devtools::install_github('MetropolitanTransportationCommission/gtfsr')

library(gtfsr)
library(dplyr)

setwd(GTFS_PATH)

library(rjson)
json_file <- paste0(PROJECT_PATH,"/data/orgs.json",collapse="")
providers <- fromJSON(paste(readLines(json_file), collapse=""))

l_p_hf <- list()
l_p_hf_errors <- list()

################################################
# Section 3. Read a single provider set using GTFSr

for (provider in providers) {
  l_p_hf_errors_provider <- list()
  zip_path <- paste0(provider,".zip",collapse="")
  gtfs_obj <- import_gtfs(zip_path, local=TRUE)
  
  ###############################################
  # Section 4. Join all the GTFS provider tables into 1 table based around stops
  
  df_sr <- join_all_gtfs_tables(gtfs_obj)
  df_sr <- make_arrival_hour_less_than_24(df_sr)
  
  ###########################################################################################
  # Section 5. Create Peak Headway tables for weekday trips 
  
  am_stops <- flag_and_filter_peak_periods_by_time(df_sr,"AM")
  am_stops <- remove_duplicate_stops(am_stops) #todo: see https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/issues/31
  am_stops <- count_trips(am_stops) 
  am_stops_hdwy <- subset(am_stops,
                          am_stops$Headways < 16)
  am_routes <- get_routes(am_stops_hdwy)
  
  pm_stops <- flag_and_filter_peak_periods_by_time(df_sr,"PM")
  pm_stops <- remove_duplicate_stops(pm_stops) #todo: see https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/issues/31
  pm_stops <- count_trips(pm_stops)
  pm_stops_hdwy <- subset(pm_stops,
                          pm_stops$Headways < 16)
  pm_routes <- get_routes(pm_stops_hdwy)
  
  ###########################################################################################
  # Section 6. Join the calculated am and pm peak routes (tpa eligible) back to stop tables
  
  df_rt_hf <- join_high_frequency_routes_to_stops(am_stops,pm_stops,am_routes,pm_routes)
  # 
  # ###########################################################################################
  # # Section 7. Join original stops mega-GTFSr data frame to Selected Routes for export to solve routes in Network Analyst
  # 
  df_stp_rt_hf <- join_mega_and_hf_routes(df_sr, df_rt_hf)
  
  df_stp_rt_hf <- deduplicate_final_table(df_stp_rt_hf)
  
  #Remove select cols.
  df_stp_rt_hf <- df_stp_rt_hf[-c(1:13)]
  # 
  
  if (dim(am_routes)[1] > 0 & dim(pm_routes)[1] > 0) {
    #both directions or loop
    am_routes <- am_routes[!duplicated(as.list(am_routes))]
    am_routes <- am_routes[is_in_both_directions(am_routes[,c("route_id","direction_id")]) 
                           | is_loop_route(am_routes$trip_headsign),]
    
    pm_routes <- pm_routes[!duplicated(as.list(pm_routes))]
    pm_routes <- pm_routes[is_in_both_directions(pm_routes[,c("route_id","direction_id")]) 
                           | is_loop_route(pm_routes$trip_headsign),]
    
    #in both am and pm
    am_in_pm <- am_routes$route_id %in% pm_routes$route_id
    pm_in_am <- pm_routes$route_id %in% am_routes$route_id
    dff <- rbind(am_routes[am_in_pm,],pm_routes[pm_in_am,])
    
    if(dim(dff)[1]>0){
      dff2 <- get_route_stats(dff)
      ##############
      #get route geometries
      ###############
      
      tpa_route_ids <- names(table(dff2$route_id))
      l3 <- lapply(tpa_route_ids,FUN=get_geoms,gtfs_obj=gtfs_obj)
      
      list.condition <- sapply(l3, function(x) class(x)!="SpatialPolygons")
      l4  <- l3[list.condition]
      print(l4)
      
      list.condition <- sapply(l3, function(x) class(x)=="SpatialPolygons")
      l3  <- l3[list.condition]
      
      l3_flattened = SpatialPolygons(lapply(l3, function(x){{x@polygons[[1]]}}))
      
      ##############
      #join them to some route stats
      ###############
      dff3 <- get_route_stats_no_direction(dff)
      row.names(dff3) <- dff3$route_id
      
      
      df_rt_frqncy_sptl = SpatialPolygonsDataFrame(Sr=l3_flattened, data=dff3,FALSE)
      
      l_p_hf[provider] <- df_rt_frqncy_sptl
    } else {
      l_p_hf_errors_provider$df_sr <- df_sr
      l_p_hf_errors_provider$am_routes <- am_routes
      l_p_hf_errors_provider$pm_routes <- pm_routes
      l_p_hf_errors$provider <- l_p_hf_errors_provider
    }
  } 
  else
  {
    l_p_hf_errors_provider$df_sr <- df_sr
    l_p_hf_errors_provider$am_routes <- am_routes
    l_p_hf_errors_provider$pm_routes <- pm_routes
    l_p_hf_errors$provider <- l_p_hf_errors_provider
  }
  #writeOGR(df_sp$gtfslines,"Sf_geoms3.csv",driver="CSV",layer = "sf",dataset_options = c("GEOMETRY=AS_WKT"))
}
# 
#bind all the results together and add an agency_id name
spdfout <- l_p_hf[[1]]
spdfout$agency <- names(l_p_hf[1])

for (s in names(l_p_hf[2:length(l_p_hf)])) {
  tsdf <- l_p_hf[[s]]
  tsdf$agency <- s
  spdfout <- rbind(spdfout,tsdf)
}

proj4string(spdfout) <- CRS("+init=epsg:26910")

library(rgdal)
writeOGR(spdfout,"hf_buffer.gpkg",driver="GPKG",layer = "hf_buffers", overwrite_layer = TRUE)
# 
# spdfout_26910 <- spTransform(spdfout, CRS("+init=epsg:26910"))
# writeOGR(spdfout_26910,"hf_bus_routes_26910.gpkg",driver="GPKG",layer = "hfbus_routes_26910", overwrite_layer = TRUE)

