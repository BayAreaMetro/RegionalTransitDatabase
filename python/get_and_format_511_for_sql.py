from mtc511 import get_511_orgs_dict get_511_gtfs_zip write_511_gtfs_to_disk validate_511_feed unzip

d = get_511_orgs_dict()

orgs_list = d['siri:Siri']['siri:ServiceDelivery']['DataObjectDelivery']['dataObjects']['ResourceFrame']['organisations']['Operator']

org_acronyms = []

for org_acronym in orgs_list:
	org_acronyms.append(org_acronym['PrivateCode'])

#for use in sql server etl:
orgs_textfile = open("orgs.txt","w")
orgs_textfile.write(str(org_acronyms))

#write org acronyms out for use in arcpy/pro
with open('org_acroynms.pickle', 'wb') as f:
    pickle.dump(org_acronyms, f) 

for org in org_acronyms:
	org_zip = 'data/gtfs/{}.zip'.format(org)
	org_path = 'data/gtfs/{}/'.format(org)
	if not os.path.exists(os.path.dirname(org_zip)):
		os.makedirs(os.path.dirname(org_zip))
	r = get_511_gtfs_zip(org)
	write_511_gtfs_to_disk(r, org_zip)
	unzip(org_zip, org_path)
