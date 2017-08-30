from boto.s3.connection import S3Connection
 
from credentials import AWS_KEY, AWS_SECRET
aws_connection = S3Connection(AWS_KEY, AWS_SECRET)
bucket = aws_connection.get_bucket('mtc511gtfs')
for file_key in bucket.list():
    print(file_key.name)

from boto.s3.key import Key
k = Key(bucket)

transfer_filenames = "data/cached/" + df1.pathname

#get from gfx

import pandas as pd 
import shutil
import requests

def get_zip(path):
	return requests.get(path, stream=True) #todo: add error handling

def write_to_disk(r, filename):
    if r.status_code == 200:
    	with open(filename, 'wb') as f:
    		shutil.copyfileobj(r.raw, f)

def download_file_from_gtfsexchange(path,filename):
	strm = get_zip(path)
	write_to_disk(strm,filename)

def main():
	df1 = pd.read_csv('data/cached_gtfs.csv')
	expths = list(df1[df1.source=="gtfs_data_exchange"].pathname)
	filenames = list("data/gtfsexch/" + df1[df1.source=="gtfs_data_exchange"].filename)
	for idx, path in enumerate(expths):
	    download_file_from_gtfsexchange(path,filenames[idx])

def upload_file_from_local(transfer_filename):
	file_handle = open(transfer_filename, 'rb')
	k.key = transfer_filename
	k.set_contents_from_file(file_handle)
	k.make_public()

#global bucket
id, file, opt=data	
transfer_file, bucket_name, s3_key_name, use_rr, make_public = file
# open the wikipedia file
if not s3_key_name:
	s3_key_name = os.path.basename(transfer_file)


sys.stdout.write('Connecting to S3...\n')
conn = boto.connect_s3(AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY)
bucket = conn.get_bucket(bucket_name)
#pprint(dir(bucket))
#print 
#e(0)


