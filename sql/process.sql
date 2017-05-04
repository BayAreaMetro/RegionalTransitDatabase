--Build qry for Route Stop Schedule RTD 2016
--Need to document the processing steps so that this method can be repeated for future years.
--Also need to collect the transit data for past years in a similar format so that we can build an animated story from this dataset.
--Try to use this to build the entire database out from the gtfs transit feed data
-----------------------------------------------------------------------------------------------
Print 'Step 1. Build rtd_route_trips view.'
-----------------------------------------------------------------------------------------------
USE [RTD_2017]
GO
	IF EXISTS(select * FROM sys.views where name = 'rtd_route_trips')
			begin
				drop view rtd_route_trips 
				PRINT 'Dropping View:'
			end
	ELSE
		PRINT 'View Does Not Exist';
GO
		create view rtd_route_trips as
		SELECT        agency.agency_id, agency.agency_name, routes.route_short_name, trips.trip_headsign, routes.route_id, trips.trip_id, 
					  trips.direction_id, routes.agency_route_id, trips.agency_trip_id, trips.agency_service_id, 
                         routes.route_type
FROM            agency AS agency INNER JOIN
                         routes AS routes ON agency.agency_id = routes.agency_id INNER JOIN
                         trips AS trips ON routes.agency_route_id = trips.agency_route_id
--WHERE        (routes.route_type = 3)
GO
-----------------------------------------------------------------------------------------------
Print 'Step 2. Building Route Stop Schedule Table (route_stop_schedule).'
-----------------------------------------------------------------------------------------------
GO
	IF EXISTS(select * FROM sys.views where name = 'rtd_route_stop_schedule')
			begin
				drop view rtd_route_stop_schedule 
				PRINT 'Dropping View: rtd_route_stop_schedule'
			end
	ELSE
		PRINT 'View Does Not Exist';
GO
		create view rtd_route_stop_schedule as
SELECT        rtd_route_trips.agency_id, rtd_route_trips.agency_name, rtd_route_trips.route_id, rtd_route_trips.direction_id, stops.stop_name, 
                         CAST(stop_times.arrival_time AS time) AS arrival_time, stop_times.stop_sequence, stop_times.agency_stop_id, rtd_route_trips.route_type, 
                         stops.stop_lat, stops.stop_lon, calendar.monday, calendar.tuesday, calendar.wednesday, calendar.thursday, calendar.friday, 
                         calendar.agency_service_id
FROM            stops INNER JOIN
                         stop_times ON stops.agency_stop_id = stop_times.agency_stop_id INNER JOIN
                         rtd_route_trips ON stop_times.agency_trip_id = rtd_route_trips.agency_trip_id INNER JOIN
                         calendar ON rtd_route_trips.agency_service_id = calendar.agency_service_id
WHERE        (rtd_route_trips.route_type = 3)
Go
------------------------------------------------------------------------------------------
Print 'Create route_stop_schedule to remove duplicate arrival times for select operators'
------------------------------------------------------------------------------------------
GO
	IF EXISTS(select * FROM sys.tables where name = 'route_stop_schedule')
			begin
				drop table route_stop_schedule 
				PRINT 'Dropping Table: route_stop_schedule'
			end
	ELSE
		PRINT 'Table Does Not Exist';
GO
		
SELECT        agency_id, agency_name, route_id, direction_id, stop_name, arrival_time, cast(stop_sequence as int) as stop_sequence, agency_stop_id, route_type, stop_lat, stop_lon, monday, tuesday, wednesday, thursday, friday, agency_service_id, 
                         COUNT(arrival_time) AS Duplicate_Arrival_Times
into route_stop_schedule
FROM            rtd_route_stop_schedule
GROUP BY agency_id, agency_name, route_id, direction_id, stop_name, arrival_time, stop_sequence, agency_stop_id, route_type, stop_lat, stop_lon, monday, tuesday, wednesday, thursday, friday, 
                         agency_service_id
--HAVING        (route_type = 3)
--ORDER BY agency_service_id, agency_stop_id, route_id, direction_id, arrival_time, stop_sequence 
GO
--------------------------------------------------------------------------------------------------------------
Print 'Step 3. Building Weekday (Monday thru Friday) AM/PM Peak Transit Stop Headway Views.';
--------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#Monday_AM_Peak_Transit_Stop_Headways') IS NOT NULL
begin
 DROP TABLE #Monday_AM_Peak_Transit_Stop_Headways
 Print 'Dropped #Monday_AM_Peak_Transit_Stop_Headways Table'
 end
ELSE
	PRINT 'Monday_AM_Peak_Transit_Stop_Headways Table Does Not Exist';
Go
	Print 'Creating Monday AM Peak Table.';
GO
	
	SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, route_type, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS AM_Peak_Monday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Monday_AM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	into #Monday_AM_Peak_Transit_Stop_Headways
	FROM            route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '06:00:00.0000' AND '09:59:59.0000') AND (Monday = 1) AND hour < 23
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, route_type, stop_name, stop_sequence, stop_lon, stop_lat 
GO

IF OBJECT_ID('tempdb..#Monday_PM_Peak_Transit_Stop_Headways') IS NOT NULL 
begin
DROP TABLE #Monday_PM_Peak_Transit_Stop_Headways
Print 'Deleting #Monday_PM_Peak_Transit_Stop_Headways'
end

ELSE
	PRINT 'Monday_PM_Peak_Transit_Stop_Headways Table Does Not Exist';
Go
	Print 'Creating Monday PM Peak Table.';
