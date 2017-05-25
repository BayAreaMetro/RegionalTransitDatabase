R Scripts for 511 TPA Processing
-------------------------------

### File List  

-  `check_by_provider_and_grouped.R`    
used to compare the bus route route stops file output. ideally, this should check that trip counts, headways, and routes are identically identified by the by-provider method and the all-providers method of data processing.  
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
