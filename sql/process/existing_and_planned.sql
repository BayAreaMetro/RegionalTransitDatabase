Print 'Reclassify status values of E to Existing'
--------------------------------------------------------------------------------------------------
Go
/*update TPA_Transit_Stops_2017_Build
set status = 'Existing'
where status = 'E'*/
GO
