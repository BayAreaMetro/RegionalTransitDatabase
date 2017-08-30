`process_cached_gtfs_for_points_and_frequencies.py`:this script does most of the heavy lifting of processing points and frequencies for all the cached gtfs data (`../data/cached_gtfs.csv`)

the following scripts were used in the tpa process:
- tpa/TPA_Geoprocessing.py. 
- tpa/make_tpa_polygons.py  

the following scripts were used to set up the metadata and cache data on s3 as found in the metadata list in `../data/cached_gtfs.csv`
- etl/archive_all_gtfs_files_to_s3.py   
- `etl/get_511_current_gtfs_metadata_and_gtfs.py`:fetches ZIP files from 511 API     
- etl/get_data_exchange_gtfs_data.py   
- etl/get_data_exchange_gtfs_metadata.py   
- etl/upload_cached_gtfs_to_s3.py.   