GO
		
	SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, route_type, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS PM_Peak_Monday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Monday_PM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	into #Monday_PM_Peak_Transit_Stop_Headways
	FROM            route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '15:00:00.0000' AND '18:59:59.0000') AND (Monday = 1) AND hour < 23
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, route_type, stop_name, stop_sequence, stop_lon, stop_lat 
GO

IF OBJECT_ID('tempdb..#Tuesday_AM_Peak_Transit_Stop_Headways') IS NOT NULL 
	begin
	DROP TABLE #Tuesday_AM_Peak_Transit_Stop_Headways
	Print 'Deleting #Tuesday_PM_Peak_Transit_Stop_Headways'
	end
ELSE
	PRINT 'Tuesday_AM_Peak_Transit_Stop_Headways Table Does Not Exist';
Go
	Print 'Creating Tuesday AM Peak Table.';
GO
	
	SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, route_type, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS AM_Peak_Tuesday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Tuesday_AM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	into #Tuesday_AM_Peak_Transit_Stop_Headways
	FROM            route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '06:00:00.0000' AND '09:59:59.0000') AND (Tuesday = 1) AND hour < 23
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, route_type, stop_name, stop_sequence, stop_lon, stop_lat 
GO
IF OBJECT_ID('tempdb..#Tuesday_PM_Peak_Transit_Stop_Headways') IS NOT NULL 
begin
DROP TABLE #Tuesday_PM_Peak_Transit_Stop_Headways
Print 'Deleting #Tuesday_PM_Peak_Transit_Stop_Headways'
end
ELSE
	PRINT 'Tuesday_AM_Peak_Transit_Stop_Headways Table Does Not Exist';
Go
	Print 'Creating Tuesday PM Peak Table.';
GO
		
	SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, route_type, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS PM_Peak_Tuesday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Tuesday_PM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	into #Tuesday_PM_Peak_Transit_Stop_Headways
	FROM            route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '15:00:00.0000' AND '18:59:59.0000') AND (Tuesday = 1) AND hour < 23
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, route_type, stop_name, stop_sequence, stop_lon, stop_lat 
GO
IF OBJECT_ID('tempdb..#Wednesday_AM_Peak_Transit_Stop_Headways') IS NOT NULL 
	begin 
		DROP TABLE #Wednesday_AM_Peak_Transit_Stop_Headways 
		Print 'Dropped #Wednesday_AM_Peak_Transit_Stop_Headways Table' 
	end
ELSE
	PRINT 'Wednesday_AM_Peak_Transit_Stop_Headways Table Does Not Exist';
Go
	Print 'Creating Wednesday AM Peak Table.';
GO
	
	SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, route_type, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS AM_Peak_Wednesday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Wednesday_AM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	into #Wednesday_AM_Peak_Transit_Stop_Headways
	FROM            route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '06:00:00.0000' AND '09:59:59.0000') AND (Wednesday = 1) AND hour < 23
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, route_type, stop_name, stop_sequence, stop_lon, stop_lat 
GO
IF OBJECT_ID('tempdb..#Wednesday_PM_Peak_Transit_Stop_Headways') IS NOT NULL 
begin DROP TABLE #Wednesday_PM_Peak_Transit_Stop_Headways 
Print 'Dropped #Wednesday_PM_Peak_Transit_Stop_Headways Table' 
end
ELSE
	PRINT 'Wednesday_AM_Peak_Transit_Stop_Headways Table Does Not Exist';
Go
	Print 'Creating Wednesday PM Peak Table.';
GO
		
	SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, route_type, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS PM_Peak_Wednesday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Wednesday_PM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	into #Wednesday_PM_Peak_Transit_Stop_Headways
	FROM            route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '15:00:00.0000' AND '18:59:59.0000') AND (Wednesday = 1) AND hour < 23
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, route_type, stop_name, stop_sequence, stop_lon, stop_lat 
GO
	IF OBJECT_ID('tempdb..#Thursday_AM_Peak_Transit_Stop_Headways') IS NOT NULL 
		begin 
			DROP TABLE #Thursday_AM_Peak_Transit_Stop_Headways 
			Print 'Dropped #Thursday_AM_Peak_Transit_Stop_Headways Table' 
		end
ELSE
	PRINT 'Thursday_AM_Peak_Transit_Stop_Headways Table Does Not Exist';
Go
	Print 'Creating Thursday AM Peak Table.';
GO
	
	SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, route_type, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS AM_Peak_Thursday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Thursday_AM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	into #Thursday_AM_Peak_Transit_Stop_Headways
	FROM            route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '06:00:00.0000' AND '09:59:59.0000') AND (Thursday = 1) AND hour < 23 AND hour > 23
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, route_type, stop_name, stop_sequence, stop_lon, stop_lat 
GO
IF OBJECT_ID('tempdb..#Thursday_PM_Peak_Transit_Stop_Headways') IS NOT NULL 
	begin 
			DROP TABLE #Thursday_PM_Peak_Transit_Stop_Headways 
			Print 'Dropped #Thursday_PM_Peak_Transit_Stop_Headways Table'
	end
ELSE
	PRINT 'Thursday_AM_Peak_Transit_Stop_Headways Table Does Not Exist';
Go
	Print 'Creating Thursday PM Peak Table.';
GO
		
	SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, route_type, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS PM_Peak_Thursday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Thursday_PM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	into #Thursday_PM_Peak_Transit_Stop_Headways
	FROM            route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '15:00:00.0000' AND '18:59:59.0000') AND (Thursday = 1) AND hour < 23
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, route_type, stop_name, stop_sequence, stop_lon, stop_lat 
GO
IF OBJECT_ID('tempdb..#Friday_AM_Peak_Transit_Stop_Headways') IS NOT NULL 
	begin 
		DROP TABLE #Friday_AM_Peak_Transit_Stop_Headways 
		Print 'Dropped #Friday_AM_Peak_Transit_Stop_Headways Table' 
	end
