# RegionalTransitDatabase  

Tools for Processing 511 RTD API Datasets  

[Problem Statement](#problem-statement)   
[Data Sources](#data-sources)   
[Methodology](#methodology)   
[Outcome](#outcome)   

### Problem Statement  

Calculate frequency of service for stops and routes.  

### Data Sources   

[511 API Documentation](https://metrotrans-my.sharepoint.com/personal/ksmith_mtc_ca_gov/_layouts/15/guestaccess.aspx?guestaccesstoken=LaSLmz8PqjHcCy3J9t5JWiVYbBx2wq7AOn7XAeSI65c%3d&docid=2_1b3fffc8d501f42949c5c14bb423aa445)

#### GTFS Flat Files    
[RTD April 2016](https://mtcdrive.box.com/s/7zvjm6lqudj2gh7cfokt9g3hnzwvxoq0)   
[RTD April 2017](https://mtcdrive.box.com/s/pkw8e0ng3n02b47mufaefqz5749cv5nm)     

### Analysis Parameters   

### Methodology   

#### [2016](https://metrotrans-my.sharepoint.com/personal/ksmith_mtc_ca_gov/_layouts/15/WopiFrame.aspx?sourcedoc=%7B2FB81C2E-8CF6-4BA4-8994-6B36F7E1B647%7D&file=511%20Data%20API%20Documentation.docx&action=default)

#### 2017:     

A pseudo-shell/bat script with links reflecting the process thus far:   

-  [get_and_format_511_for_sql](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/python/get_and_format_511_for_sql.py)     
-  [interpolate blank stop times](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/python/preprocess_gtfs_folders.py)   
-  [combine_provider_tables](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/etl/combine_provider_tables.R)   
-  [create_all_tables](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/etl/create_all_tables.sql)   
-  [load_combined_csv_to_db](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/etl/load_combined_csv_to_db.bat)   
-  [create_join_keys_across_tables](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/etl/create_join_keys_across_tables.sql)   
-  [calculate route frequencies for various times of day and types of transit, ad-hoc fixes to data where necessary](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/6afc5c9fff45fc1df07b1176b961e5c92e10f696/R/make_weekday_peak_bus_stops_csv.R)
-  [Build the Route Lines: Take the points for each route from previous step and then get route geometries](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/a66673c376f9cb5468b39424f9439af18587c63b/python/network_analysis.py)   

##### To Calculate Stop Headways(Tabled momentarily):   

Run the Preprocess GTFS Data for each operator.   

Then run the [Count Trips at Stops](https://github.com/Esri/public-transit-tools/blob/master/better-bus-buffers/scripts/BBB_CountTripsAtStops.py) or [Points](https://github.com/Esri/public-transit-tools/blob/6451cf1de24d4e5b7337df402135f351a7eaf181/better-bus-buffers/scripts/BBB_CountTripsAtPoints.py) to calculate the Stop or Intersection frequency for Transit Service.   

### Outcomes   

#### Flat Files:   

#### Database details:   

##### Ideas for Future Maps/Visualization:   

-  AM Peak/PM Peak transit stop frequency for all stops within a half mile distance of the intersection animated over a Weekday (or entire Week) by hour. These data are output by the Step 2 [Points tool](https://github.com/Esri/public-transit-tools/blob/6451cf1de24d4e5b7337df402135f351a7eaf181/better-bus-buffers/scripts/BBB_CountTripsAtPoints.py))      
sql/Regional Transit Database Processing for 2016 final.sql
