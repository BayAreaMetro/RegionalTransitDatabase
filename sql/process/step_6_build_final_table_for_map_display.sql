-----------------------------------------------------------------------------------------
Print 'Step 6. Building Final Table for Map Display'
-----------------------------------------------------------------------------------------
GO
GO
  IF EXISTS(select * FROM sys.tables where name = 'stops_tpa_staging')
    begin
      DROP TABLE stops_tpa_staging 
      PRINT 'Dropping Table: stops_tpa_staging'
    end
ELSE
  PRINT 'Table Does Not Exist';
GO
  Print 'Creating Table stops_tpa_staging'
GO

SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, AVG(Max_AM_Trips) AS Avg_Weekday_AM_Trips, AVG(Min_AM_Headway) AS Avg_Weekday_AM_Headway, 
                         AVG(Max_PM_Trips) AS Avg_Weekday_PM_Trips, AVG(Min_PM_Headway) AS Avg_Weekday_PM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, TPA_Eligible, Stop_Description, Project_Description, stop_lon, stop_lat
into stops_tpa_staging
FROM         TPA_TRANSIT_STOPS
--Where Avg_Weekday_AM_Headway is not null and Avg_Weekday_PM_Headway is not null
GROUP BY agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Delete_Stop, TPA_Eligible, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat
--ORDER BY agency_id, route_id, agency_stop_id

GO