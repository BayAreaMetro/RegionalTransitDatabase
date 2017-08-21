import pickle
import os
from mtc511 import get_511_orgs_dict, get_511_gtfs_zip, get_org_acronyms_from_511, get_zip_from_511

def main():
	d = get_511_orgs_dict()
	org_acronyms = get_org_acronyms_from_511(d)
	get_zip_from_511(org_acronyms, datadir = "../data")

if __name__ == "__main__":
	main()