import pickle
import os
from mtc511 import get_511_orgs_dict, get_511_gtfs_zip, write_511_gtfs_to_disk

#error with sqllite, trying postgres
#brew install postgresql
#createdb gtfs -W 
#gtfsrun "postgresql:///gtfs" GtfsExport --bundle=MS2.zip --logsql --skip_shape_dist

def main(): 
	d = get_511_orgs_dict()
	org_acronyms = get_org_acronyms_from_511()
	get_zip_from_511(org_acronyms, datadir = "../data")

if __name__ == "__main__":
main()