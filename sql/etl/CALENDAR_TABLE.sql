DROP TABLE [dbo].[calendar];
CREATE TABLE [dbo].[calendar](
      [service_id] [varchar](200) NULL,
      [monday] [int] NULL,
      [tuesday] [int] NULL,
      [wednesday] [int] NULL,
      [thursday] [int] NULL,
      [friday] [int] NULL,
      [saturday] [int] NULL,
      [sunday] [int] NULL,
      [start_date] [varchar](50) NULL,
      [end_date] [varchar](50) NULL,
      [agency_service_id] [varchar](200) NULL
) 

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
            Bulk Insert [dbo].trips
            From "C:\\temp\\RegionalTransitDatabase\\data\\gtfs\\' + @ORG + '\\calendar.txt"
            With
            (
                              FIRSTROW = 2,
                        FIELDTERMINATOR = '','',
                        ROWTERMINATOR = ''0x0A'',
                        ERRORFILE = ''C:\\temp\\RegionalTransitDatabase\\data\\gtfs\\' + @ORG + '\\calendar_load_error.txt' + @LoadTime + '.txt''
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

SELECT COUNT(*) from [dbo].calendar;