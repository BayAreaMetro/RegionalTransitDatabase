Print 'Fix Null Route ID values in stops_tpa_staging table'
/*Go
update stops_tpa_staging
set route_id = agency_name + ' ' + route_type + ' Service'
Where route_id is null
Go*/
----------------------------------------------------------------------------------------------------
--Print 'Ensure that all Rail, BRT, Light Rail and Ferry Stops are flagged TPA Eligible'
----------------------------------------------------------------------------------------------------
GO
update stops_tpa_staging
set TPA_Eligible = 1
Where route_type <> 3
GO
----------------------------------------------------------------------------------------------------
--Print 'Fix Route Names for unclassified values in the Future Transit Table'
----------------------------------------------------------------------------------------------------
/*GO
update stops_tpa_staging
set agency_id = N'ACE'
where agency_name = 'ACE'
*/
--------------------------------------------------------------------------------------------------
Print 'Fix route_id values that are null or missing'
--------------------------------------------------------------------------------------------------
Go

/*update stops_tpa_staging
set route_id = 'ACTC-BRT'
where agency_id = 'AC' and route_type = 'Bus Rapid Transit' --and route_id is null*/
GO
update stops_tpa_staging
set route_id = agency_name
where agency_id = 'AM' and route_type = 2 and route_id is null
GO
update stops_tpa_staging
set route_id = agency_name
where agency_id = 'BF' and route_type = 4 and route_id is null
GO
update stops_tpa_staging
set route_id = agency_name
where agency_id = 'SMART' and route_id is null
GO
/*update stops_tpa_staging
set route_id = 'BART (Future)'
where agency_id = 'BA' and route_type = 2 and status <> 'E' and route_id is null*/
/*GO
update stops_tpa_staging
set route_id = agency_name + '-' + route_type
where status <> 'E' and route_id is null
GO