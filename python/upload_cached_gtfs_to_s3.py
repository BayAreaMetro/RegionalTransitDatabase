from boto.s3.connection import S3Connection
from credentials import AWS_KEY, AWS_SECRET
import pandas as pd 
import shutil
import requests


def upload_file_from_local(transfer_filename,k):
	file_handle = open(transfer_filename, 'rb')
	k.key = transfer_filename
	print("uploading:" + transfer_filename)
	k.set_contents_from_file(file_handle)
	k.make_public()

def main():
	df1 = pd.read_csv('data/cached_gtfs.csv')
	aws_connection = S3Connection(AWS_KEY, AWS_SECRET)
	bucket = aws_connection.get_bucket('mtc511gtfs')
	for file_key in bucket.list():
	    print(file_key.name)
	from boto.s3.key import Key
	k = Key(bucket)
	transfer_filenames1 = list("data/cached/" + df1[df1.source=="mtc"].pathname)
	for filename in transfer_filenames1:
		upload_file_from_local(filename,k)
	transfer_filenames2 = list("data/gtfsexch/" + df1[df1.source=="gtfs_data_exchange"].filename)
	for filename in transfer_filenames2:
		upload_file_from_local(filename,k)

if __name__ == "__main__":
	main()