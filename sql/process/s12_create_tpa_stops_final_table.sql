
------------------------------------------------------------------------------------------------------
Print 'Creating Draft View.  Contains only Eligible Transit Stops'
------------------------------------------------------------------------------------------------------
GO
IF EXISTS(select * FROM sys.views where name = 'stops_tpa_draft')
			begin
				drop view stops_tpa_draft 
				PRINT 'Dropping View: stops_tpa_draft'
			end
	ELSE
		PRINT 'View Does Not Exist';
GO

create view stops_tpa_draft as
SELECT top 1000000 agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Trips, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Trips, Avg_Weekday_PM_Headway, Delete_Stop, 
                         Meets_Headway_Criteria, Distance_Eligible, TPA_Eligible, Stop_Description, Project_Description, stop_lon, stop_lat, SHAPE
FROM            stops_tpa_staging 
--Where Meets_Headway_Criteria = 1 
order by agency_id, route_id, route_type


------------------------------------------------------------------------------------------------------
Print 'Creating Final View. Contains only Eligible Transit Stops'
------------------------------------------------------------------------------------------------------

IF EXISTS(select * FROM sys.tables where name = 'stops_tpa_draft')
			begin
				drop TABLE stops_tpa_draft 
				PRINT 'Dropping TABLE: stops_tpa_draft'
			end
	ELSE
		PRINT 'Table Does Not Exist';
Go
select * 
into stops_tpa_draft
from stops_tpa_staging
Go
Print 'Add RecID Column with an Index'
Go
alter table stops_tpa_draft
add RecID int IDENTITY(1,1) NOT NULL,
CONSTRAINT [PK_stops_tpa_draft] PRIMARY KEY CLUSTERED 
(
	RecID ASC
)


---- Create Spatial Index on Shape Col.
create spatial index spin_TPA_Stops ON [dbo].stops_tpa_draft(Shape);
--Create index on compare columns (agency_stop_id)
create index IX_StopID on [dbo].stops_tpa_draft(agency_stop_id)



Go
IF EXISTS(select * FROM sys.tables where name = 'stops_tpa_final')
			begin
				drop TABLE stops_tpa_final 
				PRINT 'Dropping TABLE: stops_tpa_final'
			end
	ELSE
		PRINT 'Table Does Not Exist';
Go
SELECT     RecID, agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Trips, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Trips, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, Distance_Eligible, 
                  TPA_Eligible, Stop_Description, Project_Description, stop_lon, stop_lat, geometry::Point([stop_lon], [stop_lat], 4326) as SHAPE
into stops_tpa_draft_final
FROM        stops_tpa_draft

Go

DROP table stops_tpa_draft;