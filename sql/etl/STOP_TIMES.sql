--Insert table values
--stop_times
--truncate Table dbo.stop_times
--select * From dbo.stop_times --qry run time 1 min. 47 secs. for 2827141
DROP TABLE [dbo].stop_times;

CREATE TABLE [dbo].[stop_times](
      [trip_id] [varchar](50) NULL,
      [arrival_time] [varchar](50) NULL,
      [departure_time] [varchar](50) NULL,
      [stop_id] [varchar](100) NULL,
      [stop_sequence] [varchar](100) NULL,
      [agency_stop_id] [varchar](200) NULL,
      [agency_trip_id] [varchar](200) NULL,
      [agency_id] [varchar](50) NULL
) ON [PRIMARY]

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
            Bulk Insert [dbo].[stop_times]
            From "C:\\temp\\RegionalTransitDatabase\\data\\gtfs\\' + @ORG + '\\stop_times.txt"
            With
            (
                        FIRSTROW = 2,
                        FIELDTERMINATOR = '','',
                        ROWTERMINATOR = ''0x0A'',
                        ERRORFILE = ''C:\\temp\\RegionalTransitDatabase\\data\\gtfs\\' + @ORG + '\\stop_times_load_error.txt' + @LoadTime + '.txt''
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

SELECT COUNT(*) from [dbo].stop_times;


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

