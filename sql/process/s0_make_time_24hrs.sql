--
--set gtfs time to expected datetime, backing up source column

EXEC sp_rename 'stop_times.arrival_time', 'gtfs_arrival_time', 'COLUMN'; 
ALTER TABLE stop_times ADD arrival_time NVARCHAR(50) NULL

update stop_times
set arrival_time = gtfs_arrival_time
where isdate(gtfs_arrival_time) = 1

update stop_times
set arrival_time = replace(gtfs_arrival_time, left(gtfs_arrival_time,2), cast(left(gtfs_arrival_time,2) as int) - 24)
where isdate(gtfs_arrival_time) = 0 and arrival_hour > 23
