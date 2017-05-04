----------------------------------------------------------------------------------------------------------------------------------------------------------------
Print 'Step 5. Insert Weekday (Monday thru Friday) AM/PM Peak Headway values into a container for summarization (TPA_TRANSIT_STOPS table).'
----------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
	IF EXISTS(select * FROM sys.tables where name = 'TPA_TRANSIT_STOPS')
		begin
			DROP TABLE TPA_TRANSIT_STOPS 
			PRINT 'Dropping Table: TPA_TRANSIT_STOPS'
		end
ELSE
	PRINT 'Table Does Not Exist';
GO
	Print 'Creating Table TPA_TRANSIT_STOPS'
GO
	CREATE TABLE [TPA_TRANSIT_STOPS](
	RecID int IDENTITY(1,1) NOT NULL,	
	[agency_id] [nvarchar](100) NULL,
	[agency_name] [nvarchar](100) NULL,
	[route_id] [varchar](max) NULL,
	[agency_stop_id] [nvarchar](50) NULL,
	[stop_name] [nvarchar](200) NULL,
	[route_type] [varchar](50) NULL,
	[Max_AM_Trips] [int] NULL,
	[Min_AM_Headway] [int] NULL,
	[Max_PM_Trips] [int] NULL,
	[Min_PM_Headway] [int] NULL,
	[Weekday] [nvarchar](50) NULL,
	[Delete_Stop] [int] NULL,
	[TPA] [varchar](200) NULL,
	[Meets_Headway_Criteria] [int] NULL,
	[TPA_Eligible] [int] NULL,
	[Stop_Description] [varchar](200) NULL,
	[Project_Description] [varchar](max) NULL,
	[stop_lon] [numeric](38, 8) NULL,
	[stop_lat] [numeric](38, 8) NULL
) ON [PRIMARY]
GO
	--------------------------------------------------------------------------------------------------------------------
	Print 'Insert Weekday (Monday thru Friday) AM/PM Peak Headway values into the TPA_TRANSIT_STOPS table.'
	--------------------------------------------------------------------------------------------------------------------
GO
	Print 'Inserting Monday Values'
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_AM_Trips, Min_AM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max AM Trips], [Min AM Headway], 0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Monday_AM_Peak_Trips_15min_or_Less
	Where [Max AM Trips] is not null
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_PM_Trips, Min_PM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max PM Trips], [Min PM Headway],0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Monday_PM_Peak_Trips_15min_or_Less
	Where [Max PM Trips] is not null
GO
GO
	Print 'Update the container table for each Weekday Value (Monday)'
GO
	Update [TPA_TRANSIT_STOPS]
	Set Weekday = 'Monday'
	Where Weekday is null
GO
	Print 'Inserting Tuesday Values'
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_AM_Trips, Min_AM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max AM Trips], [Min AM Headway], 0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Tuesday_AM_Peak_Trips_15min_or_Less
	Where [Max AM Trips] is not null
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_PM_Trips, Min_PM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max PM Trips], [Min PM Headway],0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Tuesday_PM_Peak_Trips_15min_or_Less
	Where [Max PM Trips] is not null
GO
GO
	Print 'Update the container table for each Weekday Value (Tuesday)'
GO
	Update [TPA_TRANSIT_STOPS]
	Set Weekday = 'Tuesday'
	Where Weekday is null
GO
Print 'Inserting Wednesday Values'
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_AM_Trips, Min_AM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max AM Trips], [Min AM Headway], 0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM        #Wednesday_AM_Peak_Trips_15min_or_Less
	Where [Max AM Trips] is not null
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_PM_Trips, Min_PM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max PM Trips], [Min PM Headway],0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Wednesday_PM_Peak_Trips_15min_or_Less
	Where [Max PM Trips] is not null
GO
GO
	Print 'Update the container table for each Weekday Value (Wednesday)'
GO
	Update [TPA_TRANSIT_STOPS]
	Set Weekday = 'Wednesday'
	Where Weekday is null
GO
Print 'Inserting Thursday Values'
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_AM_Trips, Min_AM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max AM Trips], [Min AM Headway], 0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Thursday_AM_Peak_Trips_15min_or_Less
	Where [Max AM Trips] is not null
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_PM_Trips, Min_PM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max PM Trips], [Min PM Headway],0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM        #Thursday_PM_Peak_Trips_15min_or_Less
	Where [Max PM Trips] is not null
GO
GO
	Print 'Update the container table for each Weekday Value (Thursday)'
GO
	Update [TPA_TRANSIT_STOPS]
	Set Weekday = 'Thursday'
	Where Weekday is null
GO
Print 'Inserting Friday Values'
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_AM_Trips, Min_AM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max AM Trips], [Min AM Headway], 0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Friday_AM_Peak_Trips_15min_or_Less
	Where [Max AM Trips] is not null
GO
	INSERT INTO [TPA_TRANSIT_STOPS]
							 (agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, Max_PM_Trips, Min_PM_Headway, Delete_Stop, TPA, Meets_Headway_Criteria, Stop_Description, Project_Description, stop_lon, stop_lat)
	SELECT   agency_id, agency_name, route_id, agency_stop_id, stop_name, route_type, [Max PM Trips], [Min PM Headway],0 as Delete_Stop, TPA, 0 as Meets_Headway_Criteria, 'Existing Transit Stop' as Stop_Description, null as Project_Description, stop_lon, stop_lat
	FROM         #Friday_PM_Peak_Trips_15min_or_Less
	Where [Max PM Trips] is not null
GO
GO
	Print 'Update the container table for each Weekday Value (Friday)'
GO
	Update [TPA_TRANSIT_STOPS]
	Set Weekday = 'Friday'
	Where Weekday is null
GO
