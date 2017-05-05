
------------------------------------------------------------------------------------------------------
Print 'Creating Draft View for Mapping Purposes.  Contains only Eligible Transit Stops'
------------------------------------------------------------------------------------------------------
GO
IF EXISTS(select * FROM sys.views where name = 'TPA_Transit_Stops_2017_Draft')
			begin
				drop view TPA_Transit_Stops_2017_Draft 
				PRINT 'Dropping View: TPA_Transit_Stops_2017_Draft'
			end
	ELSE
		PRINT 'View Does Not Exist';
GO

create view TPA_Transit_Stops_2017_Draft as
SELECT top 1000000 agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Trips, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Trips, Avg_Weekday_PM_Headway, Delete_Stop, 
                         Meets_Headway_Criteria, Distance_Eligible, TPA_Eligible, Stop_Description, Project_Description, stop_lon, stop_lat, SHAPE
FROM            TPA_Transit_Stops_2017_Build 
--Where Meets_Headway_Criteria = 1 
order by agency_id, route_id, route_type


------------------------------------------------------------------------------------------------------
Print 'Creating Final View. Contains only Eligible Transit Stops'
------------------------------------------------------------------------------------------------------

IF EXISTS(select * FROM sys.tables where name = 'TPA_Stops_2017_Draft')
			begin
				drop TABLE TPA_Stops_2017_Draft 
				PRINT 'Dropping TABLE: TPA_Stops_2017_Draft'
			end
	ELSE
		PRINT 'Table Does Not Exist';
Go
select * 
into TPA_Stops_2017_Draft
from TPA_Transit_Stops_2017_Draft
Go
Print 'Add RecID Column with an Index'
Go
alter table TPA_Stops_2017_Draft
add RecID int IDENTITY(1,1) NOT NULL,
CONSTRAINT [PK_TPA_Stops_2017_Draft] PRIMARY KEY CLUSTERED 
(
	RecID ASC
)


---- Create Spatial Index on Shape Col.
create spatial index spin_TPA_Stops ON [dbo].TPA_Stops_2017_Draft(Shape);
--Create index on compare columns (agency_stop_id)
create index IX_StopID on [dbo].TPA_Stops_2017_Draft(agency_stop_id)



Go
IF EXISTS(select * FROM sys.tables where name = 'TPA_Stops_2017_Final')
			begin
				drop TABLE TPA_Stops_2017_Final 
				PRINT 'Dropping TABLE: TPA_Stops_2017_Final'
			end
	ELSE
		PRINT 'Table Does Not Exist';
Go
SELECT     RecID, agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Trips, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Trips, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, Distance_Eligible, 
                  TPA_Eligible, Stop_Description, Project_Description, stop_lon, stop_lat, geometry::Point([stop_lon], [stop_lat], 4326) as SHAPE
into TPA_Stops_2017_Final
FROM        TPA_Stops_2017_Draft