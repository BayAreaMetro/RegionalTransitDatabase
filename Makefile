data/source_zips/AC.zip: 
  	python get_511_zips.py

interpolated_zipfiles: data/source_zips/AC.zip temp_db
	gtfsdbloader  "postgresql:///tmp_gtfs" --load=data/source_zips/MS.zip
	gtfsrun "postgresql:///tmp_gtfs" GtfsExport --bundle=data/MS2.zip --logsql --skip_shape_dist

temp_db:
	dropdb tmp_gtfs
	createdb tmp_gtfs -w

