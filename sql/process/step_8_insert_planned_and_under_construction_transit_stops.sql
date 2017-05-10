-----------------------------------------------------------------------------------------
Print 'Step 8. Insert Planned and Under Construction Transit Stops'
-----------------------------------------------------------------------------------------
GO
--Fix the column name in the TPA_Future_Transit_Stops Table
--SELECT        agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, stop_description, Project_Description, 
--                         stop_lon, stop_lat
--FROM            TPA_Future_Transit_Stops
--Where System = 'Ferry'

INSERT INTO TPA_Transit_Stops_2017_Build
                         (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, Stop_Description, Project_Description, 
                         stop_lon, stop_lat)
SELECT        agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, stop_description, Project_Description, 
                         stop_lon, stop_lat
FROM            TPA_Future_Transit_Stops
Where stop_description not in ('Stevens Creek LRT','North Bayshore LRT (NASA/Bayshore to Google)','Tasman West LRT Realignment (Fair Oaks to Mountain View)', 'eBART – Phase 2 (Antioch to Brentwood)')
GO