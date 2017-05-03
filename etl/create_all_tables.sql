CREATE TABLE trips (
	route_id VARCHAR(100) NULL, 
	service_id VARCHAR(100) NOT NULL, 
	trip_id VARCHAR(100) NOT NULL, 
	trip_headsign VARCHAR(100) NULL, 
	direction_id BIT NULL, 
	block_id VARCHAR(100) NULL, 
	shape_id VARCHAR(100) NULL, 
	trip_short_name VARCHAR(100) NULL, 
	CHECK (direction_id IN (0, 1)) 
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
	trip_id VARCHAR(200) NOT NULL, 
	arrival_time VARCHAR(50) NOT NULL, 
	departure_time VARCHAR(50) NOT NULL, 
	stop_id VARCHAR(100) NOT NULL, 
	stop_sequence INTEGER NOT NULL
);

CREATE TABLE routes (
	route_id VARCHAR(30) NOT NULL, 
	agency_id VARCHAR(2) NOT NULL, 
	route_short_name VARCHAR(30) NULL, 
	route_long_name VARCHAR(59) NULL, 
	route_type INTEGER NOT NULL
);

CREATE TABLE calendar (
	service_id VARCHAR(50) NOT NULL, 
	monday BIT NOT NULL, 
	tuesday BIT NOT NULL, 
	wednesday BIT NOT NULL, 
	thursday BIT NOT NULL, 
	friday BIT NOT NULL, 
	saturday BIT NOT NULL, 
	sunday BIT NOT NULL, 
	start_date VARCHAR(50) NOT NULL, 
	end_date VARCHAR(50) NOT NULL, 
	CHECK (monday IN (0, 1)), 
	CHECK (tuesday IN (0, 1)), 
	CHECK (wednesday IN (0, 1)), 
	CHECK (thursday IN (0, 1)), 
	CHECK (friday IN (0, 1)), 
	CHECK (saturday IN (0, 1)), 
	CHECK (sunday IN (0, 1))
);
