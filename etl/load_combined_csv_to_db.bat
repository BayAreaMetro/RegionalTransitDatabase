set GTFS_SOURCE_DIR=C:\temp\RegionalTransitDatabase\data\gtfs\

rem rem remove unnecessary columns
rem ren %GTFS_SOURCE_DIR%routes.csv routes_back.csv
rem csvcut -C "route_text_color","route_color" %GTFS_SOURCE_DIR%routes_back.csv > %GTFS_SOURCE_DIR%routes.csv -e WINDOWS-1252
rem del %GTFS_SOURCE_DIR%routes_back.csv

rem Load into DB
rem first, setup pyodbc and connect to db directly
rem it may be necessary to use the *.whl here:
rem http://www.lfd.uci.edu/~gohlke/pythonlibs/#pyodbc
rem connection string info is here:
rem https://github.com/mkleehammer/pyodbc/wiki/Connecting-to-SQL-Server-from-Windows
rem csvsql --db "mssql+pyodbc://%RTDLOGIN%:%RTDPASSWORD%@localhost:1433/RTD_2017?driver=ODBC+Driver+11+for+SQL+Server" --insert "%GTFS_SOURCE_DIR%routes.csv" -e WINDOWS-1252

rem output a best guess for what the tables in SQL server for these CSV's should look like
rem this isn't a strict requirement, but i found it helpful to create tables that tracked
rem exactly the same column names as the csv's, since we've done some processing on them
rem and since there's not already a ready-made sql server schema for GTFS text files
head -n 15000 "%GTFS_SOURCE_DIR%routes.csv" | csvsql -i mssql -e WINDOWS-1252 > create_routes_table.sql
head -n 15000 "%GTFS_SOURCE_DIR%trips.csv" | csvsql -i mssql -e WINDOWS-1252 > create_trips_table.sql
head -n 15000 "%GTFS_SOURCE_DIR%stops.csv" | csvsql -i mssql -e WINDOWS-1252 > create_stops_table.sql
head -n 10 "%GTFS_SOURCE_DIR%agency.csv" | csvsql -i mssql -e WINDOWS-1252 > create_agency_table.sql
head -n 2000 "%GTFS_SOURCE_DIR%calendar.csv" | csvsql -i mssql -e WINDOWS-1252 > create_calendar_table.sql
head -n 4000 "%GTFS_SOURCE_DIR%shapes.csv" | csvsql -i mssql -e WINDOWS-1252 > create_shapes_table.sql
head -n 15000 "%GTFS_SOURCE_DIR%stop_times.csv" | csvsql -i mssql -e WINDOWS-1252 > create_stop_times_table.sql
rem had to fix the sql output by the above lines to match what GTFS should look like. then pasted all the results into create_all_tables.sql

rem import csv's to existing db tables
csvsql --db "mssql+pyodbc://%RTDLOGIN%:%RTDPASSWORD%@localhost:1433/RTD_2017?driver=ODBC+Driver+11+for+SQL+Server;BoolsAsChar=0" --insert "%GTFS_SOURCE_DIR%routes.csv" -e WINDOWS-1252 --no-create
csvsql --db "mssql+pyodbc://%RTDLOGIN%:%RTDPASSWORD%@localhost:1433/RTD_2017?driver=ODBC+Driver+11+for+SQL+Server;BoolsAsChar=0" --insert "%GTFS_SOURCE_DIR%trips.csv" -e WINDOWS-1252 --no-create
csvsql --db "mssql+pyodbc://%RTDLOGIN%:%RTDPASSWORD%@localhost:1433/RTD_2017?driver=ODBC+Driver+11+for+SQL+Server;BoolsAsChar=0" --insert "%GTFS_SOURCE_DIR%stops.csv" -e WINDOWS-1252 --no-create
csvsql --db "mssql+pyodbc://%RTDLOGIN%:%RTDPASSWORD%@localhost:1433/RTD_2017?driver=ODBC+Driver+11+for+SQL+Server;BoolsAsChar=0" --insert "%GTFS_SOURCE_DIR%agency.csv" -e WINDOWS-1252 --no-create
csvsql --db "mssql+pyodbc://%RTDLOGIN%:%RTDPASSWORD%@localhost:1433/RTD_2017?driver=ODBC+Driver+11+for+SQL+Server;BoolsAsChar=0" --insert "%GTFS_SOURCE_DIR%calendar.csv" -e WINDOWS-1252 --no-create
csvsql --db "mssql+pyodbc://%RTDLOGIN%:%RTDPASSWORD%@localhost:1433/RTD_2017?driver=ODBC+Driver+11+for+SQL+Server;BoolsAsChar=0" --insert "%GTFS_SOURCE_DIR%shapes.csv" -e WINDOWS-1252 --no-create
csvsql --db "mssql+pyodbc://%RTDLOGIN%:%RTDPASSWORD%@localhost:1433/RTD_2017?driver=ODBC+Driver+11+for+SQL+Server;BoolsAsChar=0" --insert "%GTFS_SOURCE_DIR%stop_times.csv" -e WINDOWS-1252 --no-create

