-----------------------------------------------------------------------------------------
Print 'Step 6. Insert Planned and Under Construction Transit Stops'
-----------------------------------------------------------------------------------------
GO
--Fix the column name in the TPA_Future_Transit_Stops Table
--SELECT        agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, stop_description, Project_Description, 
--                         stop_lon, stop_lat
--FROM            TPA_Future_Transit_Stops
--Where System = 'Ferry'

INSERT INTO stops_tpa_staging
                         (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, Stop_Description, Project_Description, 
                         stop_lon, stop_lat)
SELECT        agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Avg_Weekday_AM_Headway, Avg_Weekday_PM_Headway, Delete_Stop, Meets_Headway_Criteria, stop_description, Project_Description, 
                         stop_lon, stop_lat
FROM            TPA_Future_Transit_Stops
Where stop_description not in ('Stevens Creek LRT','North Bayshore LRT (NASA/Bayshore to Google)','Tasman West LRT Realignment (Fair Oaks to Mountain View)', 'eBART – Phase 2 (Antioch to Brentwood)')
GO

------------------------------------------------------------------------------------------------------------
Print 'Append all existing Rail, Light Rail, Cable Car, and Ferry Stops into stops_tpa_staging'
------------------------------------------------------------------------------------------------------------
GO
INSERT INTO stops_tpa_staging
                         (agency_id, agency_name, agency_stop_id, stop_name, route_type, stop_lon, stop_lat)
SELECT        agency_id, agency_name, agency_stop_id, stop_name, route_type, stop_lon, stop_lat
FROM            rtd_route_stop_all_other_modes
WHERE        (agency_stop_id NOT IN ('AT:12175078', 'BG:1091722', 'HF:12175092', 'AT:12175080', 'BG:1091727', 'SB:12048537'))
GROUP BY agency_id, agency_name, agency_stop_id, stop_name, route_type, stop_lon, stop_lat
--ORDER BY route_type, agency_id
--select * from rtd_route_stop_all_other_modes where route_type='Ferry'
GO

Print 'Reclassify status values of E to Existing'
--------------------------------------------------------------------------------------------------
Go
/*update stops_tpa_staging
set status = 'Existing'
where status = 'E'*/
GO
