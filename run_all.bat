python python/get_511_gtfs_zips.py  
sql "sql/etl/RTD 2016 BULK INSERT AND UPDATE FOR CALENDAR TABLE.sql"
sql "sql/etl/RTD 2016 BULK INSERT AND UPDATE FOR ROUTES.sql"
sql "sql/etl/RTD 2016 BULK INSERT AND UPDATE FOR STOPS TABLE.sql"
sql "sql/etl/RTD 2016 BULK INSERT AND UPDATE FOR STOP_TIMES TABLE.sql"
sql "sql/etl/RTD 2016 BULK INSERT AND UPDATE FOR TRIPS TABLE.sql"
sql "sql/etl/RTD 2016 BULK INSERT AND UPDATE FOR STOP_TIMES TABLE.sql"
rem is it necessary to load to db if we are also using python processing scripts? 
git clone https://github.com/Esri/public-transit-tools.git
python public-transit-tools/interpolate-blank-stop-times/scripts/simple_interpolate.py $SQLDbase $outStopTimesFile
