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

def load_network(ntwrk_name, **kwargs):
    import arcpy
    print(kwargs["network_dataset"])
    arcpy.MakeRouteLayer_na(kwargs["network_dataset"], ntwrk_name, 
        kwargs["impedance_attribute"], "use_input_order", "preserve_both", 
        "no_timewindows", kwargs["accumulators"], kwargs["u_turn_policy"], 
        kwargs["restrictions"], kwargs["use_hierarchy_in_analysis"], "", kwargs["output_path_shape"], "")
    return ntwrk_name


def load_stops(ntwrk_name,mtcgis_agency_route_pattern,**kwargs):
    import arcpy
    #mtcgis_agency_route_pattern_id is a legacy id that mtc uses to uniquely identify routes and stops
    import re
    route_shortname = re.sub("\W","", mtcgis_agency_route_pattern)
    route_filter = "Agency_Route_Pattern ='" + mtcgis_agency_route_pattern +"'"
    arcpy.MakeFeatureLayer_management(in_features=kwargs["stop_locations"], 
        out_layer=route_shortname, 
        where_clause=route_filter, 
        workspace="")
    arcpy.na.AddLocations(in_network_analysis_layer=ntwrk_name,
                     sub_layer="Stops",
                     in_table=route_shortname,
                     field_mappings=kwargs["field_mappings"],
                     search_tolerance="5000 Meters",
                     sort_field=kwargs["sort_field"],
                     search_criteria="Streets SHAPE;Routing_ND_Junctions NONE",
                     match_type="MATCH_TO_CLOSEST",
                     append="APPEND",
                     snap_to_position_along_network="NO_SNAP",
                     snap_offset="5 Meters",
                     exclude_restricted_elements="INCLUDE",
                     search_query="Streets #;Routing_ND_Junctions #")
    return route_shortname

def solve_route(route_name):
    import arcpy
    import re
    network_name = "N" + re.sub("\W","", route_name)
    load_network(network_name,**ntwrk_args)
    load_stops(network_name, route_name, **stop_args)
    try:
        arcpy.Solve_na(network_name, "SKIP", "TERMINATE", "")
        arcpy.CopyFeatures_management(in_features=network_name + "\Routes", 
                                    out_feature_class="C:/temp/RegionalTransitDatabase/data/network_analyst.gdb/" + network_name, 
                                    config_keyword="", 
                                    spatial_grid_1="0", 
                                    spatial_grid_2="0", 
                                    spatial_grid_3="0")
    except:
        pass

    # arcpy.CopyTraversedSourceFeatures_na(input_network_analysis_layer=network_name, 
    #                                     output_location="C:/temp/RegionalTransitDatabase/data/network_analyst.gdb", 
    #                                     edge_feature_class_name="Edges", 
    #                                     junction_feature_class_name="Junctions", 
    #                                     turn_table_name="Turns")
    # then append the result of the edges table iteratively - need something to map RouteID in edges to Agency_Route_Pattern