ELSE
	PRINT 'Friday_AM_Peak_Transit_Stop_Headways Table Does Not Exist';
Go
	Print 'Creating Friday AM Peak Table.';
GO
	
	SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, route_type, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS AM_Peak_Friday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Friday_AM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	into #Friday_AM_Peak_Transit_Stop_Headways
	FROM            route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '06:00:00.0000' AND '09:59:59.0000') AND (Friday = 1) AND hour < 23
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, route_type, stop_name, stop_sequence, stop_lon, stop_lat 
GO
IF OBJECT_ID('tempdb..#Friday_PM_Peak_Transit_Stop_Headways') IS NOT NULL 
	begin 
		DROP TABLE #Friday_PM_Peak_Transit_Stop_Headways 
		Print 'Dropped #Friday_PM_Peak_Transit_Stop_Headways Table' 
	end
ELSE
	PRINT 'Friday_PM_Peak_Transit_Stop_Headways Table Does Not Exist';
Go
	Print 'Creating Friday PM Peak Table.';
GO
		
	SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, route_type, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS PM_Peak_Friday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Friday_PM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	into #Friday_PM_Peak_Transit_Stop_Headways
	FROM            route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '15:00:00.0000' AND '18:59:59.0000') AND (Friday = 1) AND hour < 23
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, route_type, stop_name, stop_sequence, stop_lon, stop_lat 
GO
------------------------------------------------------------------------------------------------------------------------------------------------------
Print 'Step 4. Building Views for Weekday (Monday thru Friday) AM/PM Peak Transit Routes/Stops with 15 min or better Headways.'
------------------------------------------------------------------------------------------------------------------------------------------------------
GO
	Print 'Transit stops with 15 min or better AM Peak headways on Monday'
GO
	IF OBJECT_ID('tempdb..#Monday_AM_Peak_Trips_15min_or_Less') IS NOT NULL 
	begin
		DROP TABLE #Monday_AM_Peak_Trips_15min_or_Less
	end
ELSE
	PRINT '#Monday_AM_Peak_Trips_15min_or_Less Table Does Not Exist';
GO
		
		SELECT agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, MAX(AM_Peak_Monday_Total_Trips) AS [Max AM Trips], MIN(Monday_AM_Peak_Headway) AS [Min AM Headway], COUNT(agency_stop_id) AS [Route Patterns], stop_lon, stop_lat
		into #Monday_AM_Peak_Trips_15min_or_Less
		FROM   #Monday_AM_Peak_Transit_Stop_Headways
		GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, stop_lon, stop_lat
		--HAVING (MIN(Monday_AM_Peak_Headway) <= 15)
GO
	Print 'Transit stops with 15 min or better PM Peak headways on Monday';
GO
	IF OBJECT_ID('tempdb..#Monday_PM_Peak_Trips_15min_or_Less') IS NOT NULL DROP TABLE #Monday_PM_Peak_Trips_15min_or_Less
ELSE
	PRINT '#Monday_PM_Peak_Trips_15min_or_Less Table Does Not Exist';
GO
	
	SELECT agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, MAX(PM_Peak_Monday_Total_Trips) AS [Max PM Trips], MIN(Monday_PM_Peak_Headway) AS [Min PM Headway], COUNT(agency_stop_id) AS [Route Patterns], stop_lon, stop_lat
	into #Monday_PM_Peak_Trips_15min_or_Less
	FROM   #Monday_PM_Peak_Transit_Stop_Headways
	GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, stop_lon, stop_lat
	--HAVING (MIN(Monday_PM_Peak_Headway) <= 15)
GO
	Print 'Transit stops with 15 min or better AM Peak headways on Tuesday'
GO
	IF OBJECT_ID('tempdb..#Tuesday_AM_Peak_Trips_15min_or_Less') IS NOT NULL DROP TABLE #Tuesday_AM_Peak_Trips_15min_or_Less
ELSE
	PRINT '#Tuesday_AM_Peak_Trips_15min_or_Less Table Does Not Exist';
GO
		
		SELECT agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, MAX(AM_Peak_Tuesday_Total_Trips) AS [Max AM Trips], MIN(Tuesday_AM_Peak_Headway) AS [Min AM Headway], COUNT(agency_stop_id) AS [Route Patterns], stop_lon, stop_lat
		into #Tuesday_AM_Peak_Trips_15min_or_Less
		FROM   #Tuesday_AM_Peak_Transit_Stop_Headways
		GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, stop_lon, stop_lat
		--HAVING (MIN(Tuesday_AM_Peak_Headway) <= 15)
GO
	Print 'Transit stops with 15 min or better PM Peak headways on Tuesday';
GO
	IF OBJECT_ID('tempdb..#Tuesday_PM_Peak_Trips_15min_or_Less') IS NOT NULL DROP TABLE #Tuesday_PM_Peak_Trips_15min_or_Less
ELSE
	PRINT '#Tuesday_PM_Peak_Trips_15min_or_Less Table Does Not Exist';
GO
	
	SELECT agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, MAX(PM_Peak_Tuesday_Total_Trips) AS [Max PM Trips], MIN(Tuesday_PM_Peak_Headway) AS [Min PM Headway], COUNT(agency_stop_id) AS [Route Patterns], stop_lon, stop_lat
	into #Tuesday_PM_Peak_Trips_15min_or_Less
	FROM   #Tuesday_PM_Peak_Transit_Stop_Headways
	GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, stop_lon, stop_lat
	--HAVING (MIN(Tuesday_PM_Peak_Headway) <= 15)
