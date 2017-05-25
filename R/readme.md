R Scripts for 511 TPA Processing
-------------------------------

The scripts in this directory are used for identifying TPA eligible bus routes.  

The expected output of these scripts is a set (CSV, DBF) of bus stops that are linked for a given route.  

The bus stops are then passed to a python script that determines the shortest route between them using ArcGIS Network Analyst on a TomTom Street Network. Please see the Python directory for more details on route identification.  

We have an outstanding task to prune some of these scripts, but they are still currently under review so all are available for the moment.  

### File List  

-  `DownloadDatasetsFromAPI.R`        
a stub for a future R script to replace the functionality of an existing Python script   
-  `RTD Data Processing.R`
a draft script used to load, combine, and then identify TPA eligibile bus stops for all providers
-  `RouteBuilderStuff_KS.R`
a draft script for route building. 
-  `Stop_Times_Fix.R`
a stub that can probably be removed, since this functionality is in r511.R  
-  `check_by_provider_and_grouped.R`    
Used to compare the bus route route stops file output. Check that trip counts, headways, and routes are identically identified by the by-provider method and the all-providers method of data processing.  It seems like there are slight differences with counts (by provider is higher). This difference is probably related to issue #20. By-provider also reports 10 more routes than those found in the all-provider method. by-provider is not missing any of the routes in the all-providers method.   
-  `example_process_AC_transit.R`     
an example of using the helper functions in r511.R to identify routes/stops that are TPA eligibile for 1 provider
-  `example_loop_through_providers.R`   
an example of using the helper functions in r511.R to identify routes/stops that are TPA eligibile for all providers
-  `r511.R`     
a library of helper functions for processing gtfs data into tpa eligible routes/stops   
