#from mtc511 import solve_route, load_network, load_stops

arcpy.env.overwriteOutput = True

PROJECT_DIR = "C:/temp/RegionalTransitDatabase/"
STOPS_FILE =  "data/network_analyst.gdb/stops_meeting_headway_criteria"
NETWORK_FILE = "data/TomTom_2015_12_NW.gdb/Routing/Routing_ND"
OUTPUT_GDB = "C:/temp/RegionalTransitDatabase/data/network_output.gdb/"

MXD_PATH = PROJECT_DIR + "network_analyst.mxd"
stop_file_path = PROJECT_DIR + STOPS_FILE
ntwrk_path = PROJECT_DIR + NETWORK_FILE

ntwrk_args = {"network_dataset":ntwrk_path,
              "impedance_attribute":"miles",
              "u_turn_policy":"allow_uturns",
              "restrictions":"'avoid walkways';'driving a public bus'", 
              "accumulators":"miles;minutes", 
              "output_path_shape":"true_lines_without_measures", 
              "use_hierarchy_in_analysis":"true"}

stop_args = {"restrictions" : "'avoid walkways';'driving a public bus'",
            "group_by_fields" : "agency_route_pattern_id", 
            "sort_field" : "stop_sequence",
            "field_mappings": "name agency_route_pattern_id #",
            "solve_succeeded" : "false",
            "child_data_element" : "routes",
            #hhts_trips__2_ = network_analyst_layer,
            "hhts_trips" : "empty_fc",
            "stop_locations" : stop_file_path}

solve_args = {"ignore_invalids":"SKIP",
              "terminate_on_solve_error":"CONTINUE",
              "simplification_tolerance":""}

########################################
#remove whitespace from route pattern string to make 
#it into a more effective id to join with network geoms
########################################
# arcpy.management.AddField(in_table=stop_file_path, 
#   field_name="agency_route_pattern_id", 
#   field_type="TEXT", 
#   field_precision="", 
#   field_scale="", field_length="400", 
#   field_alias="", field_is_nullable="NULLABLE", 
#   field_is_required="NON_REQUIRED", 
#   field_domain="")

# arcpy.management.CalculateField(in_table=stop_file_path, field="agency_route_pattern_id", 
#   expression="remove_spaces(!Agency_Route_Pattern!)", 
#   expression_type="PYTHON_9.3", 
#   code_block="import re\ndef remove_spaces(string):\n    return re.sub('\W','', string)")

#####################
##group by pattern id
#####################
import itertools
groups = [] 

with arcpy.da.SearchCursor(stop_file_path, ["agency_route_pattern_id"]) as cursor:
    for k, g in itertools.groupby(cursor):
        groups.append(list(g))

#there's a better way to do this w/above
unq_groups = [x[0] for x in [y[0] for y in groups]]

for rt_nm in unq_groups[14:15]:
    solve_route(rt_nm, output_gdb=OUTPUT_GDB, **solve_args)