GO
Print 'Transit stops with 15 min or better AM Peak headways on Wednesday'
GO
	IF OBJECT_ID('tempdb..#Wednesday_AM_Peak_Trips_15min_or_Less') IS NOT NULL DROP TABLE #Wednesday_AM_Peak_Trips_15min_or_Less
ELSE
	PRINT '#Wednesday_AM_Peak_Trips_15min_or_Less Table Does Not Exist';
GO
		
		SELECT agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, MAX(AM_Peak_Wednesday_Total_Trips) AS [Max AM Trips], MIN(Wednesday_AM_Peak_Headway) AS [Min AM Headway], COUNT(agency_stop_id) AS [Route Patterns], stop_lon, stop_lat
		into #Wednesday_AM_Peak_Trips_15min_or_Less
		FROM   #Wednesday_AM_Peak_Transit_Stop_Headways
		GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, stop_lon, stop_lat
		--HAVING (MIN(Wednesday_AM_Peak_Headway) <= 15)
GO
	Print 'Transit stops with 15 min or better PM Peak headways on Wednesday';
GO
	IF OBJECT_ID('tempdb..#Wednesday_PM_Peak_Trips_15min_or_Less') IS NOT NULL DROP TABLE #Wednesday_PM_Peak_Trips_15min_or_Less
ELSE
	PRINT '#Wednesday_PM_Peak_Trips_15min_or_Less Table Does Not Exist';
GO
	
	SELECT agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, MAX(PM_Peak_Wednesday_Total_Trips) AS [Max PM Trips], MIN(Wednesday_PM_Peak_Headway) AS [Min PM Headway], COUNT(agency_stop_id) AS [Route Patterns], stop_lon, stop_lat
	into #Wednesday_PM_Peak_Trips_15min_or_Less
	FROM   #Wednesday_PM_Peak_Transit_Stop_Headways
	GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, stop_lon, stop_lat
	--HAVING (MIN(Wednesday_PM_Peak_Headway) <= 15)
GO
Print 'Transit stops with 15 min or better AM Peak headways on Thursday'
GO
	IF OBJECT_ID('tempdb..#Thursday_AM_Peak_Trips_15min_or_Less') IS NOT NULL DROP TABLE #Thursday_AM_Peak_Trips_15min_or_Less
ELSE
	PRINT '#Thursday_AM_Peak_Trips_15min_or_Less Table Does Not Exist';
GO
		
		SELECT agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, MAX(AM_Peak_Thursday_Total_Trips) AS [Max AM Trips], MIN(Thursday_AM_Peak_Headway) AS [Min AM Headway], COUNT(agency_stop_id) AS [Route Patterns], stop_lon, stop_lat
		into #Thursday_AM_Peak_Trips_15min_or_Less
		FROM   #Thursday_AM_Peak_Transit_Stop_Headways
		GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, stop_lon, stop_lat
		--HAVING (MIN(Thursday_AM_Peak_Headway) <= 15)
GO
	Print 'Transit stops with 15 min or better PM Peak headways on Thursday';
GO
	IF OBJECT_ID('tempdb..#Thursday_PM_Peak_Trips_15min_or_Less') IS NOT NULL DROP TABLE #Thursday_PM_Peak_Trips_15min_or_Less
ELSE
	PRINT '#Thursday_PM_Peak_Trips_15min_or_Less Table Does Not Exist';
GO
	
	SELECT agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, MAX(PM_Peak_Thursday_Total_Trips) AS [Max PM Trips], MIN(Thursday_PM_Peak_Headway) AS [Min PM Headway], COUNT(agency_stop_id) AS [Route Patterns], stop_lon, stop_lat
	into #Thursday_PM_Peak_Trips_15min_or_Less
	FROM   #Thursday_PM_Peak_Transit_Stop_Headways
	GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, stop_lon, stop_lat
	--HAVING (MIN(Thursday_PM_Peak_Headway) <= 15)
GO
Print 'Transit stops with 15 min or better AM Peak headways on Friday'
GO
	IF OBJECT_ID('tempdb..#Friday_AM_Peak_Trips_15min_or_Less') IS NOT NULL DROP TABLE #Friday_AM_Peak_Trips_15min_or_Less
ELSE
	PRINT '#Friday_AM_Peak_Trips_15min_or_Less Table Does Not Exist';
GO
		
		SELECT agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, MAX(AM_Peak_Friday_Total_Trips) AS [Max AM Trips], MIN(Friday_AM_Peak_Headway) AS [Min AM Headway], COUNT(agency_stop_id) AS [Route Patterns], stop_lon, stop_lat
		into #Friday_AM_Peak_Trips_15min_or_Less
		FROM   #Friday_AM_Peak_Transit_Stop_Headways
		GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, stop_lon, stop_lat
		--HAVING (MIN(Friday_AM_Peak_Headway) <= 15)
GO
	Print 'Transit stops with 15 min or better PM Peak headways on Friday';
GO
	IF OBJECT_ID('tempdb..#Friday_PM_Peak_Trips_15min_or_Less') IS NOT NULL DROP TABLE #Friday_PM_Peak_Trips_15min_or_Less
ELSE
	PRINT '#Friday_PM_Peak_Trips_15min_or_Less Table Does Not Exist';
