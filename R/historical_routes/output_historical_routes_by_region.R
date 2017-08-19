library(sf)
mainDir <- "~/Documents/Projects/rtd2"
setwd(mainDir)
#devtools::install_github('ropensci/gtfsr')
library(gtfsr)
R_HELPER_FUNCTIONS_PATH <- paste0(PROJECT_PATH,"/R/r511.R",collapse="")
source(R_HELPER_FUNCTIONS_PATH)
library(dplyr)
library(readr)
library(dplyr)

#read gtfs cache metadata
cg <- read_csv("~/Documents/Projects/rtd2/data/cached_gtfs.csv")

cg$feedname <- gsub(".zip", "", cg$filename)
cg$route_path <- paste0("data/routes/",cg$year,"/",cg$operator,"/",cg$source)
cg$geojson_name <- paste0(cg$route_path,"/",cg$feedname,".geojson")
cg$gdb_name <- paste0(cg$route_path,"/",cg$feedname,".gpkg")

process_one_feed <- function(cg_row) {
  operatorname <- cg_row['operator']
  s3path <- cg_row['s3pathname']
  gtfs_obj1 <- import_gtfs(s3path)
  rt_df_sp <- convert_gtfs_routes_to_sf(gtfs_obj1)
  dir.create(file.path(cg_row['route_path']), showWarnings = FALSE, recursive = TRUE)
  st_write(rt_df_sp,cg_row['geojson_name'],driver="GeoJSON")
  st_write(rt_df_sp,cg_row['gdb_name'],driver="GPKG")
}

#error handling from http://adv-r.had.co.nz/Exceptions-Debugging.html
results <- apply(cg, 1, function(x) try(process_one_feed(x)))
is.error <- function(x) inherits(x, "try-error")
succeeded <- !vapply(results, is.error, logical(1))