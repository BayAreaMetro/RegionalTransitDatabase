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

------------------------------------------------------------------------------------------------------
Print 'Make Indexed Spatial Field on Transit Stops Table'
------------------------------------------------------------------------------------------------------

GO
--Also need to add a Distance Flag field to hold the boolean value for stops that have an adjacent stop within the AM/PM Peak Headway threshold.
ALTER TABLE TPA_Transit_Stops_2016_Build
ADD Distance_Eligible int,
Shape Geography
GO

GO
update TPA_Transit_Stops_2016_Build
set Shape = geography::STGeomFromText('POINT('+convert(varchar(20),stop_lon)+' '+convert(varchar(20),stop_lat)+')',4326)
GO

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


------------------------------------------------------------------------------------------------------
Print 'Create Adjacency Tables'
------------------------------------------------------------------------------------------------------

--query 1: count adjacent stops within 0.2 miles 
--query 2: insert adjacent stops into a table
--

--Find stops that have other adjacent stops within 0.2 miles
GO
IF OBJECT_ID('tempdb..#ODMatrix') IS NOT NULL DROP TABLE #ODMatrix
ELSE
	PRINT 'Table Does Not Exist';
Go
IF OBJECT_ID('tempdb..#StopsThatMeetDistanceThreshold') IS NOT NULL DROP TABLE #StopsThatMeetDistanceThreshold
ELSE
	PRINT 'Table Does Not Exist';
Go

--it sounds like OriginStops was made in Arc
With OriginStops AS
	(select 
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
