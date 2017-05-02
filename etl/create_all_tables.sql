CREATE TABLE trips (
	route_id VARCHAR(100) NULL, 
	service_id VARCHAR(100) NOT NULL, 
	trip_id VARCHAR(100) NOT NULL, 
	trip_headsign VARCHAR(100) NULL, 
	direction_id BIT NULL, 
	block_id VARCHAR(100) NULL, 
	shape_id VARCHAR(100) NULL, 
	trip_short_name BIT NULL, 
	CHECK (direction_id IN (0, 1)), 
	CHECK (trip_short_name IN (0, 1))
);

CREATE TABLE agency (
	agency_id VARCHAR(2) NOT NULL, 
	agency_name VARCHAR(50) NOT NULL, 
	agency_url VARCHAR(200) NOT NULL, 
	agency_timezone VARCHAR(50) NOT NULL, 
	agency_lang VARCHAR(2) NULL, 
	agency_phone VARCHAR(50) NULL
);

CREATE TABLE stops (
	stop_id VARCHAR(30) NOT NULL, 
	stop_name VARCHAR(100) NOT NULL, 
	stop_lat VARCHAR(max) NOT NULL, 
	stop_lon VARCHAR(max) NOT NULL, 
	zone_id VARCHAR(200) NULL
);

CREATE TABLE stop_times (
	r_id integer NOT NULL, 
	trip_id VARCHAR(50) NOT NULL, 
	arrival_time VARCHAR(50) NOT NULL, 
	departure_time VARCHAR(50) NOT NULL, 
	stop_id DECIMAL NOT NULL, 
	stop_sequence DECIMAL NOT NULL
);

CREATE TABLE routes (
	route_id VARCHAR(30) NOT NULL, 
	agency_id VARCHAR(2) NOT NULL, 
	route_short_name VARCHAR(30) NULL, 
	route_long_name VARCHAR(59) NULL, 
	route_type DECIMAL NOT NULL
);
