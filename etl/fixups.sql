---------------
--TRIPS
---------------
--performed after an insert:

ALTER TABLE trips ADD agency_trip_id NVARCHAR(200) NULL
ALTER TABLE trips ADD agency_service_id NVARCHAR(200) NULL
ALTER TABLE trips ADD agency_route_id NVARCHAR(200) NULL

update trips
set agency_trip_id = agency_id + cast(trip_id as nvarchar(200))
,agency_service_id = agency_id + cast(service_id as nvarchar(200))
,agency_route_id = agency_id + cast(route_id as nvarchar(200))
where agency_trip_id IS NULL

update trips
set agency_route_id = replace(replace(agency_route_id, CHAR(13),''),CHAR(10),'')
,agency_service_id = replace(replace(agency_service_id, CHAR(13),''),CHAR(10),'')
,agency_trip_id = replace(replace(agency_trip_id, CHAR(13),''),CHAR(10),'')

select * From trips

---------------
--STOPS
---------------
--performed after an insert:

ALTER TABLE stops ADD agency_stop_id NVARCHAR(200) NULL

update stops
set agency_stop_id = agency_id + cast(stop_id as nvarchar(100))
where agency_stop_id IS NULL 

update stops
set agency_stop_id = agency_id + ':' + stop_id

------------------
-----ROUTES
-----------------

ALTER TABLE routes ADD agency_route_id NVARCHAR(200) NULL

update [routes]
set agency_route_id = agency_id + cast(route_id as nvarchar(200))
where agency_route_id is null

update routes
set agency_route_id = replace(replace(agency_route_id, CHAR(13),''),CHAR(10),'')
,route_id = replace(replace(route_id, CHAR(13),''),CHAR(10),'')

--------------
--CALENDAR_TABLE.sql
--------------

ALTER TABLE calendar ADD agency_service_id NVARCHAR(200) NULL

update calendar
set agency_service_id = agency_id + cast(service_id as nvarchar(200))
where agency_service_id IS NULL

update calendar
set agency_service_id = replace(replace(agency_service_id, CHAR(13),''),CHAR(10),'')

select * From calendar order by agency_service_id

---------------
--STOP TIMES---
---------------

ALTER TABLE stop_times ADD agency_trip_id NVARCHAR(200) NULL
ALTER TABLE stop_times ADD agency_stop_id NVARCHAR(200) NULL

update stop_times
set agency_stop_id = agency_id + ':' + replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_trip_id = agency_id + ':' + replace(replace(trip_id, CHAR(13),''),CHAR(10),'')
where agency_stop_id IS NULL 

--select * 
--into stop_times_processed
--From stop_times

--select left(arrival_time,2) - 24 as arr_time from stop_times where left(arrival_time,2)>23 order by arr_time desc

update stop_times
set arrival_time = replace(arrival_time, left(arrival_time,2), cast(left(arrival_time,2) as int) - 24)
where cast(left(arrival_time,2) as int)>23

--check results
SELECT        CAST(arrival_time AS time) AS arr_time
FROM            stop_times
GROUP BY CAST(arrival_time AS time)
ORDER BY arr_time --desc

--Due to formatting contained in the GF stop_times.txt gtfs file, correctoins are needed to repair the arrival time field so that time values are in the proper 24hr. clock format. (for the 7,8,9 hours)
--update stop_times
--set arrival_time = replace(arrival_time, left(arrival_time,1), '0'+left(arrival_time,1))
--Where arrival_time like '9:%'


--select replace(arrival_time, left(arrival_time,1), '0'+left(arrival_time,1)) as arr_time
--from stop_times
--Where arrival_time like '7:%'
--order by arrival_time DESC
