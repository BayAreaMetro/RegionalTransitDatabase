PROJECT_PATH <- getwd() #assumes your working directory is just the root of the RegionalTransitDatabase git folder
GTFS_PATH <- paste0(PROJECT_PATH,"/data/05_2017_511_GTFS/AC.zip",collapse="")
R_HELPER_FUNCTIONS_PATH <- paste0(PROJECT_PATH,"/R/r511.R",collapse="")
source(R_HELPER_FUNCTIONS_PATH)

# if (!require(devtools)) {
#   install.packages('devtools')
# }
# devtools::install_github('ropensci/gtfsr')

library(gtfsr)
library(dplyr)

gtfs_obj <- import_gtfs(GTFS_PATH, local=TRUE)

df <- get_peak_bus_route_stops(gtfs_obj)

write.csv(df,file="peak_bus_routes.csv", row.names=FALSE)