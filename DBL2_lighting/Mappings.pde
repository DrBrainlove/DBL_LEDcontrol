//Mapping ze brain. 

//Zees veel bee BEEG mezz

//but, beeg mezz zat vorks

import java.io.*;
import java.nio.file.*;
import java.util.*;


public Model buildTheBrain() { 
  
  SortedMap<String, List<float[]>> barlists = new TreeMap<String, List<float[]>>();
  SortedMap<String, BarWithModuleNum> bars = new TreeMap<String, BarWithModuleNum>();
  
  boolean newbar;

  Table nodexyzs = loadTable("pixel_mapping.csv", "header");
  List<float[]> bar_for_this_particular_led;
  Set barnames = new HashSet();
  
  for (TableRow row : nodexyzs.rows()) {
      
      String module_num = row.getString("Module");
      int pixel_num = row.getInt("Pixel_i");
      String node1 = row.getString("Node1");
      String node2 = row.getString("Node2");
      float x = row.getFloat("X");
      float y = row.getFloat("Y");
      float z = row.getFloat("Z");
      String bar_name=node1+node2+"_"+module_num;
      newbar=barnames.add(bar_name);
      if (newbar){
        List<float[]> poince = new ArrayList<float[]>();
        //Bar foo_bar = new Bar(bar_name);
        barlists.put(bar_name,poince);
      }
      bar_for_this_particular_led = barlists.get(bar_name);
      float[] point = new float[]{x,y,z};
      bar_for_this_particular_led.add(point);
      }
    for (String barname : barlists.keySet()){
      BarWithModuleNum bar = new BarWithModuleNum(barname,barlists.get(barname));
      bars.put(barname,bar);
      println(barname);
    } 
  return new Model(bars);
  }
