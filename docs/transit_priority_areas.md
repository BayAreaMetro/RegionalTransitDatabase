## Transit Priority Area Processing 2017

[Problem Statement](#problem-statement)   
[Data Sources](#data-sources)   
[Methodology](#methodology)   
[Outcome](#outcome)   

### Problem Statement  

Identify bus routes and stops that match the definition of a Transit Priority Area (TPA).  Output geometries for them.      

#### TPA as defined in Senate Bill 743:

TPAs as defined in Senate Bill 743:
-  1/4 and/or 1/2 mile Buffer around existing (and/or planned??) high-frequency bus routes (lines) with a headway of 15 minutes or better during both the morning and evening peak periods  (Data Source: 511 Regional Transit Database API June 2017)
-  Defined as half-mile buffer around the following geographies:   
-  Existing rail stations  (Data Source: [MTC GIS- Heavy Rail](http://mtc.maps.arcgis.com/home/item.html?id=f1d073078d13450f92b362bdb9cc7827) | [MTC GIS Light Rail](http://mtc.maps.arcgis.com/home/item.html?id=420799986ef0418bba532a82d0e31c49)) 
-  Planned rail stations in an adopted RTP (Data Source: [MTC GIS]() | [Plan Bay Area 2040](http://projects.planbayarea.org))   
-  Existing/Planned ferry terminals with bus or rail service (Data Source: [MTC GIS](http://mtc.maps.arcgis.com/home/item.html?id=1188286d6b24418bbe57e573bfff00ee))   
-  Peak periods were defined as 6 AM to 10 AM and 3 PM to 7 PM  
-  Bus stops had to meet the criterion for both AM and PM peaks  
-  Average headway during the 4-hour window was used to identify achievement of 15 minute threshold  
-  Bus stops have to be less than 0.2 miles in distance from one another (i.e., short walk to transfer) (Data Source: [MTC GIS](http://mtc.maps.arcgis.com/home/item.html?id=1188286d6b24418bbe57e573bfff00ee))  
-  Intersection of at least two existing or planned bus routes with headways of 15 minutes or better during both the morning and evening peak periods 
-  Bus service had to originate from a single route (i.e., not combined headways of multiple routes)  

copied from http://mtc.maps.arcgis.com/home/item.html?id=1188286d6b24418bbe57e573bfff00ee

#### 2 Bills:

There are 2 laws defining the relevant distance from a transit corridor

1/4 mile here: http://www.leginfo.ca.gov/pub/11-12/bill/asm/ab_0901-0950/ab_904_bill_20120612_amended_sen_v94.html

and 1/2 mile here: http://leginfo.legislature.ca.gov/faces/billCompareClient.xhtml?bill_id=201320140SB743

As such, output representations of both and/or either of these areas.   

[Some pretty, though some potentially incorrect, graphics about SB743 are here](http://www.fehrandpeers.com/sb743/)   

### Data Sources   

[511 API Documentation](https://metrotrans-my.sharepoint.com/personal/ksmith_mtc_ca_gov/_layouts/15/guestaccess.aspx?guestaccesstoken=LaSLmz8PqjHcCy3J9t5JWiVYbBx2wq7AOn7XAeSI65c%3d&docid=2_1b3fffc8d501f42949c5c14bb423aa445)

### Methodology   

1. Get 2017 Frequency Data
-  download processed (stop time interpolated) data [here](https://mtcdrive.box.com/s/41tfjd14hazu1x3qe53lt19u7fbiqdjk)      
alternatively, process from the source:  
-  [get_and_format_511_gtfs_data](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/python/get_and_format_511_for_sql.py)
-  [interpolate blank stop times using gtfs-tools](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/8a2ce450af213707bbc6d61dbd035363b40f058c/python/preprocess_gtfs_folders.py)
2. [Query the Data](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/0435639579044ba099a1f516bb1a896d6bc00ad0/R/priority_routes/identify_bus_tpas_and_output_geometries.R#L54)      
3. [Determine Stop Frequency and Headway](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/0435639579044ba099a1f516bb1a896d6bc00ad0/R/priority_routes/identify_bus_tpas_and_output_geometries.R#L55-L81)  
4. [Combine Into Lines, 1/4, 1/2 mile buffer](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/0435639579044ba099a1f516bb1a896d6bc00ad0/R/priority_routes/identify_bus_tpas_and_output_geometries.R#L156-L191)   
5. [Add Rail/Ferry Buffered Areas (1/2 mile)](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/0435639579044ba099a1f516bb1a896d6bc00ad0/R/priority_routes/add_transit_stops_new_routes_then_buffer.R)    
6. [Density/Intensity Overlay](https://github.com/MetropolitanTransportationCommission/tpp_ceqa_map_for_pba_17)    
7. Generate TPA Map    

#### Confirm the Buffer Methodology    

from [this issue](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/issues/43)   

1. All HF Bus route lines are 1/4 buffer. Not the stops, just the lines (see step 4 above)
2. HF Bus Stops that are within 0.2 miles of a HF bus stop (which is served by a different route) is buffered 1/2 mile (done [here](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/R/priority_routes/identify_bus_tpas_and_output_geometries.R#L194-L213))   
3. All Rail, Ferry and Light Rail stops (Planned and Existing) are buffered 1/2 Mile. (see step 5 above)

Run these scripts to output the feature class linked below to your local machine:     

Step 2: frequency calculations and route geometries    
-  [add_transit and new routes](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/a7cf88601fc73c0eca69aa6b24f2be1a9be3f04a/R/examples/add_transit_stops_new_routes_then_buffer.R)
-  [make polygons from tpa eligible transit stops and routes](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/a7cf88601fc73c0eca69aa6b24f2be1a9be3f04a/python/make_tpa_polygons.py)

### Outcomes   

-  [Map](http://www.arcgis.com/home/webmap/viewer.html?webmap=3f89d2b053bf4dbc81318a0e707531fb&extent=-122.5562,37.5907,-122.0491,37.8571)   

#### Data   

feature classes: 

name|description|link
-----|--------|--------
main_hf_stops (0)|bus stops on high frequency routes|<a href="/i2dkYWmb4wHvYPda/ArcGIS/rest/services/tpa_2017_draft4/FeatureServer/0?token=g7M1_7cqEbOd0CR3Xxb9eSm2ZzgzynuFvQ452G_lqed1ueeTZdkahKvYNCMF0k9nsovI7qkt1H1NzDODWio2mA8BT9FFy6Zhn6f-NuysQeTkgaZqm6YpkH3gwBiCyA2mP3CKmh_68BYeYY6cCJI_EC1kI1iq0wf5YYqQmFCDCm7l58dv0fqp-zXFzPo0QTiCI7H32R_QBT5TsDLSv7xvkg..">main_hf_stops</a> (0)
main_hf_rts_1_4_ml_buf (1)|1/4 mile buffer of tpa route lines from source gtfs|<a href="/i2dkYWmb4wHvYPda/ArcGIS/rest/services/tpa_2017_draft4/FeatureServer/1?token=g7M1_7cqEbOd0CR3Xxb9eSm2ZzgzynuFvQ452G_lqed1ueeTZdkahKvYNCMF0k9nsovI7qkt1H1NzDODWio2mA8BT9FFy6Zhn6f-NuysQeTkgaZqm6YpkH3gwBiCyA2mP3CKmh_68BYeYY6cCJI_EC1kI1iq0wf5YYqQmFCDCm7l58dv0fqp-zXFzPo0QTiCI7H32R_QBT5TsDLSv7xvkg..">main_hf_rts_1_4_ml_buf</a> (1)
main_hf_stops_with_hf_neighbors_buffer (2)|0.2 mile buffer of tpa qualifying main_hf_stops|<a href="/i2dkYWmb4wHvYPda/ArcGIS/rest/services/tpa_2017_draft4/FeatureServer/2?token=g7M1_7cqEbOd0CR3Xxb9eSm2ZzgzynuFvQ452G_lqed1ueeTZdkahKvYNCMF0k9nsovI7qkt1H1NzDODWio2mA8BT9FFy6Zhn6f-NuysQeTkgaZqm6YpkH3gwBiCyA2mP3CKmh_68BYeYY6cCJI_EC1kI1iq0wf5YYqQmFCDCm7l58dv0fqp-zXFzPo0QTiCI7H32R_QBT5TsDLSv7xvkg..">main_hf_stops_with_hf_neighbors_buffer</a> (2)
main_hf_rts_1_2_ml_buf (3)|1/2 mile buffer of tpa route lines from source gtfs|<a href="/i2dkYWmb4wHvYPda/ArcGIS/rest/services/tpa_2017_draft4/FeatureServer/3?token=g7M1_7cqEbOd0CR3Xxb9eSm2ZzgzynuFvQ452G_lqed1ueeTZdkahKvYNCMF0k9nsovI7qkt1H1NzDODWio2mA8BT9FFy6Zhn6f-NuysQeTkgaZqm6YpkH3gwBiCyA2mP3CKmh_68BYeYY6cCJI_EC1kI1iq0wf5YYqQmFCDCm7l58dv0fqp-zXFzPo0QTiCI7H32R_QBT5TsDLSv7xvkg..">main_hf_rts_1_2_ml_buf</a> (3)
main_non_weekday_qualifying_routes (4)|non tpa qualifying route lines|<a href="/i2dkYWmb4wHvYPda/ArcGIS/rest/services/tpa_2017_draft4/FeatureServer/4?token=g7M1_7cqEbOd0CR3Xxb9eSm2ZzgzynuFvQ452G_lqed1ueeTZdkahKvYNCMF0k9nsovI7qkt1H1NzDODWio2mA8BT9FFy6Zhn6f-NuysQeTkgaZqm6YpkH3gwBiCyA2mP3CKmh_68BYeYY6cCJI_EC1kI1iq0wf5YYqQmFCDCm7l58dv0fqp-zXFzPo0QTiCI7H32R_QBT5TsDLSv7xvkg..">main_non_weekday_qualifying_routes</a> (4)
geneva_route_1_4_mile|1/4 mile buffer aroudn the new geneva route|[geneva_route_1_4_mile](http://services3.arcgis.com/i2dkYWmb4wHvYPda/arcgis/rest/services/tpa_2017/FeatureServer/11?token=g7M1_7cqEbOd0CR3Xxb9eSm2ZzgzynuFvQ452G_lqed1ueeTZdkahKvYNCMF0k9nsovI7qkt1H1NzDODWio2mA8BT9FFy6Zhn6f-NuysQeTkgaZqm6YpkH3gwBiCyA2mP3CKmh_68BYeYY6cCJI_EC1kI1iq0wf5YYqQmFCDCm7l58dv0fqp-zXFzPo0QTiCI7H32R_QBT5TsDLSv7xvkg)
geneva_route_1_2_mile|1/2 mile buffer aroudn the new geneva route|[geneva_route_1_4_mile](http://services3.arcgis.com/i2dkYWmb4wHvYPda/arcgis/rest/services/tpa_2017/FeatureServer/11?token=g7M1_7cqEbOd0CR3Xxb9eSm2ZzgzynuFvQ452G_lqed1ueeTZdkahKvYNCMF0k9nsovI7qkt1H1NzDODWio2mA8BT9FFy6Zhn6f-NuysQeTkgaZqm6YpkH3gwBiCyA2mP3CKmh_68BYeYY6cCJI_EC1kI1iq0wf5YYqQmFCDCm7l58dv0fqp-zXFzPo0QTiCI7H32R_QBT5TsDLSv7xvkg..)
rail_and_ferry_1_2_mile_buffer|1/2 mile buffer around new rail and ferry projects|[rail_and_ferry_1_2_mile_buffer](http://services3.arcgis.com/i2dkYWmb4wHvYPda/arcgis/rest/services/tpa_2017/FeatureServer/10?token=g7M1_7cqEbOd0CR3Xxb9eSm2ZzgzynuFvQ452G_lqed1ueeTZdkahKvYNCMF0k9nsovI7qkt1H1NzDODWio2mA8BT9FFy6Zhn6f-NuysQeTkgaZqm6YpkH3gwBiCyA2mP3CKmh_68BYeYY6cCJI_EC1kI1iq0wf5YYqQmFCDCm7l58dv0fqp-zXFzPo0QTiCI7H32R_QBT5TsDLSv7xvkg)  

-  [List of High Priority Routes](https://gist.github.com/tombuckley/eeafd0b32c6c8f588aba6fd49d268a0b)  

-  Further diagnostics are in the branch called [diagnostic-improvements](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/tree/diagnostic-improvements)  
