#Document and Publish Data Sources to AGOL
##Need to do this still

##Define Input Variables for this script so that 

#Select Existing and Planned Stops for Buffers
arcpy.management.MakeFeatureLayer(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Non_Bus_Eligible_Stops_2017", "TPA_Eligible_Stops", "TPA_Eligible = 1", None, "OBJECTID OBJECTID VISIBLE NONE;Shape Shape VISIBLE NONE;agency_id agency_id HIDDEN NONE;agency_name agency_name VISIBLE NONE;route_id route_id VISIBLE NONE;agency_stop_id agency_stop_id HIDDEN NONE;stop_name stop_name VISIBLE NONE;status status VISIBLE NONE;system system VISIBLE NONE;Avg_Weekday_AM_Headway Avg_Weekday_AM_Headway HIDDEN NONE;Avg_Weekday_PM_Headway Avg_Weekday_PM_Headway HIDDEN NONE;Delete_Stop Delete_Stop HIDDEN NONE;TPA_Eligible TPA_Eligible HIDDEN NONE;Stop_Description Stop_Description HIDDEN NONE;Project_Description Project_Description HIDDEN NONE;Distance_Eligible Distance_Eligible HIDDEN NONE;Buffer_Distance Buffer_Distance HIDDEN NONE")
#Apply Symbology to Layer
arcpy.management.ApplySymbologyFromLayer("TPA_Eligible_Stops", "TPA_Non_Bus_Eligible_Stops_2017", "VALUE_FIELD system system")

#Buffer Rail, Ferry, Light Rail, Cable Car and BRT Stops
arcpy.analysis.Buffer("TPA_Eligible_Stops", r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Temp_Buffers", ".5 Miles", "FULL", "ROUND", "LIST", "system", "PLANAR")

#Add and Calculate Classify Field to each Buffer
arcpy.management.AddField("TPA_Temp_Buffers", "Rail_HM", "LONG", None, None, None, "Rail HM Buffer", "NULLABLE", "NON_REQUIRED", "Status")
arcpy.management.SelectLayerByAttribute("TPA_Temp_Buffers", "NEW_SELECTION", "system = 'Rail'", None)
arcpy.management.CalculateField("TPA_Temp_Buffers", "Rail_HM", 1, "PYTHON_9.3", None)

arcpy.management.AddField("TPA_Temp_Buffers", "Light_Rail_HM", "LONG", None, None, None, "Light Rail HM Buffer", "NULLABLE", "NON_REQUIRED", "Status")
arcpy.management.SelectLayerByAttribute("TPA_Temp_Buffers", "NEW_SELECTION", "system = 'Light Rail'", None)
arcpy.management.CalculateField("TPA_Temp_Buffers", "Light_Rail_HM", 1, "PYTHON_9.3", None)

arcpy.management.AddField("TPA_Temp_Buffers", "Ferry_HM", "LONG", None, None, None, "Ferry HM Buffer", "NULLABLE", "NON_REQUIRED", "Status")
arcpy.management.SelectLayerByAttribute("TPA_Temp_Buffers", "NEW_SELECTION", "system = 'Ferry'", None)
arcpy.management.CalculateField("TPA_Temp_Buffers", "Ferry_HM", 1, "PYTHON_9.3", None)

arcpy.management.AddField("TPA_Temp_Buffers", "BRT_HM", "LONG", None, None, None, "BRT HM Buffer", "NULLABLE", "NON_REQUIRED", "Status")
arcpy.management.SelectLayerByAttribute("TPA_Temp_Buffers", "NEW_SELECTION", "system = 'Bus Rapid Transit'", None)
arcpy.management.CalculateField("TPA_Temp_Buffers", "BRT_HM", 1, "PYTHON_9.3", None)

arcpy.management.AddField("TPA_Temp_Buffers", "CC_HM", "LONG", None, None, None, "Cable Car HM Buffer", "NULLABLE", "NON_REQUIRED", "Status")
arcpy.management.SelectLayerByAttribute("TPA_Temp_Buffers", "NEW_SELECTION", "system = 'Cable Car'", None)
arcpy.management.CalculateField("TPA_Temp_Buffers", "CC_HM", 1, "PYTHON_9.3", None)

#Separate Layers Based Upon Transit System
arcpy.management.MakeFeatureLayer(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Temp_Buffers", "TPA_Rail_Buffer_HM", "system = 'Rail'", None, "OBJECTID OBJECTID VISIBLE NONE;Shape Shape VISIBLE NONE;system system VISIBLE NONE;Shape_Length Shape_Length HIDDEN NONE;Shape_Area Shape_Area HIDDEN NONE;BRT_HM BRT_HM HIDDEN NONE;Light_Rail_HM Light_Rail_HM HIDDEN NONE;Ferry_HM Ferry_HM HIDDEN NONE;Rail_HM Rail_HM VISIBLE NONE;CC_HM CC_HM HIDDEN NONE")
arcpy.management.MakeFeatureLayer(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Temp_Buffers", "TPA_Ferry_Buffer_HM", "system = 'Ferry'", None, "OBJECTID OBJECTID VISIBLE NONE;Shape Shape VISIBLE NONE;system system VISIBLE NONE;Shape_Length Shape_Length HIDDEN NONE;Shape_Area Shape_Area HIDDEN NONE;BRT_HM BRT_HM HIDDEN NONE;Light_Rail_HM Light_Rail_HM HIDDEN NONE;Ferry_HM Ferry_HM VISIBLE NONE;Rail_HM Rail_HM HIDDEN NONE;CC_HM CC_HM HIDDEN NONE")
arcpy.management.MakeFeatureLayer(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Temp_Buffers", "TPA_Light_Rail_Buffer_HM", "system = 'Light Rail'", None, "OBJECTID OBJECTID VISIBLE NONE;Shape Shape VISIBLE NONE;system system VISIBLE NONE;Shape_Length Shape_Length HIDDEN NONE;Shape_Area Shape_Area HIDDEN NONE;BRT_HM BRT_HM HIDDEN NONE;Light_Rail_HM Light_Rail_HM VISIBLE NONE;Ferry_HM Ferry_HM HIDDEN NONE;Rail_HM Rail_HM HIDDEN NONE;CC_HM CC_HM HIDDEN NONE")
arcpy.management.MakeFeatureLayer(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Temp_Buffers", "TPA_Cable_Car_Buffer_HM", "system = 'Cable Car'", None, "OBJECTID OBJECTID VISIBLE NONE;Shape Shape VISIBLE NONE;system system VISIBLE NONE;Shape_Length Shape_Length HIDDEN NONE;Shape_Area Shape_Area HIDDEN NONE;BRT_HM BRT_HM HIDDEN NONE;Light_Rail_HM Light_Rail_HM HIDDEN NONE;Ferry_HM Ferry_HM HIDDEN NONE;Rail_HM Rail_HM HIDDEN NONE;CC_HM CC_HM VISIBLE NONE")
arcpy.management.MakeFeatureLayer(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Temp_Buffers", "TPA_BRT_Buffer_HM", "system = 'Bus Rapid Transit'", None, "OBJECTID OBJECTID VISIBLE NONE;Shape Shape VISIBLE NONE;system system VISIBLE NONE;Shape_Length Shape_Length HIDDEN NONE;Shape_Area Shape_Area HIDDEN NONE;BRT_HM BRT_HM VISIBLE NONE;Light_Rail_HM Light_Rail_HM HIDDEN NONE;Ferry_HM Ferry_HM HIDDEN NONE;Rail_HM Rail_HM HIDDEN NONE;CC_HM CC_HM HIDDEN NONE")

#Identity Commands --- Puts it all together

#Process First Overlay
arcpy.analysis.Identity("Counties_Shoreline_Clipped", "TPA_Rail_Buffer_HM", r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_1", "ALL", None, "NO_RELATIONSHIPS")

#Process Next Overlay
arcpy.analysis.Identity("TPA_Overlay_1", "TPA_Ferry_Buffer_HM", r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_2", "ALL", None, "NO_RELATIONSHIPS")
#Delete Previous Overlay
arcpy.management.Delete(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_1", None)

#Process next Overlay
arcpy.analysis.Identity("TPA_Overlay_2", "TPA_Light_Rail_Buffer_HM", r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_3", "ALL", None, "NO_RELATIONSHIPS")
#Delete Previous Overlay
arcpy.management.Delete(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_2", None)

#Process next Overlay
arcpy.analysis.Identity("TPA_Overlay_3", "TPA_Cable_Car_Buffer_HM", r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_4", "ALL", None, "NO_RELATIONSHIPS")
#Delete Previous Overlay
arcpy.management.Delete(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_3", None)

#Process next Overlay
arcpy.analysis.Identity("TPA_Overlay_4", "TPA_BRT_Buffer_HM", r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_5", "ALL", None, "NO_RELATIONSHIPS")
#Delete Previous Overlay
arcpy.management.Delete(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_4", None)

#Process next Overlay
arcpy.analysis.Identity("TPA_Overlay_5", "TPA_BRT_GENEVA_QM_Buffer", r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_6", "ALL", None, "NO_RELATIONSHIPS")
#Delete Previous Overlay
arcpy.management.Delete(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_5", None)

#Process next Overlay
arcpy.analysis.Identity("TPA_Overlay_6", "TPA_Bus_Routes_QM_Buffer_DISS", r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_7", "ALL", None, "NO_RELATIONSHIPS")
#Delete Previous Overlay
arcpy.management.Delete(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_6", None)

#Process next Overlay
arcpy.analysis.Identity("TPA_Overlay_7", "TPA_Bus_HM_Buffer_Meets_Distance_Threshold", r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\Draft_TPAs_2017_Rev6", "ALL", None, "NO_RELATIONSHIPS")
#Delete Previous Overlay
arcpy.management.Delete(r"f:\Active\Keareys Working\_Section\Planning\TPAs\TPA Analysis 2017.gdb\TPA_Overlay_7", None)

#Cleanup Fields
arcpy.management.DeleteField("Draft_TPAs_2017_Rev6", "FID_TPA_HM_Buffer_Meets_Distance_Threshold;FID_TPA_Overlay_7;FID_TPA_Overlay_6;FID_TPA_Overlay_5;FID_TPA_Overlay_4;FID_TPA_Overlay_3;FID_TPA_Overlay_2;FID_TPA_Overlay_1;FID_Counties_Shoreline_Clipped;FID_TPA_Temp_Buffers;system;system_1;FID_TPA_Temp_Buffers_1;FID_TPA_Temp_Buffers_12;system_12;FID_TPA_Temp_Buffers_12_13;system_12_13;FID_TPA_Temp_Buffers_12_13_14;system_12_13_14;FID_TPA_BRT_GENEVA_QM_Buffer;FID_TPA_Bus_Routes_QM_Buffer_DISS;FID_TPA_Bus_Routes_HM_Buffer_DISS")

#Add Overlay Total Field and Sum Results
arcpy.management.AddField("Draft_TPAs_2017_Rev6", "Map_Class", "LONG", None, None, None, "Total Overlays", "NULLABLE", "NON_REQUIRED", None)
arcpy.management.CalculateField("Draft_TPAs_2017_Rev6", "Map_Class", "!HF_BUS_HM!+!Bus_Routes_QM!+!Rail_HM!+!Ferry_HM!+!Light_Rail_HM!+!BRT_HM!+!BRT_QM!+!CC_HM!", "PYTHON_9.3", None)

#Remove Non TPA Areas from Dataset
arcpy.management.MakeFeatureLayer("Draft_TPAs_2017_Rev6", "Draft_TPAs_2017_Rev6_Layer", "Map_Class=0", None, "OBJECTID OBJECTID VISIBLE NONE;Shape Shape VISIBLE NONE;COUNTYNAME COUNTYNAME VISIBLE NONE;CountyFIP CountyFIP VISIBLE NONE;Rail_HM Rail_HM VISIBLE NONE;Ferry_HM Ferry_HM VISIBLE NONE;Light_Rail_HM Light_Rail_HM VISIBLE NONE;CC_HM CC_HM VISIBLE NONE;BRT_HM BRT_HM VISIBLE NONE;BRT_QM BRT_QM VISIBLE NONE;Bus_Routes_QM Bus_Routes_QM VISIBLE NONE;HF_BUS_HM HF_BUS_HM VISIBLE NONE;Shape_Length Shape_Length VISIBLE NONE;Shape_Area Shape_Area VISIBLE NONE;Map_Class Map_Class VISIBLE NONE")
arcpy.management.DeleteFeatures("Draft_TPAs_2017_Rev6_Layer")
arcpy.management.Delete("Draft_TPAs_2017_Rev6_Layer", None)
arcpy.management.Delete("TPA_Eligible_Stops", None)
arcpy.management.Delete("TPA_Temp_Buffers")
#Apply Map Layer Style
arcpy.management.ApplySymbologyFromLayer("Draft_TPAs_2017_Rev4", "Draft_TPAs_2017_Rev2", "VALUE_FIELD Map_Class Map_Class")