#$@ is the file name of the target of the rule. 
#example get from s3:aws s3 cp s3://landuse/zoning/match_fields_tables_zoning_2012_source.csv match_fields_tables_zoning_2012_source.csv
get = aws s3 cp s3://landuse/mtc-gtfs-archive/

stops_and_frequencies:
#	source activate gtfslib
	python "rtd/process_cached_gtfs_for_points_and_frequencies.py"

routes:
	R R/historical_routes/output_historical_routes_by_region.R

the_db:
	dropdb tmp_gtfs
	createdb tmp_gtfs -w

cached_gtfs: data/cached/2012/GTFSTransitData_3D_2012.10.12.zip \
	data/cached/2013/GTFSTransitData_3D_2012.11.16.zip \
	data/cached/2014/DataExport_ACTransit.zip \
	data/cached/2015/GTFSTransitData_SF_2015.08.11.zip \
	data/cached/2016/GTFSTransitData_3D.zip \
	data/cached/2017/AC.zip

#originally exported in november
data/cached/2012/GTFSTransitData_3D_2012.10.12.zip: data/cached/2012/DataExport_647.zip 
	unzip -d data/cached/2012/ $<

#some operator backups for 2013 are duplicates of 2012
data/cached/2013/GTFSTransitData_3D_2012.11.16.zip: data/cached/2013/Transit_Files_1_22_13.zip 
	unzip -d data/cached/2013/ $<

data/cached/2014/DataExport_ACTransit.zip: data/cached/2014/gtfs_2014.zip
	unzip -d data/cached/2014/ $<

data/cached/2015/GTFSTransitData_SF_2015.08.11.zip: data/cached/2015/MUNI_08_12_2015.zip
	unzip -d data/cached/2015/ $<

data/cached/2016/GTFSTransitData_3D.zip: data/cached/2016/July_2016.zip
	unzip -j -d data/cached/2016/ $<

data/cached/2017/AC.zip: data/cached/2017/GTFS_511_07_31_2017.zip 
	unzip -d data/cached/2017/ $<