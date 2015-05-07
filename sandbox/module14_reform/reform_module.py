#!/usr/bin/python

import sys, os, math
import csv


#reads the node positions file and saves the xyz of each node/segment
segs = {}
count = 0
print(sys.argv)
if len(sys.argv) > 1:
    nodefile = sys.argv[1]
else:
    nodefile="node_info.csv"
    
for line in open(nodefile, "r").xreadlines():
   vals = line.rstrip().split(",")
   if len(vals)<6: continue
   seg = vals[0]
   x = float(vals[1])
   y = float(vals[2])
   z = float(vals[3])
   segs[seg] = {"fx":x,"fy":y,"fz":z}

fs = {}
for line in open(nodefile, "r").xreadlines():
   vals = line.rstrip().split(",")
   if len(vals)<6: continue
   pair = 4
   f = vals[0]
   t = vals[pair]
   fs[f + "-" + t] = s = {}
   s["fx"] = segs[f]["fx"]
   s["fy"] = segs[f]["fy"]
   s["fz"] = segs[f]["fz"]
   s["tx"] = segs[t]["fx"]
   s["ty"] = segs[t]["fy"]
   s["tz"] = segs[t]["fz"]
   while pair < len(vals)-2:
      pair+=2
     # f = t    #this line was causing an error. the nodes in a given line are all connecting to the first node, not stringing along each other.
      t = vals[pair]
      fs[f + "-" + t] = s = {}
      s["fx"] = segs[f]["fx"]
      s["fy"] = segs[f]["fy"]
      s["fz"] = segs[f]["fz"]
      s["tx"] = segs[t]["fx"]
      s["ty"] = segs[t]["fy"]
      s["tz"] = segs[t]["fz"]

#print segs

#sys.exit()

module_nodes=["ERA","RIB","IRE","FOG","LAW","GIG","EVE","TAU","OLD","LIE"]
#000 indicates the end of a strip and the start of a new one - e.g. just start at the new one
#module_path=["LIE","TAU","FOG","LAW","EVE","OLD","LIE"]
module_paths=[["LIE","TAU","FOG","RIB","ERA","IRE","GIG","LIE","OLD","TAU","LAW","OLD","FOG","LAW","RIB","IRE","LAW","ERA","GIG","LAW","LIE","EVE","OLD"],["EVE","GIG","EVE","IRE"]]
#module_paths=[['LIE', 'TAU', 'FOG', 'RIB', 'ERA', 'LAW'],
#	 		['EVE', 'GIG', 'LIE', 'EVE', 'LAW', 'GIG'],
#		  	['LAW', 'IRE', 'EVE', 'OLD', 'TAU', 'LAW'],
#			['IRE', 'GIG', 'ERA', 'IRE', 'RIB', 'LAW'], 
#			['OLD', 'LIE', 'LAW', 'OLD', 'FOG', 'LAW']]

# module_paths=[["TAU","LAW","FOG","RIB","ERA","LAW","IRE"],
                # ["OLD","EVE","LAW","OLD","LIE"],
                # ["GIG","LIE","TAU","OLD","LIE"],
                # ["LAW","LIE","EVE","GIG","IRE","ERA"],
                # ["ERA","GIG","LAW","RIB","IRE","EVE"]]
                
# module_paths=[["TAU","LAW","FOG","RIB","ERA","LAW","IRE"],
            # ["OLD","EVE","LAW","OLD","FOG","TAU"], # this one is backwards too
            # ["GIG","LIE","TAU","OLD","LIE"], # this line is backwards
            # ["LAW","LIE","EVE","GIG","IRE","ERA"],
            # ["ERA","GIG","LAW","RIB","IRE","EVE"]]
module_paths=[["TAU","LAW","FOG","RIB","ERA","LAW","IRE"],
            ["TAU","FOG","OLD","LAW","EVE","OLD"],
            ["LIE","OLD","TAU","LIE","GIG"],
            ["LAW","LIE","EVE","GIG","IRE","ERA"],
            ["ERA","GIG","LAW","RIB","IRE","EVE"]]
            
#zeros the coordinate system on the xyz of the first node in the chain
x0=segs[module_paths[0][0]]["fx"]
y0=segs[module_paths[0][0]]["fy"]
z0=segs[module_paths[0][0]]["fz"]

