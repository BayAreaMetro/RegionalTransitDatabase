--Flag TPA Eligible Stops based upon Distance and Headway Thresholds
Go
Print 'Flag bus stops that are TPA Eligible'
Go
UPDATE TPA_Transit_Stops_2017_Build
set TPA_Eligible = 1
Where (Distance_Eligible = 1 and Meets_Headway_Criteria = 1)
Go
Print 'Flag stops that do not meet the distance criteria'
Go
UPDATE TPA_Transit_Stops_2017_Build
set Distance_Eligible = 0
Where Distance_Eligible is null
Go
Print 'Flag stops that do not meet the headway criteria'
Go
UPDATE TPA_Transit_Stops_2017_Build
set Meets_Headway_Criteria = 0
Where Meets_Headway_Criteria is null
Go
Print 'Flag stops that are not TPA Eligible'
Go
UPDATE TPA_Transit_Stops_2017_Build
set TPA_Eligible = 0
Where Distance_Eligible = 0 or Meets_Headway_Criteria = 0
Go
Print 'Flag Rail, Ferry, Light Rail, Cable Car, Bus Rapid Transit stops that are TPA Eligible'
Go
UPDATE TPA_Transit_Stops_2017_Build
set TPA_Eligible = 1
Where
route_type in (0,1,2,5,6,7)
--based on definition here https://mtc.legistar.com/View.ashx?M=F&ID=4093399&GUID=BCE50066-9441-4B00-88A0-A28708C99CBB
--and gtfs definition here: https://developers.google.com/transit/gtfs/reference/routes-file
Go

