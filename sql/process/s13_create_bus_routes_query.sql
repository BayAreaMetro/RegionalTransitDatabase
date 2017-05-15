SELECT        rtd_route_trips.agency_id, rtd_route_trips.agency_name, rtd_route_trips.route_id, 
              rtd_route_trips.direction_id, stops.stop_name, 
              CAST(stop_times.arrival_time AS time) AS arrival_time, 
              stop_times.stop_sequence, stop_times.agency_stop_id,  
              stops.stop_lat, stops.stop_lon, calendar.monday, calendar.tuesday, 
              calendar.wednesday, calendar.thursday, calendar.friday, 
              calendar.agency_service_id, rtd_route_trips.route_short_name, rtd_route_trips.trip_headsign, 
              rtd_route_trips.trip_id, stop_times.agency_trip_id, 
              geometry::Point(stops.stop_lon, stops.stop_lat, 4326) AS SHAPE
INTO          stops_bus_route_pattern_schedule
FROM            stops INNER JOIN
                         stop_times ON stops.agency_stop_id = stop_times.agency_stop_id INNER JOIN
                         rtd_route_trips ON stop_times.agency_trip_id = rtd_route_trips.agency_trip_id INNER JOIN
                         calendar ON rtd_route_trips.agency_service_id = calendar.agency_service_id
WHERE        (rtd_route_trips.route_type = 3)

alter table stops_bus_route_pattern_schedule
add OBJECTID int IDENTITY(1,1) NOT NULL,
CONSTRAINT PK_stops_bus_route_pattern_schedule PRIMARY KEY CLUSTERED 
(
	OBJECTID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY


SELECT        
     agency_id, agency_name, route_id, 
     Case When direction_id = 0 Then 'Inbound' Else 'Outbound' End as Route_Direction, 
     stop_name, stop_sequence, agency_stop_id, stop_lat, stop_lon, route_short_name, 
     trip_headsign, 
     agency_id + ' - ' + route_id + ' - ' + Case When direction_id = 0 Then 'Inbound' Else 'Outbound' End as Agency_Route_Pattern, 
     geometry::Point(stop_lon, stop_lat, 4326) AS SHAPE
INTO stops_bus_route_pattern
FROM stops_bus_route_pattern_schedule
GROUP BY agency_id, agency_name, route_id, direction_id, stop_name, 
         stop_sequence, agency_stop_id, stop_lat, 
         stop_lon, route_short_name, trip_headsign
ORDER BY agency_id, route_id, direction_id, stop_sequence

alter table stops_bus_route_pattern
add OBJECTID int IDENTITY(1,1) NOT NULL,
CONSTRAINT PK_stops_bus_route_pattern PRIMARY KEY CLUSTERED 
(
	OBJECTID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY

create view stops_meeting_headway_criteria as
SELECT agency_id
      ,agency_name
      ,route_id
      ,Route_Direction
      ,stop_name
      ,stop_sequence
      ,agency_stop_id
      ,stop_lat
      ,stop_lon
      ,route_short_name
      ,trip_headsign
      ,Agency_Route_Pattern
      ,SHAPE
      ,OBJECTID
  FROM stops_bus_route_pattern
  where stops_bus_route_pattern.agency_stop_id IN
  (SELECT agency_stop_id
  FROM stops_tpa_final
  WHERE Meets_Headway_Criteria = 1)

-- a quick check shows that average values are for routes, not stops
SELECT agency_stop_id, route_id, Avg_Weekday_AM_Headway,
    PERCENTILE_CONT(0.5) 
        WITHIN GROUP (ORDER BY Avg_Weekday_AM_Headway)
        OVER (PARTITION BY agency_stop_id, route_id) AS MedianCont
FROM stops_tpa_final

/*agency_stop_id  route_id  Avg_Weekday_AM_Headway  MedianCont
AC:50000  29  24  24
AC:50101  96  30  30
AC:50104  48  60  60
AC:50105  67  30  30
AC:50108  677 240 240
AC:50108  691 NULL  NULL
AC:50110  40  10  10
AC:50110  840 240 240
AC:50112  20  30  30
AC:50112  21  30  30
AC:50112  339 NULL  NULL
AC:50112  39  80  80
AC:50113  76  30  30*/

--so we can just select any value
create view routes_meeting_headway_criteria as
SELECT sbr.Agency_Route_Pattern,
      max(rs.Avg_Weekday_AM_Trips) as Avg_Weekday_AM_Trips,
      max(rs.Avg_Weekday_AM_Headway) as Avg_Weekday_AM_Headway,
      max(rs.Avg_Weekday_PM_Trips) as Avg_Weekday_PM_Trips,
      max(rs.Avg_Weekday_PM_Headway) as Avg_Weekday_PM_Headway,
      max(rs.Meets_Headway_Criteria) as Meets_Headway_Criteria --seems a bit suspect, max better than min!
    FROM stops_bus_route_pattern sbr LEFT JOIN
    (
      select 
      agency_stop_id, 
      route_id, 
      Avg_Weekday_AM_Trips,
      Avg_Weekday_AM_Headway,
      Avg_Weekday_PM_Trips,
      Avg_Weekday_PM_Headway,
      Meets_Headway_Criteria
    FROM 
    stops_tpa_final
    ) as rs
  ON rs.agency_stop_id = sbr.agency_stop_id
group by Agency_Route_Pattern
