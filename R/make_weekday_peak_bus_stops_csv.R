#be sure to set the project path
PROJECT_PATH <- setwd("/Users/tommtc/Documents/Projects/RegionalTransitDatabase")

GTFS_PATH <- paste0(PROJECT_PATH,"/data/05_2017_511_GTFS/",collapse="")
R_HELPER_FUNCTIONS_PATH <- paste0(PROJECT_PATH,"/R/r511.R",collapse="")
source(R_HELPER_FUNCTIONS_PATH)

# if (!require(devtools)) {
#   install.packages('devtools')
# }
# devtools::install_github('ropensci/gtfsr')

library(gtfsr)
library(dplyr)

setwd(GTFS_PATH)

results <- list()

for (txt in dir(pattern = ".zip$",full.names=TRUE,recursive=TRUE)){
  result = tryCatch({
    operator_prefix <- strsplit(strsplit(txt, "/")[[1]][[2]],".zip")[[1]]
    gtfs_obj <- import_gtfs(txt, local=TRUE)
    df <- get_peak_bus_route_stops(gtfs_obj)
    peak_routes_filename <- paste0(c(operator_prefix,"_peak_bus_routes.csv"),collapse="")
    write.csv(df,file=peak_routes_filename, row.names=FALSE)
    },
    error=function(cond) {
      message(paste("The following provider had errors:", operator_prefix))
      message("Here's the original error message:")
      message(cond)
      return(cond)
    },
    warning=function(cond) {
      message(paste("The following provider had a warning:", operator_prefix))
      message("Here's the original warning message:")
      message(cond)
      return(cond)
    },
    finally={
      message(paste("Processed operator:", operator_prefix))
    }
  )    
  results[[operator_prefix]] <- result
}


