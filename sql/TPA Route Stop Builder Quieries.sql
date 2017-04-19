SELECT        gtfs_2016.rtd_route_trips.agency_id, gtfs_2016.rtd_route_trips.agency_name, gtfs_2016.rtd_route_trips.route_id, gtfs_2016.rtd_route_trips.direction_id, gtfs_2016.stops.stop_name, 
                         CAST(gtfs_2016.stop_times.arrival_time AS time) AS arrival_time, gtfs_2016.stop_times.stop_sequence, gtfs_2016.stop_times.agency_stop_id, gtfs_2016.rtd_route_trips.status, gtfs_2016.rtd_route_trips.system, 
                         gtfs_2016.stops.stop_lat, gtfs_2016.stops.stop_lon, gtfs_2016.calendar.monday, gtfs_2016.calendar.tuesday, gtfs_2016.calendar.wednesday, gtfs_2016.calendar.thursday, gtfs_2016.calendar.friday, 
                         gtfs_2016.calendar.agency_service_id, gtfs_2016.rtd_route_trips.route_short_name, gtfs_2016.rtd_route_trips.trip_headsign, gtfs_2016.rtd_route_trips.trip_id, gtfs_2016.stop_times.agency_trip_id, 
                         geometry::Point(gtfs_2016.stops.stop_lon, gtfs_2016.stops.stop_lat, 4326) AS SHAPE, STOPS_NETWORK_LOCATIONS.SourceID, STOPS_NETWORK_LOCATIONS.SourceOID, 
                         STOPS_NETWORK_LOCATIONS.PosAlong, STOPS_NETWORK_LOCATIONS.SideOfEdge, STOPS_NETWORK_LOCATIONS.SnapX, STOPS_NETWORK_LOCATIONS.SnapY, 
                         STOPS_NETWORK_LOCATIONS.DistanceToNetworkInMeters
INTO              gtfs_2016.RTD_2016_Route_Pattern_Bus_Stop_Schedule
FROM            gtfs_2016.stops INNER JOIN
                         gtfs_2016.stop_times ON gtfs_2016.stops.agency_stop_id = gtfs_2016.stop_times.agency_stop_id INNER JOIN
                         gtfs_2016.rtd_route_trips ON gtfs_2016.stop_times.agency_trip_id = gtfs_2016.rtd_route_trips.agency_trip_id INNER JOIN
                         gtfs_2016.calendar ON gtfs_2016.rtd_route_trips.agency_service_id = gtfs_2016.calendar.agency_service_id INNER JOIN
                         STOPS_NETWORK_LOCATIONS ON gtfs_2016.stops.agency_stop_id = STOPS_NETWORK_LOCATIONS.agency_stop_id
WHERE        (gtfs_2016.rtd_route_trips.system = 'Bus')

alter table gtfs_2016.RTD_2016_Route_Pattern_Bus_Stop_Schedule
add OBJECTID int IDENTITY(1,1) NOT NULL,
CONSTRAINT [PK_RTD_2016_Route_Pattern_Bus_Stop_Schedule] PRIMARY KEY CLUSTERED 
(
	OBJECTID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SELECT        
agency_id, agency_name, route_id, Case When direction_id = 0 Then 'Inbound' Else 'Outbound' End as Route_Direction, stop_name, stop_sequence, agency_stop_id, status, system, stop_lat, stop_lon, route_short_name, trip_headsign, SourceID, SourceOID, PosAlong, SideOfEdge, 
                         SnapX, SnapY, DistanceToNetworkInMeters, agency_id + ' - ' + route_id + ' - ' + Case When direction_id = 0 Then 'Inbound' Else 'Outbound' End as Agency_Route_Pattern, geometry::Point(stop_lon, stop_lat, 4326) AS SHAPE
INTO gtfs_2016.RTD_2016_Route_Pattern_Bus_Stops
FROM            gtfs_2016.RTD_2016_Route_Pattern_Bus_Stop_Schedule
GROUP BY agency_id, agency_name, route_id, direction_id, stop_name, stop_sequence, agency_stop_id, status, system, stop_lat, stop_lon, route_short_name, trip_headsign, SourceID, SourceOID, PosAlong, SideOfEdge, 
                         SnapX, SnapY, DistanceToNetworkInMeters
ORDER BY agency_id, route_id, direction_id, stop_sequence

alter table gtfs_2016.RTD_2016_Route_Patternn_Stops
add OBJECTID int IDENTITY(1,1) NOT NULL,
CONSTRAINT [PK_RTD_2016_Route_Pattern_Stop] PRIMARY KEY CLUSTERED 
(
	OBJECTID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
