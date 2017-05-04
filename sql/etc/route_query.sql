--MA
create view gtfs.rtd_route_trips_2016 as
SELECT 
agency.agency_id, 
agency.agency_name, 
routes.route_short_name, 
trips.trip_headsign, 
routes.route_id, 
trips.trip_id, 
trips.direction_id, 
routes.agency_route_id, 
trips.agency_trip_id, 
trips.agency_service_id
FROM   
GTFS.AGENCY AS agency INNER JOIN
             GTFS.ROUTES AS routes ON agency.agency_id = routes.agency_id INNER JOIN
             GTFS.TRIPS AS trips ON routes.agency_route_id = trips.agency_route_id

