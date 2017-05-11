create view rtd_route_stop_schedule as
SELECT        rtd_route_trips.agency_id, rtd_route_trips.agency_name, rtd_route_trips.route_id, 
			  rtd_route_trips.direction_id, stops.stop_name, 
              CAST(stop_times.arrival_time AS time) AS arrival_time, 
              stop_times.stop_sequence, stop_times.agency_stop_id, rtd_route_trips.route_type, 
              stops.stop_lat, stops.stop_lon, calendar.monday, calendar.tuesday, 
              calendar.wednesday, calendar.thursday, calendar.friday, 
              calendar.agency_service_id
FROM        stops INNER JOIN
    		stop_times ON stops.agency_stop_id = stop_times.agency_stop_id INNER JOIN
    		rtd_route_trips ON stop_times.agency_trip_id = rtd_route_trips.agency_trip_id INNER JOIN
    		calendar ON rtd_route_trips.agency_service_id = calendar.agency_service_id;

SELECT      agency_id, agency_name, route_id, direction_id, stop_name, arrival_time, 
			cast(stop_sequence as int) as stop_sequence, agency_stop_id, 
			route_type, stop_lat, stop_lon, monday, tuesday, wednesday, 
			thursday, friday, agency_service_id, COUNT(arrival_time) AS Duplicate_Arrival_Times
			into route_stop_schedule
FROM    rtd_route_stop_schedule
GROUP BY agency_id, agency_name, route_id, direction_id, stop_name, arrival_time, stop_sequence, 
		agency_stop_id, route_type, stop_lat, stop_lon, monday, tuesday, wednesday, thursday, friday, 
                         agency_service_id
ORDER BY agency_service_id, agency_stop_id, route_id, direction_id, arrival_time, stop_sequence; 

drop view rtd_route_stop_schedule;