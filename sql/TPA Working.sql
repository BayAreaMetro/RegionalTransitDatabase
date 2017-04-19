--create view dbo.rtd_route_trips_2016 as
--SELECT        agency.agency_id, agency.agency_name, routes.route_short_name, trips.trip_headsign, routes.route_id, trips.trip_id, trips.direction_id, routes.agency_route_id, trips.agency_trip_id, 
--                         trips.agency_service_id
--FROM            dbo.AGENCY AS agency INNER JOIN
--                         dbo.ROUTES AS routes ON agency.agency_id = routes.agency_id INNER JOIN
--                         dbo.TRIPS AS trips ON routes.agency_route_id = trips.agency_route_id


--select * from rtd_route_trips_2016

--THIS VIEW CONTAINS THE ENTIRE SCHEDULE FOR ALL TRANSIT OPERATOR STOPS IN THE RTD FOR WEEKDAY TRIPS.  QRY RUN TIME: 50 SECS.
--drop view dbo.route_stop_schedule
--create view dbo.route_stop_schedule as
--SELECT        rtd_route_trips_2016.agency_id, rtd_route_trips_2016.agency_name, rtd_route_trips_2016.route_id, rtd_route_trips_2016.direction_id, stops.stop_name, CAST(stop_times.arrival_time as time) as arrival_time, stop_times.stop_sequence, 
--stop_times.agency_stop_id, stops.stop_lat, stops.stop_lon, calendar.monday, calendar.tuesday, calendar.wednesday, calendar.thursday, calendar.friday
--FROM            stops INNER JOIN
--stop_times ON stops.agency_stop_id = stop_times.agency_stop_id INNER JOIN
--rtd_route_trips_2016 ON stop_times.agency_trip_id = rtd_route_trips_2016.agency_trip_id INNER JOIN
--calendar ON rtd_route_trips_2016.agency_service_id = calendar.agency_service_id

--select * from route_stop_schedule

--drop view Monday_AM_Peak_Transit_Stop_Headways

create view Friday_AM_Peak_Transit_Stop_Headways as
SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, status, system, stop_name, stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS AM_Peak_Friday_Total_Trips, 
                         240 / COUNT(stop_sequence) AS Friday_AM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
FROM            route_stop_schedule
WHERE        (CAST(arrival_time AS time) BETWEEN '06:00:00.0000' AND '09:59:59.0000') AND (friday = 1)
GROUP BY agency_id, agency_name, route_id, direction_id, agency_stop_id, stop_name, stop_sequence, stop_lon, stop_lat, status, system

create view Friday_PM_Peak_Transit_Stop_Headways as
SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, status, system, stop_name, stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS PM_Peak_Friday_Total_Trips, 
                         240 / COUNT(stop_sequence) AS Friday_PM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
FROM            route_stop_schedule
WHERE        (CAST(arrival_time AS time) BETWEEN '15:00:00.0000' AND '18:59:59.0000') AND (friday = 1)
GROUP BY agency_id, agency_name, route_id, direction_id, agency_stop_id, stop_name, stop_sequence, stop_lon, stop_lat, status, system

select * from Monday_AM_Peak_Transit_Stop_Headways Where TPA = 'Meets Criteria'
select * from Monday_PM_Peak_Transit_Stop_Headways Where TPA = 'Meets Criteria'
select * from Tuesday_AM_Peak_Transit_Stop_Headways Where TPA = 'Meets Criteria'
select * from Tuesday_PM_Peak_Transit_Stop_Headways Where TPA = 'Meets Criteria'
select * from Wednesday_AM_Peak_Transit_Stop_Headways Where TPA = 'Meets Criteria'
select * from Wednesday_PM_Peak_Transit_Stop_Headways Where TPA = 'Meets Criteria'
select * from Thursday_AM_Peak_Transit_Stop_Headways Where TPA = 'Meets Criteria'
select * from Thursday_PM_Peak_Transit_Stop_Headways Where TPA = 'Meets Criteria'
select * from Friday_AM_Peak_Transit_Stop_Headways Where TPA = 'Meets Criteria'
select * from Friday_PM_Peak_Transit_Stop_Headways Where TPA = 'Meets Criteria'

