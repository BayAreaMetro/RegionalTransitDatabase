#be sure to set the project path
PROJECT_PATH <- "C:/projects/RTD/RegionalTransitDatabase"

GTFS_PATH <- paste0(PROJECT_PATH,"/data/gtfs_interpolated_05_01_20175/",collapse="")
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

l_high_frqncy_rt_bffrs_1_4 <- list()
l_high_frqncy_rt_bffrs_1_2 <- list()

l_high_frqncy_stps <- list()
l_high_frqncy_stps_non_spatial <- list()
l_candidate_routes <- list()

l_all_stops <- list()

################################################
# Section 3. Read a single provider set using GTFSr

for (provider in providers) {
  try(
    {
      l_candidate_routes_provider <- list()
      zip_path <- paste0(provider,".zip",collapse="")
      gtfs_obj <- import_gtfs(zip_path, local=TRUE)
      
      #######
      ##Stops
      #######
      
      ###############################################
      # Section 4. Join all the GTFS provider tables into 1 table based around stops
      
      
      df_sr <- join_all_gtfs_tables(gtfs_obj)
      df_sr <- make_arrival_hour_less_than_24(df_sr)
      
      l_all_stops[[provider]] <- as.data.frame(df_sr)
      
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
      
      df_stp_rt_hf$cnt_adjacent_hf_routes <- rep(0,nrow(df_stp_rt_hf))
      df_stp_rt_hf$lgcl_adjacent_hf_routes <- rep(FALSE,nrow(df_stp_rt_hf))
      
      ########
      ##Routes
      ########
      
      if (dim(am_routes)[1] > 0 & dim(pm_routes)[1] > 0) {
        #############################
        ##Put stops into a 
        ##SpatialPointsDataFrame
        ##Need this later for distance 
        ##from routes calculation
        ############################
        df_stp_rt_hf_xy <- as.data.frame(df_stp_rt_hf)
        coordinates(df_stp_rt_hf_xy) = ~stop_lon + stop_lat
        proj4string(df_stp_rt_hf_xy) <- CRS("+proj=longlat +datum=WGS84")
        df_stp_rt_hf_xy <- spTransform(df_stp_rt_hf_xy, CRS("+init=epsg:26910"))
        
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
          #1/4 mile buffer
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
          
          df_rt_frqncy_sptl <- SpatialPolygonsDataFrame(Sr=l3_flattened, data=dff3,FALSE)
          
          l_high_frqncy_rt_bffrs_1_4[provider] <- df_rt_frqncy_sptl
    
          ##############
          #get route geometries 
          #1/2 mile buffer
          ###############
          
          l3 <- lapply(tpa_route_ids,FUN=get_geoms,gtfs_obj=gtfs_obj,buffer=804.672)
          
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
          
          df_rt_frqncy_sptl <- SpatialPolygonsDataFrame(Sr=l3_flattened, data=dff3,FALSE)
          
          l_high_frqncy_rt_bffrs_1_2[provider] <- df_rt_frqncy_sptl
          
          #########
          ###Route Distance (02. miles)
          ###from hf Stops
          ########
          
          l5 <- lapply(tpa_route_ids,FUN=get_geoms,gtfs_obj=gtfs_obj,buffer=321.869)
    
          list.condition <- sapply(l3, function(x) class(x)!="SpatialPolygons")
          l6  <- l5[list.condition]
          print(l6)
    
          list.condition <- sapply(l3, function(x) class(x)=="SpatialPolygons")
          l5  <- l5[list.condition]
    
          l5_flattened = SpatialPolygons(lapply(l3, function(x){{x@polygons[[1]]}}))
    
          df_rt_frqncy_stop_check <- SpatialPolygonsDataFrame(Sr=l5_flattened, data=dff3,FALSE)
    
          
          proj4string(df_rt_frqncy_stop_check) <- CRS("+init=epsg:26910")
    
          if(dim(as.data.frame(df_rt_frqncy_stop_check))[1]>0) {
            
            m <- gWithin(df_stp_rt_hf_xy, df_rt_frqncy_stop_check, byid = TRUE)
            
            within_distance_of_more_than_one_route <- function(x){table(x)['TRUE']>1}
            
            l2 <- apply(m,2,within_distance_of_more_than_one_route)
            
            number_of_routes_within_distance <- function(x){table(x)['TRUE']}
            l1 <- apply(m,2,number_of_routes_within_distance)
            df_stp_rt_hf_xy$cnt_adjacent_hf_routes <- l1
            df_stp_rt_hf_xy$lgcl_adjacent_hf_routes <- l2
            
          } 
        } else {
          l_candidate_routes_provider$am_routes <- am_routes
          l_candidate_routes_provider$pm_routes <- pm_routes
          l_candidate_routes$provider <- l_candidate_routes_provider
        }
      
      l_high_frqncy_stps[provider] <- df_stp_rt_hf_xy
        
      }
      
      else
      {
        l_candidate_routes_provider$am_routes <- am_routes
        l_candidate_routes_provider$pm_routes <- pm_routes
        l_candidate_routes$provider <- l_candidate_routes_provider
      }
      #writeOGR(df_sp$gtfslines,"Sf_geoms3.csv",driver="CSV",layer = "sf",dataset_options = c("GEOMETRY=AS_WKT"))
    }
  )
}


