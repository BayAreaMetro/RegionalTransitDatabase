library(readr)
d1 <- "~/Documents/Projects/rtd/data/05_2017_511_GTFS"
setwd(d1)

df_bp <- read_csv("Weekday_Peak_Routes_Builder.csv")
df_all <- read_csv("Weekday_Peak_Bus_Routes_Stops_Builder.csv")

#make the route ID's match
library(stringr)
df_all$Route_Pattern_ID <- str_replace(df_all$Route_Pattern_ID,"Outbound", "0")
df_all$Route_Pattern_ID <- str_replace(df_all$Route_Pattern_ID,"Inbound", "1")

r_bp <- names(table(df_bp$Route_Pattern_ID))
r_all <- names(table(df_all$Route_Pattern_ID))

#table of routes in all-providers method not in by-provider method
length(r_all[!(r_all %in% r_bp)])
r_all[!(r_all %in% r_bp)]

#table of routes in the by-provider method not in the all-providers method
length(r_bp[!(r_bp %in% r_all)])
r_bp[!(r_bp %in% r_all)]

df_bp_back <- df_bp
df_all_back <- df_all

#compare the headways
df_bp <- df_bp_back[c('Route_Pattern_ID','Headway')]
df_all <- df_all_back[c('Route_Pattern_ID','Headway')]

rp_g <- group_by(df_bp, Route_Pattern_ID)
df_bp_hdwy <- summarize(rp_g, mean(Headway))

ra_g <- group_by(df_all, Route_Pattern_ID)
df_all_hdwy <- summarize(ra_g, mean(Headway))

cmpr_hdwy <- inner_join(df_bp_hdwy, df_all_hdwy, by = "Route_Pattern_ID", copy = FALSE, suffix = c(".bp", ".all"))

print(cmpr_hdwy)
                        
#compare the counts
df_bp <- df_bp_back[c('Route_Pattern_ID','Total_Trips')]
df_all <- df_all_back[c('Route_Pattern_ID','Total_Trips')]

rp_g <- group_by(df_bp, Route_Pattern_ID)
df_bp_trps <- summarize(rp_g, mean(Total_Trips))

ra_g <- group_by(df_all, Route_Pattern_ID)
df_all_trps <- summarize(ra_g, mean(Total_Trips))

cmpr_trips <- inner_join(df_bp_trps, df_all_trps, by = "Route_Pattern_ID", copy = FALSE, suffix = c(".bp", ".all"))

print(cmpr_trips)

