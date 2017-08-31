# RegionalTransitDatabase  

Tools for Processing 511 API Datasets for MTC's Regional Transit Database

## Goal 

Process transit data from The Bay Area's Transit operators to satisfy statutory requirements and answer policy question.  

## Data Sources

GTFS as published by operators.

[`data/cached_gtfs.csv`](https://github.com/BayAreaMetro/RegionalTransitDatabase/blob/master/data/cached_gtfs.csv) contains a reference to cached GTFS data that are available to us.  

## Methodology 

- [Transit Priority Areas](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/docs/transit_priority_areas.md) 

- [Routes, Stops, and Frequencies by Transit Provider from 2008 to 2017](https://github.com/MetropolitanTransportationCommission/RegionalTransitDatabase/blob/master/docs/historical_transit_data.md) 


### Folders

- R: scripts for analysis of regional transit data
- data: small, important inputs and outputs 
- docs: documentation
- images: used in documentation
- rtd: python scripts for fetching and processing data