#################
#bind routes 
#together
################

####
##1/4 mile
####



# 
# spdfout <- l_high_frqncy_rt_bffrs_1_4[[1]]
# spdfout$agency <- names(l_high_frqncy_rt_bffrs_1_4[1])
# 
# for (s in names(l_high_frqncy_rt_bffrs_1_4[2:length(l_high_frqncy_rt_bffrs_1_4)])) {
#   tsdf <- l_high_frqncy_rt_bffrs_1_4[[s]]
#   tsdf$agency <- rep(s,nrow(tsdf))
#   spdfout <- rbind(spdfout,tsdf)
# }
# 
# library(rgdal)
# 
# proj4string(spdfout) <- CRS("+init=epsg:26910")
# writeOGR(spdfout,"hf_buffer_1_4.gpkg",driver="GPKG",layer = "hf_buffer", overwrite_layer = TRUE)

####
##1/2 mile
####

spdfout <- l_high_frqncy_rt_bffrs_1_2[[1]]
spdfout$agency <- names(l_high_frqncy_rt_bffrs_1_2[1])

for (s in names(l_high_frqncy_rt_bffrs_1_2[2:length(l_high_frqncy_rt_bffrs_1_2)])) {
  tsdf <- l_high_frqncy_rt_bffrs_1_2[[s]]
  tsdf$agency <- rep(s,nrow(tsdf))
  spdfout <- rbind(spdfout,tsdf)
}

library(rgdal)
proj4string(spdfout) <- CRS("+init=epsg:26910")
writeOGR(spdfout,"hf_buffer_1_2_2.gpkg",driver="GPKG",layer = "hf_buffer_2", overwrite_layer = TRUE)

# 
# spdfout_26910 <- spTransform(spdfout, CRS("+init=epsg:26910"))
# writeOGR(spdfout_26910,"hf_bus_routes_26910.gpkg",driver="GPKG",layer = "hfbus_routes_26910", overwrite_layer = TRUE)

#################
#bind stops 
#together
################
# 
# spdfout2 <- l_high_frqncy_stps[[1]]
# spdfout2$agency <- names(l_high_frqncy_stps[1])
# 
# for (s in names(l_high_frqncy_stps[2:length(l_high_frqncy_stps)])) {
#   print(s)
#   tsdf <- l_high_frqncy_stps[[s]]
#   print(head(tsdf))
#   tsdf$agency <- rep(s,nrow(tsdf))
#   print(class(tsdf))
#   print(class(spdfout2))
#   print(names(tsdf))
#   print(names(spdfout2))
#   spdfout2 <- rbind(spdfout2,tsdf)
# }
# 
# 
# library(rgdal)
# 
# spdfout2$mtcstpid <- seq(1,nrow(spdfout2))
# 
# writeOGR(spdfout2,"hf_stops.csv",driver="CSV",layer = "hf_stops", overwrite_layer = TRUE)
# 
# spdfout2_sp <- spdfout2[,c("mtcstpid")]
# 
# writeOGR(spdfout2_sp,"hf_stops_spatial.shp",driver="ESRI Shapefile",layer = "hf_stops", overwrite_layer = TRUE)
# 
# writeOGR(spdfout2,"hf_stops.gpkg",driver="GPKG",layer = "hf_stops", overwrite_layer = TRUE)
# 
