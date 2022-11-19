import csv
import math
import cv2
import sqlite3

import geopy.distance
import random





def pointWithinRadius(longitude, latitude, radius): 
    x0 = longitude;
    y0 = latitude;
    rd = radius / 111300;

    u = random.uniform(0, 1);
    v = random.uniform(0, 1);

    w = rd * math.sqrt(u);
    t = 2 * math.pi * v;
    x = w * math.cos(t);
    y = w * math.sin(t);

    return (x+x0, y+y0)


def generator():
    longitude = 11.61430161647961
    latitude = 48.111355593621
    for i in range(0, 5):
        
        fst,snd = pointWithinRadius(longitude, latitude, 1500)
        coords_1 = (snd, fst)
        coords_2 = (latitude, latitude)

        print(geopy.distance.geodesic(coords_1, coords_2).m)




con = sqlite3.connect("app.db", check_same_thread=False)

cur = con.cursor()

# read csv into rows list
with open('issues.csv', 'r', encoding='utf-8') as csv_file:
    reader = csv.reader(csv_file)
    columns = next(reader) # this gets the columns in the first line as list of strings
    assert(columns == ['image_id','longitude','latitude','osm_way_id','highway']) # check that the columns are as expected

    rows = []
    for image_id, lon, lat, id, highway in reader:
        rows.append([lon,lat])

    # rows [lon,lat] 
    rowsDB = rows[:24]
    rowsHidden = rows[24:]
        


issueId = 0

# insert each row into DB
for lon, lat in rowsDB:
    cur.execute("INSERT INTO openIssues VALUES (?,?,?,0.0,0.0,0.0)", (issueId, lon, lat ))
    issueId += 1


for lon, lat in rowsHidden:
    lon, lat = float(lon), float(lat)
    (showLon, showLat) = pointWithinRadius(lon, lat, 1000)
    cur.execute("INSERT INTO openIssues VALUES (?,?,?,?,?,?)", (issueId, str(lon), str(lat), 1000.0, str(showLon), str(showLat)))
    issueId += 1
    
