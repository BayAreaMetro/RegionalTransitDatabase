--Insert table values
--calendar
--truncate Table dbo.calendar
--select * From dbo.calendar
truncate Table dbo.calendar
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\3D\3D_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
--update unique identifier fields with Agency IDs
update [dbo].calendar
set agency_service_id = N'3D:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\AC\AC_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'AC:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\AM\AM_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'AM:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\AT\AT_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'AT:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\AY\AY_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'AY:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\BA\BA_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'BA:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\BG\BG_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'BG:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\CC\CC_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'CC:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\CE\CE_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'CE:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\CT\CT_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'CT:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\DE\DE_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'DE:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\EM\EM_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'EM:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\FS\FS_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'FS:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\GF\calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'GF:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\GG\GG_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'GG:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\HF\HF_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'HF:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\MA\MA_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'MA:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\MS\MS_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'MS:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\PE\PE_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'PE:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\RV\RV_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'RV:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SB\SB_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'SB:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SC\SC_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'SC:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SF\SF_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'SF:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SM\SM_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'SM:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SO\SO_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'SO:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SR\SR_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'SR:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\ST\ST_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'ST:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\UC\UC_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'UC:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\VC\VC_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'VC:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\VN\VN_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'VN:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\WC\WC_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'WC:' + cast(service_id as nvarchar(200))
where agency_service_id =N''
Bulk Insert [dbo].[calendar]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\WH\WH_calendar.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].calendar
set agency_service_id = N'WH:' + cast(service_id as nvarchar(200))
where agency_service_id =N''


update dbo.calendar
set agency_service_id = replace(replace(agency_service_id, CHAR(13),''),CHAR(10),'')

select * From dbo.calendar order by agency_service_id


