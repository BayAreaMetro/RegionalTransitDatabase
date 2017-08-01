#todo: move this script/process to a container or service such as lambda
import os
import pickle
import requests
from credentials import APIKEY

def get_511_orgs_dict():
    import requests
    import xmltodict
    operator_url = "http://api.511.org/transit/operators?api_key={}&Format=XML".format(APIKEY)
    j = requests.get(operator_url)
    d = xmltodict.parse(j.content)
    return d

def get_511_gtfs_zip(private_code, apikey=APIKEY):
	request_url = 'http://api.511.org/transit/datafeeds?api_key={}&operator_id={}'.format(apikey,private_code)	
	return requests.get(request_url, stream=True) #todo: add error handling

def write_511_gtfs_to_disk(r, path):
    import shutil
    if r.status_code == 200:
    	with open(path, 'wb') as f:
    		#r.raw.decode_content = True
    		#todo: unzip to dir
    		shutil.copyfileobj(r.raw, f)

def get_org_acronyms_from_511(dictionary):
    orgs_list = d['siri:Siri']['siri:ServiceDelivery']['DataObjectDelivery']['dataObjects']['ResourceFrame']['organisations']['Operator']
    org_acronyms = []
    for org_acronym in orgs_list:
        org_acronyms.append(org_acronym['PrivateCode'])
    return(org_acronyms)

    #eventually it would be nice to keep track of the org list and the times we fetch/process data
    #perhaps in a db, using continuous-integration, a la openaddress/machine 
    #write org acronyms 
    # with open('org_acroynms.pickle', 'wb') as f:
    #     pickle.dump(org_acronyms, f) 


def get_zip_from_511(org_acronyms, datadir = "../data")
    for org in org_acronyms:
        org_zip = '{}/{}.zip'.format(datadir,org)
        if not os.path.exists(os.path.dirname(org_zip)):
            os.makedirs(os.path.dirname(org_zip))
            r = get_511_gtfs_zip(org)
            write_511_gtfs_to_disk(r, org_zip)

def read_gtfs_zip_using_dao(datadir,operator_acronym):
    from gtfslib.dao import Dao
    dao = Dao("postgresql:///gtfs")
    dao.load_gtfs("{}/{}.zip".format(datadir,operator_acronym))
    # for stop in dao.stops():
        # print(stop.stop_name)
    for route in dao.routes():
        print("%s: %d trips" % (route.route_long_name, len(route.trips)))