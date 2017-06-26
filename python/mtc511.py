#todo: move this script/process to a container or service such as lambda
import os
import pickle
from credentials import APIKEY

def get_511_orgs_dict():
    import requests
    import xmltodict
    operator_url = "http://api.511.org/transit/operators?api_key={}&Format=XML".format(APIKEY)
    j = requests.get(url_511)
    d = xmltodict.parse(j.content)
    return d

def get_511_gtfs_zip(private_code, apikey=APIKEY):
	request_url = 'http://api.511.org/transit/datafeeds?api_key={}&operator_id={}'.format(apikey,private_code)	
	return requests.get(request_url, stream=True) #todo: add error handling

def write_511_gtfs_to_disk(r, path):
    import shutil
    if r.status_code == 200:
    	with open(path, 'wb') as f:
    		#r.raw.decode_content = True
    		#todo: unzip to dir
    		shutil.copyfileobj(r.raw, f)

# def validate_511_feed(orgname):
#     org_zip = 'data/gtfs/{}.zip'.format(orgname)
#     with open("python/feedvalidator.py") as f:
#         code = compile(f.read(), "python/feedvalidator.py {}".format(org_zip), 'exec')
#         exec(code, global_vars, local_vars)

#from http://stackoverflow.com/questions/12886768/how-to-unzip-file-in-python-on-all-oses
def unzip(source_filename, dest_dir):
    import zipfile
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
                path = os.path.join(path, word)
            zf.extract(member, path)
