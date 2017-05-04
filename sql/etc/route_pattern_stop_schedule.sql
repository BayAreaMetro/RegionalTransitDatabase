-- create view gtfs.rtd_route_stop_schedule as
SELECT GTFS.rtd_route_trips_2016.agency_id, GTFS.rtd_route_trips_2016.agency_name, GTFS.rtd_route_trips_2016.route_id, GTFS.rtd_route_trips_2016.direction_id, GTFS.STOPS.stop_name, GTFS.STOP_TIMES.arrival_time, GTFS.STOP_TIMES.stop_sequence, 
             GTFS.STOPS.stop_lat, GTFS.STOPS.stop_lon
FROM   GTFS.STOPS INNER JOIN
             GTFS.STOP_TIMES ON GTFS.STOPS.agency_stop_id = GTFS.STOP_TIMES.agency_stop_id INNER JOIN
             GTFS.rtd_route_trips_2016 ON GTFS.STOP_TIMES.agency_trip_id = GTFS.rtd_route_trips_2016.agency_trip_id INNER JOIN
             GTFS.CALENDAR ON GTFS.rtd_route_trips_2016.agency_service_id = GTFS.CALENDAR.agency_service_id
WHERE (GTFS.CALENDAR.monday = 1)
ORDER BY GTFS.rtd_route_trips_2016.agency_id, GTFS.rtd_route_trips_2016.agency_route_id, GTFS.rtd_route_trips_2016.agency_trip_id, GTFS.rtd_route_trips_2016.direction_id, GTFS.STOP_TIMES.stop_sequence, GTFS.STOPS.agency_stop_id