segment_indexes={}
leds=[]
led_distance=0.656168 #60 leds per meter, in inches. Why in tarnation are we using inches?
distance_covered=0
ledpositions=[]
string_start_indexes=[]
minledx=0
minledy=0
minledz=0
maxledx=0
maxledy=0
maxledz=0

#1) the try-except checks the direction of the segment (sometimes they're listed DEF-ABC, sometimes ABC-DEF and I'm going by which way we have the LED strip set up)
#2) for each segment, appends the xyz coordinates of each LED by jumping one LED distance in the direction of the segment and keeps track of the LED count in the index of the ledpositions array
#3) Also records the start and end led indexes of each segment in segment_indexes
#4) Note: It seems that the x coordinates are reversed according to what this looks like in Processing. Not making any code changes for now until we figure out why.

for led_string,module_path in enumerate(module_paths):
   string_start_indexes.append([led_string,len(ledpositions)])
   start=module_path[0]
   for node in module_path[1:]: 
         end=node
         k = start+"-"+end
         k2=end+"-"+start
         segment_index_reversed=False
         try:
            f = fs[k]
            xd = f["tx"] - f["fx"]
            yd = f["ty"] - f["fy"]
            zd = f["tz"] - f["fz"]
            right_direction=k
         except KeyError:
            f = fs[k2]
            fs[k]=f
            segment_index_reversed=True
            xd = f["fx"] - f["tx"]
            yd = f["fy"] - f["ty"]
            zd = f["fz"] - f["tz"]
            right_direction=k2
         segment_indexes[right_direction]=[]
         segment_indexes[right_direction].append(len(ledpositions)+1)
         distance=math.sqrt(math.pow(xd,2)+math.pow(yd,2)+math.pow(zd,2))
         distance_covered+=distance
         divcount=0
         while len(ledpositions)*led_distance<distance_covered:
            if not segment_index_reversed:
               ledx=f["fx"]+divcount*led_distance*xd/distance-x0
               ledy=f["fy"]+divcount*led_distance*yd/distance-y0
               ledz=f["fz"]+divcount*led_distance*zd/distance-z0
            else:
               ledx=f["tx"]-divcount*led_distance*xd/distance-x0
               ledy=f["ty"]-divcount*led_distance*yd/distance-y0
               ledz=f["tz"]-divcount*led_distance*zd/distance-z0
            ledpositions.append([led_string,ledx,ledy,ledz])
            if ledx<minledx:
               minledx=ledx
            if ledy<minledy:
               minledy=ledy
            if ledz<minledz:
               minledz=ledz
            if ledx>maxledx:
               maxledx=ledx
            if ledy>maxledy:
               maxledy=ledy
            if ledy>maxledz:
               maxledz=ledz
            divcount+=1
         segment_indexes[right_direction].append(len(ledpositions))
         start=end
         #ledpositions.append(node)

#outputs the LED positions in xyz to a csv file
with open("led_positions.csv","wb") as f:
   wrtr=csv.writer(f)
   for c,led in enumerate(ledpositions):
      wrtr.writerow([c]+led)
      print c,"-",led


#outputs the string start/end indexes of each LED to a csv file
with open("LED_string_start_indexes.csv","wb") as f:
   wrtr=csv.writer(f)
   for segment in string_start_indexes:
      wrtr.writerow(segment)

#outputs the segment start/end indexes of each LED to a csv file
with open("segment_start_end_indexes.csv","wb") as f:
   wrtr=csv.writer(f)
   for segment in segment_indexes:
      wrtr.writerow([segment]+segment_indexes[segment])

#prints each of the segment start/end LED indexes, just a sanity check
for x in segment_indexes:
   print x,segment_indexes[x]      

#just for reference
print "min x,y,z:",minledx,minledy,minledz
print "max x,y,z:",maxledx,maxledy,maxledz


for k in fs.keys():
   #print k, segs[k]
   #print "beginShape();"
   f = fs[k]
   xd = f["tx"] - f["fx"]
   yd = f["ty"] - f["fy"]
   zd = f["tz"] - f["fz"]

   interp = 15

   xd/=interp;
   yd/=interp;
   zd/=interp;

   for i in range(0,interp):
  #    print f["fx"]+xd*i, ",", f["fy"]+yd*i, ",", f["fz"]+zd*i
     pass
   #print "point(", f["tx"], ",", f["ty"], ",", f["tz"], ");"
   #print "endShape();"


