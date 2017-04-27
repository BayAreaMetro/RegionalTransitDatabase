import arcpy
import pickle
arcpy.ImportToolbox("C:/temp/RegionalTransitDatabase/esri_rtd17/public-transit-tools/public-transit-tools-master/interpolate-blank-stop-times/InterpolateBlankStopTimes.tbx")

with open('C:/temp/RegionalTransitDatabase/org_acroynms.pickle', 'rb') as f:
	org_acronyms = pickle.load(f)         

failures = []

for org in org_acronyms:
	stop_times_file = "C:/temp/RegionalTransitDatabase/data/gtfs/{}/stop_times.txt".format(org)
	stop_times_temp_db = "C:/temp/RegionalTransitDatabase/data/gtfs/{}/temp_db".format(org)
	try:
  		arcpy.transit.PreprocessStopTimes(stop_times_file, stop_times_temp_db)
  		arcpy.transit.SimpleInterpolation(stop_times_temp_db, stop_times_file)
	except:
		failures.append(org) 
  		pass


	