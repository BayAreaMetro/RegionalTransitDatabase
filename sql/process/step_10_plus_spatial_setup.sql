------------------------------------------------------------------------------------------------------------
Print 'Append all existing Rail, Light Rail, Cable Car, and Ferry Stops into TPA_Transit_Stops_2016_Build'
------------------------------------------------------------------------------------------------------------
GO
INSERT INTO TPA_Transit_Stops_2016_Build
                         (agency_id, agency_name, agency_stop_id, stop_name, route_type, stop_lon, stop_lat)
SELECT        agency_id, agency_name, agency_stop_id, stop_name, route_type, stop_lon, stop_lat
FROM            rtd_route_stop_all_other_modes
WHERE        (agency_stop_id NOT IN ('AT:12175078', 'BG:1091722', 'HF:12175092', 'AT:12175080', 'BG:1091727', 'SB:12048537'))
GROUP BY agency_id, agency_name, agency_stop_id, stop_name, route_type, stop_lon, stop_lat
--ORDER BY route_type, agency_id
--select * from rtd_route_stop_all_other_modes where route_type='Ferry'
GO
Print 'Fix Null Route ID values in TPA_Transit_Stops_2016_Build table'
Go
update TPA_Transit_Stops_2016_Build
set route_id = agency_name + ' ' + route_type + ' Service'
Where route_id is null
Go
----------------------------------------------------------------------------------------------------
--Print 'Ensure that all Rail, BRT, Light Rail and Ferry Stops are flagged TPA Eligible'
----------------------------------------------------------------------------------------------------
--GO
--update TPA_Transit_Stops_2016_Build
--set TPA_Eligible = 1
--Where route_type <> 3
--GO
----------------------------------------------------------------------------------------------------
--Print 'Fix Route Names for unclassified values in the Future Transit Table'
----------------------------------------------------------------------------------------------------
--update TPA_Transit_Stops_2016_Build
--set route_id = null
--where route_id = 'Route Name                               ';
GO
--update TPA_Transit_Stops_2016_Build
--set agency_id = N'ACE'
--where agency_name = 'ACE'
--GO
--------------------------------------------------------------------------------------------------
Print 'Fix route_id values that are null or missing'
--------------------------------------------------------------------------------------------------
Go

