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
library(rgeos)

setwd(GTFS_PATH)

library(rjson)
json_file <- paste0(PROJECT_PATH,"/data/orgs.json",collapse="")
providers <- fromJSON(paste(readLines(json_file), collapse=""))

#create a bunch of lists
#to fill with output data
#and some dataframes for debugging
#some of these may not be used anymore
#and should be cleared out
l_high_frqncy_rt_bffrs_1_4 <- list()
l_high_frqncy_rt_bffrs_1_2 <- list()

l_all_stops <- list()
l_nearly_qualifying_routes <- list()
l_non_qualifying_routes <- list()
l_nearly_qualifying_routes_sp <- list()

l_high_frqncy_stps <- list()

################################################
# Section 3. Read a single provider set using GTFSr

for (provider in providers) {
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
      am_routes_nonq <- get_routes(am_stops)
      
      pm_stops <- flag_and_filter_peak_periods_by_time(df_sr,"PM")
      pm_stops <- remove_duplicate_stops(pm_stops) #todo: see https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/issues/31
      pm_stops <- count_trips(pm_stops)
      pm_stops_hdwy <- subset(pm_stops,
                              pm_stops$Headways < 16)
      pm_routes <- get_routes(pm_stops_hdwy)
      pm_routes_nonq <- get_routes(pm_stops)
      
      ###########################################################################################
      # Section 6. Join the calculated am and pm peak routes (tpa eligible) back to stop tables
      
      df_rt_hf <- join_high_frequency_routes_to_stops(am_stops,pm_stops,am_routes,pm_routes)
      
      # df_rt_hf_non_qualifying <- join_high_frequency_routes_to_stops(am_stops,pm_stops,am_routes_nonq,pm_routes_nonq)
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
      
      df_stp_rt_hf <- df_stp_rt_hf[is_in_both_periods(df_stp_rt_hf[,c("stop_id","Peak_Period")]),]
      
    
      #do the same for all non-qualifying routes
      # 
      # df_stp_rt_hf_non_q <- join_mega_and_hf_routes(df_sr, df_rt_hf_non_qualifying)
      # 
      # df_stp_rt_hf_non_q <- deduplicate_final_table(df_stp_rt_hf_non_q)
      # 
      # #Remove select cols.
      # df_stp_rt_hf_non_q <- df_stp_rt_hf_non_q[-c(1:13)]
      
      
      ########
      ##Routes
      ########

      df_non_qualifying_rts <- get_routes_with_geoms_and_stats(am_routes_nonq,pm_routes_nonq)
    
      #see bottom of next if statement for where nq_sp is put in a list 
      
      ########
      ##Routes-Qualifying
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
        df_qualifying_routes <- rbind(am_routes[am_in_pm,],pm_routes[pm_in_am,])
        
        if(dim(df_potential_routes)[1]>0){
          l_nearly_qualifying_routes[[provider]] <- get_routes_with_geoms_and_stats(am_routes[!am_in_pm,],pm_routes[!pm_in_am,])
        } # end potential_routes if statement
        
        if(dim(df_qualifying_routes)[1]>0){
          
          library(reshape2)
          df_qualifying_routes_stats <- get_route_stats_no_direction(df_qualifying_routes)
          row.names(df_qualifying_routes_stats) <- df_qualifying_routes_stats$route_id
          ##############
          #get route geometries 
          #1/4 mile buffer
          ###############
          tpa_route_ids <- names(table(df_qualifying_routes_stats$route_id))
          
          spply_1_4 <- get_route_geometries(tpa_route_ids, buffer=402.336)
          
          df_rt_frqncy_sptl_1_4 <- SpatialPolygonsDataFrame(Sr=spply_1_4, data=df_qualifying_routes_stats,FALSE)

          l_high_frqncy_rt_bffrs_1_4[provider] <- df_rt_frqncy_sptl_1_4
                    
          ##############
          #get route geometries 
          #1/2 mile buffer
          ###############
          
          spply_1_2 <- get_route_geometries(tpa_route_ids, buffer=804.672)
          
          df_rt_frqncy_sptl_1_2 <- SpatialPolygonsDataFrame(Sr=spply_1_2, data=df_qualifying_routes_stats,FALSE)
          
          l_high_frqncy_rt_bffrs_1_2[provider] <- df_rt_frqncy_sptl_1_2
          
          #########
          ###Route Distance (02. miles)
          ###from hf Stops
          ########
          
          spply_minimal <- get_route_geometries(tpa_route_ids, buffer=0.10)
          
          proj4string(spply_minimal) <- CRS("+init=epsg:26910")
          
          df_rt_frqncy_sptl <- SpatialPolygonsDataFrame(Sr=spply_minimal, data=df_qualifying_routes_stats,FALSE)
          
          if(dim(as.data.frame(df_rt_frqncy_sptl))[1]>0) {
            #drop stops not on hf routes
            df_stp_rt_hf_xy <- df_stp_rt_hf_xy[df_stp_rt_hf_xy$route_id %in% df_rt_frqncy_sptl$route_id,] 
            
            #get high freq stops with hf neigbors
            m1 <- gWithinDistance(df_stp_rt_hf_xy, df_stp_rt_hf_xy, byid = TRUE, dist = 321.869)
            m2 <- outer(df_stp_rt_hf_xy$route_id,df_stp_rt_hf_xy$route_id, FUN= "!=")
            m3 <- m1 == TRUE & m2 == TRUE

            number_of_routes_within_distance <- function(x){table(x)['TRUE']}
            l1 <- apply(m3,2,number_of_routes_within_distance)
            df_stp_rt_hf_xy$cnt_adjacent_hf_routes <- l1
            
            within_distance_of_more_than_one_route <- function(x){table(x)['TRUE']>0}
            l2 <- apply(m3,2,within_distance_of_more_than_one_route)
            l2[is.na(l2)] <- FALSE
            
            df_stp_rt_hf_xy$lgcl_adjacent_hf_routes <- l2
            df_stp_rt_hf_xy$dst_frm_rte <- get_stops_distances_from_routes(df_stp_rt_hf_xy,df_rt_frqncy_sptl)
            
            l_high_frqncy_stps[[provider]] <- df_stp_rt_hf_xy
          }
          
        #drop qualifying routes from non-qualifying dataframe
          nq_sp <- nq_sp[!nq_sp$route_id %in% tpa_route_ids,]
          l_non_qualifying_routes[[provider]] <- nq_sp
        }
        else
        {
          l_non_qualifying_routes[[provider]] <- nq_sp  
        }
        
      #writeOGR(df_sp$gtfslines,"Sf_geoms3.csv",driver="CSV",layer = "sf",dataset_options = c("GEOMETRY=AS_WKT"))
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

non_qualifying_routes <- bind_list_of_routes_spatial_dataframes(l_non_qualifying_routes)

nearly_qualifying_routes <- bind_list_of_routes_spatial_dataframes(l_nearly_qualifying_routes_sp)

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
write_to_geopackage_with_date(non_qualifying_routes)

# fix buggy names,
# for why, see: http://r-sig-geo.2731867.n2.nabble.com/Bug-in-writeOGR-MSSQLSpatial-driver-td7583633.html
# row.names(spdfout_stps) <- as.character(1:nrow(spdfout_stps))

write_to_geopackage_with_date(hf_stops)

hf_stops_with_hf_neighbors <- hf_stops[hf_stops$lgcl_adjacent_hf_routes==TRUE,]

hf_stops_with_hf_neighbors_buffer <- SpatialPolygonsDataFrame(
  gBuffer(hf_stops_with_hf_neighbors,width=804.672,byid = TRUE),
  data=hf_stops_with_hf_neighbors@data)

write_to_geopackage_with_date(hf_stops_with_hf_neighbors_buffer)


