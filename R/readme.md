R Scripts for 511 TPA Processing
-------------------------------

The scripts in this directory are used for identifying TPA eligible bus routes.  

The expected output of these scripts is a set (CSV, DBF, GeoPackage) of bus stops and routes that are linked for a given route.  

### File List  

-  `RouteBuilderStuff_KS.R`
a draft script for route building. 
-  `r511.R`     
a library of helper functions for processing gtfs data into tpa eligible routes/stops   
-  `priority_routes/`  
scripts for fetching high frequency routes by provider, and some tools to compare outputs  
