import java.io.*;
import java.nio.file.*;
import java.util.*;


//Builds the brain model
//BEWARE. Lots of csvs and whatnot.
//It's uglier than sin, but the brain is complicated, internally redundant, and not always heirarchical.
//It works.
public Model buildTheBrain(String bar_selection_identifier) { 
  
  String mapping_data_location="mapping_datasets/"+bar_selection_identifier+"/";
  
  SortedMap<String, List<float[]>> barlists = new TreeMap<String, List<float[]>>();
  SortedMap<String, Bar> bars = new TreeMap<String, Bar>();
  SortedMap<String, PhysicalBar> physical_bars = new TreeMap<String, PhysicalBar>();
  SortedMap<String, Node> nodes = new TreeMap<String, Node>();
  SortedMap<String, PhysicalNode> physical_nodes = new TreeMap<String, PhysicalNode>();
  SortedMap<String, ArrayList<String>>  bar_trackin = new TreeMap<String, ArrayList<String>>();
  boolean newbar;
  boolean newnode;


  //Map the pixels to individual LEDs and in the process declare the physical bars.
  //As of 15/6/1 the physical bars are the only things that don't have their own declaration table
  //Because this works
  Table pixelmapping = loadTable(mapping_data_location+"pixel_mapping.csv", "header");
  List<float[]> bar_for_this_particular_led;
  Set barnames = new HashSet();
  Set nodenames = new HashSet();
  List<String> bars_in_pixel_order = new ArrayList<String>();
  for (TableRow row : pixelmapping.rows()) {
     
    String module_num1 = row.getString("Module1"); //This is the module that the bar belongs to
    String module_num2 = row.getString("Module2"); //Not this one. But this is important for the second physical node name
    int pixel_num = row.getInt("Pixel_i");
    String node1 = row.getString("Node1");
    String node2 = row.getString("Node2");
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    float z = row.getFloat("Z");
    String strip_num = row.getString("Strip"); 
    String inner_outer = row.getString("Inner_Outer"); 
    String left_right_mid = row.getString("Left_Right_Mid");
    String bar_name=node1+"-"+node2+"-"+module_num1;
    newbar=barnames.add(bar_name);
    if (newbar){
      bars_in_pixel_order.add(bar_name);
      List<float[]> poince = new ArrayList<float[]>();
      barlists.put(bar_name,poince);
      ArrayList<String> barstufflist=new ArrayList<String>();
      barstufflist.add(module_num1);
      barstufflist.add(module_num2);
      barstufflist.add(node1);
      barstufflist.add(node2);
      barstufflist.add(strip_num);
      barstufflist.add(inner_outer);
      barstufflist.add(left_right_mid);
      bar_trackin.put(bar_name,barstufflist);
    }
    bar_for_this_particular_led = barlists.get(bar_name);
    float[] point = new float[]{x,y,z};
    bar_for_this_particular_led.add(point);
  }
  for (String barname : bars_in_pixel_order){
    List<String> pbar_data = bar_trackin.get(barname);
    String module_num1 = pbar_data.get(0);
    String module_num2 = pbar_data.get(1);
    String node1 = pbar_data.get(2);
    String node2 = pbar_data.get(3);
    int strip_num = parseInt(pbar_data.get(4));
    String inner_outer = pbar_data.get(5);
    String left_right_mid = pbar_data.get(6);
    
    //println(barname+"-"+str(strip_num));
    List<String> node_names = new ArrayList<String>();
    node_names.add(node1);
    node_names.add(node2);
    List<String> physical_node_names = new ArrayList<String>();
    physical_node_names.add(node1+"-"+module_num1);
    physical_node_names.add(node2+"-"+module_num2);

    PhysicalBar physicalbar = new PhysicalBar(barname,module_num1,barlists.get(barname),node_names,physical_node_names, strip_num,inner_outer, left_right_mid);
    physical_bars.put(barname,physicalbar);
  } 
  println("Finished loading pixel_mapping");
  
  
  //Load the node info for the model nodes. (ignores double nodes)
  Table node_csv = loadTable(mapping_data_location+"Model_Node_Info.csv","header");
  

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
    String inner_outer = row.getString("Inner_Outer");
    String left_right_mid = row.getString("Left_Right_Mid");
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
    
    Node nod = new Node(node,x,y,z,connected_physical_bars,connected_bars, neighbors, adjacent_physical_nodes,subnodes, ground,inner_outer, left_right_mid); 
   
    nodes.put(node,nod);
  }
  println("finished loading model_node_info");
  
  
  
  //Loads the model for the structural nodes (the ones that deal with all the double bars and cross-module stuff etc)
  Table node_struct_csv = loadTable(mapping_data_location+"Structural_Node_Info.csv","header");
  
 
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
    String inner_outer = row.getString("Inner_Outer");
    String left_right_mid = row.getString("Left_Right_Mid");
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
    
    PhysicalNode nod = new PhysicalNode(node_w_module,modul,x,y,z,connected_nodes,connected_physical_nodes,connected_bars,connected_physical_bars, ground,inner_outer, left_right_mid);
    physical_nodes.put(node_w_module,nod);


  }
  println("Finished loading structural node info");
  
  
  //Based on the physical nodes in the physical bars, add min and max xyz
  //TODO: This is janky and this way of doing it prevents PhysicalBar min_x etc from being able to be final
  //Not high priority but this should be done in python and passed into the physical bar class directly.
  for (String pbs : physical_bars.keySet()){
    println(pbs);
    PhysicalBar pb = physical_bars.get(pbs);
    println("yo");
    List<String> nns = pb.node_names;
    List<String> pnns = pb.physical_node_names;
    for (String nn : nns){
      Node nnooddee = nodes.get(nn);
      pb.nodes.add(nnooddee);
    }
    //These specific values aren't important - just that they're way outside the bounds of the model.
    float pbxmin=10000;
    float pbymin=10000;
    float pbzmin=10000;
    float pbxmax=-10000;
    float pbymax=-10000;
    float pbzmax=-10000;
    for (String pnn : pnns){
      println(pnn);
      PhysicalNode pnnooddee = physical_nodes.get(pnn);
      println(pnnooddee);
      println("abc");
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
      println("def");
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
  println("calculated max/min values for pixel coords");


  //Load the model bar info (which has conveniently abstracted away all of the double node jiggery-pokery)
  Table bars_csv = loadTable(mapping_data_location+"Model_Bar_Info.csv","header");
  
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
    String inner_outer = row.getString("Inner_Outer");
    String left_right_mid = row.getString("Left_Right_Mid");
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
    Bar barrrrrrr = new Bar(barname,usethesepoints,moduls,min_x,min_y,min_z,max_x,max_y,max_z,nods,pbars,pnods,connected_nodes,connected_physical_bars,connected_bars,connected_physical_nodes, ground,inner_outer,left_right_mid);
    bars.put(barname,barrrrrrr);

  println("Loaded Model bar info");

  }
  
  //Map the strip numbers to lengths so that they're easy to handle via  the pixelpusher
  IntList strip_lengths = new IntList();
  int current_strip=0;
  for (String pbarnam : bars_in_pixel_order){
    PhysicalBar pbar = physical_bars.get(pbarnam);
    int strip_num = pbar.strip_num;
    int pixels_in_pbar = pbar.points.size();
    if (strip_num!=9999){ //9999 is the value for "there's no actual physical strip set up for this right now but show it in Processing anyways" 
      if (strip_num==current_strip){
        int existing_strip_length=strip_lengths.get(strip_num);
        int new_strip_length = existing_strip_length + pixels_in_pbar;
        strip_lengths.set(strip_num,new_strip_length);
      } else {
        strip_lengths.append(pixels_in_pbar);
        current_strip+=1;
      }
    }
    }
  
  //println(strip_lengths);

  // I can haz brain modl.
  return new Model(nodes, bars, physical_nodes,physical_bars, bars_in_pixel_order, strip_lengths);
}
  
  
  
  
  
  
  
  
