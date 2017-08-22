#requires a postgres db
#see setup here for mac: https://keita.blog/2016/01/09/homebrew-and-postgresql-9-5/
import pickle
import os
from credentials import APIKEY
import datetime
import requests
from credentials import AWS_KEY, AWS_SECRET
from boto.s3.key import Key
from boto.s3.connection import S3Connection
import pandas as pd
from gtfslib.dao import Dao
import subprocess

working_dir = "/Users/tommtc/Documents/Projects/rtd2/data"
timestamp = datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S')
date = datetime.datetime.now().strftime('%Y.%m.%d')
year = datetime.datetime.now().strftime('%Y')
source = 'mtc511cache'
dbstring = "postgresql:///tmp_gtfs"

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

def export_shapefiles(operator):
	shpexport = ['gtfsrun',dbstring,
	'ShapefileExport',
	'--feed_id={}'.format(operator),
	'--cluster=50',
	'--stopshp=data/{}-stops2.shp'.format(operator),
	'--hopshp=data/{}-hops2.shp'.format(operator)]
	print(subprocess.call(shpexport))

def export_frequencies(operator):
	shpexport = ['gtfsrun',dbstring,
	'Frequencies',
	'--cluster=1',
	'--samename=True',
	'--csv=data/{}-freq.csv'.format(operator)]
	print(subprocess.call(shpexport))

def process_one(org_zip,org):
	operator=org
	s3name = write_511_gtfs_to_s3(org_zip)
	try:
		dao = Dao(dbstring)
		dao.load_gtfs(org_zip,feed_id=operator)
		export_shapefiles(org)
		export_frequencies(dbstring,operator)
		dao.delete_feed(operator)
		processed = 1
	except ZeroDivisionError:
   		processed = 0
	os.remove(org_zip)

	d = {
		"s3name":s3name,
		"processed":processed
	}

	return(d)

def process_org(org, path = "."):
	org_zip = '{}/{}-{}.zip'.format(path,timestamp,org)
	if not os.path.exists(os.path.dirname(org_zip)):
		os.makedirs(os.path.dirname(org_zip))
	if not os.path.exists(org_zip):
		r = get_511_gtfs_zip(org)
		write_511_gtfs_to_disk(r, org_zip)
		if os.path.exists(org_zip):
			d = process_one(org_zip,org)
			return(d)
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
	d = get_511_orgs_dict()
	org_acronyms = get_org_acronyms_from_511(d)
	df = pd.read_csv('data/cached_gtfs.csv')
	for org in org_acronyms:
		print("fetching:" + org)
		d1 = process_org(org)
		d = {'s3pathname': d1['s3path'],
			'operator': org,
			'year': year,
			'date_exported': date,
			'source': source,
			'processed':d1['processed'],
			'filename':os.path.basename(s3path)}
		df = df.append(d,ignore_index=True)
	df.to_csv('data/cached_gtfs.csv')

if __name__ == "__main__":
	main()