GO
	
	SELECT agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, MAX(PM_Peak_Friday_Total_Trips) AS [Max PM Trips], MIN(Friday_PM_Peak_Headway) AS [Min PM Headway], COUNT(agency_stop_id) AS [Route Patterns], stop_lon, stop_lat
	into #Friday_PM_Peak_Trips_15min_or_Less
	FROM   #Friday_PM_Peak_Transit_Stop_Headways
	GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, TPA, stop_lon, stop_lat
	--HAVING (MIN(Friday_PM_Peak_Headway) <= 15)
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------
Print 'Step 5. Insert Weekday (Monday thru Friday) AM/PM Peak Headway values into a container for summarization (TPA_TRANSIT_STOPS table).'
----------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
	IF EXISTS(select * FROM sys.tables where name = 'TPA_TRANSIT_STOPS')
		begin
			DROP TABLE TPA_TRANSIT_STOPS 
			PRINT 'Dropping Table: TPA_TRANSIT_STOPS'
		end
ELSE
	PRINT 'Table Does Not Exist';
GO
	Print 'Creating Table TPA_TRANSIT_STOPS'
GO
	CREATE TABLE [TPA_TRANSIT_STOPS](
	RecID int IDENTITY(1,1) NOT NULL,	
	[agency_id] [nvarchar](100) NULL,
	[agency_name] [nvarchar](100) NULL,
	[route_id] [varchar](max) NULL,
	[agency_stop_id] [nvarchar](50) NULL,
	[stop_name] [nvarchar](200) NULL,
	[route_type] [varchar](50) NULL,
	[Max_AM_Trips] [int] NULL,
	[Min_AM_Headway] [int] NULL,
	[Max_PM_Trips] [int] NULL,
	[Min_PM_Headway] [int] NULL,
	[Weekday] [nvarchar](50) NULL,
	[Delete_Stop] [int] NULL,
	[TPA] [varchar](200) NULL,
	[Meets_Headway_Criteria] [int] NULL,
	[TPA_Eligible] [int] NULL,
	[Stop_Description] [varchar](200) NULL,
	[Project_Description] [varchar](max) NULL,
	[stop_lon] [numeric](38, 8) NULL,
	[stop_lat] [numeric](38, 8) NULL
) ON [PRIMARY]
GO
	--------------------------------------------------------------------------------------------------------------------
	Print 'Insert Weekday (Monday thru Friday) AM/PM Peak Headway values into the TPA_TRANSIT_STOPS table.'
	--------------------------------------------------------------------------------------------------------------------
GO
	Print 'Inserting Monday Values'
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_AM_Trips, Min_AM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max AM Trips], [Min AM Headway], 0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Monday_AM_Peak_Trips_15min_or_Less
	Where [Max AM Trips] is not null
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_PM_Trips, Min_PM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max PM Trips], [Min PM Headway],0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Monday_PM_Peak_Trips_15min_or_Less
	Where [Max PM Trips] is not null
GO
GO
	Print 'Update the container table for each Weekday Value (Monday)'
GO
	Update [TPA_TRANSIT_STOPS]
	Set Weekday = 'Monday'
	Where Weekday is null
GO
	Print 'Inserting Tuesday Values'
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_AM_Trips, Min_AM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max AM Trips], [Min AM Headway], 0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Tuesday_AM_Peak_Trips_15min_or_Less
	Where [Max AM Trips] is not null
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_PM_Trips, Min_PM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max PM Trips], [Min PM Headway],0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Tuesday_PM_Peak_Trips_15min_or_Less
	Where [Max PM Trips] is not null
GO
GO
	Print 'Update the container table for each Weekday Value (Tuesday)'
GO
	Update [TPA_TRANSIT_STOPS]
	Set Weekday = 'Tuesday'
	Where Weekday is null
GO
Print 'Inserting Wednesday Values'
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_AM_Trips, Min_AM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max AM Trips], [Min AM Headway], 0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM        #Wednesday_AM_Peak_Trips_15min_or_Less
	Where [Max AM Trips] is not null
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_PM_Trips, Min_PM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max PM Trips], [Min PM Headway],0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Wednesday_PM_Peak_Trips_15min_or_Less
	Where [Max PM Trips] is not null
GO
GO
	Print 'Update the container table for each Weekday Value (Wednesday)'
GO
	Update [TPA_TRANSIT_STOPS]
	Set Weekday = 'Wednesday'
	Where Weekday is null
GO
Print 'Inserting Thursday Values'
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_AM_Trips, Min_AM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max AM Trips], [Min AM Headway], 0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Thursday_AM_Peak_Trips_15min_or_Less
	Where [Max AM Trips] is not null
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_PM_Trips, Min_PM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max PM Trips], [Min PM Headway],0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM        #Thursday_PM_Peak_Trips_15min_or_Less
	Where [Max PM Trips] is not null
GO
GO
	Print 'Update the container table for each Weekday Value (Thursday)'
GO
	Update [TPA_TRANSIT_STOPS]
	Set Weekday = 'Thursday'
	Where Weekday is null
GO
Print 'Inserting Friday Values'
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_AM_Trips, Min_AM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max AM Trips], [Min AM Headway], 0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Friday_AM_Peak_Trips_15min_or_Less
	Where [Max AM Trips] is not null
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_PM_Trips, Min_PM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max PM Trips], [Min PM Headway],0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Friday_PM_Peak_Trips_15min_or_Less
	Where [Max PM Trips] is not null
GO
GO
	Print 'Update the container table for each Weekday Value (Friday)'
GO
	Update [TPA_TRANSIT_STOPS]
	Set Weekday = 'Friday'
	Where Weekday is null
GO
-----------------------------------------------------------------------------------------
Print 'Step 6. Building Final Table for Map Display'
-----------------------------------------------------------------------------------------
GO
GO
	IF EXISTS(select * FROM sys.tables where name = 'TPA_Transit_Stops_2016_Build')
		begin
			DROP TABLE TPA_Transit_Stops_2016_Build 
			PRINT 'Dropping Table: TPA_Transit_Stops_2016_Build'
		end
