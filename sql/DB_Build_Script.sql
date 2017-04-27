
CREATE SCHEMA [gtfs_2017]
GO
CREATE TABLE [dbo].[agency](
	[agency_id] [varchar](50) NULL,
	[agency_name] [varchar](50) NULL,
	[agency_url] [varchar](200) NULL,
	[agency_timezone] [varchar](50) NULL,
	[agency_lang] [varchar](50) NULL,
	[agency_phone] [varchar](50) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[calendar](
	[service_id] [varchar](200) NULL,
	[monday] [int] NULL,
	[tuesday] [int] NULL,
	[wednesday] [int] NULL,
	[thursday] [int] NULL,
	[friday] [int] NULL,
	[saturday] [int] NULL,
	[sunday] [int] NULL,
	[start_date] [varchar](50) NULL,
	[end_date] [varchar](50) NULL,
	[agency_service_id] [varchar](200) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[routes](
	[route_id] [varchar](200) NULL,
	[agency_id] [varchar](200) NULL,
	[route_short_name] [varchar](50) NULL,
	[route_long_name] [varchar](200) NULL,
	[route_type] [varchar](50) NULL,
	[route_color] [varchar](50) NULL,
	[route_text_color] [varchar](50) NULL,
	[agency_route_id] [varchar](200) NULL,
	[status] [varchar](50) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[stop_times](
	[trip_id] [varchar](50) NULL,
	[arrival_time] [varchar](50) NULL,
	[departure_time] [varchar](50) NULL,
	[stop_id] [varchar](100) NULL,
	[stop_sequence] [varchar](100) NULL,
	[agency_stop_id] [varchar](200) NULL,
	[agency_trip_id] [varchar](200) NULL,
	[agency_id] [varchar](50) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[stop_times_processed](
	[trip_id] [varchar](50) NULL,
	[arrival_time] [varchar](50) NULL,
	[departure_time] [varchar](50) NULL,
	[stop_id] [varchar](100) NULL,
	[stop_sequence] [varchar](100) NULL,
	[agency_stop_id] [varchar](200) NULL,
	[agency_trip_id] [varchar](200) NULL,
	[agency_id] [varchar](50) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[stops](
	[stop_id] [varchar](100) NULL,
	[stop_name] [varchar](200) NULL,
	[stop_lat] [varchar](max) NULL,
	[stop_lon] [varchar](max) NULL,
	[zone_id] [varchar](50) NULL,
	[agency_id] [varchar](50) NULL,
	[agency_stop_id] [varchar](200) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[system_type](
	[route_type] [varchar](50) NULL,
	[system] [varchar](50) NULL,
	[system_description] [varchar](200) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[trips](
	[route_id] [varchar](200) NULL,
	[service_id] [varchar](200) NULL,
	[trip_id] [varchar](200) NULL,
	[trip_headsign] [varchar](200) NULL,
	[direction_id] [varchar](50) NULL,
	[block_id] [varchar](50) NULL,
	[shape_id] [varchar](50) NULL,
	[trip_short_name] [varchar](200) NULL,
	[agency_id] [varchar](50) NULL,
	[agency_route_id] [varchar](200) NULL,
	[agency_service_id] [varchar](200) NULL,
	[agency_trip_id] [varchar](200) NULL
) ON [PRIMARY]

