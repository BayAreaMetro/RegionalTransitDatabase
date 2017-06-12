# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
# The following inputs are layers or table views: "main.rail_and_ferry_buffer_half_mile"
arcpy.FeatureClassToFeatureClass_conversion(in_features="main.rail_and_ferry_buffer_half_mile",
										    out_path="C:/projects/RTD/RegionalTransitDatabase/data/hf_bus_routes_source.gdb",
										    out_name="rail_and_ferry_buffer_half_mile",
										    where_clause="",
										    field_mapping='x "x" true true false 8 Double 8 38 ,First,#,main.rail_and_ferry_buffer_half_mile,x,-1,-1', 
										    config_keyword="")

arcpy.Merge_management(inputs="hfbus_routes_buffer_half_mile;rail_and_ferry_buffer_half_mile;new_bus_projects_buffer_half_mile",
 					   output="C:/projects/RTD/RegionalTransitDatabase/data/hf_bus_routes_source.gdb/tpas_2017_draft1",
 					   field_mappings='geom_Length "geom_Length" true true false 8 Double 0 0 ,First,#,hfbus_routes_buffer_half_mile,geom_Length,-1,-1,new_bus_projects_buffer_half_mile,geom_Length,-1,-1;geom_Area "geom_Area" true true false 8 Double 0 0 ,First,#,hfbus_routes_buffer_half_mile,geom_Area,-1,-1,new_bus_projects_buffer_half_mile,geom_Area,-1,-1;Shape_Length "Shape_Length" false true true 8 Double 0 0 ,First,#,hfbus_routes_buffer_half_mile,Shape_Length,-1,-1,rail_and_ferry_buffer_half_mile,Shape_Length,-1,-1;Shape_Area "Shape_Area" false true true 8 Double 0 0 ,First,#,hfbus_routes_buffer_half_mile,Shape_Area,-1,-1,rail_and_ferry_buffer_half_mile,Shape_Area,-1,-1;x "x" true true false 8 Double 0 0 ,First,#,rail_and_ferry_buffer_half_mile,x,-1,-1,new_bus_projects_buffer_half_mile,x,-1,-1')

arcpy.Merge_management(inputs="rail_and_ferry_buffer_half_mile;new_bus_projects_buffer_half_mile;hfbus_routes_buffer_quarter_mile",
 					   output="C:/projects/RTD/RegionalTransitDatabase/data/hf_bus_routes_source.gdb/tpas_2017_draft1_quarter_mile_bus",
 					   field_mappings='geom_Length "geom_Length" true true false 8 Double 0 0 ,First,#,new_bus_projects_buffer_half_mile,geom_Length,-1,-1,hfbus_routes_buffer_quarter_mile,geom_Length,-1,-1;geom_Area "geom_Area" true true false 8 Double 0 0 ,First,#,new_bus_projects_buffer_half_mile,geom_Area,-1,-1,hfbus_routes_buffer_quarter_mile,geom_Area,-1,-1;Shape_Length "Shape_Length" false true true 8 Double 0 0 ,First,#,rail_and_ferry_buffer_half_mile,Shape_Length,-1,-1;Shape_Area "Shape_Area" false true true 8 Double 0 0 ,First,#,rail_and_ferry_buffer_half_mile,Shape_Area,-1,-1;x "x" true true false 8 Double 0 0 ,First,#,rail_and_ferry_buffer_half_mile,x,-1,-1,new_bus_projects_buffer_half_mile,x,-1,-1')


# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
# The following inputs are layers or table views: "tpas_2017_draft1"
arcpy.Dissolve_management(in_features="tpas_2017_draft1", 
						  out_feature_class="C:/projects/RTD/RegionalTransitDatabase/data/hf_bus_routes_source.gdb/tpas_2017_draft1_dissolve_half_mile", 
 						  dissolve_field="",
 						  statistics_fields="",
 						  multi_part="MULTI_PART",
 						  unsplit_lines="DISSOLVE_LINES")

arcpy.Dissolve_management(in_features="tpas_2017_draft1_quarter_mile_bus", 
						  out_feature_class="C:/projects/RTD/RegionalTransitDatabase/data/hf_bus_routes_source.gdb/tpas_2017_draft1_dissolve_quarter_mile", 
 						  dissolve_field="",
 						  statistics_fields="",
 						  multi_part="MULTI_PART",
 						  unsplit_lines="DISSOLVE_LINES")


arcpy.StageService_server(in_service_definition_draft="C:/Users/tbuckl/AppData/Local/ESRI/Desktop10.5/Staging/My Hosted Services/tpa_2017.sddraft",
 						  out_service_definition="C:/Users/tbuckl/AppData/Local/ESRI/Desktop10.5/Staging/My Hosted Services/tpa_2017.sd")

arcpy.UploadServiceDefinition_server(in_sd_file="C:/Users/tbuckl/AppData/Local/ESRI/Desktop10.5/Staging/My Hosted Services/tpa_2017.sd",
 									 in_server="My Hosted Services",
 									 in_service_name="",
 									 in_cluster="",
 									 in_folder_type="FROM_SERVICE_DEFINITION",
 									 in_folder="",
 									 in_startupType="STARTED",
 									 in_override="OVERRIDE_DEFINITION",
 									 in_my_contents="NO_SHARE_ONLINE",
 									 in_public="PRIVATE",
 									 in_organization="SHARE_ORGANIZATION",
 									 in_groups="") 