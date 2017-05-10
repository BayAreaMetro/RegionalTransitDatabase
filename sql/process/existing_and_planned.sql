Print 'Reclassify status values of E to Existing'
--------------------------------------------------------------------------------------------------
Go
/*update stops_tpa_staging
set status = 'Existing'
where status = 'E'*/
GO
