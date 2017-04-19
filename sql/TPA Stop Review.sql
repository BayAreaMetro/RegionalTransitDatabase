select * From [dbo].[rtd_route_stop_schedule] Where system <> 'Bus'

SELECT        dbo.rtd_route_trips.agency_id, dbo.rtd_route_trips.agency_name, dbo.rtd_route_trips.route_id, dbo.stops.stop_name, dbo.stop_times.agency_stop_id, 
                         dbo.rtd_route_trips.status, dbo.rtd_route_trips.system, dbo.stops.stop_lat, dbo.stops.stop_lon
FROM            dbo.stops INNER JOIN
                         dbo.stop_times ON dbo.stops.agency_stop_id = dbo.stop_times.agency_stop_id INNER JOIN
                         dbo.rtd_route_trips ON dbo.stop_times.agency_trip_id = dbo.rtd_route_trips.agency_trip_id
GROUP BY dbo.rtd_route_trips.agency_id, dbo.rtd_route_trips.agency_name, dbo.rtd_route_trips.route_id, dbo.stops.stop_name, dbo.stop_times.agency_stop_id, 
                         dbo.rtd_route_trips.status, dbo.rtd_route_trips.system, dbo.stops.stop_lat, dbo.stops.stop_lon
HAVING        (dbo.rtd_route_trips.system = 'Bus')
Order By agency_id, stop_name


select * from [dbo].[rtd_route_stop_all_other_modes] where agency_stop_id = 'BG:1091728'

select * from dbo.TPA_Transit_Stops_2016_Build where agency_stop_id = 'BG:1091728'

select * from stops where stop_id = '1091722'

--Remove select rows from the Future Transit Stops Table based upon feedback from Dave V.

--Check Select Routes
SELECT        agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, status, system, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS AM_Peak_Monday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Monday_AM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	--into #Monday_AM_Peak_Transit_Stop_Headways
	FROM            dbo.rtd_route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '06:00:00.0000' AND '09:59:59.0000') AND (Monday = 1) --and agency_id = 'ST' and route_id = '85' 
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, status, system, stop_name, stop_sequence, stop_lon, stop_lat, status, system
	Order by agency_id, route_id, direction_id, stop_sequence

SELECT        agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, status, system, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS PM_Peak_Monday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Monday_PM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	--into #Monday_AM_Peak_Transit_Stop_Headways
	FROM            dbo.rtd_route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '15:00:00.0000' AND '18:59:59.0000') AND (Monday = 1) and agency_id = 'ST' and route_id = '85'
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_service_id, agency_stop_id, arrival_time,status, system, stop_name, stop_sequence, stop_lon, stop_lat, status, system
	Order by agency_id, route_id, direction_id, stop_sequence


SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, status, system, stop_name, cast(stop_sequence as int) as stop_sequence, stop_lon, stop_lat, COUNT(stop_sequence) AS AM_Peak_Monday_Total_Trips, 
							 240 / COUNT(stop_sequence) AS Monday_AM_Peak_Headway, CASE WHEN (240 / COUNT(stop_sequence) <= 15) THEN 'Meets Criteria' ELSE 'Does Not Meet Criteria' END AS TPA
	--into #Monday_AM_Peak_Transit_Stop_Headways
	FROM            dbo.rtd_route_stop_schedule
	WHERE        (CAST(arrival_time AS time) BETWEEN '06:00:00.0000' AND '09:59:59.0000') AND (Monday = 1) and agency_id = 'GG' and route_id = '4' 
	GROUP BY agency_id, agency_name, route_id, direction_id, agency_stop_id, status, system,stop_name, stop_sequence, stop_lon, stop_lat, status, system
	Order by agency_id, route_id, direction_id, stop_sequence

SELECT        agency_id, agency_name, route_id, direction_id, agency_stop_id, status, system, stop_name, CAST(stop_sequence AS int) AS stop_sequence, arrival_time, stop_lon, stop_lat
FROM            dbo.rtd_route_stop_schedule
WHERE        (CAST(arrival_time AS time) BETWEEN '15:00:00.0000' AND '18:59:59.0000') AND (monday = 1) AND (agency_id = 'GG') AND (route_id = '4')
ORDER BY agency_id, route_id, direction_id, stop_sequence



