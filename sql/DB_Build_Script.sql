--Be sure to create RTD_2017 Database before running this script
--Also be sure to create DB Schema called [gtfs_2017]
--I added the create scripts below.  This should work.  You may need to revise the path for where the DB is created.  Check the location and revise as needed.  The path that I am using is specific to my computer.

/*CREATE DATABASE [RTD_2017]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RTD_2017', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.MTCGIS\MSSQL\DATA\RTD_2017.mdf' , SIZE = 4904000KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'RTD_2017', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.MTCGIS\MSSQL\DATA\RTD_2017.ldf' , SIZE = 1623488KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
USE [RTD_2017]
GO*/
/****** Object:  Table [dbo].[agency]    Script Date: 4/26/17 4:48:39 PM ******/

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


/****** Object:  Table [dbo].[calendar]    Script Date: 4/26/17 4:48:39 PM ******/

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

CREATE TABLE [gtfs_2017].[agency](
	[agency_id] [varchar](50) NULL,
	[agency_name] [varchar](50) NULL,
	[agency_url] [varchar](200) NULL,
	[agency_timezone] [varchar](50) NULL,
	[agency_lang] [varchar](50) NULL,
	[agency_phone] [varchar](50) NULL
) ON [PRIMARY]

CREATE TABLE [gtfs_2017].[calendar](
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

CREATE TABLE [gtfs_2017].[route_stop_schedule](
	[agency_id] [varchar](50) NULL,
	[agency_name] [varchar](50) NULL,
	[route_id] [varchar](200) NULL,
	[direction_id] [varchar](50) NULL,
	[stop_name] [varchar](200) NULL,
	[arrival_time] [time](7) NULL,
	[stop_sequence] [int] NULL,
	[agency_stop_id] [varchar](200) NULL,
	[status] [varchar](50) NULL,
	[system] [varchar](50) NULL,
	[stop_lat] [varchar](max) NULL,
	[stop_lon] [varchar](max) NULL,
	[monday] [int] NULL,
	[tuesday] [int] NULL,
	[wednesday] [int] NULL,
	[thursday] [int] NULL,
	[friday] [int] NULL,
	[agency_service_id] [varchar](200) NULL,
	[Duplicate_Arrival_Times] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [gtfs_2017].[routes](
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


CREATE TABLE [gtfs_2017].[RTD_2016_Route_Pattern_Bus_Stop_Schedule](
	[agency_id] [varchar](50) NULL,
	[agency_name] [varchar](50) NULL,
	[route_id] [varchar](200) NULL,
	[direction_id] [varchar](50) NULL,
	[stop_name] [varchar](200) NULL,
	[arrival_time] [time](7) NULL,
	[stop_sequence] [varchar](100) NULL,
	[agency_stop_id] [varchar](200) NULL,
	[status] [varchar](50) NULL,
	[system] [varchar](50) NULL,
	[stop_lat] [varchar](max) NULL,
	[stop_lon] [varchar](max) NULL,
	[monday] [int] NULL,
	[tuesday] [int] NULL,
	[wednesday] [int] NULL,
	[thursday] [int] NULL,
	[friday] [int] NULL,
	[agency_service_id] [varchar](200) NULL,
	[route_short_name] [varchar](50) NULL,
	[trip_headsign] [varchar](200) NULL,
	[trip_id] [varchar](200) NULL,
	[agency_trip_id] [varchar](200) NULL,
	[SHAPE] [geometry] NULL,
	[SourceID] [int] NULL,
	[SourceOID] [int] NULL,
	[PosAlong] [numeric](38, 8) NULL,
	[SideOfEdge] [int] NULL,
	[SnapX] [numeric](38, 8) NULL,
	[SnapY] [numeric](38, 8) NULL,
	[DistanceToNetworkInMeters] [numeric](38, 8) NULL,
	[OBJECTID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_RTD_2016_Route_Pattern_Bus_Stop_Schedule] PRIMARY KEY CLUSTERED 
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


/****** Object:  Table [gtfs_2017].[RTD_2016_Route_Pattern_Bus_Stops]    Script Date: 4/26/17 4:48:39 PM ******/

CREATE TABLE [gtfs_2017].[RTD_2016_Route_Pattern_Bus_Stops](
	[agency_id] [varchar](50) NULL,
	[agency_name] [varchar](50) NULL,
	[route_id] [varchar](200) NULL,
	[Route_Direction] [varchar](8) NOT NULL,
	[stop_name] [varchar](200) NULL,
	[stop_sequence] [varchar](100) NULL,
	[agency_stop_id] [varchar](200) NULL,
	[status] [varchar](50) NULL,
	[system] [varchar](50) NULL,
	[stop_lat] [varchar](max) NULL,
	[stop_lon] [varchar](max) NULL,
	[route_short_name] [varchar](50) NULL,
	[trip_headsign] [varchar](200) NULL,
	[SourceID] [int] NULL,
	[SourceOID] [int] NULL,
	[PosAlong] [numeric](38, 8) NULL,
	[SideOfEdge] [int] NULL,
	[SnapX] [numeric](38, 8) NULL,
	[SnapY] [numeric](38, 8) NULL,
	[DistanceToNetworkInMeters] [numeric](38, 8) NULL,
	[Agency_Route_Pattern] [varchar](264) NULL,
	[SHAPE] [geometry] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


/****** Object:  Table [gtfs_2017].[stop_times]    Script Date: 4/26/17 4:48:39 PM ******/

CREATE TABLE [gtfs_2017].[stop_times](
	[trip_id] [varchar](50) NULL,
	[arrival_time] [varchar](50) NULL,
	[departure_time] [varchar](50) NULL,
	[stop_id] [varchar](100) NULL,
	[stop_sequence] [varchar](100) NULL,
	[agency_stop_id] [varchar](200) NULL,
	[agency_trip_id] [varchar](200) NULL,
	[agency_id] [varchar](50) NULL
) ON [PRIMARY]


/****** Object:  Table [gtfs_2017].[stop_times_DeDuped]    Script Date: 4/26/17 4:48:39 PM ******/

CREATE TABLE [gtfs_2017].[stop_times_DeDuped](
	[agency_id] [varchar](50) NULL,
	[agency_trip_id] [varchar](200) NULL,
	[agency_stop_id] [varchar](200) NULL,
	[stop_sequence] [varchar](100) NULL,
	[arrival_time] [varchar](50) NULL,
	[trip_id] [varchar](50) NULL,
	[stop_id] [varchar](100) NULL,
	[Duplicate_Arrival_Times] [int] NULL
) ON [PRIMARY]


/****** Object:  Table [gtfs_2017].[stops]    Script Date: 4/26/17 4:48:39 PM ******/

CREATE TABLE [gtfs_2017].[stops](
	[stop_id] [varchar](100) NULL,
	[stop_name] [varchar](200) NULL,
	[stop_lat] [varchar](max) NULL,
	[stop_lon] [varchar](max) NULL,
	[zone_id] [varchar](50) NULL,
	[agency_id] [varchar](50) NULL,
	[agency_stop_id] [varchar](200) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


/****** Object:  Table [gtfs_2017].[system_type]    Script Date: 4/26/17 4:48:39 PM ******/

CREATE TABLE [gtfs_2017].[system_type](
	[route_type] [varchar](50) NULL,
	[system] [varchar](50) NULL,
	[system_description] [varchar](200) NULL
) ON [PRIMARY]


/****** Object:  Table [gtfs_2017].[trips]    Script Date: 4/26/17 4:48:39 PM ******/

CREATE TABLE [gtfs_2017].[trips](
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
