# RegionalTransitDatabase  

Tools for Processing 511 RTD API Datasets  

[Problem Statement](#problem-statement)   
[Data Sources](#data-sources)   
[Methodology](#methodology)   
[Outcome](#outcome)   

### Problem Statement  

### Data Sources   

[511 API Documentation](https://metrotrans-my.sharepoint.com/personal/ksmith_mtc_ca_gov/_layouts/15/guestaccess.aspx?guestaccesstoken=LaSLmz8PqjHcCy3J9t5JWiVYbBx2wq7AOn7XAeSI65c%3d&docid=2_1b3fffc8d501f42949c5c14bb423aa445)

#### GTFS Flat Files    
[RTD April 2016](https://mtcdrive.box.com/v/gtfs)  
RTD April 2017   

#### Land Use Data    

#### Transportation Data   

### Analysis Parameters   

### Methodology   

#### [2016](https://metrotrans-my.sharepoint.com/personal/ksmith_mtc_ca_gov/_layouts/15/WopiFrame.aspx?sourcedoc=%7B2FB81C2E-8CF6-4BA4-8994-6B36F7E1B647%7D&file=511%20Data%20API%20Documentation.docx&action=default)

##### Step 1. Interpolate Blank Stop Times   

Run Preprocess [stop_times](https://github.com/Esri/public-transit-tools/blob/6451cf1de24d4e5b7337df402135f351a7eaf181/interpolate-blank-stop-times/scripts/simple_interpolate.py) for all bus operators. No need to run for Ferry and Rail operators as these do not have any blank stop times in the stop_times.txt datasets.   

After running this tool for each operator, run the [Simple Interpolation Tool](https://github.com/Esri/public-transit-tools/blob/6451cf1de24d4e5b7337df402135f351a7eaf181/interpolate-blank-stop-times/scripts/simple_interpolate.py) to create the new stop_times.txt datasets. Be sure to rename the old stop_times.txt to stop_times_OLD.txt   

##### Step 2. Better Bus Buffers   

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
