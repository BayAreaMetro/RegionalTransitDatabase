--Insert table values
--stop_times
--truncate Table dbo.stop_times
--select * From dbo.stop_times --qry run time 1 min. 47 secs. for 2827141
truncate Table dbo.[stop_times]
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\3D\3D_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)

--update unique identifier fields with Agency IDs
update [dbo].stop_times
set agency_id = N'3D'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\AC\AC_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'AC'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\AM\AM_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'AM'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\AT\AT_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'AT'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\AY\AY_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'AY'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\BA\BA_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'BA'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\BG\BG_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'BG'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\CC\CC_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'CC'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\CE\CE_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'CE'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\CT\CT_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'CT'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\DE\DE_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'DE'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\EM\EM_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'EM'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\FS\FS_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'FS'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\GF\stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'GF'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\GG\GG_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'GG'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\HF\HF_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'HF'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\MA\MA_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'MA'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\MS\MS_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'MS'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\PE\PE_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'PE'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\RV\RV_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'RV'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SB\SB_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'SB'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SC\SC_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'SC'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SF\SF_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'SF'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SM\SM_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'SM'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SO\SO_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'SO'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SR\SR_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'SR'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\ST\ST_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'ST'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\UC\UC_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'UC'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\VC\VC_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'VC'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\VN\VN_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'VN'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\WC\WC_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'WC'
where agency_id =N''
Bulk Insert [dbo].[stop_times]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\WH\WH_stop_times.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].stop_times
set agency_id = N'WH'
where agency_id =N''

update dbo.stop_times
set agency_id = replace(replace(agency_id, CHAR(13),''),CHAR(10),'')
,agency_stop_id = agency_id + ':' + replace(replace(stop_id, CHAR(13),''),CHAR(10),'')
,agency_trip_id = agency_id + ':' + replace(replace(trip_id, CHAR(13),''),CHAR(10),'')



--select * 
--into dbo.stop_times_processed
--From dbo.stop_times

--select left(arrival_time,2) - 24 as arr_time from dbo.stop_times where left(arrival_time,2)>23 order by arr_time desc


update dbo.stop_times
set arrival_time = replace(arrival_time, left(arrival_time,2), cast(left(arrival_time,2) as int) - 24)
where cast(left(arrival_time,2) as int)>23

--check results
SELECT        CAST(arrival_time AS time) AS arr_time
FROM            dbo.stop_times
GROUP BY CAST(arrival_time AS time)
ORDER BY arr_time --desc


--Due to formatting contained in the GF stop_times.txt gtfs file, correctoins are needed to repair the arrival time field so that time values are in the proper 24hr. clock format. (for the 7,8,9 hours)
--update dbo.stop_times
--set arrival_time = replace(arrival_time, left(arrival_time,1), '0'+left(arrival_time,1))
--Where arrival_time like '9:%'


--select replace(arrival_time, left(arrival_time,1), '0'+left(arrival_time,1)) as arr_time
--from dbo.stop_times
--Where arrival_time like '7:%'
--order by arrival_time DESC

