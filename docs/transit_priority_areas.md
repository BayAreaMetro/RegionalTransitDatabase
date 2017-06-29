## Transit Priority Area Processing 2017

[Problem Statement](#problem-statement)   
[Data Sources](#data-sources)   
[Methodology](#methodology)   
[Outcome](#outcome)   

### Problem Statement  

Identify bus routes and stops that match the definition of a Transit Priority Area (TPA).  Output geometries for them.     

TPA's are defined for the following areas. The numbers adjacent to the definition, e.g. (1), refer to that area type in the data output listed below in the [Outcome](#outcome) section.   

#### Bus Routes
-  [1/4](http://www.leginfo.ca.gov/pub/11-12/bill/asm/ab_0901-0950/ab_904_bill_20120612_amended_sen_v94.html) and/or [1/2](http://leginfo.legislature.ca.gov/faces/billCompareClient.xhtml?bill_id=201320140SB743) mile Buffer around existing or planned *high-frequency* bus routes (lines). (1)*

#### Bus Stops
-  0.2 mile Buffer around existing or planned *high-frequency* bus stops. (2)*

*See Qualifying Criteria in Methods for a more thorough definition of *high frequency*

#### Rail & Ferry:   
-  Existing rail stations  (3)
-  Planned rail stations in an adopted RTP (4)   
-  Existing/Planned ferry terminals with bus or rail service (5)   

![stops_and_routes](http://www.fehrandpeers.com/wp-content/uploads/2016/01/SB743-transit-asset_REV-01.png)  

### Data Sources   

#### Bus Stops & Routes
GTFS data (stop time interpolated) from MTC 511 were [processed](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/8a2ce450af213707bbc6d61dbd035363b40f058c/python/preprocess_gtfs_folders.py) and put [here](https://mtcdrive.box.com/s/41tfjd14hazu1x3qe53lt19u7fbiqdjk)      

#### Rail & Ferry

location|source data
--------------|-------
Existing heavy rail stations|[MTC GIS- Heavy Rail](http://mtc.maps.arcgis.com/home/item.html?id=f1d073078d13450f92b362bdb9cc7827)
existing light rail stations|[MTC GIS Light Rail](http://mtc.maps.arcgis.com/home/item.html?id=420799986ef0418bba532a82d0e31c49)
Planned rail stations in an adopted RTP|[Plan Bay Area 2040](http://projects.planbayarea.org)
Existing/Planned ferry terminals with bus or rail service|[MTC GIS](http://mtc.maps.arcgis.com/home/item.html?id=1188286d6b24418bbe57e573bfff00ee)

### Methodology   

#### Bus Stop and Route Qualifying Criteria
-  Peak periods were defined as 6 AM to 10 AM and 3 PM to 7 PM (as filtered by [this function](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/9c370d72e9fa0d788fedf33d1cbec5a844e96c19/R/r511.R#L352-L379)) 
-  Bus routes had to meet the criterion for both AM and PM peaks (as checked [here](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/9c370d72e9fa0d788fedf33d1cbec5a844e96c19/R/priority_routes/identify_bus_tpas_and_output_geometries.R#L137-L143)) 
-  Average headway (as calculated [here](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/9c370d72e9fa0d788fedf33d1cbec5a844e96c19/R/r511.R#L144-L159)) during the 4-hour window was used to identify achievement of [15 minute threshold](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/R/priority_routes/identify_bus_tpas_and_output_geometries.R#L65-L66)  
-  Bus stops have to be less than 0.2 miles in distance from one another, as calculated [here](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/9c370d72e9fa0d788fedf33d1cbec5a844e96c19/R/priority_routes/identify_bus_tpas_and_output_geometries.R#L198-L200) (i.e., short walk to transfer) 
-  Intersection of at least two existing or planned bus routes with headways of 15 minutes or better during both the morning and evening peak periods 
-  Bus service had to originate from a single route (i.e., not combined headways of multiple routes)  

#### Bus Stops & Routes Step By Step Processing:  
1. Get 2017 Frequency Data
-  download processed (stop time interpolated) data [here](https://mtcdrive.box.com/s/41tfjd14hazu1x3qe53lt19u7fbiqdjk)      
alternatively, process from the source:  
-  [get_and_format_511_gtfs_data](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/python/get_and_format_511_for_sql.py)
-  [interpolate blank stop times using gtfs-tools](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/8a2ce450af213707bbc6d61dbd035363b40f058c/python/preprocess_gtfs_folders.py)
2. [Query the Data](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/0435639579044ba099a1f516bb1a896d6bc00ad0/R/priority_routes/identify_bus_tpas_and_output_geometries.R#L54)      
3. [Determine Stop Frequency and Headway](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/0435639579044ba099a1f516bb1a896d6bc00ad0/R/priority_routes/identify_bus_tpas_and_output_geometries.R#L55-L81)  
4. [Combine Into Lines, 1/4, 1/2 mile buffer](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/0435639579044ba099a1f516bb1a896d6bc00ad0/R/priority_routes/identify_bus_tpas_and_output_geometries.R#L156-L191)   

#### Rail & Ferry Processing (2017)

Much of the Rail and Ferry data did not require processing. What little processing was required in 2017 is below:  

1. [Add Rail/Ferry Buffered Areas (1/2 mile)](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/0435639579044ba099a1f516bb1a896d6bc00ad0/R/priority_routes/add_transit_stops_new_routes_then_buffer.R)    

#### Buffers    

Run these scripts to output the feature class linked below to your local machine:     

Step 2: frequency calculations and route geometries    
-  [add_transit and new routes](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/a7cf88601fc73c0eca69aa6b24f2be1a9be3f04a/R/examples/add_transit_stops_new_routes_then_buffer.R)
-  [make polygons from tpa eligible transit stops and routes](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/a7cf88601fc73c0eca69aa6b24f2be1a9be3f04a/python/make_tpa_polygons.py)

### Outcome   

-  [Map](http://www.arcgis.com/home/webmap/viewer.html?webmap=3f89d2b053bf4dbc81318a0e707531fb&extent=-122.5562,37.5907,-122.0491,37.8571)   

#### Data   

feature classes: 

##### Existing Bus Routes & Stops   

*TPA type* is defined in the [Problem Statement](#problem-statement)  

name|description|TPA type
-----|--------|-----
[main_hf_rts_1_4_ml_buf](http://mtc.maps.arcgis.com/home/item.html?id=dc818c03e86243ec8cf85b8995caab4d)|1/4 mile buffer of tpa route lines from source gtfs|1
[main_hf_rts_1_2_ml_buf](http://mtc.maps.arcgis.com/home/item.html?id=303f6c62df4842af8459d2cab86b80fe)|1/2 mile buffer of tpa route lines from source gtfs|1
[main_hf_stops_with_hf_neighbors_buffer](http://mtc.maps.arcgis.com/home/item.html?id=a239938913e24c618bea07b6f5f34d52)|0.2 mile buffer of tpa qualifying main_hf_stops|2

##### Planned Bus  

name|description|TPA type
-----|--------|------
[geneva_route_1_4_mile](http://mtc.maps.arcgis.com/home/item.html?id=c076e3dd52b1422bbf2ea122bbd280f3)|1/4 mile buffer around the new geneva route|1    
[geneva_route_1_2_mile](http://www.arcgis.com/home/item.html?id=1e65df8b816c4dd2b41c811dcbdd540c)|1/2 mile buffer around the new geneva route|1   

##### Existing Rail  

name|description|TPA type
-----|--------|----
[rail_and_ferry_1_2_mile_buffer](http://mtc.maps.arcgis.com/home/item.html?id=1bbb5e24e8b048f6b291784920eaf61c)|1/2 mile buffer around new rail and ferry projects|3,5

#### Related Projects:

[TPP & CEQA Density/Intensity Overlay](https://github.com/MetropolitanTransportationCommission/tpp_ceqa_map_for_pba_17)     
