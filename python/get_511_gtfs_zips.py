#todo: move this script/process to a container or service such as lambda
from credentials import APIKEY
import zipfile
import shutil
import os

#using XML instead of JSON because its not clear the JSON endpoint works
operator_url = "http://api.511.org/transit/operators?api_key={}&Format=XML".format(APIKEY)

import requests

j = requests.get(operator_url)

import xmltodict
d = xmltodict.parse(j.content)
orgs_list = d['siri:Siri']['siri:ServiceDelivery']['DataObjectDelivery']['dataObjects']['ResourceFrame']['organisations']['Operator']

org_acronyms = []

for org_acronym in orgs_list:
	org_acronyms.append(org_acronym['PrivateCode'])

def get_511_gtfs_zip(private_code, apikey=APIKEY):
	request_url = 'http://api.511.org/transit/datafeeds?api_key={}&operator_id={}'.format(apikey,private_code)	
	return requests.get(request_url, stream=True) #todo: add error handling

def write_511_gtfs_to_disk(r, path):
	if r.status_code == 200:
		with open(path, 'wb') as f:
			#r.raw.decode_content = True
			#todo: unzip to dir
			shutil.copyfileobj(r.raw, f)

for org in org_acronyms:
	org_path = 'data/gtfs/{}.zip'.format(org)
	if not os.path.exists(os.path.dirname(org_path)):
		os.makedirs(os.path.dirname(org_path))
	r = get_511_gtfs_zip(org)
	write_511_gtfs_to_disk(r, org_path)
