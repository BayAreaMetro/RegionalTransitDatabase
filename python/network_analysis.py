from mtc511 import solve_route, load_network, load_stops

arcpy.env.overwriteOutput = True

PROJECT_DIR = "C:/temp/RegionalTransitDatabase/"
STOPS_FILE = "data/network_analyst.gdb/stops_meeting_headway_criteria"
NETWORK_FILE = "data/TomTom_2015_12_NW.gdb/Routing/Routing_ND"

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
            "group_by_fields" : "agency_route_id", 
            "sort_field" : "stop_sequence",
            "field_mappings": "name agency_route_id #;routename agency_route_id #",
            "solve_succeeded" : "false",
            "child_data_element" : "routes",
            #hhts_trips__2_ = network_analyst_layer,
            "hhts_trips" : "empty_fc",
            "stop_locations" : stop_file_path}

#####################
##group by pattern id
####################
groups = [] 

with arcpy.da.SearchCursor(stop_file_path, ["Agency_Route_Pattern"]) as cursor:
    for k, g in itertools.groupby(cursor):
        groups.append(list(g))

unq_groups = [x[0] for x in groups]
unq_groups = [x[0] for x in unq_groups]

for rt_nm in unq_groups:
    solve_route(rt_nm)