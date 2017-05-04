## Tables:   

### Key Temporary Tables:

-  `TPA_Transit_Stops_2016_Build`   
-  `TPA_TRANSIT_STOPS`   
-  `TPA_Stops_2016_Draft`   

### Key Final Tables:
- `rtd_route_stop_all_other_modes`     
- `rtd_route_stop_schedule`     
- `rtd_route_trips`     
- `TPA_Transit_Stops_2016_Draft`   

## Steps   

### Step 1. Build rtd_route_trips view.   
		view(table) created: `dbo.rtd_route_trips `  
### Step 2. Building Route Stop Schedule Table (route_stop_schedule).   
		view(table) created: `dbo.rtd_route_stop_schedule `  
### Create route_stop_schedule to remove duplicate arrival times for select operators   
Duplicate removal  
### Step 3. Building Weekday (Monday thru Friday) AM/PM Peak Transit Stop Headway Views.';
#### Tables created:  
	-  `Monday_AM_Peak_Transit_Stop_Headways`  
	-  `Monday_PM_Peak_Transit_Stop_Headways`  
	-  `Tuesday_AM_Peak_Transit_Stop_Headways`  
	-  `Tuesday_PM_Peak_Transit_Stop_Headways`  
	-  `Wednesday_AM_Peak_Transit_Stop_Headways`  
	-  `Wednesday_PM_Peak_Transit_Stop_Headways`  
	-  `Thursday_AM_Peak_Transit_Stop_Headways`  
	-  `Thursday_PM_Peak_Transit_Stop_Headways`  
	-  `Friday_AM_Peak_Transit_Stop_Headways`  
	-  `Friday_PM_Peak_Transit_Stop_Headways`  
	FROM            dbo.route_stop_schedule
### Step 4. Building Views for Weekday (Monday thru Friday) AM/PM Peak Transit Routes/Stops with 15 min or better Headways.   
#### Tables created:  
	-  `Monday_AM_Peak_Trips_15min_or_Less`   
	-  `Monday_PM_Peak_Trips_15min_or_Less`   
	-  `Tuesday_AM_Peak_Trips_15min_or_Less`   
	-  `Tuesday_PM_Peak_Trips_15min_or_Less`   
	-  `Wednesday_AM_Peak_Trips_15min_or_Less`   
	-  `Wednesday_PM_Peak_Trips_15min_or_Less`   
	-  `Thursday_AM_Peak_Trips_15min_or_Less`   
	-  `Thursday_PM_Peak_Trips_15min_or_Less`   
	-  `Friday_AM_Peak_Trips_15min_or_Less`   
	-  `Friday_PM_Peak_Trips_15min_or_Less`   
### Step 5. Insert Weekday (Monday thru Friday) AM/PM Peak Headway values into a container for summarization (TPA_TRANSIT_STOPS table).   
#e.g.
```
	Update dbo.[TPA_TRANSIT_STOPS]
	Set Weekday = 'Monday   
	Where #Parse DateTime
```
### Step 6. Building Final Table for Map Display   
table created: `dbo.TPA_Transit_Stops_2016_Build`   
### Step 7. Flag Bus Stops that meet the AM/PM Peak Thresholds   

```
update dbo.TPA_Transit_Stops_2016_Build
set Meets_Headway_Criteria = 1
Where ((Avg_Weekday_AM_Headway <=15) and (Avg_Weekday_PM_Headway <=15))-- and (Meets_Headway_Criteria = 0 or Meets_Headway_Criteria is null)
```

### Step 8. Insert Planned and Under Construction Transit Stops   

### A bunch of Fixes to data in `dbo.TPA_Transit_Stops_2016_Build`

-  Fix the column name in the TPA_Future_Transit_Stops Table  

-  Step 9. Build view of all existing Rail, Light Rail, Cable Car, and Ferry Stops     
view(table): `dbo.rtd_route_stop_all_other_modes`     

-  Append all existing Rail, Light Rail, Cable Car, and Ferry Stops into TPA_Transit_Stops_2016_Build     
view(table): `dbo.TPA_Transit_Stops_2016_Build`   

-  Fix Null Route ID values in TPA_Transit_Stops_2016_Build table     

-  Ensure that all Rail, BRT, Light Rail and Ferry Stops are flagged TPA Eligible     

-  Fix Route Names for unclassified values in the Future Transit Table     
-  Fix route_id values that are null or missing     
-  Also need to add a Distance Flag field to hold the boolean value for stops that have an adjacent stop within the AM/PM Peak   Headway threshold.

### Add Geography to Shape Field   

A BUNCH of spatial data work goes here (indexes, within, etc)

##### The following all assign boolean categorical style fields based on the spatial work from the above step
- Flag bus stops that are TPA Eligible   
- Flag stops that do not meet the distance criteria   
- Flag stops that do not meet the headway criteria   
- Flag stops that are not TPA Eligible   
- Flag Rail, Ferry, Light Rail, Cable Car, Bus Rapid Transit stops that are TPA Eligible   
- Fix stop_name values that are in UPPER Case format   
- Creating Final View for Mapping Purposes.  Contains only Eligible Transit Stops   

