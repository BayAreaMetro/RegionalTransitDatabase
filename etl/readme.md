This directory contains some details on the way that we extracted, loaded, and transformed (etl'ed) the 511 GTFS data.  

## contents   

- `combine_provider_tables.R`: stacks each gtfs provider table (and seemingly cleans up character issues that were plaguing our use of sql server's `bulk insert` import process)   
- `load_combined_csv_to_db.bat`: loads the combined csv's into our sql server instance. contains limited docs on environment and tools for loading.      
- `fixups.sql`: from legacy load scripts--a mix of fixes (e.g. to datetime) and calculations of key columns used to link tables for frequency calculations.           
- `check_csv_encoding.py`:the encoding of the csv's output by `combine_provider_tables.R` was an unknown--its probably set by the R user environment by default. so we used this to check so we could tell the csv import tool what the encoding was.  
- `create_all_tables.sql`: the sql server db table schema for the csv's output bu the combine_provider script  