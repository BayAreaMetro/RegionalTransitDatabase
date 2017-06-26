## Transit Priority Area Processing 2017

[Problem Statement](#problem-statement)   
[Data Sources](#data-sources)   
[Methodology](#methodology)   
[Outcome](#outcome)   

### Problem Statement  

Identify bus routes and stops that match the definition of a Transit Priority Area.   

for buses and output the geometries for high priority bus routes

### TPAs as defined in Senate Bill 743:

TPAs as defined in Senate Bill 743:
-  1/4 and/or 1/2 mile Buffer around high-frequency bus routes
-  Defined as half-mile buffer around the following geographies: Existing rail stations   
-  Planned rail stations in an adopted RTP   
-  Existing ferry terminals with bus or rail service   
-  Planned ferry terminals with bus or rail service in an adopted RTP Intersection of at least two existing or planned bus   -  routes with headways of 15 minutes or better during both the morning and evening peak periods   
-  Half-mile buffer around existing or planned fixed-route bus corridor with headway of 15 minutes or better during both   the -  morning and evening peak periods  
-  Data Source: Regional Transit Database, 2016, Plan Bay Area 2017  
-  Peak periods were defined as 6 AM to 10 AM and 3 PM to 7 PM  
-  Bus stops had to meet the criterion for both AM and PM peaks  
-  Average headway during the 4-hour window was used to identify achievement of 15 minute threshold  
-  Bus stops have to be less than 0.2 miles in distance from one another (i.e., short walk to transfer)  
-  Bus service had to originate from a single route (i.e., not combined headways of multiple routes)  

copied from http://mtc.maps.arcgis.com/home/item.html?id=1188286d6b24418bbe57e573bfff00ee

#### 2 Bills:

There are 2 laws defining the relevant distance from a transit corridor

1/4 mile here: http://www.leginfo.ca.gov/pub/11-12/bill/asm/ab_0901-0950/ab_904_bill_20120612_amended_sen_v94.html

and 1/2 mile here: http://leginfo.legislature.ca.gov/faces/billCompareClient.xhtml?bill_id=201320140SB743

As such, output representations of both and/or either of these areas.   

### Data Sources   

[511 API Documentation](https://metrotrans-my.sharepoint.com/personal/ksmith_mtc_ca_gov/_layouts/15/guestaccess.aspx?guestaccesstoken=LaSLmz8PqjHcCy3J9t5JWiVYbBx2wq7AOn7XAeSI65c%3d&docid=2_1b3fffc8d501f42949c5c14bb423aa445)

### Methodology   

![rtd_process_outline.JPG](../images/rtd_process_outline.JPG?raw=true)  

Run these scripts to output the feature class linked below to your local machine:     

To skip Step 1 download processed (stop time interpolated) data [here](https://mtcdrive.box.com/s/41tfjd14hazu1x3qe53lt19u7fbiqdjk)

Step 1: data preprocessing   
-  [get_and_format_511_gtfs_data](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/python/get_and_format_511_for_sql.py)
-  [interpolate blank stop times using gtfs-tools](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/8a2ce450af213707bbc6d61dbd035363b40f058c/python/preprocess_gtfs_folders.py)

NOTE:for unknown reasons the gtfs tool for preprocessing seems to have dropped stop_times files during failures. you can use the following command to copy in stop_times from the source to fill those back in:   
`find ./gtfs_pre_processed/ -type f \( -iname "stop_times.txt" \) -print | xargs -I {} cp -n {} ../gtfs_post_processed/{}`  

Step 2: frequency calculations and route geometries    
-  [calculate route frequencies and output high frequency bus routes and stops](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/e8c60dc4c76fd4227f1f960f08c00a742c297fd1/R/examples/get_everything.R)
-  [add_transit and new routes](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/a7cf88601fc73c0eca69aa6b24f2be1a9be3f04a/R/examples/add_transit_stops_new_routes_then_buffer.R)
-  [make polygons from tpa eligible transit stops and routes](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/a7cf88601fc73c0eca69aa6b24f2be1a9be3f04a/python/make_tpa_polygons.py)

### Outcomes   

[Feature Class With Geometries and Route Stats for High Frequency Routes](http://services3.arcgis.com/i2dkYWmb4wHvYPda/arcgis/rest/services/WeekdayPeakPeriodRoutesSourceGeoms/FeatureServer)   