--Print 'Update Agency Name for Future Transit'
--GO
--	UPDATE       gtfs_2016.TPA_Future_Transit_Stops
--	SET                agency_name = gtfs_2016.agency.agency_name
--	FROM            gtfs_2016.agency INNER JOIN
--							 gtfs_2016.TPA_Future_Transit_Stops ON gtfs_2016.agency.agency_id = gtfs_2016.TPA_Future_Transit_Stops.agency_id
--GO
--Print 'Fix agency_name values that are not in the agency table'
----These values should be added to the agency table at a later time.
--update [gtfs_2016].[TPA_Future_Transit_Stops]
--set agency_name = CASE WHEN agency_id = 'BF' THEN 'Bay Ferry' WHEN agency_id = 'SMART' THEN 'SMART' ELSE '' END
--Where agency_name = 'Agency Name                           '



--Append the results of this qry to the Main 
--select agency_id, agency_name, route_id, agency_stop_id, status, system from gtfs_2016.rtd_route_stop_schedule
--where system in ('Ferry','Light Rail','Rail','Cable Car','Subway')
--group by agency_id, agency_name, route_id, agency_stop_id, status, system

--select system From gtfs_2016.TPA_Transit_Stops_2016_Final
--Group By system



-----What is next after this is done??

--SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, MAX(Max_AM_Trips) AS Max_AM_Trips, MIN(Min_AM_Headway) AS Min_AM_Headway, MAX(Max_PM_Trips) 
--                         AS Max_PM_Trips, MIN(Min_PM_Headway) AS Min_PM_Headway, Weekday, stop_lon, stop_lat
--FROM         gtfs_2016.TPA_TRANSIT_STOPS
--GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, Weekday, stop_lon, stop_lat
--Order By agency_id, route_id, agency_stop_id






--Weekday Transit Stops that meet the TPA criteria. (Qry Run time: Long Running)
--This qry tries to merge the ten tables (Weekday AM/PM Peak) into one final table based upon the stop_id relationship.
--This qry may not be the best to be used since it requires so much time to complete.
--SELECT 
--STOPS.agency_stop_id, 
--STOPS.stop_name, 
--STOPS.stop_lat, 
--STOPS.stop_lon, 
--MIN(MonAM.[Max AM Trips]) AS [Monday AM Trips], 
--MIN(MonPM.[Max PM Trips]) AS [Monday PM Trips], 
--MIN(MonAM.[Min AM Headway]) AS [Monday AM Headway], 
--MIN(MonPM.[Min PM Headway]) AS [Monday PM Headway], 
--MIN(TueAM.[Max AM Trips]) AS [Tuesday AM Trips], 
--MIN(TuePM.[Max PM Trips]) AS [Tuesday PM Trips], 
--MIN(TueAM.[Min AM Headway]) AS [Tuesday AM Headway], 
--MIN(TuePM.[Min PM Headway]) AS [Tuesday PM Headway],
--MIN(WedAM.[Max AM Trips]) AS [Wednesday AM Trips], 
--MIN(WedPM.[Max PM Trips]) AS [Wednesday PM Trips], 
--MIN(WedAM.[Min AM Headway]) AS [Wednesday AM Headway], 
--MIN(WedPM.[Min PM Headway]) AS [Wednesday PM Headway],
--MIN(ThuAM.[Max AM Trips]) AS [Thursday AM Trips], 
--MIN(ThuPM.[Max PM Trips]) AS [Thursday PM Trips], 
--MIN(ThuAM.[Min AM Headway]) AS [Thursday AM Headway], 
--MIN(ThuPM.[Min PM Headway]) AS [Thursday PM Headway],
--MIN(FriAM.[Max AM Trips]) AS [Friday AM Trips], 
--MIN(FriPM.[Max PM Trips]) AS [Friday PM Trips], 
--MIN(FriAM.[Min AM Headway]) AS [Friday AM Headway], 
--MIN(FriPM.[Min PM Headway]) AS [Friday PM Headway],
--COUNT(STOPS.agency_stop_id) AS [Total Duplicate Stops]
----Into TPA_Transit_Stops_2016_tbl
--FROM   gtfs_2016.stops FULL OUTER JOIN
--Friday_AM_Peak_Trips_15min_or_Less AS FriAM ON STOPS.agency_stop_id = FriAM.agency_stop_id FULL OUTER JOIN
--Friday_PM_Peak_Trips_15min_or_Less AS FriPM ON STOPS.agency_stop_id = FriPM.agency_stop_id FULL OUTER JOIN
--Thursday_AM_Peak_Trips_15min_or_Less AS ThuAM ON STOPS.agency_stop_id = ThuAM.agency_stop_id FULL OUTER JOIN
--Thursday_PM_Peak_Trips_15min_or_Less AS ThuPM ON STOPS.agency_stop_id = ThuPM.agency_stop_id FULL OUTER JOIN
--Wednesday_AM_Peak_Trips_15min_or_Less AS WedAM ON STOPS.agency_stop_id = WedAM.agency_stop_id FULL OUTER JOIN
--Wednesday_PM_Peak_Trips_15min_or_Less AS WedPM ON STOPS.agency_stop_id = WedPM.agency_stop_id FULL OUTER JOIN
--Tuesday_AM_Peak_Trips_15min_or_Less AS TueAM ON STOPS.agency_stop_id = TueAM.agency_stop_id FULL OUTER JOIN
--Tuesday_PM_Peak_Trips_15min_or_Less AS TuePM ON STOPS.agency_stop_id = TuePM.agency_stop_id FULL OUTER JOIN
--Monday_PM_Peak_Trips_15min_or_Less AS MonPM ON STOPS.agency_stop_id = MonPM.agency_stop_id FULL OUTER JOIN
--Monday_AM_Peak_Trips_15min_or_Less AS MonAM ON STOPS.agency_stop_id = MonAM.agency_stop_id
--GROUP BY STOPS.agency_stop_id, STOPS.stop_name, STOPS.stop_lat, STOPS.stop_lon
----Order By STOPS.agency_stop_id

