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

#for use in sql server etl:
orgs_textfile = open("orgs.txt","w")
orgs_textfile.write(str(org_acronyms))

#write org acronyms out for use in arcpy/pro
import pickle
with open('org_acroynms.pickle', 'wb') as f:
    pickle.dump(org_acronyms, f) 

def get_511_gtfs_zip(private_code, apikey=APIKEY):
	request_url = 'http://api.511.org/transit/datafeeds?api_key={}&operator_id={}'.format(apikey,private_code)	
	return requests.get(request_url, stream=True) #todo: add error handling

def write_511_gtfs_to_disk(r, path):
	if r.status_code == 200:
		with open(path, 'wb') as f:
			#r.raw.decode_content = True
			#todo: unzip to dir
			shutil.copyfileobj(r.raw, f)

#from http://stackoverflow.com/questions/12886768/how-to-unzip-file-in-python-on-all-oses
def unzip(source_filename, dest_dir):
    with zipfile.ZipFile(source_filename) as zf:
        for member in zf.infolist():
            # Path traversal defense copied from
            # http://hg.python.org/cpython/file/tip/Lib/http/server.py#l789
            words = member.filename.split('/')
            path = dest_dir
            for word in words[:-1]:
                while True:
                    drive, word = os.path.splitdrive(word)
                    head, word = os.path.split(word)
                    if not drive:
                        break
                if word in (os.curdir, os.pardir, ''):
                    continue
                path = os.path.join(path, word)anac
            zf.extract(member, path)

for org in org_acronyms:
	org_zip = 'data/gtfs/{}.zip'.format(org)
	org_path = 'data/gtfs/{}/'.format(org)
	if not os.path.exists(os.path.dirname(org_zip)):
		os.makedirs(os.path.dirname(org_zip))
	r = get_511_gtfs_zip(org)
	write_511_gtfs_to_disk(r, org_zip)
	unzip(org_zip, org_path)

