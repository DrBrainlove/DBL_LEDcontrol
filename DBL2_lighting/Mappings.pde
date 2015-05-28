//Mapping ze brain. 

//Zees veel bee BEEG mezz

//but, beeg mezz zat vorks

import java.io.*;
import java.nio.file.*;
import java.util.*;


public Model buildTheBrain() { 
  
  SortedMap<String, List<float[]>> barlists = new TreeMap<String, List<float[]>>();
 // SortedMap<String, Bar> bars = new TreeMap<String, Bar>();
  SortedMap<String, PhysicalBar> physical_bars = new TreeMap<String, PhysicalBar>();
  SortedMap<String, Node> nodes = new TreeMap<String, Node>();
  SortedMap<String, PhysicalNode> physical_nodes = new TreeMap<String, PhysicalNode>();
  
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
      PhysicalBar bar = new PhysicalBar(barname,barlists.get(barname));
      physical_bars.put(barname,bar);
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
    String csv_connected_physical_bars = row.getString("Physical_Bars");
    String csv_adjacent_physical_nodes = row.getString("Physical_Nodes");
    boolean ground;
    String groundstr = row.getString("Ground");
    if (groundstr.equals("1")){
      ground=true;
    }
    else{
      ground=false;
    } 

    //all of those were strings - split by the underscores
    List<String> neighbors = Arrays.asList(csv_neighbors.split("_"));
    List<String> connected_bars = Arrays.asList(csv_connected_bars.split("_"));
    List<String> connected_physical_bars = Arrays.asList(csv_connected_physical_bars.split("_"));
    List<String> adjacent_physical_nodes = Arrays.asList(csv_adjacent_physical_nodes.split("_"));
    
    Node nod = new Node(node,x,y,z,connected_physical_bars,connected_bars,adjacent_physical_nodes, ground); 
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
    String csv_connected_physical_bars = row.getString("Physical_Bars");
    String csv_adjacent_physical_nodes = row.getString("Physical_Nodes");
    boolean ground;
    String groundstr = row.getString("Ground");
    if (groundstr.equals("1")){
      ground=true;
    }
    else{
      ground=false;
    } 
    
    //all of those were strings - split by the underscores
    List<String> neighbors = Arrays.asList(csv_neighbors.split("_"));
    List<String> connected_bars = Arrays.asList(csv_connected_bars.split("_"));
    List<String> connected_physical_bars = Arrays.asList(csv_connected_physical_bars.split("_"));
    List<String> adjacent_physical_nodes = Arrays.asList(csv_adjacent_physical_nodes.split("_"));
    
    PhysicalNode nod = new PhysicalNode(node_w_module,modul,x,y,z,connected_bars,connected_physical_bars, ground);
    physical_nodes.put(node_w_module,nod);

  }
  return new Model(physical_bars,nodes,physical_nodes);
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
