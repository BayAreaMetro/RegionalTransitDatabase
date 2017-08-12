library(sf)
setwd("~/Documents/Projects/rtd2")
#devtools::install_github('ropensci/gtfsr')
library(gtfsr)
R_HELPER_FUNCTIONS_PATH <- paste0(PROJECT_PATH,"/R/r511.R",collapse="")
source(R_HELPER_FUNCTIONS_PATH)
library(dplyr)
library(rgeos)
library(readr)
library(dplyr)

year <- 2009
print(year)

#get routes

#read gtfs cache metadata
cg <- read_csv("~/Documents/Projects/rtd2/data/cached_gtfs.csv")

cg$feedname <- gsub(".zip", "", cg$filename)
cg$gdb_path <- paste0("data/routes-",cg$year,"-",cg$operator,"-",cg$source)
cg$gdb_name <- paste0(cg$gdb_path,"-",cg$feedname,".gpkg")

process_one_feed <- function(cg_row) {
  operatorname <- cg_row['operator']
  print(operatorname)
  s3path <- cg_row['s3pathname']
  gtfs_obj1 <- import_gtfs(s3path)
  rt_df_sp <- convert_gtfs_routes_to_sf(gtfs_obj1)
  st_write(rt_df_sp,cg_row['gdb_name'],driver="GPKG")
}

#error handling from http://adv-r.had.co.nz/Exceptions-Debugging.html
results <- apply(cg, 1, function(x) try(process_one_feed(x)))
is.error <- function(x) inherits(x, "try-error")
succeeded <- !vapply(results, is.error, logical(1))

if(FALSE) {
  
  ########
  #scratch work below
  #######
  # to do:
  # 1) merge by year
  
  #drop operators with null for sf data
  bind_routes_together_by_year <- function (df1,year) {
    year <- years[i]
    df_bind <- l2[[1]]
    for (i in c(2:length(l2))){
      df_bind <- rbind(df_bind,l2[[i]])
    }
    return(df_bind)
  }
  
  #one way to get a year/provider subset: 
  #get first row of each year for each provider
  #might need to reowrk this based on succeeded processing above
  cg_operator_year <- cg %>% group_by(operator,year) %>%
    filter(row_number()==1)
  
  years <- unique(cg_operator_year$year)
  
  for (i in length(years)) {
    year <- years[i]
    l_sfs[[year]] <- bind_routes_together_by_year(cg_operator_year,year)
  }

}