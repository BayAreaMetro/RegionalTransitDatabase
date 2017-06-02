#be sure to set the project path
PROJECT_PATH <- "C:/projects/RTD/RegionalTransitDatabase"

GTFS_PATH <- paste0(PROJECT_PATH,"/data/05_2017_511_GTFS/",collapse="")
R_HELPER_FUNCTIONS_PATH <- paste0(PROJECT_PATH,"/R/r511.R",collapse="")
source(R_HELPER_FUNCTIONS_PATH)

# if (!require(devtools)) {
#   install.packages('devtools')
# }
# devtools::install_github('ropensci/gtfsr')

#library(gtfsr)
library(dplyr)

setwd(GTFS_PATH)

################################################
# Section 3. Read a single provider set using GTFSr

providers <- c("SM","EM","MS","SF","AC","SC")

for (provider in providers[2:6]) {
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
  
  ###########################################################################################
  # Section 7. Join original stops mega-GTFSr data frame to Selected Routes for export to solve routes in Network Analyst
  
  df_stp_rt_hf <- join_mega_and_hf_routes(df_sr, df_rt_hf)
  
  df_stp_rt_hf <- deduplicate_final_table(df_stp_rt_hf)
  
  #Remove select cols.
  df_stp_rt_hf <- df_stp_rt_hf[-c(1:13)]
  
  ##############
  #get route geometries and write to disk
  ###############
  
  
  #subset to only HF routes
  #gtfs_geoms[(gtfs_geoms %in% am_routes$route_id)]
  
  l2 <- get_hf_geoms(am_routes,pm_routes,gtfs_obj)
  sldf_rt_id <- route_id_indexed_sldf(l2)
  writeOGR(sldf_rt_id ,paste0(provider,"_shapes_route_indexed.gpkg",collapse=""),driver="GPKG",layer = provider, overwrite_layer = TRUE)
  library(rgdal)
  writeOGR(l2$sldf,paste0(provider,"_shapes.gpkg",collapse=""),driver="GPKG",layer = provider, overwrite_layer = TRUE)
  library(foreign)
  df <- as.data.frame(l2$df)
  write.dbf(df, file=paste0(provider,"_shapes_to_route_id.dbf",collapse=""), factor2char = TRUE, max_nchar = 254)
  rm(df)
  #writeOGR(df_sp$gtfslines,"Sf_geoms3.csv",driver="CSV",layer = "sf",dataset_options = c("GEOMETRY=AS_WKT"))
}


#sketch for getting the other data on the spatial dataframe:
#join shapes_routes_df on shape_id
#join am_routes and pm_routes to the output of that on route_id
#one way to do this: make a list of all of the above
#reduce to get output of a table
#then relate spatial dataframe back to the table somehow