ELSE
	PRINT 'Table Does Not Exist';
GO
	Print 'Creating Table TPA_Transit_Stops_2016_Build'
GO

SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, AVG(Max_AM_Trips) AS Avg_Weekday_AM_Trips, AVG(Min_AM_Headway) AS Avg_Weekday_AM_Headway, 
                         AVG(Max_PM_Trips) AS Avg_Weekday_PM_Trips, AVG(Min_PM_Headway) AS Avg_Weekday_PM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, TPA_Eligible, Stop_Description, Project_Description, stop_lon, stop_lat
into TPA_Transit_Stops_2016_Build
FROM         TPA_TRANSIT_STOPS
--Where Avg_Weekday_AM_Headway is not null and Avg_Weekday_PM_Headway is not null
GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Delete_Stop, TPA_Eligible, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat
--ORDER BY agency_id, route_id, agency_stop_id

GO
-----------------------------------------------------------------------------------------
Print 'Step 7. Flag Bus Stops that meet the AM/PM Peak Thresholds'
-----------------------------------------------------------------------------------------
GO
update TPA_Transit_Stops_2016_Build
set Meets_Headway_Criteria = 1
Where ((Avg_Weekday_AM_Headway <=15) and (Avg_Weekday_PM_Headway <=15))-- and (Meets_Headway_Criteria = 0 or Meets_Headway_Criteria is null)
GO
-----------------------------------------------------------------------------------------
Print 'Step 8. Insert Planned and Under Construction Transit Stops'
-----------------------------------------------------------------------------------------
GO
--Fix the column name in the TPA_Future_Transit_Stops Table
--SELECT        agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, stop_description, Project_Description, 
--                         stop_lon, stop_lat
--FROM            TPA_Future_Transit_Stops
--Where System = 'Ferry'

INSERT INTO TPA_Transit_Stops_2016_Build
                         (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, Stop_Description, Project_Description, 
                         stop_lon, stop_lat)
SELECT        agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, stop_description, Project_Description, 
                         stop_lon, stop_lat
FROM            TPA_Future_Transit_Stops
Where stop_description not in ('Stevens Creek LRT','North Bayshore LRT (NASA/Bayshore to Google)','Tasman West LRT Realignment (Fair Oaks to Mountain View)', 'eBART – Phase 2 (Antioch to Brentwood)')
GO
-----------------------------------------------------------------------------------------------
Print 'Step 9. Build view of all existing Rail, Light Rail, Cable Car, and Ferry Stops'
-----------------------------------------------------------------------------------------------
GO
	IF EXISTS(select * FROM sys.views where name = 'rtd_route_stop_all_other_modes')
			begin
				drop view rtd_route_stop_all_other_modes 
				PRINT 'Dropping View: rtd_route_stop_all_other_modes'
			end
	ELSE
		PRINT 'View Does Not Exist';
GO
		create view rtd_route_stop_all_other_modes as
SELECT        rtd_route_trips.agency_id, rtd_route_trips.agency_name, rtd_route_trips.route_id, stops.stop_name, stop_times.agency_stop_id, 
                         rtd_route_trips.rtd_route_trips.route_type, stops.stop_lat, stops.stop_lon
FROM            stops INNER JOIN
                         stop_times ON stops.agency_stop_id = stop_times.agency_stop_id INNER JOIN
                         rtd_route_trips ON stop_times.agency_trip_id = rtd_route_trips.agency_trip_id
GROUP BY rtd_route_trips.agency_id, rtd_route_trips.agency_name, rtd_route_trips.route_id, stops.stop_name, stop_times.agency_stop_id, 
                         rtd_route_trips.rtd_route_trips.route_type, stops.stop_lat, stops.stop_lon
HAVING        (rtd_route_trips.route_type <> 3)
GO
------------------------------------------------------------------------------------------------------------
Print 'Append all existing Rail, Light Rail, Cable Car, and Ferry Stops into TPA_Transit_Stops_2016_Build'
------------------------------------------------------------------------------------------------------------
GO
INSERT INTO TPA_Transit_Stops_2016_Build
                         (agency_id, agency_name, agency_stop_id, stop_name, route_type, stop_lon, stop_lat)
SELECT        agency_id, agency_name, agency_stop_id, stop_name, route_type, stop_lon, stop_lat
FROM            rtd_route_stop_all_other_modes
WHERE        (agency_stop_id NOT IN ('AT:12175078', 'BG:1091722', 'HF:12175092', 'AT:12175080', 'BG:1091727', 'SB:12048537'))
GROUP BY agency_id, agency_name, agency_stop_id, stop_name, route_type, stop_lon, stop_lat
--ORDER BY route_type, agency_id
--select * from rtd_route_stop_all_other_modes where route_type='Ferry'
GO
Print 'Fix Null Route ID values in TPA_Transit_Stops_2016_Build table'
Go
update TPA_Transit_Stops_2016_Build
set route_id = agency_name + ' ' + route_type + ' Service'
Where route_id is null
Go
----------------------------------------------------------------------------------------------------
--Print 'Ensure that all Rail, BRT, Light Rail and Ferry Stops are flagged TPA Eligible'
----------------------------------------------------------------------------------------------------
--GO
--update TPA_Transit_Stops_2016_Build
--set TPA_Eligible = 1
--Where route_type <> 3
--GO
----------------------------------------------------------------------------------------------------
--Print 'Fix Route Names for unclassified values in the Future Transit Table'
----------------------------------------------------------------------------------------------------
--update TPA_Transit_Stops_2016_Build
--set route_id = null
--where route_id = 'Route Name                               ';
GO
--update TPA_Transit_Stops_2016_Build
--set agency_id = N'ACE'
--where agency_name = 'ACE'
--GO
--------------------------------------------------------------------------------------------------
Print 'Fix route_id values that are null or missing'
--------------------------------------------------------------------------------------------------
Go

