--Be sure to create RTD_2017 Database before running this script
--Also be sure to create DB Schema called [gtfs_2017]
--I added the create scripts below.  This should work.  You may need to revise the path for where the DB is created.  
--Check the location and revise as needed.  The path that I am using is specific to my computer.

CREATE DATABASE [RTD_2017]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RTD_2017', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.MTCGIS\MSSQL\DATA\RTD_2017.mdf' , SIZE = 4904000KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'RTD_2017', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.MTCGIS\MSSQL\DATA\RTD_2017.ldf' , SIZE = 1623488KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
USE [RTD_2017]
GO
/****** Object:  Table [dbo].[agency]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[calendar]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[routes]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[stop_times]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[stop_times_processed]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[stops]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[stops](
	[stop_id] [varchar](100) NULL,
	[stop_name] [varchar](200) NULL,
	[stop_lat] [varchar](max) NULL,
	[stop_lon] [varchar](max) NULL,
	[zone_id] [varchar](50) NULL,
	[agency_id] [varchar](50) NULL,
	[agency_stop_id] [varchar](200) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[system_type]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[system_type](
	[route_type] [varchar](50) NULL,
	[system] [varchar](50) NULL,
	[system_description] [varchar](200) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[trips]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gtfs_2017].[agency]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gtfs_2017].[agency](
	[agency_id] [varchar](50) NULL,
	[agency_name] [varchar](50) NULL,
	[agency_url] [varchar](200) NULL,
	[agency_timezone] [varchar](50) NULL,
	[agency_lang] [varchar](50) NULL,
	[agency_phone] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gtfs_2017].[calendar]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gtfs_2017].[route_stop_schedule]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gtfs_2017].[routes]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gtfs_2017].[RTD_2016_Route_Pattern_Bus_Stop_Schedule]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gtfs_2017].[RTD_2016_Route_Pattern_Bus_Stops]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gtfs_2017].[stop_times]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gtfs_2017].[stop_times_DeDuped]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gtfs_2017].[stops]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gtfs_2017].[stops](
	[stop_id] [varchar](100) NULL,
	[stop_name] [varchar](200) NULL,
	[stop_lat] [varchar](max) NULL,
	[stop_lon] [varchar](max) NULL,
	[zone_id] [varchar](50) NULL,
	[agency_id] [varchar](50) NULL,
	[agency_stop_id] [varchar](200) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gtfs_2017].[system_type]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gtfs_2017].[system_type](
	[route_type] [varchar](50) NULL,
	[system] [varchar](50) NULL,
	[system_description] [varchar](200) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gtfs_2017].[trips]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [gtfs_2017].[rtd_route_trips]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
		create view [gtfs_2017].[rtd_route_trips] as
		SELECT        agency.agency_id, agency.agency_name, routes.route_short_name, trips.trip_headsign, routes.route_id, trips.trip_id, trips.direction_id, routes.agency_route_id, trips.agency_trip_id, trips.agency_service_id, 
                         routes.status, gtfs_2016.system_type.system
FROM            gtfs_2016.agency AS agency INNER JOIN
                         gtfs_2016.routes AS routes ON agency.agency_id = routes.agency_id INNER JOIN
                         gtfs_2016.trips AS trips ON routes.agency_route_id = trips.agency_route_id INNER JOIN
                         gtfs_2016.system_type ON routes.route_type = gtfs_2016.system_type.route_type
--WHERE        (gtfs_2016.system_type.system = 'Bus')

GO
/****** Object:  View [gtfs_2017].[rtd_route_stop_schedule]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
		create view [gtfs_2017].[rtd_route_stop_schedule] as
SELECT        gtfs_2016.rtd_route_trips.agency_id, gtfs_2016.rtd_route_trips.agency_name, gtfs_2016.rtd_route_trips.route_id, gtfs_2016.rtd_route_trips.direction_id, gtfs_2016.stops.stop_name, 
                         CAST(gtfs_2016.stop_times.arrival_time AS time) AS arrival_time, gtfs_2016.stop_times.stop_sequence, gtfs_2016.stop_times.agency_stop_id, gtfs_2016.rtd_route_trips.status, gtfs_2016.rtd_route_trips.system, 
                         gtfs_2016.stops.stop_lat, gtfs_2016.stops.stop_lon, gtfs_2016.calendar.monday, gtfs_2016.calendar.tuesday, gtfs_2016.calendar.wednesday, gtfs_2016.calendar.thursday, gtfs_2016.calendar.friday, 
                         gtfs_2016.calendar.agency_service_id
FROM            gtfs_2016.stops INNER JOIN
                         gtfs_2016.stop_times ON gtfs_2016.stops.agency_stop_id = gtfs_2016.stop_times.agency_stop_id INNER JOIN
                         gtfs_2016.rtd_route_trips ON gtfs_2016.stop_times.agency_trip_id = gtfs_2016.rtd_route_trips.agency_trip_id INNER JOIN
                         gtfs_2016.calendar ON gtfs_2016.rtd_route_trips.agency_service_id = gtfs_2016.calendar.agency_service_id
WHERE        (gtfs_2016.rtd_route_trips.system = 'Bus')

GO
/****** Object:  View [gtfs_2017].[rtd_route_stop_all_other_modes]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
		create view [gtfs_2017].[rtd_route_stop_all_other_modes] as
SELECT        gtfs_2016.rtd_route_trips.agency_id, gtfs_2016.rtd_route_trips.agency_name, gtfs_2016.rtd_route_trips.route_id, gtfs_2016.stops.stop_name, gtfs_2016.stop_times.agency_stop_id, 
                         gtfs_2016.rtd_route_trips.status, gtfs_2016.rtd_route_trips.system, gtfs_2016.stops.stop_lat, gtfs_2016.stops.stop_lon
FROM            gtfs_2016.stops INNER JOIN
                         gtfs_2016.stop_times ON gtfs_2016.stops.agency_stop_id = gtfs_2016.stop_times.agency_stop_id INNER JOIN
                         gtfs_2016.rtd_route_trips ON gtfs_2016.stop_times.agency_trip_id = gtfs_2016.rtd_route_trips.agency_trip_id
GROUP BY gtfs_2016.rtd_route_trips.agency_id, gtfs_2016.rtd_route_trips.agency_name, gtfs_2016.rtd_route_trips.route_id, gtfs_2016.stops.stop_name, gtfs_2016.stop_times.agency_stop_id, 
                         gtfs_2016.rtd_route_trips.status, gtfs_2016.rtd_route_trips.system, gtfs_2016.stops.stop_lat, gtfs_2016.stops.stop_lon
HAVING        (gtfs_2016.rtd_route_trips.system <> 'Bus')

GO
/****** Object:  View [gtfs_2017].[TPA_Transit_Stops_2016_Draft]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [gtfs_2017].[TPA_Transit_Stops_2016_Draft] as
SELECT TOP (50000)        agency_id, agency_name, route_id, agency_stop_id, stop_name, status, system, Avg_Weekday_AM_Trips, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Trips, Avg_Weekday_PM_Headway, Delete_Stop, 
                         Meets_Headway_Criteria, Distance_Eligible, TPA_Eligible, Stop_Description, Project_Description, stop_lon, stop_lat, SHAPE
FROM            gtfs_2016.TPA_Transit_Stops_2016_Build 
--Where Meets_Headway_Criteria = 1 
--order by agency_id, route_id, status, system

GO
/****** Object:  View [gtfs_2017].[TransitStops2016]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [gtfs_2017].[TransitStops2016] as
SELECT agency_id, agency_name, route_id, agency_stop_id, stop_name, system, status,stop_lon, stop_lat, Avg_Weekday_AM_Trips, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Trips, Avg_Weekday_PM_Headway
FROM     gtfs_2016.TPA_Transit_Stops_2016_Draft
GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, system, status,stop_lon, stop_lat, Avg_Weekday_AM_Trips, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Trips, Avg_Weekday_PM_Headway
GO
/****** Object:  View [dbo].[stop_times_revised]    Script Date: 4/26/17 4:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[stop_times_revised]
AS
SELECT        TOP (100) PERCENT agency_id, agency_trip_id, agency_stop_id, stop_sequence, arrival_time, trip_id, stop_id, COUNT(arrival_time) AS Duplicate_Arrival_Times
FROM            gtfs_2016.stop_times
GROUP BY trip_id, arrival_time, stop_id, stop_sequence, agency_stop_id, agency_trip_id, agency_id
ORDER BY agency_id, agency_trip_id, agency_stop_id, stop_sequence, arrival_time

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "stop_times (gtfs_2016)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 366
               Right = 504
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 3345
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'stop_times_revised'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'stop_times_revised'
GO
