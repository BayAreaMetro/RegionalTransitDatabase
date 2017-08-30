## Transit Priority Area Processing 2017

[Problem Statement](#problem-statement)   
[Data Sources](#data-sources)   
[Methodology](#methodology)   
[Outcome](#outcome)   

### Problem Statement  

Review the past RTD datasets collected since 2006 to determine the possibility of creating GTFS data by year for all transit operators in the nine county bay region.

### Data Sources

Collected by staff at MTC and from GTFS Data Exchange. Listed in `data/cached_gtfs.csv`

### Methodology

Process each GTFS file listed in `data/cached_gtfs.csv` for routes, stops, and frequencies.  

#### Routes

see `/R/historical_routes/output_historical_routes_by_region.R`

#### Stops and Frequencies

see `/rtd/process_cached_gtfs_for_points_and_frequencies.py`

### Outcome

Intermediate data are staged here for now: https://github.com/BayAreaMetro/transit-data