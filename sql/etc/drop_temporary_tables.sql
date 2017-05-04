select 'drop view ' + QUOTENAME(sc.name) + '.' + QUOTENAME(obj.name) + ';'
from sys.objects obj
INNER JOIN sys.schemas sc
ON sc.schema_id = obj.schema_id
where obj.type='V'
and sc.name = 'gtfs_2016';

drop view [gtfs_2016].[rtd_route_trips];
drop view [gtfs_2016].[rtd_route_stop_schedule];
drop view [gtfs_2016].[Monday_AM_Peak_Transit_Stop_Headways];
drop view [gtfs_2016].[Monday_PM_Peak_Transit_Stop_Headways];
drop view [gtfs_2016].[Tuesday_PM_Peak_Transit_Stop_Headways];
drop view [gtfs_2016].[Wednesday_PM_Peak_Transit_Stop_Headways];
drop view [gtfs_2016].[Thursday_PM_Peak_Transit_Stop_Headways];
drop view [gtfs_2016].[Friday_PM_Peak_Transit_Stop_Headways];
drop view [gtfs_2016].[Monday_AM_Peak_Trips_15min_or_Less];
drop view [gtfs_2016].[Monday_PM_Peak_Trips_15min_or_Less];
drop view [gtfs_2016].[Tuesday_AM_Peak_Trips_15min_or_Less];
drop view [gtfs_2016].[Tuesday_PM_Peak_Trips_15min_or_Less];
drop view [gtfs_2016].[Wednesday_AM_Peak_Trips_15min_or_Less];
drop view [gtfs_2016].[Wednesday_PM_Peak_Trips_15min_or_Less];
drop view [gtfs_2016].[Thursday_AM_Peak_Trips_15min_or_Less];
drop view [gtfs_2016].[Thursday_PM_Peak_Trips_15min_or_Less];
drop view [gtfs_2016].[Friday_AM_Peak_Trips_15min_or_Less];
drop view [gtfs_2016].[Tuesday_AM_Peak_Transit_Stop_Headways];
drop view [gtfs_2016].[Wednesday_AM_Peak_Transit_Stop_Headways];
drop view [gtfs_2016].[Thursday_AM_Peak_Transit_Stop_Headways];
drop view [gtfs_2016].[Friday_AM_Peak_Transit_Stop_Headways];