#should write out csv like this: to merge with our cached data: 
#filename,year,date_exported,operator,pathname,source
from datetime import datetime
import pandas as pd
import json

def get_dx_metadata(o):
	dataexchange_id = o["dataexchange_id"]
	import requests
	request_url = 'http://www.gtfs-data-exchange.com/api/agency?agency={}'.format(dataexchange_id)	
	r = requests.get(request_url, stream=True) #todo: add error handling
	if r.status_code == 200:
		l3 = r.json()["data"]["datafiles"]
		if l3:
			return [map_to_511_meta(x1,o) for x1 in l3]
	else: 
		return null

def map_to_511_meta(d,o):
	format = "%Y.%m.%d"
	return {"pathname" : d["file_url"],
			"filename" : d["filename"],
			"date_exported" : datetime.fromtimestamp((int(d['date_added']))).strftime(format),
			"year": datetime.fromtimestamp((int(d['date_added']))).year,
			"operator" : o["511_PrivateCode"],
			"source" : "gtfs_data_exchange"}

def main():
	with open('data/511_to_data_exchange.json') as j:
		l1 = json.load(j)
		l2 = [get_dx_metadata(x) for x in l1 if x["dataexchange_id"] != '']
	l3 = sum(l2, [])
	df = pd.DataFrame(l3)
	df = df[['filename','year','date_exported','operator','pathname','source']]
	df1 = pd.read_csv('data/cached_gtfs_only.csv')
	df = df1.append(df)
	df.to_csv('data/cached_gtfs_from_data_exchange.csv')

if __name__ == "__main__":
	main()