--There are 40,863 Total  Transit Stops in the Database.. might not be correct
--SELECT OBJECTID, COUNT(stop_id) AS [Duplicate Stops], stop_name, stop_lat, stop_lon, zone_id, agency_stop_id
--FROM   gtfs_2016.STOPS
--where agency_stop_id is null
--GROUP BY OBJECTID, stop_name, stop_lat, stop_lon, zone_id, agency_stop_id


--These queries append the Weekday Trips into a Master Table that is then summarized to find the Avg. Weekday Headways for Transit stops with a heaway of 15 min. or less.

--Create container table to hold the results of the append qry.


--Random Exploration Quieries. Not Used in final process.
--select agency_id, agency_route_id, route_type from gtfs_2016.routes group by agency_id, agency_route_id, route_type order by agency_id, route_type
--create view gtfs_2016.Friday_Route_Stop_Schedule as
--SELECT rtd_route_trips.agency_id, rtd_route_trips.agency_name, rtd_route_trips.route_id, rtd_route_trips.direction_id, STOPS.stop_name, STOP_TIMES.arrival_time, STOP_TIMES.stop_sequence, STOP_TIMES.agency_stop_id, STOPS.stop_lat, 
--             STOPS.stop_lon
--FROM   STOPS INNER JOIN
--             STOP_TIMES ON STOPS.agency_stop_id = STOP_TIMES.agency_stop_id INNER JOIN
--             rtd_route_trips ON STOP_TIMES.agency_trip_id = rtd_route_trips.agency_trip_id INNER JOIN
--             CALENDAR ON rtd_route_trips.agency_service_id = CALENDAR.agency_service_id
--WHERE (CALENDAR.Friday = 1)

--policy question- what is the avg. distance between transit stops
--calculates Route Stop AM Peak Headways
--create sql qry with case statement that calculates total trips by Day of the week and time period.  THis would alow for one main query as opposed to multiple queries.
--create view gtfs_2016.Friday_AM_Peak_Route_Headways as
--SELECT agency_id, agency_name, route_id, direction_id, agency_stop_id, stop_name, stop_sequence, COUNT(stop_sequence) AS AM_Peak_Friday_Total_Trips, 240 / COUNT(stop_sequence) AS Friday_AM_Peak_Headway, stop_lon, stop_lat
--FROM   Friday_Route_Stop_Schedule
--WHERE (CAST(arrival_time AS time) BETWEEN '06:00:00.0000' AND '09:59:59.0000')
--GROUP BY agency_id, agency_name, route_id, direction_id, agency_stop_id, stop_name, stop_sequence, stop_lon, stop_lat
----ORDER BY agency_id, route_id, direction_id, stop_sequence, AM_Peak_Friday_Total_Trips

----calculates Route Stop PM Peak Headways
--create view gtfs_2016.Friday_PM_Peak_Route_Headways as
--SELECT agency_id, agency_name, route_id, direction_id, agency_stop_id, stop_name, stop_sequence, COUNT(stop_sequence) AS PM_Peak_Friday_Total_Trips, (240/COUNT(stop_sequence)) AS Friday_PM_Peak_Headway, stop_lon, stop_lat
--FROM   gtfs_2016.Friday_Route_Stop_Schedule
--WHERE (CAST(arrival_time AS time) BETWEEN '15:00:00.0000' AND '18:59:59.0000')
--GROUP BY agency_id, agency_name, route_id, direction_id, agency_stop_id, stop_name, stop_sequence, stop_lon, stop_lat
----ORDER BY agency_id, route_id, direction_id, stop_sequence, PM_Peak_Friday_Total_Trips