/*update TPA_Transit_Stops_2016_Build
set route_id = 'ACTC-BRT'
where agency_id = 'AC' and route_type = 'Bus Rapid Transit' --and route_id is null*/
GO
update TPA_Transit_Stops_2016_Build
set route_id = agency_name
where agency_id = 'AM' and route_type = 2 and route_id is null
GO
update TPA_Transit_Stops_2016_Build
set route_id = agency_name
where agency_id = 'BF' and route_type = 4 and route_id is null
GO
update TPA_Transit_Stops_2016_Build
set route_id = agency_name
where agency_id = 'SMART' and route_id is null
GO
/*update TPA_Transit_Stops_2016_Build
set route_id = 'BART (Future)'
where agency_id = 'BA' and route_type = 2 and status <> 'E' and route_id is null*/
/*GO
update TPA_Transit_Stops_2016_Build
set route_id = agency_name + '-' + route_type
where status <> 'E' and route_id is null
GO
*/--------------------------------------------------------------------------------------------------
Print 'Reclassify status values of E to Existing'
--------------------------------------------------------------------------------------------------
Go
/*update TPA_Transit_Stops_2016_Build
set status = 'Existing'
where status = 'E'*/
GO
--Also need to add a Distance Flag field to hold the boolean value for stops that have an adjacent stop within the AM/PM Peak Headway threshold.
ALTER TABLE TPA_Transit_Stops_2016_Build
ADD Distance_Eligible int,
Shape Geography
GO
------------------------------------------------------------------------------------------------------
Print 'Add Geography to Shape Field'
------------------------------------------------------------------------------------------------------
GO
update TPA_Transit_Stops_2016_Build
set Shape = geography::STGeomFromText('POINT('+convert(varchar(20),stop_lon)+' '+convert(varchar(20),stop_lat)+')',4326)
GO
--for now you will need to generate a near table using ArcGIS.
--Qry would need to count adjacent stops within 0.2 miles then insert into a Temp table.
--
--SELECT        agency_id, route_type, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Headway, Meets_Headway_Criteria, Distance_Eligible, Shape
--FROM            TPA_Transit_Stops_2016_Build
--WHERE        (route_type = 3)
alter table [dbo].[TPA_Transit_Stops_2016_Build]
add RecID int IDENTITY(1,1) NOT NULL,
CONSTRAINT [PK_TPA_Transit_Stops_2016_Build] PRIMARY KEY CLUSTERED 
(
	RecID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

Go
---- Create Spatial Index on Shape Col.
create spatial index spin_Stops ON [dbo].[TPA_Transit_Stops_2016_Build](Shape);
--Create index on compare columns (agency_stop_id)
create index IX_StopID on [dbo].[TPA_Transit_Stops_2016_Build](agency_stop_id)
--Find stops that have nearby stops within 0.2 miles
GO
IF OBJECT_ID('tempdb..#ODMatrix') IS NOT NULL DROP TABLE #ODMatrix
ELSE
	PRINT 'Table Does Not Exist';
Go
IF OBJECT_ID('tempdb..#StopsThatMeetDistanceThreshold') IS NOT NULL DROP TABLE #StopsThatMeetDistanceThreshold
ELSE
	PRINT 'Table Does Not Exist';
Go
With OriginStops AS
(select 
--Top(100) 
* from [dbo].[TPA_Transit_Stops_2016_Build])
select OD.agency_stop_id, DDStops.agency_stop_id as dd_stop_id, OD.route_type, OD.Shape as OD_SHape, DDStops.Shape as DD_Shape
 into #ODMatrix from OriginStops as OD
CROSS APPLY (Select Top(1) * from [dbo].[TPA_Transit_Stops_2016_Build] as DD
Where OD.agency_stop_id <> DD.agency_stop_id 
and 
OD.Shape.STDistance(DD.Shape) <= 321.869 --0.2 Miles
--OD.Shape.STDistance(DD.Shape) <= 804.672 --0.5 Miles
--OD.Shape.STDistance(DD.Shape) <= 1609.34 --1 mile
and OD.System = 'Bus'
Order By OD.Shape.STDistance(DD.Shape)) as DDStops
Go
--Report total stops within distance threshold
select agency_stop_id,
stuff(
(select ',' +RTRIM(dd_stop_id)
from #ODMatrix as t1
where t1.agency_stop_id = t2.agency_stop_id
Group By dd_stop_id
for xml path(''))
,1,1,'') as dd_stop_ids, Count(dd_stop_id) as TotalStopsWithin_0_2_Miles, Max(CAST((OD_SHape.STDistance(DD_Shape)/1609.344) as float)) as MaxDistanceInMiles
into #StopsThatMeetDistanceThreshold
from #ODMatrix t2
Group By agency_stop_id
Order By agency_stop_id

--Write Update statement to update those stops that meet the distance threshold in the main table.  Will need to build a join view to update the records
--select Distinct DS.agency_stop_id From #StopsThatMeetDistanceThreshold as DS INNER JOIN 
--TPA_Transit_Stops_2016_Build ON TPA_Transit_Stops_2016_Build.agency_stop_id = DS.agency_stop_id
UPDATE       TPA_Transit_Stops_2016_Build
SET                Distance_Eligible = 1
FROM            #StopsThatMeetDistanceThreshold INNER JOIN
                       TPA_Transit_Stops_2016_Build ON TPA_Transit_Stops_2016_Build.agency_stop_id = #StopsThatMeetDistanceThreshold.agency_stop_id
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