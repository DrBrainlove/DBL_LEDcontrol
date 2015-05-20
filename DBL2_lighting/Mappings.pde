//Mapping ze brain. 

//Zees veel bee BEEG mezz

//but, beeg mezz zat vorks

import java.io.*;
import java.nio.file.*;
import java.util.*;


public Model buildTheBrain() { 
  
  SortedMap<String, List<float[]>> barlists = new TreeMap<String, List<float[]>>();
 // SortedMap<String, Bar> bars = new TreeMap<String, Bar>();
  SortedMap<String, BarWithModuleNum> bars_with_module_nums = new TreeMap<String, BarWithModuleNum>();
  SortedMap<String, Node> nodes = new TreeMap<String, Node>();
  SortedMap<String, NodeWithModuleNum> nodes_with_module_nums = new TreeMap<String, NodeWithModuleNum>();
  
  boolean newbar;
  boolean newnode;

  Table pixelmapping = loadTable("pixel_mapping.csv", "header");
  List<float[]> bar_for_this_particular_led;
  Set barnames = new HashSet();
  Set nodenames = new HashSet();
  
  for (TableRow row : pixelmapping.rows()) {
      
      String module_num = row.getString("Module");
      int pixel_num = row.getInt("Pixel_i");
      String node1 = row.getString("Node1");
      String node2 = row.getString("Node2");
      float x = row.getFloat("X");
      float y = row.getFloat("Y");
      float z = row.getFloat("Z");
      String bar_name=node1+"-"+node2+"-"+module_num;
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
      bars_with_module_nums.put(barname,bar);
      println(barname);
    } 
    
  Table node_csv = loadTable("Model_Node_Info.csv","header");
  

  for (TableRow row : node_csv.rows()) {
    String node = row.getString("Node");
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    float z = row.getFloat("Z");
    String csv_neighbors = row.getString("Neighbor_Nodes");
    String csv_connected_bars = row.getString("Bars");
    String csv_connected_bars_w_mod_nums = row.getString("Bars_with_Module_Nums");
    String csv_neighbors_w_module_nums = row.getString("Nodes_with_Module_Nums");

    //all of those were strings - split by the underscores
    List<String> neighbors = Arrays.asList(csv_neighbors.split("_"));
    List<String> connected_bars = Arrays.asList(csv_connected_bars.split("_"));
    List<String> connected_bars_w_mod_nums = Arrays.asList(csv_connected_bars_w_mod_nums.split("_"));
    List<String> neighbors_w_module_nums = Arrays.asList(csv_neighbors_w_module_nums.split("_"));
    
    Node nod = new Node(node,x,y,z,connected_bars_w_mod_nums,connected_bars,neighbors_w_module_nums); 
    nodes.put(node,nod);
    }

  
  Table node_struct_csv = loadTable("Structural_Node_Info.csv","header");
  
 
  for (TableRow row : node_struct_csv.rows()) {
    String node_w_module = row.getString("Node_with_Module");
    String node = row.getString("Node");
    String modul = row.getString("Module");
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    float z = row.getFloat("Z");
    String csv_neighbors = row.getString("Neighbor_Nodes");
    String csv_connected_bars = row.getString("Bars");
    String csv_connected_bars_w_mod_nums = row.getString("Bars_with_Module_Nums");
    String csv_neighbors_w_module_nums = row.getString("Nodes_with_Module_Nums");
    
    //all of those were strings - split by the underscores
    List<String> neighbors = Arrays.asList(csv_neighbors.split("_"));
    List<String> connected_bars = Arrays.asList(csv_connected_bars.split("_"));
    List<String> connected_bars_w_mod_nums = Arrays.asList(csv_connected_bars_w_mod_nums.split("_"));
    List<String> neighbors_w_module_nums = Arrays.asList(csv_neighbors_w_module_nums.split("_"));
    
    NodeWithModuleNum nod = new NodeWithModuleNum(node_w_module,modul,x,y,z,connected_bars,connected_bars_w_mod_nums);
    nodes_with_module_nums.put(node_w_module,nod);

     }
  return new Model(bars_with_module_nums,nodes,nodes_with_module_nums);
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
