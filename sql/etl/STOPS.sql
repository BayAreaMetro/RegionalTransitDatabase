--Insert table values
--stops
--truncate Table dbo.stops
--select * From dbo.stops
truncate Table gtfs_2016.[stops]
Bulk Insert [gtfs_2016].[stops]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\3D\3D_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\AC\AC_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\AM\AM_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\AT\AT_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\AY\AY_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\BA\BA_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\BG\BG_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\CC\CC_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\CE\CE_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\CT\CT_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\DE\DE_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\EM\EM_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\FS\FS_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\GF\stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\GG\GG_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\HF\HF_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\MA\MA_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\MS\MS_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\PE\PE_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\RV\RV_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SB\SB_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SC\SC_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SF\SF_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SM\SM_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SO\SO_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SR\SR_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\ST\ST_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\UC\UC_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\VC\VC_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\VN\VN_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\WC\WC_stops.txt'
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
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\WH\WH_stops.txt'
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


