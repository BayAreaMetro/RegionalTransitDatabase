--Cleanup unneeded tables
------------------------------------------------------------
Print 'Cleanup unneeded tables'
------------------------------------------------------------
Drop Table [dbo].[stops_tpa_staging]
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