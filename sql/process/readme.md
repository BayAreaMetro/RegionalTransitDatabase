## Steps   

### Goal  

From source GTFS data, compile a database of tables for use in estimating bus frequency and stop adjacency for Transit Priority Area estimation.  

### Input Tables:  

-  `stop_times`
-  `stops`
-  `routes`
-  `calendar`
-  `agency`   

### Output Tables/Views:  

-  `route_trips`: join `agency`, `routes`, and `trips`, filter for bus only  
-  ~~`rtd_route_stop_schedule`: join `rtd_route_trips` with `stop_times` and `calendar`~~   
-  `route_stop_schedule`: remove duplicate arrivals (by time) in `rtd_route_stop_schedule` and count them in column: `Duplicate_Arrival_Times`
-  ~~`TPA_TRANSIT_STOPS`:  a version of `route_stop_schedule` in which stops are flagged as 'TPA eligible' or not based on the criteria [here](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/c0f04b36e99a4aa702b7bd3ecfd8608c6bf4b1bf/sql/process/step_3_build_headway_am_pm_views.sql#L17-L19). The schema is [here](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/c0f04b36e99a4aa702b7bd3ecfd8608c6bf4b1bf/sql/process/step_5_insert_weekday_am_pm_headway_into_single_table.sql#L15-L35).~~   
-  ~~`rtd_route_stop_all_other_modes`: non-bus stops that are eventually added into `stops_tpa_staging` in order to calculate their TPA eligibility.~~  
-  `TPA_Future_Transit_Stops`:  we don't have this table in the db yet, but it represents future or planned stops, which should eventually be included as part of the eligibility calculation below.  
-  `stops_tpa_staging`: built from `TPA_TRANSIT_STOPS` and contains the column `Distance_Eligible`, which flags whether a stop is within a distance threshold of other stops, another TPA eligibility criteria.
-  `stops_bus_route_pattern_schedule`: 
-  `stops_bus_route_pattern`:
             


##### Step 1. Build rtd_route_trips view.   
view(table) created: `dbo.rtd_route_trips `    
##### Step 2. Building Route Stop Schedule Table (route_stop_schedule).   
view(table) created: `dbo.rtd_route_stop_schedule `    
Create route_stop_schedule to remove duplicate arrival times for select operators   
Duplicate removal   
##### Step 3. Building Weekday (Monday thru Friday) AM/PM Peak Transit Stop Headway Views.      
Tables created:  
	-  `Monday_AM_Peak_Transit_Stop_Headways`  
	-  `Monday_PM_Peak_Transit_Stop_Headways`  
	-  `Tuesday_AM_Peak_Transit_Stop_Headways`  
	-  etc...   
	FROM            dbo.route_stop_schedule
##### Step 4. Building Views for Weekday (Monday thru Friday) AM/PM Peak Transit Routes/Stops with 15 min or better Headways.   
Tables created:  
	-  `Monday_AM_Peak_Trips_15min_or_Less`   
	-  `Monday_PM_Peak_Trips_15min_or_Less`   
	-  `Tuesday_AM_Peak_Trips_15min_or_Less`   
	-  etc...   
##### Step 5. Insert Weekday (Monday thru Friday) AM/PM Peak Headway values into a container for summarization (TPA_TRANSIT_STOPS table).   
e.g.
```
	Update dbo.[TPA_TRANSIT_STOPS]
	Set Weekday = 'Monday   
	Where #Parse DateTime
```
##### Step 6. Building Final Table for Map Display   
table created: `dbo.stops_tpa_staging`    
##### Step 7. Flag Bus Stops that meet the AM/PM Peak Thresholds   

```
update dbo.stops_tpa_staging
set Meets_Headway_Criteria = 1
Where ((Avg_Weekday_AM_Headway <=15) and (Avg_Weekday_PM_Headway <=15))-- and (Meets_Headway_Criteria = 0 or Meets_Headway_Criteria is null)
```

##### Step 8. Insert Planned and Under Construction Transit Stops   

A bunch of Fixes to data in `dbo.stops_tpa_staging`

-  Fix the column name in the TPA_Future_Transit_Stops Table  

##### Step 9. Build view of all existing Rail, Light Rail, Cable Car, and Ferry Stops      

Step 10.   
-  Append all existing Rail, Light Rail, Cable Car, and Ferry Stops into stops_tpa_staging     
-  Fix Null Route ID values in stops_tpa_staging table     
-  Ensure that all Rail, BRT, Light Rail and Ferry Stops are flagged TPA Eligible     
-  Fix Route Names for unclassified values in the Future Transit Table     
-  Fix route_id values that are null or missing     
-  Also need to add a Distance Flag field to hold the boolean value for stops that have an adjacent stop within the AM/PM Peak   Headway threshold.
-  Add Geography to Shape Field     
A BUNCH of spatial data work goes here (indexes, within, etc)   

Step 11. 

The following all assign boolean categorical style fields based on the spatial work from the above spatial step

-  Flag bus stops that are TPA Eligible   
-  Flag stops that do not meet the distance criteria   
-  Flag stops that do not meet the headway criteria   
-  Flag stops that are not TPA Eligible   
-  Flag Rail, Ferry, Light Rail, Cable Car, Bus Rapid Transit stops that are TPA Eligible   
-  Fix stop_name values that are in UPPER Case format   
-  Creating Final View for Mapping Purposes.  Contains only Eligible Transit Stops   

## Tables:   

### Key Temporary Tables:

-  `stops_tpa_staging`   
-  `TPA_TRANSIT_STOPS`   
-  `TPA_Stops_2017_Draft`   

### Key Final Tables:
- `rtd_route_stop_all_other_modes`     
- `rtd_route_stop_schedule`     
- `rtd_route_trips`     
- `stops_tpa_draft`   
- `stops_tpa_final`   


## Other files:

-  `existing_and_planned.sql` - for now we are moving existing/planned queries out to this file and will put them back in later.  other relevant columns removed from a number of queries are found [here](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/commit/e14a773645881c15bf1d2e0d16a2dbc4a5ac5069)  

