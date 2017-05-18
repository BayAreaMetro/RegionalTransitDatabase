library(readr)
library(gsubfn)
library(stringr)
library(magrittr)
library(dplyr)
source("r511.r")

# This makes reading data in from text files much more logical.
options(stringsAsFactors = FALSE)
setwd("C:/projects/RTD/RegionalTransitDatabase/data/05_2017_511_GTFS")

#Fix bad times in the arrival and departure time fields
stop_times_fix <- read_csv("AC/stop_times.txt", col_types =cols(
  trip_id = col_character(),
  arrival_time = col_character(),
  departure_time = col_character(),
  stop_id = col_character(),
  stop_sequence = col_integer()
))

t1 <- stop_times_fix$arrival_time
t2 <- stop_times_fix$departure_time
stop_times_fix$arrival_time <- sapply(t1,FUN=fix_hour)
stop_times_fix$departure_time <- sapply(t2,FUN=fix_hour)

#Output table fixes
write.csv(stop_times_fix, file="stop_times_fix.txt", row.names=FALSE)
rm(stop_times_fix)
#Import stop_times tbl from repaired output
 stop_times <- read_csv("stop_times_fix.txt", col_types =cols(
   trip_id = col_character(),
   arrival_time = col_time(format= "%H:%M:%S"),
   departure_time = col_time(format= "%H:%M:%S"),
   stop_id = col_character(),
   stop_sequence = col_integer(),
   agency_id = col_character()
 ))

#When exporting the data frame to a data table, be sure to reformat the arrival_time value to text.
#Reformat arrival_time col. to hour | min | sec format prior to export to Data Table.
Weekday_Peak_Bus_Routes_TPA_Listing$arrival_time <- as.character(Weekday_Peak_Bus_Routes_TPA_Listing$arrival_time)
