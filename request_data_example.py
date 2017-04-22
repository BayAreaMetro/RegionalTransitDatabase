from credentials import APIKEY
#using XML instead of JSON because its not clear the JSON endpoint works
operator_url = "http://api.511.org/transit/operators?api_key={}&Format=XML".format(APIKEY)

import requests

j = requests.get(operator_url)

import xmltodict
xmltodict.parse(j.content)
orgs_list = d['siri:Siri']['siri:ServiceDelivery']['DataObjectDelivery']['dataObjects']['ResourceFrame']['organisations']['Operator']

org_acronyms = []

for org_acronym in orgs_list:
	org_acronyms.append(org_acronym['PrivateCode'])

for org in org_acronyms:
	request_url = 'http://api.511.org/transit/datafeeds?api_key={}&operator_id={}'.format(APIKEY,org)	
	#to do: handle response