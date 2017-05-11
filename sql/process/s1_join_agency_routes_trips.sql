create view rtd_route_trips as
SELECT  agency.agency_id, agency.agency_name, routes.route_short_name, 
		trips.trip_headsign, routes.route_id, trips.trip_id, 
		trips.direction_id, routes.agency_route_id, trips.agency_trip_id, 
		trips.agency_service_id, routes.route_type
FROM    agency AS agency INNER JOIN
		routes AS routes ON agency.agency_id = routes.agency_id INNER JOIN
		trips AS trips ON routes.agency_route_id = trips.agency_route_id
WHERE   (routes.route_type = 3) --filters to buses only 
