library(readr)
library(rgdal)
library(gdalUtils)

#' get a Route Pattern ID
#' @param dataframe
#' @returns a vector which combines the agency id, route id, and direction id in a string 

d1 <- "C:/projects/RTD/RegionalTransitDatabase"
setwd(d1)

spdf_src <- readOGR(dsn="data/hf_bus_routes_source.gdb",layer = "hfbus_routes")
spdf_na <- readOGR(dsn="data/hf_bus_routes_source.gdb",layer = "WeekdayPeakPeriodRoutes")

df_src <- as.data.frame(spdf_src)
df_na <- as.data.frame(spdf_na)

df_src$agency <- as.character(df_src$agency)
df_src$route_id <- as.character(df_src$route_id)

df_na2 <- cbind(df_na,colsplit(df_na$Name, "-", names = c("agency","route_id","direction_id","headsign")))

sapply(df_na,class)
sapply(df_src,class)

df_src$direction_id <- as.character(df_src$direction_id)
df_src$direction_id <- str_replace(df_src$direction_id,"0","Outbound")
df_src$direction_id <- str_replace(df_src$direction_id,"1","Inbound")

na_not_in_src <- anti_join(df_na2,df_src)
src_not_in_na <- anti_join(df_src,df_na2)

write.csv(na_not_in_src, "na_not_in_src.csv")
write.csv(src_not_in_na, "src_not_in_na.csv")