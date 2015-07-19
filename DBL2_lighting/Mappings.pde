import java.io.*;
import java.nio.file.*;
import java.util.*;
//import processing.data.Table;

//Builds the brain model
//BEWARE. Lots of csvs and whatnot.
//It's uglier than sin, but the brain is complicated, internally redundant, and not always heirarchical.
//It works.
public Model buildTheBrain(String bar_selection_identifier) { 
  
  String mapping_data_location="mapping_datasets/"+bar_selection_identifier+"/";
  
  SortedMap<String, List<float[]>> barlists = new TreeMap<String, List<float[]>>();
  SortedMap<String, Bar> bars = new TreeMap<String, Bar>();
  SortedMap<String, Node> nodes = new TreeMap<String, Node>();
  boolean newbar;
  boolean newnode;


  //Map the pixels to individual LEDs and in the process declare the physical bars.
  //As of 15/6/1 the physical bars are the only things that don't have their own declaration table
  //TODO: This is now mostly handled by the Bar class loading, so clean it up and get rid of the unnecessary parts.
  Table pixelmapping = loadTable(mapping_data_location+"pixel_mapping.csv", "header");
  List<float[]> bar_for_this_particular_led;
  Set barnames = new HashSet();
  Set nodenames = new HashSet();
  List<String> bars_in_pixel_order = new ArrayList<String>();
  for (processing.data.TableRow row : pixelmapping.rows()) {
    int pixel_num = row.getInt("Pixel_i");
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    float z = row.getFloat("Z");
    String node1 = row.getString("Node1");
    String node2 = row.getString("Node2");
    String strip_num = row.getString("Strip");
    String bar_name=node1+"-"+node2;
    newbar=barnames.add(bar_name);
    if (newbar){
      bars_in_pixel_order.add(bar_name);
      List<float[]> poince = new ArrayList<float[]>();
      barlists.put(bar_name,poince); 
    }
    bar_for_this_particular_led = barlists.get(bar_name);
    float[] point = new float[]{x,y,z};
    bar_for_this_particular_led.add(point);
  } 
  println("Finished loading pixel_mapping");
  
  
  //Load the node info for the model nodes. (ignores double nodes)
  Table node_csv = loadTable(mapping_data_location+"Model_Node_Info.csv","header");
  

  for (processing.data.TableRow row : node_csv.rows()) {
    String node = row.getString("Node");
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    float z = row.getFloat("Z");
    String csv_neighbors = row.getString("Neighbor_Nodes");
    String csv_connected_bars = row.getString("Bars");
//    String csv_connected_physical_bars = row.getString("Physical_Bars");
//    String csv_adjacent_physical_nodes = row.getString("Physical_Nodes");
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
    List<String> neighbors = Arrays.asList(csv_neighbors.split("_"));
    List<String> connected_bars = Arrays.asList(csv_connected_bars.split("_"));
    Node nod = new Node(node,x,y,z,connected_bars, neighbors, ground,inner_outer, left_right_mid); 
   
    nodes.put(node,nod);
  }
  println("finished loading model_node_info");
  
  
  //Load the model bar info (which has conveniently abstracted away all of the double node jiggery-pokery)
  Table bars_csv = loadTable(mapping_data_location+"Model_Bar_Info.csv","header");
  
  for (processing.data.TableRow row : bars_csv.rows()) {
    String barname = row.getString("Bar_name");
    float min_x = row.getFloat("Min_X");
    float min_y = row.getFloat("Min_Y");
    float min_z = row.getFloat("Min_Z");
    float max_x = row.getFloat("Max_X");
    float max_y = row.getFloat("Max_Y");
    float max_z = row.getFloat("Max_Z");
    String csv_nods=row.getString("Nodes");
    String module=row.getString("Module");
    String csv_adjacent_nodes = row.getString("Adjacent_Nodes");
    String csv_adjacent_bars = row.getString("Adjacent_Bars");
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
    List<String> nods=Arrays.asList(csv_nods.split("_"));
    List<String> connected_nodes = Arrays.asList(csv_adjacent_nodes.split("_"));
    List<String> connected_bars = Arrays.asList(csv_adjacent_bars.split("_"));
    float current_max_z=-10000;
    List<float[]> usethesepoints = new ArrayList<float[]>();
    usethesepoints = barlists.get(barname);
    Bar barrrrrrr = new Bar(barname,usethesepoints,min_x,min_y,min_z,max_x,max_y,max_z,module,nods,connected_nodes,connected_bars, ground,inner_outer,left_right_mid);
  
    bars.put(barname,barrrrrrr);

  println("Loaded Model bar info");

  }
  Model model = new Model(nodes, bars, bars_in_pixel_order);
  // I can haz brain model.
  return model;
}
  
  
  
  
  
  
  
  
