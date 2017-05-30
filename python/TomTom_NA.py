# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
# The following inputs are layers or table views: "Routing_ND"
arcpy.MakeRouteLayer_na(in_network_dataset="Routing_ND", out_network_analysis_layer="Driving a Public Bus", impedance_attribute="Miles", find_best_order="USE_INPUT_ORDER", ordering_type="PRESERVE_BOTH", time_windows="NO_TIMEWINDOWS", accumulate_attribute_name="", UTurn_policy="ALLOW_UTURNS", restriction_attribute_name="'Avoid Unpaved Roads';'Avoid Walkways';'Driving a Public Bus'", hierarchy="USE_HIERARCHY", hierarchy_settings="", output_path_shape="TRUE_LINES_WITHOUT_MEASURES", start_date_time="")
# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script

# The following inputs are layers or table views: "Driving a Public Bus"
arcpy.UpdateAnalysisLayerAttributeParameter_na(in_network_analysis_layer="Driving a Public Bus", parameterized_attribute="Driving a Public Bus", attribute_parameter_name="Restriction Usage", attribute_parameter_value="PREFER_HIGH")

# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
# The following inputs are layers or table views: "Route"
arcpy.Solve_na(in_network_analysis_layer="Route", ignore_invalids="SKIP", terminate_on_solve_error="CONTINUE", simplification_tolerance="", overrides="")
