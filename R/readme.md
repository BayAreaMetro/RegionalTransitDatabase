R Scripts for 511 TPA Processing
-------------------------------

### File List  

-  `check_by_provider_and_grouped.R`    
Used to compare the bus route route stops file output. Use to check that trip counts, headways, and routes are identically identified by the by-provider method and the all-providers method of data processing.  It seems like there are slight differences with counts (by provider is higher). This difference is probably related to issue #20. By-provider also reports 10 more routes than those found in the all-provider method. by-provider is not missing any of the routes in the all-providers method.   
-  `DownloadDatasetsFromAPI.R`        
a stub for a future R script to replace the functionality of an existing Python script   
-  `r511.R`     
the main library of helper functions for processing gtfs data into tpa eligible routes/stops   
-  `RouteBuilderStuff_KS.R`
a draft script for route building. 
-  `example_process_AC_transit.R`     
an example of using the helper functions in r511.R to identify routes/stops that are TPA eligibile for 1 provider
-  `example_loop_through_providers.R`   
an example of using the helper functions in r511.R to identify routes/stops that are TPA eligibile for all providers
-  `Stop_Times_Fix.R`
a stub that can probably be removed, since this functionality is in r511.R  
