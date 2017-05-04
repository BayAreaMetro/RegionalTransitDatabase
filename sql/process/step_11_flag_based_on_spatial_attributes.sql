--Flag TPA Eligible Stops based upon Distance and Headway Thresholds
Go
Print 'Flag bus stops that are TPA Eligible'
Go
UPDATE TPA_Transit_Stops_2016_Build
set TPA_Eligible = 1
Where (Distance_Eligible = 1 and Meets_Headway_Criteria = 1)
Go
Print 'Flag stops that do not meet the distance criteria'
Go
UPDATE TPA_Transit_Stops_2016_Build
set Distance_Eligible = 0
Where Distance_Eligible is null
Go
Print 'Flag stops that do not meet the headway criteria'
Go
UPDATE TPA_Transit_Stops_2016_Build
set Meets_Headway_Criteria = 0
Where Meets_Headway_Criteria is null
Go
Print 'Flag stops that are not TPA Eligible'
Go
UPDATE TPA_Transit_Stops_2016_Build
set TPA_Eligible = 0
Where Distance_Eligible = 0 or Meets_Headway_Criteria = 0
Go
Print 'Flag Rail, Ferry, Light Rail, Cable Car, Bus Rapid Transit stops that are TPA Eligible'
Go
UPDATE TPA_Transit_Stops_2016_Build
set TPA_Eligible = 1
Where
route_type in (0,1,2,5,6,7)
#based on definition here https://mtc.legistar.com/View.ashx?M=F&ID=4093399&GUID=BCE50066-9441-4B00-88A0-A28708C99CBB
#and gtfs definition here: https://developers.google.com/transit/gtfs/reference/routes-file
Go
--------------------------------------------------------------------------------------------------
Print 'Fix stop_name values that are in UPPER Case format'
--------------------------------------------------------------------------------------------------
update TPA_Transit_Stops_2016_Build
set stop_name = ProperCase(stop_name)--,
--route_id = ProperCase(route_id),
--agency_name = ProperCase(agency_name)
GO
------------------------------------------------------------------------------------------------------
Print 'Creating Final View for Mapping Purposes.  Contains only Eligible Transit Stops'
------------------------------------------------------------------------------------------------------
GO
IF EXISTS(select * FROM sys.views where name = 'TPA_Transit_Stops_2016_Draft')
			begin
				drop view TPA_Transit_Stops_2016_Draft 
				PRINT 'Dropping View: TPA_Transit_Stops_2016_Draft'
			end
	ELSE
		PRINT 'View Does Not Exist';
GO

create view TPA_Transit_Stops_2016_Draft as
SELECT TOP (60000)        agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Trips, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Trips, Avg_Weekday_PM_Headway, Delete_Stop, 
                         Meets_Headway_Criteria, Distance_Eligible, TPA_Eligible, Stop_Description, Project_Description, stop_lon, stop_lat, SHAPE
FROM            TPA_Transit_Stops_2016_Build 
--Where Meets_Headway_Criteria = 1 
order by agency_id, route_id, route_type
GO
Print 'Build Final Tale for Map View'
Go
IF EXISTS(select * FROM sys.tables where name = 'TPA_Stops_2016_Draft')
			begin
				drop TABLE TPA_Stops_2016_Draft 
				PRINT 'Dropping TABLE: TPA_Stops_2016_Draft'
			end
	ELSE
		PRINT 'Table Does Not Exist';
Go
select * 
into TPA_Stops_2016_Draft
from TPA_Transit_Stops_2016_Draft
Go
Print 'Add RecID Column with an Index'
Go
alter table TPA_Stops_2016_Draft
add RecID int IDENTITY(1,1) NOT NULL,
CONSTRAINT [PK_TPA_Stops_2016_Draft] PRIMARY KEY CLUSTERED 
(
	RecID ASC
) 
---- Create Spatial Index on Shape Col.
create spatial index spin_TPA_Stops ON [dbo].TPA_Stops_2016_Draft(Shape);
--Create index on compare columns (agency_stop_id)
create index IX_StopID on [dbo].TPA_Stops_2016_Draft(agency_stop_id)

Go
IF EXISTS(select * FROM sys.tables where name = 'TPA_Stops_2016_Final')
			begin
				drop TABLE TPA_Stops_2016_Final 
				PRINT 'Dropping TABLE: TPA_Stops_2016_Final'
			end
	ELSE
		PRINT 'Table Does Not Exist';
Go
SELECT     RecID, agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Trips, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Trips, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, Distance_Eligible, 
                  TPA_Eligible, Stop_Description, Project_Description, stop_lon, stop_lat, geometry::Point([stop_lon], [stop_lat], 4326) as SHAPE
into TPA_Stops_2016_Final
FROM        TPA_Stops_2016_Draft

--Cleanup unneeded tables
------------------------------------------------------------
Print 'Cleanup unneeded tables'
------------------------------------------------------------
Drop Table [dbo].[TPA_Transit_Stops_2016_Build]
Drop Table [dbo].[TPA_TRANSIT_STOPS]
Drop Table [dbo].TPA_Stops_2016_Draft

--Check Distance_Eligible and Meets_Headway_Criteria values for Bus to determine if the Distance based calculation used in SQL is working appropriately.
------------------------------------------------------------
Print 'End of Query' ---EOF 
------------------------------------------------------------
--Check Output
--select * From [dbo].[rtd_route_stop_all_other_modes] --No output
--select * from [dbo].[rtd_route_stop_schedule] -- No Output
--select * From [dbo].[rtd_route_trips] --no output
--select * From [dbo].[TPA_Transit_Stops_2016_Draft] where route_type <>'Bus' order by agency_id, route_id, route_type, stop_name -- Only Planned Transit