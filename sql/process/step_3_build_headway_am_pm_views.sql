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
	
	SELECT      agency_id, agency_name, route_id, direction_id, agency_stop_id, 
				route_type, stop_name, cast(stop_sequence as int) as stop_sequence, 
				stop_lon, stop_lat, COUNT(stop_sequence) AS AM_Peak_Monday_Total_Trips, 
				240 / COUNT(stop_sequence) AS Monday_AM_Peak_Headway, 
				CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
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
		
	SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, route_type, stop_name, 
				  cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS PM_Peak_Monday_Total_Trips, 
				  240 / COUNT(stop_sequence) AS Monday_PM_Peak_Headway, 
				  CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
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
	
	SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, route_type, stop_name, 
				  cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS AM_Peak_Tuesday_Total_Trips, 
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
