--Insert table values
--stops
--truncate Table dbo.stops
--select * From dbo.stops
truncate Table gtfs_2016.[stops]
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\3D\3D_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
--update unique identifier fields with Agency IDs
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'3D:' + cast(stop_id as nvarchar(100))
,agency_id = N'3D'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\AC\AC_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'AC:' + cast(stop_id as nvarchar(100))
,agency_id = N'AC'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\AM\AM_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'AM:' + cast(stop_id as nvarchar(100))
,agency_id = N'AM'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\AT\AT_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'AT:' + cast(stop_id as nvarchar(100))
,agency_id = N'AT'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\AY\AY_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'AY:' + cast(stop_id as nvarchar(100))
,agency_id = N'AY'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\BA\BA_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'BA:' + cast(stop_id as nvarchar(100))
,agency_id = N'BA'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\BG\BG_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'BG:' + cast(stop_id as nvarchar(100))
,agency_id = N'BG'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\CC\CC_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'CC:' + cast(stop_id as nvarchar(100))
,agency_id = N'CC'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\CE\CE_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'CE:' + cast(stop_id as nvarchar(100))
,agency_id = N'CE'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\CT\CT_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'CT:' + cast(stop_id as nvarchar(100))
,agency_id = N'CT'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\DE\DE_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'DE:' + cast(stop_id as nvarchar(100))
,agency_id = N'DE'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\EM\EM_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'EM:' + cast(stop_id as nvarchar(100))
,agency_id = N'EM'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\FS\FS_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'FS:' + cast(stop_id as nvarchar(100))
,agency_id = N'FS'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\GF\stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'GF:' + cast(stop_id as nvarchar(100))
,agency_id = N'GF'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\GG\GG_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'GG:' + cast(stop_id as nvarchar(100))
,agency_id = N'GG'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\HF\HF_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'HF:' + cast(stop_id as nvarchar(100))
,agency_id = N'HF'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\MA\MA_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'MA:' + cast(stop_id as nvarchar(100))
,agency_id = N'MA'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\MS\MS_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'MS:' + cast(stop_id as nvarchar(100))
,agency_id = N'MS'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\PE\PE_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'PE:' + cast(stop_id as nvarchar(100))
,agency_id = N'PE'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\RV\RV_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'RV:' + cast(stop_id as nvarchar(100))
,agency_id = N'RV'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SB\SB_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'SB:' + cast(stop_id as nvarchar(100))
,agency_id = N'SB'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SC\SC_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'SC:' + cast(stop_id as nvarchar(100))
,agency_id = N'SC'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SF\SF_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'SF:' + cast(stop_id as nvarchar(100))
,agency_id = N'SF'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SM\SM_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'SM:' + cast(stop_id as nvarchar(100))
,agency_id = N'SM'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SO\SO_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'SO:' + cast(stop_id as nvarchar(100))
,agency_id = N'SO'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SR\SR_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'SR:' + cast(stop_id as nvarchar(100))
,agency_id = N'SR'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\ST\ST_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'ST:' + cast(stop_id as nvarchar(100))
,agency_id = N'ST'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\UC\UC_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'UC:' + cast(stop_id as nvarchar(100))
,agency_id = N'UC'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\VC\VC_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'VC:' + cast(stop_id as nvarchar(100))
,agency_id = N'VC'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\VN\VN_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'VN:' + cast(stop_id as nvarchar(100))
,agency_id = N'VN'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\WC\WC_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'WC:' + cast(stop_id as nvarchar(100))
,agency_id = N'WC'
where agency_stop_id =N''
Bulk Insert [gtfs_2016].[stops]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\WH\WH_stops.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [gtfs_2016].stops
set stop_id = replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = N'WH:' + cast(stop_id as nvarchar(100))
,agency_id = N'WH'
where agency_stop_id =N''

--fix carriage return records due to what appears to be a cast issue
update [gtfs_2016].stops
set agency_stop_id = agency_id + ':' + stop_id



select * From gtfs_2016.stops order by agency_id


