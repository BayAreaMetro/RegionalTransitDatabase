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

if __name__ == "__main__":
	main()