SELECT        dbo.rtd_route_trips.agency_id, dbo.rtd_route_trips.agency_name, dbo.rtd_route_trips.route_id, dbo.rtd_route_trips.direction_id, dbo.stops.stop_name, 
                         CAST(dbo.stop_times.arrival_time AS time) AS arrival_time, CAST(dbo.stop_times.stop_sequence as int) as stop_sequence, dbo.stop_times.agency_stop_id, dbo.rtd_route_trips.status, dbo.rtd_route_trips.system, 
                         dbo.stops.stop_lat, dbo.stops.stop_lon, dbo.calendar.agency_service_id, dbo.calendar.monday, dbo.calendar.tuesday, dbo.calendar.wednesday, 
                         dbo.calendar.thursday, dbo.calendar.friday, dbo.calendar.saturday, dbo.calendar.sunday
FROM            dbo.stops INNER JOIN
                         dbo.stop_times ON dbo.stops.agency_stop_id = dbo.stop_times.agency_stop_id INNER JOIN
                         dbo.rtd_route_trips ON dbo.stop_times.agency_trip_id = dbo.rtd_route_trips.agency_trip_id INNER JOIN
                         dbo.calendar ON dbo.rtd_route_trips.agency_service_id = dbo.calendar.agency_service_id
WHERE        (dbo.rtd_route_trips.system = 'Bus') AND (dbo.rtd_route_trips.agency_id = 'ST') AND (dbo.rtd_route_trips.route_id = '85')
ORDER BY dbo.rtd_route_trips.agency_id, dbo.rtd_route_trips.route_id, dbo.rtd_route_trips.direction_id, dbo.calendar.agency_service_id, arrival_time, dbo.stop_times.stop_sequence

select * from [dbo].[TPA_Transit_Stops_2016_Draft] 
where Agency_id = 'SM' and route_id = 'ECR'
--and system = 'Bus' 
--and Meets_Headway_Criteria = 1 
--and Distance_Eligible = 0 
--and agency_id = 'MS' 
--and route_id = '40'

select TPA_Stops.system as [Transit System], Case When TPA_Stops.TPA_Eligible = 0 Then 'No' When TPA_Eligible = 1 Then 'Yes' End as [TPA Eligibility], Count(system) as [Total Route Stops by Type]
from [dbo].[TPA_Transit_Stops_2016_Draft] as TPA_Stops
Group By system, TPA_Eligible 

select * from dbo.routes

select * from dbo.system_type

create view dbo.TPA_Stops_2016_Draft_2016_8_5 as
SELECT        agency_id, agency_name, route_id, agency_stop_id, stop_name, status, system, Avg_Weekday_AM_Trips, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Trips, Avg_Weekday_PM_Headway, Delete_Stop, 
                         Meets_Headway_Criteria, Distance_Eligible, TPA_Eligible, Stop_Description, Project_Description, stop_lon, stop_lat, RecID
FROM            dbo.TPA_Stops_2016_Draft_Version_2
Where system='ferry'

select * From dbo.stops where agency_id = 'SB'

--Several stops are missing from the import.

--Tiburon Ferry Missing
--INSERT INTO dbo.stops
--                         (stop_id, stop_name, stop_lat, stop_lon, zone_id, agency_id, agency_stop_id)
--VALUES        ('1091728','TIBURON FERRY TERMINAL','37.872644','-122.455382','','BG','BG:1091728')

----Vallejo Ferry
--INSERT INTO dbo.stops
--                         (stop_id, stop_name, stop_lat, stop_lon, zone_id, agency_id, agency_stop_id)
--VALUES        ('12149044','Vallejo Ferry Terminal','38.100149','-122.262586','55479','SB','SB:12149044')

