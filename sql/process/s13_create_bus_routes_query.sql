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
CONSTRAINT [PK_stops_bus_route_pattern_schedule] PRIMARY KEY CLUSTERED 
(
	OBJECTID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


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
CONSTRAINT [PK_stops_bus_route_pattern] PRIMARY KEY CLUSTERED 
(
	OBJECTID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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