--check output view results for each weekday peak period
--select * 
--From [gtfs_2016].[Monday_AM_Peak_Transit_Stop_Headways] 
--Where TPA = 'Meets Criteria'
--order by agency_id, route_id, direction_id, stop_sequence

--select * 
--From [gtfs_2016].[Monday_PM_Peak_Transit_Stop_Headways] 
--Where TPA = 'Meets Criteria' 
--order by agency_id, route_id, direction_id, stop_sequence

--select * from [gtfs_2016].[Tuesday_AM_Peak_Transit_Stop_Headways] Where TPA = 'Meets Criteria' order by agency_id, route_id, direction_id, stop_sequence
--select * from [gtfs_2016].[Tuesday_PM_Peak_Transit_Stop_Headways] Where TPA = 'Meets Criteria' order by agency_id, route_id, direction_id, stop_sequence
--select * from [gtfs_2016].[Wednesday_AM_Peak_Transit_Stop_Headways] Where TPA = 'Meets Criteria' order by agency_id, route_id, direction_id, stop_sequence
--select * From [gtfs_2016].[Wednesday_PM_Peak_Transit_Stop_Headways] Where TPA = 'Meets Criteria' order by agency_id, route_id, direction_id, stop_sequence
--select * From [gtfs_2016].[Thursday_AM_Peak_Transit_Stop_Headways] Where TPA = 'Meets Criteria' order by agency_id, route_id, direction_id, stop_sequence
--select * From [gtfs_2016].[Thursday_PM_Peak_Transit_Stop_Headways] Where TPA = 'Meets Criteria' order by agency_id, route_id, direction_id, stop_sequence
--select * From [gtfs_2016].[Friday_AM_Peak_Transit_Stop_Headways] Where TPA = 'Meets Criteria' order by agency_id, route_id, direction_id, stop_sequence
--select * From [gtfs_2016].[Friday_PM_Peak_Transit_Stop_Headways] Where TPA = 'Meets Criteria' order by agency_id, route_id, direction_id, stop_sequence


--Next Step: Build single table using stop point locations.
--It appears that there are some stops missing from the main stop table.
--SELECT        stops.agency_stop_id, stops.stop_name, stops.stop_lon, stops.stop_lat, MonAM.Monday_AM_Peak_Headway, MonPM.Monday_PM_Peak_Headway
--FROM            stops RIGHT OUTER JOIN
--                         Monday_PM_Peak_Transit_Stop_Headways AS MonPM ON stops.agency_stop_id = MonPM.agency_stop_id RIGHT OUTER JOIN
--                         Monday_AM_Peak_Transit_Stop_Headways AS MonAM ON stops.agency_stop_id = MonAM.agency_stop_id
--WHERE        (stops.agency_stop_id IS Not NULL) AND (MonAM.TPA = 'Meets Criteria') AND (MonPM.TPA = 'Meets Criteria')
--ORDER BY stops.agency_stop_id, MonAM.Monday_AM_Peak_Headway, MonPM.Monday_PM_Peak_Headway
--It appears that there are problems with the SO County Route tables

--In the routes table for route_type col. The following attribute values describe System Type
--5 = Cable Car
--4 = Ferry
--3 = Bus
--2 = Rail
--1 = Subway, Metro.
--0 = Lightrail

--create function dbo.ProperCase(@Text as varchar(8000))
--returns varchar(8000)
--as
--begin
--   declare @Reset bit;
--   declare @Ret varchar(8000);
--   declare @i int;
--   declare @c char(1);

--   select @Reset = 1, @i=1, @Ret = '';

--   while (@i <= len(@Text))
--    select @c= substring(@Text,@i,1),
--               @Ret = @Ret + case when @Reset=1 then UPPER(@c) else LOWER(@c) end,
--               @Reset = case when @c like '[a-zA-Z]' then 0 else 1 end,
--               @i = @i +1
--   return @Ret
--end

