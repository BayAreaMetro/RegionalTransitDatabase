p1 <- "~/Documents/Projects/rtd1/data/05_2017_511_GTFS"
p2 <- "~/Documents/Projects/RegionalTransitDatabase/data/05_2017_511_GTFS"

setwd(p2)
df1 = NULL
for (txt in dir(pattern = "_peak_bus_routes.csv$",full.names=TRUE,recursive=TRUE)){
  df1 = rbind(df1, read_csv(txt))
}

df1 <- df
setwd(p1)

df2 <- read_csv("Weekday_Peak_Bus_Routes_Stops_Builder.csv")

r1 <- table(df1$Route_Pattern_ID)
r2 <- table(df2$Route_Pattern_ID)

r2[!(r2 %in% r1)]
