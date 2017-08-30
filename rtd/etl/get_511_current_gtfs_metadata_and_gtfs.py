#####
###This script should be tested
###Last time i tried to use it out API key was blocked
#####
import pickle
import os
from credentials import APIKEY
import datetime
import requests
from credentials import AWS_KEY, AWS_SECRET
from boto.s3.key import Key
from boto.s3.connection import S3Connection
import pandas as pd

working_dir = "/Users/tommtc/Documents/Projects/rtd2/data"
timestamp = datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S')
date = datetime.datetime.now().strftime('%Y.%m.%d')
year = datetime.datetime.now().strftime('%Y')
source = 'mtc511cache'

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

def get_org_acronyms_from_511(dictionary):
	orgs_list = dictionary['siri:Siri']['siri:ServiceDelivery']['DataObjectDelivery']['dataObjects']['ResourceFrame']['organisations']['Operator']
	org_acronyms = []
	for org_acronym in orgs_list:
		org_acronyms.append(org_acronym['PrivateCode'])
	return(org_acronyms)

def get_zip_from_511(org, path = "."):
	org_zip = '{}/{}-{}.zip'.format(path,timestamp,org)
	if not os.path.exists(os.path.dirname(org_zip)):
		os.makedirs(os.path.dirname(org_zip))
	if not os.path.exists(org_zip):
		r = get_511_gtfs_zip(org)
		write_511_gtfs_to_disk(r, org_zip)
		if os.path.exists(org_zip):
			s3name = write_511_gtfs_to_s3(org_zip)
			os.remove(org_zip)
			return(s3name)
		else: 
			return("nodata")
			
def write_511_gtfs_to_disk(r, path):
	import shutil
	if r.status_code == 200:
		with open(path, 'wb') as f:
			shutil.copyfileobj(r.raw, f)

def upload_file_from_local_511(transfer_filename,k):
    file_handle = open(transfer_filename, 'rb')
    s3name = "mtc_cache/" + os.path.basename(transfer_filename)
    k.key = s3name
    print("uploading:" + s3name)
    k.set_contents_from_file(file_handle)
    k.make_public()
    return(s3name)

def write_511_gtfs_to_s3(filename):
	aws_connection = S3Connection(AWS_KEY, AWS_SECRET)
	bucket = aws_connection.get_bucket('mtc511gtfs')
	k = Key(bucket)
	s3name = upload_file_from_local_511(filename,k)
	return(s3name)

def main():
	print("this script needs tests--please do not expect it to run without some review")
	d = get_511_orgs_dict()
	org_acronyms = get_org_acronyms_from_511(d)
	df = pd.read_csv('data/cached_gtfs.csv')
	for org in org_acronyms:
		print("fetching:" + org)
		s3path = get_zip_from_511(org)
		d = {'s3pathname': s3path,
			'operator': org,
			'year': year,
			'date_exported': date,
			'source': source,
			'processed':0,
			'filename':os.path.basename(s3path)}
		df = df.append(d,ignore_index=True)
	df.to_csv('data/cached_gtfs_from_511.csv')

if __name__ == "__main__":
	main()