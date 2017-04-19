--Data Preprocessing Steps.
--Be sure to add approppriate line terminators and field terminators for all text lines in RTD tables.  Use Sublime Text or another text wrangler to manipulate the data contents prior to importing into the database.
--add necessary unique fields, line terminators "," and newRow terminators
--Insert table values
--trips
--truncate Table dbo.trips
--select * From dbo.trips
truncate Table dbo.[trips]
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\3D\3D_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
--update unique identifier fields with Agency IDs
update [dbo].trips
set agency_trip_id = N'3D:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'3D:' + cast(service_id as nvarchar(200))
,agency_route_id = N'3D:' + cast(route_id as nvarchar(200))
,agency_id = N'3D'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\AC\AC_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'AC:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'AC:' + cast(service_id as nvarchar(200))
,agency_route_id = N'AC:' + cast(route_id as nvarchar(200))
,agency_id = N'AC'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\AM\AM_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'AM:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'AM:' + cast(service_id as nvarchar(200))
,agency_route_id = N'AM:' + cast(route_id as nvarchar(200))
,agency_id = N'AM'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\AT\AT_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'AT:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'AT:' + cast(service_id as nvarchar(200))
,agency_route_id = N'AT:' + cast(route_id as nvarchar(200))
,agency_id = N'AT'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\AY\AY_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'AY:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'AY:' + cast(service_id as nvarchar(200))
,agency_route_id = N'AY:' + cast(route_id as nvarchar(200))
,agency_id = N'AY'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\BA\BA_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'BA:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'BA:' + cast(service_id as nvarchar(200))
,agency_route_id = N'BA:' + cast(route_id as nvarchar(200))
,agency_id = N'BA'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\BG\BG_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'BG:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'BG:' + cast(service_id as nvarchar(200))
,agency_route_id = N'BG:' + cast(route_id as nvarchar(200))
,agency_id = N'BG'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\CC\CC_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'CC:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'CC:' + cast(service_id as nvarchar(200))
,agency_route_id = N'CC:' + cast(route_id as nvarchar(200))
,agency_id = N'CC'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\CE\CE_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'CE:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'CE:' + cast(service_id as nvarchar(200))
,agency_route_id = N'CE:' + cast(route_id as nvarchar(200))
,agency_id = N'CE'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\CT\CT_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'CT:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'CT:' + cast(service_id as nvarchar(200))
,agency_route_id = N'CT:' + cast(route_id as nvarchar(200))
,agency_id = N'CT'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\DE\DE_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'DE:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'DE:' + cast(service_id as nvarchar(200))
,agency_route_id = N'DE:' + cast(route_id as nvarchar(200))
,agency_id = N'DE'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\EM\EM_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'EM:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'EM:' + cast(service_id as nvarchar(200))
,agency_route_id = N'EM:' + cast(route_id as nvarchar(200))
,agency_id = N'EM'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\FS\FS_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'FS:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'FS:' + cast(service_id as nvarchar(200))
,agency_route_id = N'FS:' + cast(route_id as nvarchar(200))
,agency_id = N'FS'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\GF\trips.txt'
With
(
			FIRSTROW = 2,

            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'GF:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'GF:' + cast(service_id as nvarchar(200))
,agency_route_id = N'GF:' + cast(route_id as nvarchar(200))
,agency_id = N'GF'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\GG\GG_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'GG:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'GG:' + cast(service_id as nvarchar(200))
,agency_route_id = N'GG:' + cast(route_id as nvarchar(200))
,agency_id = N'GG'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\HF\HF_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'HF:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'HF:' + cast(service_id as nvarchar(200))
,agency_route_id = N'HF:' + cast(route_id as nvarchar(200))
,agency_id = N'HF'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\MA\MA_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'MA:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'MA:' + cast(service_id as nvarchar(200))
,agency_route_id = N'MA:' + cast(route_id as nvarchar(200))
,agency_id = N'MA'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\MS\MS_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'MS:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'MS:' + cast(service_id as nvarchar(200))
,agency_route_id = N'MS:' + cast(route_id as nvarchar(200))
,agency_id = N'MS'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\PE\PE_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'PE:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'PE:' + cast(service_id as nvarchar(200))
,agency_route_id = N'PE:' + cast(route_id as nvarchar(200))
,agency_id = N'PE'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\RV\RV_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'RV:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'RV:' + cast(service_id as nvarchar(200))
,agency_route_id = N'RV:' + cast(route_id as nvarchar(200))
,agency_id = N'RV'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SB\SB_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'SB:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'SB:' + cast(service_id as nvarchar(200))
,agency_route_id = N'SB:' + cast(route_id as nvarchar(200))
,agency_id = N'SB'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SC\SC_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'SC:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'SC:' + cast(service_id as nvarchar(200))
,agency_route_id = N'SC:' + cast(route_id as nvarchar(200))
,agency_id = N'SC'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SF\SF_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'SF:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'SF:' + cast(service_id as nvarchar(200))
,agency_route_id = N'SF:' + cast(route_id as nvarchar(200))
,agency_id = N'SF'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SM\SM_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'SM:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'SM:' + cast(service_id as nvarchar(200))
,agency_route_id = N'SM:' + cast(route_id as nvarchar(200))
,agency_id = N'SM'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SO\SO_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'SO:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'SO:' + cast(service_id as nvarchar(200))
,agency_route_id = N'SO:' + cast(route_id as nvarchar(200))
,agency_id = N'SO'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\SR\SR_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'SR:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'SR:' + cast(service_id as nvarchar(200))
,agency_route_id = N'SR:' + cast(route_id as nvarchar(200))
,agency_id = N'SR'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\ST\ST_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'ST:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'ST:' + cast(service_id as nvarchar(200))
,agency_route_id = N'ST:' + cast(route_id as nvarchar(200))
,agency_id = N'ST'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\UC\UC_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'UC:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'UC:' + cast(service_id as nvarchar(200))
,agency_route_id = N'UC:' + cast(route_id as nvarchar(200))
,agency_id = N'UC'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\VC\VC_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'VC:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'VC:' + cast(service_id as nvarchar(200))
,agency_route_id = N'VC:' + cast(route_id as nvarchar(200))
,agency_id = N'VC'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\VN\VN_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'VN:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'VN:' + cast(service_id as nvarchar(200))
,agency_route_id = N'VN:' + cast(route_id as nvarchar(200))
,agency_id = N'VN'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\WC\WC_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'WC:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'WC:' + cast(service_id as nvarchar(200))
,agency_route_id = N'WC:' + cast(route_id as nvarchar(200))
,agency_id = N'WC'
where agency_trip_id =N''
Bulk Insert [dbo].[trips]
From '\\Mac\Home\Documents\MTC\_Section\Planning\Projects\TPA_2016\511 API Data\GTFS Processing\WH\WH_trips.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].trips
set agency_trip_id = N'WH:' + cast(trip_id as nvarchar(200))
,agency_service_id = N'WH:' + cast(service_id as nvarchar(200))
,agency_route_id = N'WH:' + cast(route_id as nvarchar(200))
,agency_id = N'WH'
where agency_trip_id =N''

update [dbo].trips
set agency_route_id = replace(replace(agency_route_id, CHAR(13),''),CHAR(10),'')
,agency_service_id = replace(replace(agency_service_id, CHAR(13),''),CHAR(10),'')
,agency_trip_id = replace(replace(agency_trip_id, CHAR(13),''),CHAR(10),'')
select * From dbo.trips

