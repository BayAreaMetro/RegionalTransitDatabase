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

### Methodology   

![rtd_process_outline.JPG](images/rtd_process_outline.JPG?raw=true)  

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