/*update TPA_Transit_Stops_2016_Build
set route_id = 'ACTC-BRT'
where agency_id = 'AC' and route_type = 'Bus Rapid Transit' --and route_id is null*/
GO
update TPA_Transit_Stops_2016_Build
set route_id = agency_name
where agency_id = 'AM' and route_type = 2 and route_id is null
GO
update TPA_Transit_Stops_2016_Build
set route_id = agency_name
where agency_id = 'BF' and route_type = 4 and route_id is null
GO
update TPA_Transit_Stops_2016_Build
set route_id = agency_name
where agency_id = 'SMART' and route_id is null
GO
/*update TPA_Transit_Stops_2016_Build
set route_id = 'BART (Future)'
where agency_id = 'BA' and route_type = 2 and status <> 'E' and route_id is null*/
/*GO
update TPA_Transit_Stops_2016_Build
set route_id = agency_name + '-' + route_type
where status <> 'E' and route_id is null
GO
*/--------------------------------------------------------------------------------------------------
Print 'Reclassify status values of E to Existing'
--------------------------------------------------------------------------------------------------
Go
/*update TPA_Transit_Stops_2016_Build
set status = 'Existing'
where status = 'E'*/
GO
--Also need to add a Distance Flag field to hold the boolean value for stops that have an adjacent stop within the AM/PM Peak Headway threshold.
ALTER TABLE TPA_Transit_Stops_2016_Build
ADD Distance_Eligible int,
Shape Geography
GO
------------------------------------------------------------------------------------------------------
Print 'Add Geography to Shape Field'
------------------------------------------------------------------------------------------------------
GO
update TPA_Transit_Stops_2016_Build
set Shape = geography::STGeomFromText('POINT('+convert(varchar(20),stop_lon)+' '+convert(varchar(20),stop_lat)+')',4326)
GO
--for now you will need to generate a near table using ArcGIS.
--Qry would need to count adjacent stops within 0.2 miles then insert into a Temp table.
--
--SELECT        agency_id, route_type, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Headway, Meets_Headway_Criteria, Distance_Eligible, Shape
--FROM            TPA_Transit_Stops_2016_Build
--WHERE        (route_type = 3)
alter table [dbo].[TPA_Transit_Stops_2016_Build]
add RecID int IDENTITY(1,1) NOT NULL,
CONSTRAINT [PK_TPA_Transit_Stops_2016_Build] PRIMARY KEY CLUSTERED 
(
	RecID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

Go
---- Create Spatial Index on Shape Col.
create spatial index spin_Stops ON [dbo].[TPA_Transit_Stops_2016_Build](Shape);
--Create index on compare columns (agency_stop_id)
create index IX_StopID on [dbo].[TPA_Transit_Stops_2016_Build](agency_stop_id)
--Find stops that have nearby stops within 0.2 miles
GO
IF OBJECT_ID('tempdb..#ODMatrix') IS NOT NULL DROP TABLE #ODMatrix
ELSE
	PRINT 'Table Does Not Exist';
Go
IF OBJECT_ID('tempdb..#StopsThatMeetDistanceThreshold') IS NOT NULL DROP TABLE #StopsThatMeetDistanceThreshold
ELSE
	PRINT 'Table Does Not Exist';
Go
With OriginStops AS
(select 
--Top(100) 
* from [dbo].[TPA_Transit_Stops_2016_Build])
select OD.agency_stop_id, DDStops.agency_stop_id as dd_stop_id, OD.route_type, OD.Shape as OD_SHape, DDStops.Shape as DD_Shape
 into #ODMatrix from OriginStops as OD
CROSS APPLY (Select Top(1) * from [dbo].[TPA_Transit_Stops_2016_Build] as DD
Where OD.agency_stop_id <> DD.agency_stop_id 
and 
OD.Shape.STDistance(DD.Shape) <= 321.869 --0.2 Miles
--OD.Shape.STDistance(DD.Shape) <= 804.672 --0.5 Miles
--OD.Shape.STDistance(DD.Shape) <= 1609.34 --1 mile
and OD.System = 'Bus'
Order By OD.Shape.STDistance(DD.Shape)) as DDStops
Go
--Report total stops within distance threshold
select agency_stop_id,
stuff(
(select ',' +RTRIM(dd_stop_id)
from #ODMatrix as t1
where t1.agency_stop_id = t2.agency_stop_id
Group By dd_stop_id
for xml path(''))
,1,1,'') as dd_stop_ids, Count(dd_stop_id) as TotalStopsWithin_0_2_Miles, Max(CAST((OD_SHape.STDistance(DD_Shape)/1609.344) as float)) as MaxDistanceInMiles
into #StopsThatMeetDistanceThreshold
from #ODMatrix t2
Group By agency_stop_id
Order By agency_stop_id

--Write Update statement to update those stops that meet the distance threshold in the main table.  Will need to build a join view to update the records
--select Distinct DS.agency_stop_id From #StopsThatMeetDistanceThreshold as DS INNER JOIN 
--TPA_Transit_Stops_2016_Build ON TPA_Transit_Stops_2016_Build.agency_stop_id = DS.agency_stop_id
UPDATE       TPA_Transit_Stops_2016_Build
SET                Distance_Eligible = 1
FROM            #StopsThatMeetDistanceThreshold INNER JOIN
                       TPA_Transit_Stops_2016_Build ON TPA_Transit_Stops_2016_Build.agency_stop_id = #StopsThatMeetDistanceThreshold.agency_stop_id
--Flag TPA Eligible Stops based upon Distance and Headway Thresholds
Go
Print 'Flag bus stops that are TPA Eligible'
Go
UPDATE TPA_Transit_Stops_2016_Build
set TPA_Eligible = 1
Where (Distance_Eligible = 1 and Meets_Headway_Criteria = 1)
Go
Print 'Flag stops that do not meet the distance criteria'
Go
UPDATE TPA_Transit_Stops_2016_Build
set Distance_Eligible = 0
Where Distance_Eligible is null
Go
Print 'Flag stops that do not meet the headway criteria'
Go
UPDATE TPA_Transit_Stops_2016_Build
set Meets_Headway_Criteria = 0
Where Meets_Headway_Criteria is null
Go
Print 'Flag stops that are not TPA Eligible'
Go
UPDATE TPA_Transit_Stops_2016_Build
set TPA_Eligible = 0
Where Distance_Eligible = 0 or Meets_Headway_Criteria = 0
Go
Print 'Flag Rail, Ferry, Light Rail, Cable Car, Bus Rapid Transit stops that are TPA Eligible'
Go
UPDATE TPA_Transit_Stops_2016_Build
set TPA_Eligible = 1
Where
route_type in (0,1,2,5,6,7)
#based on definition here https://mtc.legistar.com/View.ashx?M=F&ID=4093399&GUID=BCE50066-9441-4B00-88A0-A28708C99CBB
#and gtfs definition here: https://developers.google.com/transit/gtfs/reference/routes-file
Go
--------------------------------------------------------------------------------------------------
Print 'Fix stop_name values that are in UPPER Case format'
--------------------------------------------------------------------------------------------------
update TPA_Transit_Stops_2016_Build
set stop_name = ProperCase(stop_name)--,
--route_id = ProperCase(route_id),
--agency_name = ProperCase(agency_name)
GO
------------------------------------------------------------------------------------------------------
Print 'Creating Final View for Mapping Purposes.  Contains only Eligible Transit Stops'
------------------------------------------------------------------------------------------------------
GO
IF EXISTS(select * FROM sys.views where name = 'TPA_Transit_Stops_2016_Draft')
			begin
				drop view TPA_Transit_Stops_2016_Draft 
				PRINT 'Dropping View: TPA_Transit_Stops_2016_Draft'
			end
	ELSE
		PRINT 'View Does Not Exist';
GO

create view TPA_Transit_Stops_2016_Draft as
SELECT TOP (60000)        agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Trips, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Trips, Avg_Weekday_PM_Headway, Delete_Stop, 
                         Meets_Headway_Criteria, Distance_Eligible, TPA_Eligible, Stop_Description, Project_Description, stop_lon, stop_lat, SHAPE
FROM            TPA_Transit_Stops_2016_Build 
--Where Meets_Headway_Criteria = 1 
order by agency_id, route_id, route_type
GO
Print 'Build Final Tale for Map View'
Go
IF EXISTS(select * FROM sys.tables where name = 'TPA_Stops_2016_Draft')
			begin
				drop TABLE TPA_Stops_2016_Draft 
				PRINT 'Dropping TABLE: TPA_Stops_2016_Draft'
			end
	ELSE
		PRINT 'Table Does Not Exist';
Go
select * 
into TPA_Stops_2016_Draft
from TPA_Transit_Stops_2016_Draft
Go
Print 'Add RecID Column with an Index'
Go
alter table TPA_Stops_2016_Draft
add RecID int IDENTITY(1,1) NOT NULL,
CONSTRAINT [PK_TPA_Stops_2016_Draft] PRIMARY KEY CLUSTERED 
(
	RecID ASC
) 
---- Create Spatial Index on Shape Col.
create spatial index spin_TPA_Stops ON [dbo].TPA_Stops_2016_Draft(Shape);
--Create index on compare columns (agency_stop_id)
create index IX_StopID on [dbo].TPA_Stops_2016_Draft(agency_stop_id)

Go
IF EXISTS(select * FROM sys.tables where name = 'TPA_Stops_2016_Final')
			begin
				drop TABLE TPA_Stops_2016_Final 
				PRINT 'Dropping TABLE: TPA_Stops_2016_Final'
			end
	ELSE
		PRINT 'Table Does Not Exist';
Go
SELECT     RecID, agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Trips, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Trips, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, Distance_Eligible, 
                  TPA_Eligible, Stop_Description, Project_Description, stop_lon, stop_lat, geometry::Point([stop_lon], [stop_lat], 4326) as SHAPE
into TPA_Stops_2016_Final
FROM        TPA_Stops_2016_Draft

--Cleanup unneeded tables
------------------------------------------------------------
Print 'Cleanup unneeded tables'
------------------------------------------------------------
Drop Table [dbo].[TPA_Transit_Stops_2016_Build]
Drop Table [dbo].[TPA_TRANSIT_STOPS]
Drop Table [dbo].TPA_Stops_2016_Draft

--Check Distance_Eligible and Meets_Headway_Criteria values for Bus to determine if the Distance based calculation used in SQL is working appropriately.
------------------------------------------------------------
Print 'End of Query' ---EOF 
------------------------------------------------------------
--Check Output
--select * From [dbo].[rtd_route_stop_all_other_modes] --No output
--select * from [dbo].[rtd_route_stop_schedule] -- No Output
--select * From [dbo].[rtd_route_trips] --no output
--select * From [dbo].[TPA_Transit_Stops_2016_Draft] where route_type <>'Bus' order by agency_id, route_id, route_type, stop_name -- Only Planned Transit