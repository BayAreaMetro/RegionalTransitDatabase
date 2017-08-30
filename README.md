# RegionalTransitDatabase  

Tools for Processing 511 API Datasets for MTC's Regional Transit Database

## Goal 

Process transit data from The Bay Area's Transit operators to satisfy statutory requirements and answer policy question.  

## Data Sources

GTFS as published by operators and MTC 511 is the main data source

[`data/cached_gtfs.csv`](https://github.com/BayAreaMetro/RegionalTransitDatabase/blob/master/data/cached_gtfs.csv) contains a reference to cached GTFS data that are available to us.  

## Methodology 

We use existing GTFS libraries, primarily [gtfs-lib](https://github.com/afimb/gtfslib-python) and [gtfsr](https://github.com/ropensci/gtfsr), to load data and validate it. Then we process the data with one-off scripts depending on the policy question.  

## Outcomes

### Applications

- [Transit Priority Areas](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/docs/transit_priority_areas.md) 

- [Routes, Stops, and Frequencies by Transit Provider from 2008 to 2017](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/docs/historical_transit_data.md) 


### Folders

- R: scripts for analysis of regional transit data
- data: small, important inputs and outputs 
- docs: documentation
- images: used in documentation
- python: scripts for fetching data from 511 and (deprecated) executing network analyst functions
