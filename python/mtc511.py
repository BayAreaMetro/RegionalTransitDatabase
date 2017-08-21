#todo: move this script/process to a container or service such as lambda
import os
import pickle
import requests
import shutil



    #eventually it would be nice to keep track of the org list and the times we fetch/process data
    #perhaps in a db, using continuous-integration, a la openaddress/machine 
    #write org acronyms 
    # with open('org_acroynms.pickle', 'wb') as f:
    #     pickle.dump(org_acronyms, f) 

def read_gtfs_zip_using_dao(datadir,operator_acronym):
    from gtfslib.dao import Dao
    dao = Dao("postgresql:///gtfs")
    dao.load_gtfs("{}/{}.zip".format(datadir,operator_acronym))
    # for stop in dao.stops():
        # print(stop.stop_name)
    for route in dao.routes():
        print("%s: %d trips" % (route.route_long_name, len(route.trips)))

