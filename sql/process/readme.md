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

Tables below are followed by their SQL file prefix. e.g. `s1_*filename*`  

-  `stops_bus_route_pattern` (table) - s13
-  `stops_tpa_final` (table)  - s12
-  `stops_meeting_headway_criteria` (view) -s13

#### Processing/Staging Tables:  

-  `route_trips` - s1   
-  `route_stop_schedule` - s2   
-  `stops_tpa_staging_headway_base_calculations` - s3,s4 -- temporary table (currently dropped)  
-  `stops_tpa_staging`: -s6. Selected from `stops_tpa_staging_headway_base_calculations` and contains the column `Distance_Eligible`, which flags whether a stop is within a distance threshold of other stops, another TPA eligibility criteria. Stops are flagged as 'TPA eligible' or not based on the criteria [here](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/c0f04b36e99a4aa702b7bd3ecfd8608c6bf4b1bf/sql/process/step_3_build_headway_am_pm_views.sql#L17-L19)    
-  `stops_tpa_draft` -s12  
-  `stops_tpa_final`s12. spatial version of the draft table  


#### Tables Not yet included:   

-  `rtd_route_stop_all_other_modes`?: non-bus stops that are eventually added into `stops_tpa_staging` in order to calculate their TPA eligibility.  
-  `TPA_Future_Transit_Stops`:  we don't have this table in the db yet, but it represents future or planned stops, which should eventually be included as part of the eligibility calculation below.  

##### Route Build and Correction Steps
- [https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/sql/process/PeakPeriod_Routes.sql]
