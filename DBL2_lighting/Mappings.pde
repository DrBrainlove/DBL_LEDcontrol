//Mapping ze brain. 

//Zees veel bee BEEG mezz

//but, beeg mezz zat vorks

import java.io.*;
import java.nio.file.*;
import java.util.*;


//Dis code so ugly it hang out with yo momma.
public Model buildTheBrain() { 
  
  SortedMap<String, List<float[]>> barlists = new TreeMap<String, List<float[]>>();
  SortedMap<String, Bar> bars = new TreeMap<String, Bar>();
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
      physical_node_names.add(node2+"-"+module_num2);

      PhysicalBar physicalbar = new PhysicalBar(barname,module_num1,barlists.get(barname),node_names,physical_node_names);
      physical_bars.put(barname,physicalbar);
    } 
    
  Table node_csv = loadTable("Model_Node_Info.csv","header");
  

  for (TableRow row : node_csv.rows()) {
    String node = row.getString("Node");
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    float z = row.getFloat("Z");
    String csv_subnodes = row.getString("Subnodes");
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
    List<String> subnodes = Arrays.asList(csv_subnodes.split("_"));
    List<String> neighbors = Arrays.asList(csv_neighbors.split("_"));
    List<String> connected_bars = Arrays.asList(csv_connected_bars.split("_"));
    List<String> connected_physical_bars = Arrays.asList(csv_connected_physical_bars.split("_"));
    List<String> adjacent_physical_nodes = Arrays.asList(csv_adjacent_physical_nodes.split("_"));
    
    Node nod = new Node(node,x,y,z,connected_physical_bars,connected_bars, neighbors, adjacent_physical_nodes,subnodes, ground); 
    //public Node(String id, float x, float y, float z, List<String> adjacent_physical_bar_names, List<String> adjacent_bar_names, List<String> adjacent_node_names, List<String> adjacent_physical_node_names, boolean ground){
  
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


  for (String pbs : physical_bars.keySet()){
    PhysicalBar pb = physical_bars.get(pbs);
    List<String> nns = pb.node_names;
    List<String> pnns = pb.physical_node_names;
    for (String nn : nns){
      Node nnooddee = nodes.get(nn);
      pb.nodes.add(nnooddee);
    }
    float pbxmin=10000;
    float pbymin=10000;
    float pbzmin=10000;
    float pbxmax=-10000;
    float pbymax=-10000;
    float pbzmax=-10000;
    for (String pnn : pnns){
      PhysicalNode pnnooddee = physical_nodes.get(pnn);
      if (pnnooddee.x<pbxmin){
        pbxmin=pnnooddee.x;
      }
      if (pnnooddee.y<pbymin){
        pbymin=pnnooddee.y;
      }
      if (pnnooddee.z<pbzmin){
        pbzmin=pnnooddee.z;
      }
      if (pnnooddee.x>pbxmax){
        pbxmax=pnnooddee.x;
      }
      if (pnnooddee.y>pbymax){
        pbymax=pnnooddee.y;
      }
      if (pnnooddee.z>pbzmax){
        pbzmax=pnnooddee.z;
      }
      pb.physical_nodes.add(pnnooddee);
    }
    pb.min_x=pbxmin;
    pb.min_y=pbymin;
    pb.min_z=pbzmin;
    pb.min_x=pbxmax;
    pb.min_y=pbymax;
    pb.min_z=pbzmax;
    physical_bars.put(pbs,pb);
    String regular_bar_name = pb.bar_name;

  }


  Table bars_csv = loadTable("Model_Bar_Info.csv","header");
  
 //"Bar_name","Min_x","Min_y","Min_z","Max_x","Max_y","Max_z","Nodes","Physical_Bars","Physical_Nodes","Adjacent_Physical_Bars","Adjacent_Bars","Adjacent_Physical_Nodes","Ground"])
  for (TableRow row : bars_csv.rows()) {
    String barname = row.getString("Bar_name");
    float min_x = row.getFloat("Min_X");
    float min_y = row.getFloat("Min_Y");
    float min_z = row.getFloat("Min_Z");
    float max_x = row.getFloat("Max_X");
    float max_y = row.getFloat("Max_Y");
    float max_z = row.getFloat("Max_Z");
    String csv_nods=row.getString("Nodes");
    String csv_moduls=row.getString("Modules");
    String csv_pbars=row.getString("Physical_Bars");
    String csv_pnodes=row.getString("Physical_Nodes");
    String csv_adjacent_nodes = row.getString("Adjacent_Nodes");
    String csv_adjacent_bars = row.getString("Adjacent_Bars");
    String csv_adjacent_physical_bars = row.getString("Adjacent_Physical_Bars");
    String csv_adjacent_physical_nodes = row.getString("Adjacent_Physical_Nodes");
    boolean ground;
    String groundstr = row.getString("Ground");
    if (groundstr.equals("1")){
      ground=true;
    }
    else{
      ground=false;
    } 
    //all of those were strings - split by the underscores
    List<String> moduls=Arrays.asList(csv_moduls.split("_"));
    List<String> nods=Arrays.asList(csv_nods.split("_"));
    List<String> pbars=Arrays.asList(csv_pbars.split("_"));
    List<String> pnods=Arrays.asList(csv_pnodes.split("_"));
    List<String> connected_nodes = Arrays.asList(csv_adjacent_nodes.split("_"));
    List<String> connected_bars = Arrays.asList(csv_adjacent_bars.split("_"));
    List<String> connected_physical_bars = Arrays.asList(csv_adjacent_physical_bars.split("_"));
    List<String> connected_physical_nodes = Arrays.asList(csv_adjacent_physical_nodes.split("_"));
    float current_max_z=-10000;
    List<LXPoint> usethesepoints = new ArrayList<LXPoint>();
    for (String pbarnam : pbars){
      PhysicalBar pbar = physical_bars.get(pbarnam);
      if (pbar.max_z>current_max_z){
        usethesepoints = pbar.points;
      }
    }
    Bar barre = new Bar(barname,usethesepoints,moduls,min_x,min_y,min_z,max_x,max_y,max_z,nods,pbars,pnods,connected_nodes,connected_physical_bars,connected_bars,connected_physical_nodes, ground);
    bars.put(barname,barre);


  }
//delete this comment, jsut for ref
 // public Bar(String id, List<String> module_names, float min_x, float min_y, float min_z, float max_x, float max_y, float max_z, List<String> node_names, List<String> physical_bar_names, 
 //             List<String> physical_node_names, List<String> adjacent_node_names, List<String> adjacent_physical_bar_names, List<String> adjacent_bar_names, 
 //             List<String> adjacent_physical_node_names, boolean ground){





  //(String id, float x, float y, float z, List<String> node_names, List<String> physical_bar_names, 
  //            List<String> physical_node_names, List<String> adjacent_physical_bar_names, List<String> adjacent_bar_names, 
  //            List<String> adjacent_physical_node_names, boolean ground)
  
  //Make the Bar models
  //Do this in python.


/*
   

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
  return new Model(nodes, bars, physical_nodes,physical_bars);
}
  
  
  
  
  
  
  
  
