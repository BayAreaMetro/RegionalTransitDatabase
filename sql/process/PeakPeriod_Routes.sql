--This query uses RTD data tables, and route output tables exported from R scripts, both stored in a geodatabase to fix location problems associated with default X,Y locations for some stops that are on non-traversable street segments in the NA data tables.

--Review output from PEAKPERIOD_ROUTES.  This table is generated from the NA Route Builder process in ArcMap using the peak_period_route_pattern_stops table below.

SELECT        OBJECTID, Name, Total_Miles, Shape
FROM            PEAKPERIOD_ROUTES
Go
--Review output from dbo.peak_period_route_pattern_stops  This table is generated using R scripts.  See this location: https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/R/RouteBuilderStuff_KS.R
      ,[route_id]
      ,[direction_id]
      ,[trip_headsign]
      ,[stop_id]
      ,[stop_sequence]
      ,[arrival_time]
      ,[Peak_Period]
	  , route_pattern_id
	  ,TPA_Criteria
  FROM [dbo].[peak_period_route_pattern_stops]
  Where TPA_Criteria ='Meets TPA Criteria' --is not null --and agency_id = 'AC' AND route_id = '14'
  Order By route_pattern_id, stop_sequence
  Go

--In order to do a proper join between the [dbo].[peak_period_route_pattern_stops] table and the [WEEKDAY_HIGH_FREQUENCY_BUS_SERVICE_REVIEW] table, we need to add the unique key using the route pattern index below:
  Update [dbo].[WEEKDAY_HIGH_FREQUENCY_BUS_SERVICE_REVIEW]
  set route_pattern_id = agency_id + '-' + route_id + '-' + direction_id + '-' + trip_headsign + '-' + Peak_Period
  Go
  
  --Flag routes with the TPA_Criteria value from the WEEKDAY_HIGH_FREQUENCY_BUS_SERVICE_REVIEW table.
  UPDATE       a
SET                a.TPA_Criteria = b.TPA_Criteria
FROM            peak_period_route_pattern_stops AS a INNER JOIN
                         [WEEKDAY_HIGH_FREQUENCY_BUS_SERVICE_REVIEW] AS b ON a.route_pattern_id = b.route_pattern_id
Go

-- Review output
select * From [dbo].[WEEKDAY_HIGH_FREQUENCY_BUS_SERVICE_REVIEW]
Go
--Review Output
select * From [dbo].[ROUTE_PATTERN_SCHEDULE]
SELECT        TPA_STOPS_RELOCATED.RouteName, TPA_STOPS_RELOCATED.Sequence, TPA_STOPS_RELOCATED.SourceID, TPA_STOPS_RELOCATED.SourceOID, TPA_STOPS_RELOCATED.PosAlong, 
                         TPA_STOPS_RELOCATED.stop_lon, TPA_STOPS_RELOCATED.stop_lat, peak_period_route_pattern_stops.agency_id, peak_period_route_pattern_stops.route_id, peak_period_route_pattern_stops.direction_id, 
                         peak_period_route_pattern_stops.trip_headsign, peak_period_route_pattern_stops.stop_id
FROM            TPA_STOPS_RELOCATED INNER JOIN
                         peak_period_route_pattern_stops ON TPA_STOPS_RELOCATED.RouteName = peak_period_route_pattern_stops.route_pattern_id AND 
                         TPA_STOPS_RELOCATED.Sequence = peak_period_route_pattern_stops.stop_sequence
--Create temp table of new locations from the NA Route Builder Stop Cleanup process.  In order to properly build the routes, it was necessary to manually relocate stops that had errors due to bad locations on the Network.  These new locations will be used to update the Base RTD STOPS table.  This table was an export from the NA Route BUilder stops after manually relocated them to a proper link in the network that is traversable by the Bus route.

SELECT DISTINCT B.stop_id, A.SourceID, A.SourceOID, A.PosAlong, A.SideOfEdge, A.stop_lon, A.stop_lat
into #Stops_FC_Update
FROM            TPA_STOPS_RELOCATED AS A INNER JOIN
                         peak_period_route_pattern_stops AS B ON A.RouteName = B.route_pattern_id AND A.stop_lat <> B.stop_lat



-- Update stops that have new locations as a result of a NA review using route builder.  These new locations will be updated in the base tables (STOPS) and recalculated using the 2016_Dec TomTom Network.  The fields that are updated include stop_lon, stop_lat
--Records Modified: 2893
UPDATE       a
SET                stop_lat = b.stop_lat
FROM            STOPS AS a INNER JOIN
                         #Stops_FC_Update AS b ON a.stop_id = b.stop_id AND a.stop_lat <> b.stop_lat
--Next step: Recalculate locations and rerun route analysis.  The result of the recalculate is below:
--Messages
--Executing: CalculateLocations "\\Mac\Home\Documents\GIS Data\Transit\RTD_2017\Arc\Transit Analysis\Connection to --GISPC.sde\RTD.DBO.STOPS_FCv2" "\\Mac\Home\Documents\GIS Data\TomTom\2015_12_Rev\TomTom_2015_12_NW.gdb\Routing\Routing_ND" "5000 Meters" --"Streets SHAPE;Routing_ND_Junctions NONE" MATCH_TO_CLOSEST SourceID SourceOID PosAlong SideOfEdge SnapX SnapY Distance # # INCLUDE "Streets #;Routing_ND_Junctions #"
--Start Time: Fri May 26 13:21:39 2017
--Adding field "SourceID".
--Adding field "SourceOID".
--Adding field "PosAlong".
--Adding field "SideOfEdge".
--Adding field "SnapX".
--Adding field "SnapY".
--Adding field "Distance".
--22069 features located out of 22073. (Need to determine which stops are not located correctly)
--Succeeded at Fri May 26 13:27:05 2017 (Elapsed Time: 5 minutes 26 seconds)
--Qry Checks:
SELECT        st.agency_id, s.stop_id, tr.route_id, rte.route_short_name, tr.direction_id, st.stop_sequence, st.arrival_time, st.departure_time, st.trip_id, tr.trip_headsign, rte.route_type, s.SourceID, s.SourceOID, s.SideOfEdge, 
                         s.SnapX, s.SnapY, s.Distance, s.Shape
FROM            STOPS_FCV2 AS s RIGHT OUTER JOIN
                         STOP_TIMES AS st ON s.agency_id = st.agency_id AND s.stop_id = st.stop_id LEFT OUTER JOIN
                         TRIPS AS tr INNER JOIN
                         ROUTES AS rte ON tr.route_id = rte.route_id ON st.trip_id = tr.trip_id
WHERE        (rte.route_type = 3) and st.agency_id = 'region'
ORDER BY st.agency_id, tr.route_id, rte.route_short_name, tr.direction_id, st.stop_sequence, st.arrival_time, tr.trip_headsign







select distinct agency_id from STOP_TIMES
select distinct agency_id from Routes
select distinct agency_id from AGENCY
