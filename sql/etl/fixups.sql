---------------
--TRIPS
---------------
--performed after an insert:

ALTER TABLE RTD_2017.test_datagrip.trips ADD agency_trip_id NVARCHAR(200) NULL
ALTER TABLE RTD_2017.test_datagrip.trips ADD agency_service_id NVARCHAR(200) NULL
ALTER TABLE RTD_2017.test_datagrip.trips ADD agency_route_id NVARCHAR(200) NULL
ALTER TABLE RTD_2017.test_datagrip.trips ADD agency_id NVARCHAR(200) NULL

update RTD_2017.test_datagrip.trips
set agency_trip_id = N'AC:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'AC:' + cast(service_id as nvarchar(200))
,agency_route_id = N'AC:' + cast(route_id as nvarchar(200))
,agency_id = N'AC'
where agency_trip_id IS NULL

update RTD_2017.test_datagrip.trips
set agency_route_id = replace(replace(agency_route_id, CHAR(13),''),CHAR(10),'')
,agency_service_id = replace(replace(agency_service_id, CHAR(13),''),CHAR(10),'')
,agency_trip_id = replace(replace(agency_trip_id, CHAR(13),''),CHAR(10),'')

select * From RTD_2017.test_datagrip.trips

---------------
--STOPS
---------------
--performed after an insert:

ALTER TABLE RTD_2017.test_datagrip.stops ADD agency_stop_id NVARCHAR(200) NULL
ALTER TABLE RTD_2017.test_datagrip.stops ADD agency_id NVARCHAR(200) NULL

--error on the following:
--[2017-05-01 11:49:56] [S0001][8116] Argument data type text is invalid for argument 1 of replace function
update RTD_2017.test_datagrip.stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'AC:' + cast(stop_id as nvarchar(100))
,agency_id = N'AC'
where agency_stop_id IS NULL 

--fix carriage return records due to what appears to be a cast issue
update RTD_2017.test_datagrip.stops
set agency_stop_id = agency_id + ':' + stop_id

---------------
--STOP TIMES---
---------------

ALTER TABLE RTD_2017.test_datagrip.stop_times ADD agency_trip_id NVARCHAR(200) NULL
ALTER TABLE RTD_2017.test_datagrip.stop_times ADD agency_stop_id NVARCHAR(200) NULL
ALTER TABLE RTD_2017.test_datagrip.stop_times ADD agency_id NVARCHAR(200) NULL

update RTD_2017.test_datagrip.stop_times
set agency_id = N'AC'
where agency_id =N''

update RTD_2017.test_datagrip.stop_times
set agency_id = replace(replace(agency_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = agency_id + ':' + replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_trip_id = agency_id + ':' + replace(replace(trip_id, CHAR(13),''),CHAR(10),'')
where agency_stop_id IS NULL 

--select * 
--into RTD_2017.test_datagrip.stop_times_processed
--From RTD_2017.test_datagrip.stop_times

--select left(arrival_time,2) - 24 as arr_time from RTD_2017.test_datagrip.stop_times where left(arrival_time,2)>23 order by arr_time desc

update RTD_2017.test_datagrip.stop_times
set arrival_time = replace(arrival_time, left(arrival_time,2), cast(left(arrival_time,2) as int) - 24)
where cast(left(arrival_time,2) as int)>23

--check results
SELECT        CAST(arrival_time AS time) AS arr_time
FROM            RTD_2017.test_datagrip.stop_times
GROUP BY CAST(arrival_time AS time)
ORDER BY arr_time --desc

--Due to formatting contained in the GF stop_times.txt gtfs file, correctoins are needed to repair the arrival time field so that time values are in the proper 24hr. clock format. (for the 7,8,9 hours)
--update RTD_2017.test_datagrip.stop_times
--set arrival_time = replace(arrival_time, left(arrival_time,1), '0'+left(arrival_time,1))
--Where arrival_time like '9:%'


--select replace(arrival_time, left(arrival_time,1), '0'+left(arrival_time,1)) as arr_time
--from RTD_2017.test_datagrip.stop_times
--Where arrival_time like '7:%'
--order by arrival_time DESC

------------------
-----ROUTES
-----------------

ALTER TABLE RTD_2017.test_datagrip.routes ADD agency_route_id NVARCHAR(200) NULL
ALTER TABLE RTD_2017.test_datagrip.routes ADD agency_id NVARCHAR(200) NULL

update RTD_2017.test_datagrip.[routes]
set agency_route_id = N'AC:' + cast(route_id as nvarchar(200))
where agency_route_id is null

update RTD_2017.test_datagrip.routes
set agency_route_id = replace(replace(agency_route_id, CHAR(13),''),CHAR(10),'')
,route_id = replace(replace(route_id, CHAR(13),''),CHAR(10),'')
select * From RTD_2017.test_datagrip.routes order by status

--------------
--CALENDAR_TABLE.sql
--------------

ALTER TABLE RTD_2017.test_datagrip.calendar ADD agency_service_id NVARCHAR(200) NULL

update RTD_2017.test_datagrip.calendar
set agency_service_id = N'AC:' + cast(service_id as nvarchar(200))
where agency_service_id =N''

update RTD_2017.test_datagrip.calendar
set agency_service_id = replace(replace(agency_service_id, CHAR(13),''),CHAR(10),'')

select * From RTD_2017.test_datagrip.calendar order by agency_service_id