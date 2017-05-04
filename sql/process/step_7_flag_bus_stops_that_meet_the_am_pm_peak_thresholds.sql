-----------------------------------------------------------------------------------------
Print 'Step 7. Flag Bus Stops that meet the AM/PM Peak Thresholds'
-----------------------------------------------------------------------------------------
GO
update TPA_Transit_Stops_2016_Build
set Meets_Headway_Criteria = 1
Where ((Avg_Weekday_AM_Headway <=15) and (Avg_Weekday_PM_Headway <=15))-- and (Meets_Headway_Criteria = 0 or Meets_Headway_Criteria is null)
GO