SELECT [agency] as agency_id
      ,'Agency Name                              ' as agency_name
      ,'Route Name                               ' as route_id
	  ,[stop_id] as agency_stop_id
      ,[stop_name]
	  ,CASE WHEN [Status] = 'C' THEN 'Under Construction' WHEN [Status] = 'P' THEN 'Planned' ELSE '' END as status      
      ,CASE WHEN [stop_mode] = 'F' THEN 'Ferry' WHEN [stop_mode] = 'RR' THEN 'Rail' WHEN [stop_mode] = 'CR' THEN 'Rail' WHEN [stop_mode] = 'LRT' THEN 'Light Rail' WHEN [stop_mode] = 'BRT' THEN 'Bus Rapid Transit' ELSE '' END as system
      ,null as Avg_Weekday_AM_Headway
      ,null as Avg_Weekday_PM_Headway      
      ,[Delete_Stop]
      ,[TPA_Eligible]
	  ,[stop_desc] as stop_description
      ,[Project_Desc] as Project_Description
	  ,[Shape].STX as stop_lon
	  ,[Shape].STY as stop_lat
	  into gtfs_2016.TPA_Future_Transit_Stops
  FROM [dbo].[TPA_STOPS_P_C]

SELECT
agencyname as agency_name,
'ACE Commuter Rail' as route_id,
'ACE:' + Cast(OBJECTID as varchar(50)) as agency_stop_id, 
ts_location as [stop_name],  
station_name, 
'E' as status,  
'Rail' as System,
null as Avg_Weekday_AM_Headway,
null as Avg_Weekday_PM_Headway,      
0 as [Delete_Stop],
1 as [TPA_Eligible],
ts_location as stop_description,
ts_location as Project_Description,
[Shape].STX as stop_lon,
[Shape].STY as stop_lat
into gtfs_2016.ACE_Stations 
FROM           
dbo.ACE_STATIONS

select * from dbo.ace_stations

--create function [dbo].[fnCalcDistanceMiles] (@Lat1 decimal(8,4), @Long1 decimal(8,4), @Lat2 decimal(8,4), @Long2 decimal(8,4))
--returns decimal (8,4) as
--begin
--declare @d decimal(28,10)
---- Convert to radians
--set @Lat1 = @Lat1 / 57.2958
--set @Long1 = @Long1 / 57.2958
--set @Lat2 = @Lat2 / 57.2958
--set @Long2 = @Long2 / 57.2958
---- Calc distance
--set @d = (Sin(@Lat1) * Sin(@Lat2)) + (Cos(@Lat1) * Cos(@Lat2) * Cos(@Long2 - @Long1))
---- Convert to miles
--if @d <> 0
--begin
--set @d = 3958.75 * Atan(Sqrt(1 - power(@d, 2)) / @d);
--end
--return @d
--end 


--Example Update qry that can be used to modify records in the TPA Table
--UPDATE
--        [account]
--    SET
--        balance =
--        (
--            CASE
--                WHEN
--                    ((balance - 10.00) < 0)
--                THEN
--                    0
--                ELSE
--                    (balance - 10.00)
--            END
--        )
--    WHERE
--        id = 1

----Is there a way to find stops within 0.2 Miles using SQL?? Hmmmm......
--SELECT g1.agency_stop_id As id1, g2.agency_stop_id As id2, MIN(SHAPE.STDistance(g1.GEOGRAPHY,g2.GEOGRAPHY)) AS DIST
--FROM gtfs_2016.TPA_Transit_Stops_2016_Build As g1, gtfs_2016.TPA_Transit_Stops_2016_Build As g2   
--WHERE g1.agency_stop_id <> g2.agency_stop_id
--AND SHAPE.STContains(SHAPE.STExpand(g1.GEOGRAPHY,50),g2.GEOGRAPHY)
--GROUP BY id1
--ORDER BY id1

--create view gtfs_2016.TPA_DistanceA as
--SELECT        agency_stop_id, Distance_Eligible, Shape AS ShapeA
--FROM            gtfs_2016.TPA_Transit_Stops_2016_Build
--WHERE        (TPA_Eligible = 1) AND (system = 'Bus') AND (status = 'Existing')

--create view gtfs_2016.TPA_DistanceB as
--SELECT        agency_stop_id, Distance_Eligible, Shape AS ShapeB
--FROM            gtfs_2016.TPA_Transit_Stops_2016_Build
--WHERE        (TPA_Eligible = 1) AND (system = 'Bus') AND (status = 'Existing')

--SELECT 
--   A.agency_stop_id , 
--   B.agency_stop_id, 
--   MIN(Distance(A.ShapeA, B.ShapeB)) AS distance
--FROM gtfs_2016.TPA_Transit_Stops_2016_Build AS A, gtfs_2016.TPA_Transit_Stops_2016_Build AS B
--GROUP BY A.agency_stop_id, B.agency_stop_id