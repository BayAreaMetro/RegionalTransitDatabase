library(readr)
library(gsubfn)
library(stringr)
library(magrittr)
library(dplyr)
require(sqldf)

# This makes reading data in from text files much more logical.
options(stringsAsFactors = FALSE)
setwd("~/Documents/MTC/_Section/Planning/Projects/RTD_2017_Data_Processing/data_2017")

#Fix bad times in the arrival and departure time fields
stop_times_fix <- read_csv("stop_times.txt", col_types =cols(
  trip_id = col_character(),
  arrival_time = col_character(),
  departure_time = col_character(),
  stop_id = col_character(),
  stop_sequence = col_integer(),
  agency_id = col_character()
))

gsubfn("^24:", "00:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^25:", "01:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^26:", "02:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^27:", "03:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^28:", "04:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^29:", "05:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^30:", "06:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^31:", "07:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^32:", "08:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^33:", "09:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^34:", "10:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^35:", "11:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^36:", "12:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^37:", "13:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^38:", "14:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^39:", "15:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^40:", "16:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^41:", "17:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^42:", "18:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^43:", "19:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time
gsubfn("^44:", "20:", x = stop_times_fix$arrival_time)->stop_times_fix$arrival_time

gsubfn("^24:", "00:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^25:", "01:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^26:", "02:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^27:", "03:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^28:", "04:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^29:", "05:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^30:", "06:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^31:", "07:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^32:", "08:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^33:", "09:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^34:", "10:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^35:", "11:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^36:", "12:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^37:", "13:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^38:", "14:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^39:", "15:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^40:", "16:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^41:", "17:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^42:", "18:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^43:", "19:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
gsubfn("^44:", "20:", x = stop_times_fix$departure_time)->stop_times_fix$departure_time
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