--West Oakland BART
--INSERT INTO dbo.stops
--                         (stop_id, stop_name, stop_lat, stop_lon, zone_id, agency_id, agency_stop_id)
--VALUES        ('12018544','BART WEST OAKLAND','37.804706','-122.29497','55534','BA','BA:12018544')

--SUISUN-FAIRFIELD AMTRAK
--INSERT INTO dbo.stops
--                         (stop_id, stop_name, stop_lat, stop_lon, zone_id, agency_id, agency_stop_id)
--VALUES        ('1129131','SUISUN-FAIRFIELD AMTRAK','38.243909','-122.040419','55445','AM','AM:1129131')

--Larkspur Ferry Terminal is missing --DONE

--Missing Fairfield-Vacaville Amtrak Station.  This needs to be added back into the DB.
--insert into [dbo].[TPA_Future_Transit_Stops]
--([agency_id],[agency_name],[route_id],[agency_stop_id],[stop_name],[status],[system],
--[Avg_Weekday_AM_Headway],[Avg_Weekday_PM_Headway],[Delete_Stop],[TPA_Eligible],[Meets_Headway_Criteria],
--[stop_description],[Project_Description],[stop_lon],[stop_lat])
--Values ('AM','Amtrak','Capitol Corridor Rail Service','AM:1129132','Vacaville-Fairfield Amtrak Station','Under Construction','Rail',
--null,null,0,1,0,'','',-121.931159731559,38.3260150031587)


--Mission Bay Ferry (planned) - located at future intersection of 16th St and Francois Boulevard
--37.767088, -122.385390

--Delete from [dbo].[TPA_Future_Transit_Stops] where agency_stop_id = 'SMART: 1412'

select * 
From [dbo].[TPA_Future_Transit_Stops] 
where system in ('Rail')
order by agency_id,system

update [dbo].[TPA_Future_Transit_Stops]
set  route_id = agency_name + ' ' + system + ' Service'
where route_id =  'Route Name                               '

SELECT     rtd_route_trips.agency_id, rtd_route_trips.agency_name, rtd_route_trips.route_id, stops.stop_name, stop_times.agency_stop_id, rtd_route_trips.status, rtd_route_trips.system, stops.stop_lat, stops.stop_lon
FROM        stops INNER JOIN
                  stop_times ON stops.agency_stop_id = stop_times.agency_stop_id INNER JOIN
                  rtd_route_trips ON stop_times.agency_trip_id = rtd_route_trips.agency_trip_id
GROUP BY rtd_route_trips.agency_id, rtd_route_trips.agency_name, rtd_route_trips.route_id, stops.stop_name, stop_times.agency_stop_id, rtd_route_trips.status, rtd_route_trips.system, stops.stop_lat, stops.stop_lon
HAVING     (rtd_route_trips.system IN ('Ferry'))
ORDER BY rtd_route_trips.agency_id, rtd_route_trips.status, rtd_route_trips.system, rtd_route_trips.route_id


SELECT     RecID, agency_id, agency_stop_id, route_id, stop_name, system, status, Shape.ToString() as Location
FROM        TPA_Stops_2016_Final
Where system in ('Rail')
ORDER BY system, agency_id, route_id, stop_name, status

--update [dbo].[TPA_Future_Transit_Stops]
--set Delete_Stop = 0
--where Delete_Stop is null

--select * from [dbo].[TPA_Future_Transit_Stops] Where TPA_Eligible = 1 and system = 'Ferry'

--- Richmond ferry (future) is missing. --Need to Verify the location is in the Future Transit DB   It was not in the dataset.  I added it to the Dataset.
--- Vallejo ferry is missing. --DONE
--- Larkspur SMART (future) is missing. --Need to Verify the location is in the Future Transit DB.  It was not in the dataset.  I added it to the Dataset.
--- West Oakland BART is missing. --DONE
--- Vasco Road ACE is missing. --DONE
--- Antioch Amtrak is missing. --DONE
--- Fairfield/Vacaville Amtrak (future) is missing. --Need this location Still | It was not in the dataset.  I added it to the Dataset.
--- Fairfield/Suisun City Amtrak is missing. --DONE