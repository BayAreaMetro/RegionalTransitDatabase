--Build qry for Route Stop Schedule RTD 2016
--Need to document the processing steps so that this method can be repeated for future years.
--Also need to collect the transit data for past years in a similar format so that we can build an animated story from this dataset.
--Try to use this to build the entire database out from the gtfs transit feed data
-----------------------------------------------------------------------------------------------
Print 'Step 1. Build rtd_route_trips view.'
-----------------------------------------------------------------------------------------------
USE [RTD_2017]
GO
	IF EXISTS(select * FROM sys.views where name = 'rtd_route_trips')
			begin
				drop view rtd_route_trips 
				PRINT 'Dropping View:'
			end
	ELSE
		PRINT 'View Does Not Exist';
GO
		create view rtd_route_trips as
		SELECT        agency.agency_id, agency.agency_name, routes.route_short_name, 
					  trips.trip_headsign, routes.route_id, trips.trip_id, 
					  trips.direction_id, routes.agency_route_id, trips.agency_trip_id, 
					  trips.agency_service_id, routes.route_type
FROM        agency AS agency INNER JOIN
            routes AS routes ON agency.agency_id = routes.agency_id INNER JOIN
            trips AS trips ON routes.agency_route_id = trips.agency_route_id
WHERE        (routes.route_type = 3)
GO
