//Mapping ze brain. 

//Zees veel bee BEEG mezz

//but, beeg mezz zat vorks

import java.io.*;
import java.nio.file.*;
import java.util.*;


//Dis code so ugly it goin out with yo momma.
public Model buildTheBrain() { 
  
  SortedMap<String, List<float[]>> barlists = new TreeMap<String, List<float[]>>();
 // SortedMap<String, Bar> bars = new TreeMap<String, Bar>();
  SortedMap<String, PhysicalBar> physical_bars = new TreeMap<String, PhysicalBar>();
  SortedMap<String, Node> nodes = new TreeMap<String, Node>();
  SortedMap<String, PhysicalNode> physical_nodes = new TreeMap<String, PhysicalNode>();
  SortedMap<String, ArrayList<String>>  bar_trackin = new TreeMap<String, ArrayList<String>>();
  boolean newbar;
  boolean newnode;

  Table pixelmapping = loadTable("pixel_mapping.csv", "header");
  List<float[]> bar_for_this_particular_led;
  Set barnames = new HashSet();
  Set nodenames = new HashSet();
  
  for (TableRow row : pixelmapping.rows()) {
       
      String module_num1 = row.getString("Module1"); //IMPORTANT: This is the module that the bar belongs to
      String module_num2 = row.getString("Module2");
      int pixel_num = row.getInt("Pixel_i");
      String node1 = row.getString("Node1");
      String node2 = row.getString("Node2");
      float x = row.getFloat("X");
      float y = row.getFloat("Y");
      float z = row.getFloat("Z");
      String bar_name=node1+"-"+node2+"-"+module_num1;
      newbar=barnames.add(bar_name);
      if (newbar){
        List<float[]> poince = new ArrayList<float[]>();
        //Bar foo_bar = new Bar(bar_name);
        barlists.put(bar_name,poince);
        ArrayList<String> barstufflist=new ArrayList<String>();
        barstufflist.add(module_num1);
        barstufflist.add(module_num2);
        barstufflist.add(node1);
        barstufflist.add(node2);
        bar_trackin.put(bar_name,barstufflist);
      }
      bar_for_this_particular_led = barlists.get(bar_name);
      float[] point = new float[]{x,y,z};
      bar_for_this_particular_led.add(point);
    }
    for (String barname : barlists.keySet()){

      List<String> node_data = bar_trackin.get(barname);
      String module_num1 = node_data.get(0);
      String module_num2 = node_data.get(1);
      String node1 = node_data.get(2);
      String node2 = node_data.get(3);
      List<String> node_names = new ArrayList<String>();
      node_names.add(node1);
      node_names.add(node2);
      List<String> physical_node_names = new ArrayList<String>();
      physical_node_names.add(node1+"-"+module_num1);
      physical_node_names.add(node1+"-"+module_num2);
      PhysicalBar bar = new PhysicalBar(barname,module_num1,barlists.get(barname),node_names,physical_node_names);
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
    List<String> connected_nodes = Arrays.asList(csv_neighbors.split("_"));
    List<String> connected_bars = Arrays.asList(csv_connected_bars.split("_"));
    List<String> connected_physical_bars = Arrays.asList(csv_connected_physical_bars.split("_"));
    List<String> connected_physical_nodes = Arrays.asList(csv_adjacent_physical_nodes.split("_"));
    
    PhysicalNode nod = new PhysicalNode(node_w_module,modul,x,y,z,connected_nodes,connected_physical_nodes,connected_bars,connected_physical_bars, ground);
    physical_nodes.put(node_w_module,nod);


  }
  
   
/* Probably deprecated 5-28-15 12:18am
  for (String pn : physical_nodes.keySet()){
    PhysicalNode pnode=physical_nodes.get(pn);
    List<String> pbn=pnode.adjacent_physical_bar_names;
    for (String pnnnam : pbn){
      PhysicalBar physical_bar = physical_bars.get(pnnnam);
      pnode.adjacent_physical_bars.add(physical_bar);
    }
    List<String> pnn=pnode.adjacent_physical_node_names;
    for (String pnnnam : pnn){
      PhysicalNode physical_node = physical_nodes.get(pnnnam);
      pnode.adjacent_physical_nodes.add(physical_node);
    }
    physical_nodes.put(pn,pnode);
  }


  for (String pb : physical_bars.keySet()){
    PhysicalBar pbar=physical_bars.get(pb);
    List<String> pbn=pbar.node_names;
    for (String nodenamm : pbn){
      Node nodd = nodes.get(nodenamm);
      pbar.nodes.add(nodd);
    }
    List<String> pnn=pbar.physical_node_names;
    for (String pnnnam : pnn){
      PhysicalNode physical_node = physical_nodes.get(pnnnam);
      pbar.physical_nodes.add(physical_node);
    }
    physical_bars.put(pb,pbar);
  }*/
  return new Model(physical_bars,nodes,physical_nodes);
}
  
  
  
  
  
  
  
  
