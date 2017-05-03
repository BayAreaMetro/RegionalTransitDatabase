import chardet

file1 = 'C:/temp/RegionalTransitDatabase/data/gtfs/AC/routes.txt'
file2 = 'C:/temp/RegionalTransitDatabase/data/gtfs/routes.csv'

csvfile = open(file1,'rb').read()
result = chardet.detect(csvfile)
print(result)

csvfile = open(file2,'rb').read()
result = chardet.detect(csvfile)
print(result)