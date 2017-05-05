-----------------------------------------------------------------------------------------------
Print 'Step 9. Build view of all existing Rail, Light Rail, Cable Car, and Ferry Stops'
-----------------------------------------------------------------------------------------------
GO
	IF EXISTS(select * FROM sys.views where name = 'rtd_route_stop_all_other_modes')
			begin
				drop view rtd_route_stop_all_other_modes 
				PRINT 'Dropping View: rtd_route_stop_all_other_modes'
			end
	ELSE
		PRINT 'View Does Not Exist';
GO
		create view rtd_route_stop_all_other_modes as
SELECT        rtd_route_trips.agency_id, rtd_route_trips.agency_name, rtd_route_trips.route_id, stops.stop_name, stop_times.agency_stop_id, 
                         rtd_route_trips.route_type, stops.stop_lat, stops.stop_lon
FROM            stops INNER JOIN
                         stop_times ON stops.agency_stop_id = stop_times.agency_stop_id INNER JOIN
                         rtd_route_trips ON stop_times.agency_trip_id = rtd_route_trips.agency_trip_id
GROUP BY rtd_route_trips.agency_id, rtd_route_trips.agency_name, rtd_route_trips.route_id, stops.stop_name, stop_times.agency_stop_id, 
                         rtd_route_trips.route_type, stops.stop_lat, stops.stop_lon
HAVING        (rtd_route_trips.route_type <> 3)
GO