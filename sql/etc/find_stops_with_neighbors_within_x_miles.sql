--http://sqlblog.com/blogs/rob_farley/archive/2014/08/14/sql-spatial-getting-nearest-calculations-working-properly.aspx
--SQL Spatial: Getting “nearest” calculations working properly
--Make sure that you add an identity column to your main table
--Go
--alter table [gtfs_2016].[TPA_Transit_Stops_2016_Build]
--add COL RecID IDENTITY(1,1) NOT NULL,
--CONSTRAINT [PK_TPA_Transit_Stops_2016_Build] PRIMARY KEY CLUSTERED 
--(
--	[RecID] ASC
--) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

--Go
---- Create Spatial Index on Shape Col.
--create spatial index spin_Stops ON [gtfs_2016].[TPA_Transit_Stops_2016_Build](Shape);
--Create index on compare columns (agency_stop_id)
--create index IX_StopID on [gtfs_2016].[TPA_Transit_Stops_2016_Build](agency_stop_id)
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
* from [gtfs_2016].[TPA_Transit_Stops_2016_Build])
select OD.agency_stop_id, DDStops.agency_stop_id as dd_stop_id, OD.Shape as OD_SHape, DDStops.Shape as DD_Shape
 into #ODMatrix from OriginStops as OD
CROSS APPLY (Select Top(1) * from [gtfs_2016].[TPA_Transit_Stops_2016_Build] as DD
Where OD.agency_stop_id <> DD.agency_stop_id 
and 
OD.Shape.STDistance(DD.Shape) <= 321.869 --0.2 Miles
--OD.Shape.STDistance(DD.Shape) <= 804.672 --0.5 Miles
--OD.Shape.STDistance(DD.Shape) <= 1609.34 --1 mile
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
select Distinct DS.agency_stop_id From #StopsThatMeetDistanceThreshold as DS INNER JOIN 
gtfs_2016.TPA_Transit_Stops_2016_Build ON gtfs_2016.TPA_Transit_Stops_2016_Build.agency_stop_id = DS.agency_stop_id

select * From #StopsThatMeetDistanceThreshold


--SELECT        
--FROM            gtfs_2016.TPA_TRANSIT_STOPS INNER JOIN
--                         gtfs_2016.TPA_Transit_Stops_2016_Build ON gtfs_2016.TPA_TRANSIT_STOPS.agency_stop_id = gtfs_2016.TPA_Transit_Stops_2016_Build.agency_stop_id