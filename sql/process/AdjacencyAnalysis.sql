--Create view for adjacency summary
--See the following url for context:
--https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/02f0a5ed623ea9c644da81ec5e84595e084c980c/python/NearTransitStopMatrix.py

create view dbo.RTD_Route_Stop_Adjacency as
SELECT DISTINCT 
                         a.IN_FID, OP_IN_FID.agency_id AS IN_Agency_ID, OP_IN_FID.agency_stop_id AS IN_Agency_Stop_ID, OP_IN_FID.Route_Pattern_ID AS IN_Agency_Route_Pattern, a.NEAR_FID, 
                         OP_NEAR_FID.agency_id AS NEAR_Agency_ID, OP_NEAR_FID.agency_stop_id AS NEAR_Agency_Stop_ID, OP_NEAR_FID.Route_Pattern_ID AS NEAR_Route_Pattern_ID, a.NEAR_DIST, a.NEAR_RANK, 
                         a.FROM_X AS IN_X, a.FROM_Y AS IN_Y, a.NEAR_X, a.NEAR_Y
FROM            OPERATOR_ROUTE_ADJACENCY AS a LEFT OUTER JOIN
                         RTD_OPERATOR_ADJACENCY_UTM AS OP_NEAR_FID ON a.NEAR_FID = OP_NEAR_FID.OBJECTID LEFT OUTER JOIN
                         RTD_OPERATOR_ADJACENCY_UTM AS OP_IN_FID ON a.IN_FID = OP_IN_FID.OBJECTID
WHERE        (a.IN_FID <> a.NEAR_FID) AND OP_IN_FID.agency_id <> OP_NEAR_FID.agency_id
ORDER BY a.IN_FID


--Select Summary View of Adjacency Analysis
SELECT        IN_FID, IN_Agency_ID, IN_Agency_Stop_ID, IN_Agency_Route_Pattern, NEAR_Agency_ID as Shared_Operator, COUNT(IN_FID) AS Total_Shared, COUNT(NEAR_Agency_ID) AS Total_By_Operator
FROM            RTD_Route_Stop_Adjacency
Where IN_Agency_ID in ('GG')
GROUP BY IN_FID, IN_Agency_ID, IN_Agency_Stop_ID, IN_Agency_Route_Pattern, NEAR_Agency_ID
