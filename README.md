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

#### Land Use Data    

#### Transportation Data   

### Analysis Parameters   

### Methodology   

#### [2016](https://metrotrans-my.sharepoint.com/personal/ksmith_mtc_ca_gov/_layouts/15/WopiFrame.aspx?sourcedoc=%7B2FB81C2E-8CF6-4BA4-8994-6B36F7E1B647%7D&file=511%20Data%20API%20Documentation.docx&action=default)

#### Steps:   

A pseudo-shell/bat script with links reflecting the process thus far:   

[get_and_format_511_for_sql](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/python/get_and_format_511_for_sql.py)   
[interpolate blank stop times](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/python/preprocess_gtfs_folders.py)   
[combine_provider_tables](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/etl/combine_provider_tables.R)   
[create_all_tables](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/etl/create_all_tables.sql)   
[load_combined_csv_to_db](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/etl/load_combined_csv_to_db.bat)   
[fixups](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/etl/fixups.sql)   

##### To Calculate Route headways:     

###### Processing for Route Data  

Not on GTFS and not provided by ESRI toolkit.  

Data Cleaning, etc, based upon some review.  

`process.sql` to output the table schema here: https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/sql/process.sql#L403-L431   

If there are views or tables that are missing the processing script they may be in the utility scripts in the sql directory.  

###### Building the Route Lines   

Take the points for each route from above and process them in network analyst to get routes.  

##### To Calculate Stop Headways(Tabled momentarily):   

Run the Preprocess GTFS Data for each operator.   

Then run the [Count Trips at Stops](https://github.com/Esri/public-transit-tools/blob/master/better-bus-buffers/scripts/BBB_CountTripsAtStops.py) or [Points](https://github.com/Esri/public-transit-tools/blob/6451cf1de24d4e5b7337df402135f351a7eaf181/better-bus-buffers/scripts/BBB_CountTripsAtPoints.py) to calculate the Stop or Intersection frequency for Transit Service.   


##### Step 3. Build single Transit Stop FC with all Transit Frequency Output  

[This step](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/06839cf5c2bb3dc15e72f64683754ff8ea168811/sql/Regional%20Transit%20Database%20Processing%20for%202016%20final.sql) consolidates the 511 Transit data into one FC. This FC should contain all of the Transit Frequency attributes (AM Peak/PM Peak values for each Weekday)   

#### 2017   

[Get GTFS Data from 511 API](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/0b8fd03cba12a41753d44c8504f3285563a78ae6/get_511_gtfs_zips.py)   

### Outcomes   

#### Flat Files:   

#### Database details:   

##### Ideas for Future Maps/Visualization:   

-  AM Peak/PM Peak transit stop frequency for all stops within a half mile distance of the intersection animated over a Weekday (or entire Week) by hour. These data are output by the Step 2 [Points tool](https://github.com/Esri/public-transit-tools/blob/6451cf1de24d4e5b7337df402135f351a7eaf181/better-bus-buffers/scripts/BBB_CountTripsAtPoints.py))      
sql/Regional Transit Database Processing for 2016 final.sql
