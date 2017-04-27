DROP TABLE [dbo].[routes];

CREATE TABLE [dbo].[routes](
      [route_id] [varchar](200) NULL,
      [agency_id] [varchar](200) NULL,
      [route_short_name] [varchar](50) NULL,
      [route_long_name] [varchar](600) NULL,
      [route_type] [varchar](50) NULL,
      [route_color] [varchar](50) NULL,
      [route_text_color] [varchar](50) NULL,
      [agency_route_id] [varchar](200) NULL,
      [status] [varchar](50) NULL
);

CREATE TABLE #TRANSIT_AGENGY_ACRONYMS
(
SHORTNAME VARCHAR(128) 
)

INSERT INTO #TRANSIT_AGENGY_ACRONYMS
VALUES
('AC'),
('HF'),
('CE'),
('AY'),
('AT'),
('BA'),
('BG'),
('CT'),
('AM'),
('CM'),
('CC'),
('DE'),
('EM'),
('FS'),
('GF'),
('GG'),
('MA'),
('PE'),
('RV'),
('SM'),
('SB'),
('SR'),
('SF'),
('SA'),
('ST'),
('SO'),
('MS'),
('3D'),
('UC'),
('VC'),
('VN'),
('SC'),
('WC'),
('WH')

DECLARE @ORG as VARCHAR(128); 
DECLARE @SQL VARCHAR(MAX);
DECLARE @SHORTNAMEC AS CURSOR; 

DECLARE @LoadTime VARCHAR(100) = (select REPLACE(convert(varchar(10), GETDATE(), 108),':','') )

SET @SHORTNAMEC = CURSOR FOR 
SELECT SHORTNAME
FROM #TRANSIT_AGENGY_ACRONYMS; 

OPEN @SHORTNAMEC 
FETCH NEXT FROM @SHORTNAMEC INTO @ORG; 

WHILE @@FETCH_STATUS = 0 
BEGIN 
      SET @SQL = 

            '
            Bulk Insert [dbo].[routes]
            From "C:\\temp\\RegionalTransitDatabase\\data\\gtfs\\' + @ORG + '\\routes.txt"
            With
            (
                              FIRSTROW = 2,
                        FIELDTERMINATOR = '','',
                        ROWTERMINATOR = ''0x0A'',
                        ERRORFILE = ''C:\\temp\\RegionalTransitDatabase\\data\\gtfs\\' + @ORG + '\\routes_load_error' + @LoadTime + '.txt''
            )
            '
            BEGIN
                  BEGIN TRY
                        EXEC(@SQL)
                        FETCH NEXT FROM @SHORTNAMEC INTO @ORG; 
                  END TRY
                  BEGIN CATCH
                        PRINT(@ORG)
                        FETCH NEXT FROM @SHORTNAMEC INTO @ORG; 
                  END CATCH
            END

END 

CLOSE @SHORTNAMEC; 
DEALLOCATE @SHORTNAMEC; 

DROP TABLE #TRANSIT_AGENGY_ACRONYMS;

SELECT COUNT(*) from [dbo].[routes];

update dbo.routes
set agency_route_id = replace(replace(agency_route_id, CHAR(13),''),CHAR(10),'')
,route_id = replace(replace(route_id, CHAR(13),''),CHAR(10),'')
select * From dbo.routes order by status

