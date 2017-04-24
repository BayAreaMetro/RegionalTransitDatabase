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

Run Preprocess stop_times for all bus operators. No need to run for Ferry and Rail operators as these do not have any blank stop times in the stop_times.txt datasets.

After running this tool for each operator, run the Simple Interpolation Tool to create the new stop_times.txt datasets. Be sure to rename the old stop_times.txt to stop_times_OLD.txt

##### Step 2. Better Bus Buffers

Run the Preprocess GTFS Data for each operator.

Then run the Count Trips at Stops or Points tool to calculate the Stop or Intersection frequency for Transit Service.

The point tool can be used for intersections. For example, what is the AM Peak/PM Peak transit stop frequency for all stops within a half mile distance of the intersection.

It would be interesting to see this animated over a Weekday (or entire Week) by hour.

##### Step 3. Build single Transit Stop FC with all Transit Frequency Output

This step consolidates the 511 Transit data into one FC. This FC should contain all of the Transit Frequency attributes (AM Peak/PM Peak values for each Weekday)

{Create a sql script that builds the primary table that will contain the output}

Below is an example sql statement that can be used to update the AM/PM Peak values in the new FC table using values contained in the individual tables created in Step 2. 

#### 2017   

### Outcomes  

#### Flat Files:  

#### Database details:  