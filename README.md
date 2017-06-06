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

-  [get_and_format_511_gtfs_data](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/python/get_and_format_511_for_sql.py)     
-  [calculate route frequencies for various times of day and types of transit, get route geometries](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/1ac4cfa454c2b57bb62e6f55115477f8dc5749ec/R/examples/example_get_hf_geoms.R)

### Outcomes   

[Feature Class With Geometries and Route Stats for High Frequency Routes](http://services3.arcgis.com/i2dkYWmb4wHvYPda/arcgis/rest/services/WeekdayPeakPeriodRoutesSourceGeoms/FeatureServer)   
