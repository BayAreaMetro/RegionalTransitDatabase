--Insert table values
--routes
--truncate Table dbo.routes 
--select * From dbo.routes
truncate Table dbo.[routes]
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\3D\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
--update unique identifier fields with Agency IDs
update [dbo].[routes]
set agency_route_id = N'3D:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\AC\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'AC:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\AM\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'AM:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\AT\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'AT:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\AY\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'AY:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\BA\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'BA:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\BG\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'BG:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\CC\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'CC:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\CE\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'CE:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\CT\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'CT:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\DE\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'DE:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\EM\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'EM:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\FS\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'FS:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\GF\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'GF:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\GG\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'GG:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\HF\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'HF:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\MA\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'MA:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\MS\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'MS:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\PE\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'PE:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\RV\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'RV:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SB\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'SB:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SC\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'SC:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SF\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'SF:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SM\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'SM:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SO\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'SO:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\SR\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'SR:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\ST\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'ST:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\UC\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'UC:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\VC\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'VC:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\VN\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'VN:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\WC\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'WC:' + cast(route_id as nvarchar(200))
where agency_route_id is null
Bulk Insert [dbo].[routes]
From 'C:\temp\RegionalTransitDatabase\data\gtfs\WH\routes.txt'
With
(
			FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = 'newRow'
)
update [dbo].routes
set agency_route_id = N'WH:' + cast(route_id as nvarchar(200))
where agency_route_id is null

update dbo.routes
set agency_route_id = replace(replace(agency_route_id, CHAR(13),''),CHAR(10),'')
,route_id = replace(replace(route_id, CHAR(13),''),CHAR(10),'')
select * From dbo.routes order by status

