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


def get_511_operators_dict():
	import requests
	import xmltodict
	operator_url = "http://api.511.operator/transit/operators?api_key={}&Format=XML".format(APIKEY)
	j = requests.get(operator_url)
	d = xmltodict.parse(j.content)
	return d

def get_511_gtfs_zip(private_code, apikey=APIKEY):
	request_url = 'http://api.511.operator/transit/datafeeds?api_key={}&operator_id={}'.format(apikey,private_code)	
	return requests.get(request_url, stream=True) #todo: add error handling

def get_cached_gtfs_zip(url):
	return requests.get(url, stream=True)

def get_operator_acronyms_from_511(dictionary):
	operators_list = dictionary['siri:Siri']['siri:ServiceDelivery']['DataObjectDelivery']['dataObjects']['ResourceFrame']['operatoranisations']['Operator']
	operator_acronyms = []
	for operator_acronym in operators_list:
		operator_acronyms.append(operator_acronym['PrivateCode'])
	return(operator_acronyms)

def shp_to_js(shapefile_path):
	import fiona
	import fiona.crs
	geojson_path = shapefile_path.replace('.shp','.geojson')
	with fiona.drivers():
		with fiona.open(shapefile_path) as source:
			meta = source.meta
			meta['driver'] = 'GeoJSON'
			meta['crs'] = fiona.crs.from_epsg(4326)
			with fiona.open(geojson_path, 'w', **meta) as sink:
					for f in source:
					   sink.write(f)
	return geojson_path


def export_shapefiles(operator, filename):
	filename1 = '{}-stops.shp'.format(filename)
	filename2 = '{}-hops.shp'.format(filename)
	shpexport = ['gtfsrun',dbstring,
	'ShapefileExport',
	'--feed_id={}'.format(operator),
	'--cluster=50',
	'--stopshp={}'.format(filename1),
	'--hopshp={}'.format(filename2)]
	print(subprocess.call(shpexport))
	if os.path.exists(filename1):
		filename1 = filename1
		filename1 = shp_to_js(filename1)
	else:
		filename1 = False
	if os.path.exists(filename2):
		filename2 = filename2
		filename2 = shp_to_js(filename2)
	else:
		filename2 = False
	return({'stopsfile':filename1,'hopsfile':filename2})

def export_frequencies(operator, filename_freq):
	filename_freq1 = '{}-freq.csv'.format(filename_freq)
	freqexport = ['gtfsrun',dbstring,
	'Frequencies',
	'--cluster=50',
	'--samename=True',
	'--csv=data/{}'.format(filename_freq1)]
	print(subprocess.call(freqexport))
	if os.path.exists(filename_freq1):
		return(filename_freq1)
	else:
		return(False)

def process_one(dao,operator_zip,operator):
	s3dict = {}
	try:
		dao.load_gtfs(operator_zip,feed_id=operator)
		print("loaded to db")
	except Exception as e:
		print(e)
		try:
			try: 
				dao = Dao(dbstring)
			except: 
				next
			dao.delete_feed(operator)
		except:
			next
	try:
		operator_filename = '{}/{}-{}'.format(working_dir,timestamp,operator)
		filedict = export_shapefiles(operator,operator_filename)
		filedict["frequencies"] = export_frequencies(operator,operator_filename)
		dao.delete_feed(operator)
		s3dict = {key:write_to_s3(value) if value else "na"
					for key, value 
					in filedict.items()}
		s3dict["s3pathname"] = ""
		s3dict["processed"] = 1
	except Exception as e:
		try: 
			try: 
				dao = Dao(dbstring), 
			except: 
				next
			dao.delete_feed(operator)
		except:
			next
		print(e)
		s3dict = {"processed":0}
		s3dict["frequencies"] = ""
		s3dict["stopsfile"] = ""
		s3dict["hopsfile"] = ""
		s3dict["s3pathname"] = ""
	try:
		dao.delete_feed(operator)
	except:
		next
	return(s3dict)

def process_operator(dao,operator, url, path = "."):
	operator_zip = '{}/{}-{}.zip'.format(path,timestamp,operator)
	if not os.path.exists(os.path.dirname(operator_zip)):
		os.makedirs(os.path.dirname(operator_zip))
	if not os.path.exists(operator_zip):
		r = get_cached_gtfs_zip(url)
		write_zip_to_disk(r, operator_zip)
		if os.path.exists(operator_zip):
			d = process_one(dao,operator_zip,operator)
			return(d)
		else: 
			return("nodata")
			
def write_zip_to_disk(r, path):
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

def write_to_s3(filename):
	print("writing to s3:" + filename)
	try:
		aws_connection = S3Connection(AWS_KEY, AWS_SECRET)
		bucket = aws_connection.get_bucket('mtc511gtfs')
		k = Key(bucket)
		s3name = upload_file_from_local_511(filename,k)
	except Exception as e:
		print(e)
		s3name = "na"
	return(s3name)

def main():
#	d = get_511_operators_dict()
#	operator_acronyms = get_operator_acronyms_from_511(d)
	df = pd.read_csv('data/cached_gtfs.csv')
	df["frequencies"] = ""
	df["stopsfile"] = ""
	df["hopsfile"] = ""
	operator_urls = list(df.s3pathname)
	operator_names = list(df.operator)
	dao = Dao(dbstring)
	for idx, url in enumerate(operator_urls):
		operator = operator_names[idx]
		print("fetching:" + operator)
		d1 = process_operator(dao, operator, url)
		print(d1)
		if len(d1)>0:
			d = {'s3pathname': "https://s3-us-west-2.amazonaws.com/mtc511gtfs/"+d1['s3pathname'],
				'frequencies': d1['frequencies'],
				'stopsfile': d1['stopsfile'],
				'hopsfile': d1['hopsfile'],
				'operator': operator,
				'year': year,
				'date_exported': date,
				'source': source,
				'processed':d1['processed'],
				'filename':os.path.basename(d1['s3pathname'])}
			df = df.append(d,ignore_index=True)
		else:
			next
	df.to_csv('data/cached_gtfs2.csv')

if __name__ == "__main__":
	main()