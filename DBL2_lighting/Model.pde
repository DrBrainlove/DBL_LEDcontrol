/**
 * This is a very basic model OF A BRAIN!
 */
import java.io.*;
import java.nio.file.*;
import java.util.*;

static String lines[];
/*
public static PhysicalBar GetPhysicalBarFromTwoNodesWithModuleNums(PhysicalNode nodeone,PhysicalNode nodetwo){
  node1 = nodeone.id;
  module1 = nodeone.id;
  node2 = nodetwo.id;
  module2 = nodetwo.id;
}*/

public static class Model extends LXModel {

public final SortedMap<String, Node> nodemap;
public final SortedMap<String, Bar> barmap;
public final SortedMap<String, PhysicalBar> physicalbarmap;
public final SortedMap<String, PhysicalNode> physicalnodemap;

public Model(SortedMap<String, Node> nodemap, SortedMap<String,Bar> barmap, SortedMap<String,PhysicalNode> physicalnodemap, SortedMap<String, PhysicalBar> physicalbarmap) {
    super(new Fixture(physicalbarmap));
    this.nodemap = Collections.unmodifiableSortedMap(nodemap);
    this.barmap = Collections.unmodifiableSortedMap(barmap);
    this.physicalbarmap = Collections.unmodifiableSortedMap(physicalbarmap);
    this.physicalnodemap = Collections.unmodifiableSortedMap(physicalnodemap);
  }
  
  private static class Fixture extends LXAbstractFixture {
    
    private Fixture(SortedMap<String, PhysicalBar> physicalbarmap){
      for (PhysicalBar bar : physicalbarmap.values()) {
        if (bar != null) {
          for (LXPoint p : bar.points) {
            this.points.add(p);
          }
        }
      }
    }
    
  
  }

  public Node getRandomNode() {
    
    Random randomized = new Random();
    //TODO: Can this be optimized better? We're using maps so Processing's random function doesn't seem to apply here
    List<String> nodekeys = new ArrayList<String>(this.nodemap.keySet());
    String randomnodekey = nodekeys.get( randomized.nextInt(nodekeys.size()) );
    Node randomnode = this.nodemap.get(randomnodekey);
    return randomnode;
  }
  
  
}



public static class Bar extends LXModel {


  public final String id;
  
  //xyz position of node
  //If it's a double or triple node, returns the coordinates of the highest-z-position instance of the node
  public final float min_x;
  public final float min_y;
  public final float min_z;
  public final float max_x;
  public final float max_y;
  public final float max_z;
  public final boolean ground;
  public final String inner_outer_mid;

  public final List<String> module_names;
  
  //List of node IDs connected to node.
  public final List<String> node_names;

  //List of bar IDs connected to node.
  public final List<String> adjacent_bar_names;

  //Do not use unless you have a good reason to
  //List of bar IDs connected to node with module nums. (for dealing with double bars etc)
  public final List<String> physical_bar_names;

  //Do not use unless you have a good reason to
  //List of bar IDs connected to node with module nums. (for dealing with double bars etc)
  public final List<String> adjacent_physical_bar_names;

  //Do not use unless you have a good reason to
  //Sometimes there are more than one physical node per node because they have the same label but are in different modules
  public final List<String> physical_node_names;

  //Do not use unless you have a good reason to
  //Sometimes there are more than one physical node per node because they have the same label but are in different modules
  public final List<String> adjacent_physical_node_names;

  public ArrayList<Node> nodes = new ArrayList<Node>();
  public ArrayList<PhysicalNode> physical_nodes = new ArrayList<PhysicalNode>();
  public ArrayList<PhysicalBar> physical_bars = new ArrayList<PhysicalBar>();

  public ArrayList<Node> adjacent_nodes = new ArrayList<Node>();
  public ArrayList<Bar> adjacent_bars = new ArrayList<Bar>();
  public ArrayList<PhysicalBar> adjacent_physical_bars = new ArrayList<PhysicalBar>();
  public ArrayList<PhysicalNode> adjacent_physical_nodes = new ArrayList<PhysicalNode>();

  public Bar(String id, List<LXPoint> points, List<String> module_names, float min_x, float min_y, float min_z, float max_x, float max_y, float max_z, List<String> node_names, List<String> physical_bar_names, 
              List<String> physical_node_names, List<String> adjacent_node_names, List<String> adjacent_physical_bar_names, List<String> adjacent_bar_names, 
              List<String> adjacent_physical_node_names, boolean ground){
    super(new Fixture(points));
    this.id=id;
    this.module_names=module_names;
    this.min_x=min_x;
    this.min_y=min_y;
    this.min_z=min_z;
    this.max_x=max_x;
    this.max_y=max_y;
    this.max_z=max_z;
    this.inner_outer_mid = "WIP";
    this.node_names = node_names;
    this.physical_bar_names = physical_bar_names;
    this.physical_node_names = physical_node_names;
    this.adjacent_physical_bar_names=adjacent_physical_bar_names;
    this.adjacent_bar_names=adjacent_bar_names;
    this.adjacent_physical_node_names = adjacent_physical_node_names;
    this.ground = ground;
    this.nodes = new ArrayList<Node>();
    this.physical_bars = new ArrayList<PhysicalBar>();
    this.adjacent_bars = new ArrayList<Bar>();
    this.adjacent_nodes = new ArrayList<Node>();
    this.adjacent_physical_bars = new ArrayList<PhysicalBar>();
    this.adjacent_physical_nodes = new ArrayList<PhysicalNode>();
  }
  
  
  private static class Fixture extends LXAbstractFixture {
    private Fixture(List<LXPoint> points){
      for (LXPoint p : points ){
        this.points.add(p);
      }
    }
  }
}







//Use this
public class Node extends LXModel {

  //Node number with module number
  public final String id;

  public final float x;
  public final float y;
  public final float z;
  
  //xyz position of node
  //If it's a double or triple node, returns the coordinates of the highest-z-position instance of the node
  public final boolean ground;
  
  //List of bar IDs connected to node.
  public final List<String> adjacent_bar_names;
  
  

  //List of node IDs connected to node.
  public final List<String> adjacent_node_names;
  
  //Do not use unless you have a good reason to
  //List of bar IDs connected to node with module nums. (for dealing with double bars etc)
  public final List<String> adjacent_physical_bar_names;

  //Do not use unless you have a good reason to
  //Sometimes there are more than one physical node per node because they have the same label but are in different modules
  public final List<String> adjacent_physical_node_names;

  public final List<String> physical_node_names;

  public ArrayList<Bar> adjacent_bars = new ArrayList<Bar>();
  public ArrayList<Node> adjacent_nodes = new ArrayList<Node>();
  public ArrayList<PhysicalBar> adjacent_physical_bars = new ArrayList<PhysicalBar>();
  public ArrayList<PhysicalNode> adjacent_physical_nodes = new ArrayList<PhysicalNode>();


  //List of adjacent bars. (Status: TEST, not sure if this'll work well.)
  //FUCK YEAH. It does. For now.
  
  public ArrayList<Node> random_adjacent_nodes(int num_requested){
    ArrayList<String> returnnodstrs = new ArrayList<String>();
    ArrayList<Node> returnnods = new ArrayList<Node>();
    if (num_requested > this.adjacent_node_names.size()){
      num_requested = this.adjacent_node_names.size();
    }
    while (returnnodstrs.size() < num_requested){
       String randomnodekey = adjacent_node_names.get( int(random(adjacent_node_names.size())) );
       if (!(Arrays.asList(returnnodstrs).contains(randomnodekey))){
         returnnodstrs.add(randomnodekey);
       }
    }
    for (String randnod : returnnodstrs){
      returnnods.add(model.nodemap.get(randnod));
    }
    return returnnods;
   
  }
  
  public ArrayList<Bar> adjacent_bars(){
    ArrayList<Bar> baarrs = new ArrayList<Bar>();
    for (String pnn : this.adjacent_bar_names){
      baarrs.add(model.barmap.get(pnn));
    }
   return baarrs;
  }

    //List of adjacent bars. (Status: TEST, not sure if this'll work well.)
  //FUCK YEAH. It does. For now.
  public ArrayList<PhysicalNode> physical_nodes(){
    ArrayList<PhysicalNode> pnodes = new ArrayList<PhysicalNode>();
    for (String pnn : this.physical_node_names){
      pnodes.add(model.physicalnodemap.get(pnn));
    }
    return pnodes;
  }

 //List of adjacent bars. (Status: TEST, not sure if this'll work well.)
  //FUCK YEAH. It does. For now.
  public ArrayList<Node> adjacent_nodes(){
    ArrayList<Node> nods = new ArrayList<Node>();
    for (String pnn : this.adjacent_node_names){
      nods.add(model.nodemap.get(pnn));
    }
   return nods;
  }


  //List of actual adjacent bars. (Status: TEST, not sure if this'll work well.)
  //FUCK YEAH. It does. For now.
  public ArrayList<PhysicalBar> adjacent_physical_bars(){
    ArrayList<PhysicalBar> pbars = new ArrayList<PhysicalBar>();
    for (String pnn : this.adjacent_physical_bar_names){
      pbars.add(model.physicalbarmap.get(pnn));
    }
    return pbars;
  }

  //List of actual adjacent bars. (Status: TEST, not sure if this'll work well.)
  //FUCK YEAH. It does. For now. 
  //fuck. balls. nvm
  public ArrayList<PhysicalNode> adjacent_physical_nodes(){
    ArrayList<PhysicalNode> pnodes = new ArrayList<PhysicalNode>();
    for (String pnn : this.adjacent_physical_node_names){
      pnodes.add(model.physicalnodemap.get(pnn));
    }
    return pnodes;
  }
  

  public Node(String id, float x, float y, float z, List<String> adjacent_physical_bar_names, List<String> adjacent_bar_names, List<String> adjacent_node_names, List<String> adjacent_physical_node_names, List<String> physical_node_names, boolean ground){
    this.id=id;
    this.x=x;
    this.y=y;
    this.z=z;
    this.adjacent_physical_bar_names=adjacent_physical_bar_names;
    this.adjacent_bar_names=adjacent_bar_names;
    this.adjacent_node_names = adjacent_node_names;
    this.adjacent_physical_node_names = adjacent_physical_node_names;
    this.physical_node_names = physical_node_names;
    this.ground = ground;
    this.adjacent_bars = new ArrayList<Bar>();
    this.adjacent_nodes = new ArrayList<Node>();
    this.adjacent_physical_bars = new ArrayList<PhysicalBar>();
    this.adjacent_physical_nodes = new ArrayList<PhysicalNode>();
  }
}



/*
DO NOT USE
DO NOT USE
DO NOT USE
PRETEND THIS DOESN'T EXIST
SCROLL UP
NOOOOOOOOOOOOOOOOOO
DAAAMN IIIIT
SCROLL UP
(unless you like things being more complicated)
(or need to access just one module's instance of a bar)
This is just for mapping the physical bars (e.g. ABC-DEF-1 is node ABD to node DEF in  module 1)
Use Bar instead
*/
public static class PhysicalBar extends LXModel {

  //Bar name
  public final String id;

  public final String module_num;
  
  public final String inner_outer_mid;
  
  public boolean isActive;
  
  //Captures whether the bar is an inner bar, outer bar, or in-between bar
  //public final String innerOuterInBetween;
  
  public  float min_x;
  public  float min_y;
  public  float min_z;
  public  float max_x;
  public  float max_y;
  public  float max_z;
  
  public String bar_name;

  //public Bar bar;
  
  public final List<String> node_names;
  
  public final List<String> physical_node_names;

  public ArrayList<Node> nodes = new ArrayList<Node>();

  public ArrayList<PhysicalNode> physical_nodes = new ArrayList<PhysicalNode>();


//TODO: Figure out the nasty static/etc models with this so these are just directly accessible as methods
/*  public ArrayList<Node> nodes(){
    ArrayList<Node> nods = new ArrayList<Node>();
    for (String nn : this.node_names){
      nods.add(model.nodesmap.get(nn));
    }
    return nods;
  }
  
  public ArrayList<PhysicalNode> physical_nodes(){
    ArrayList<PhysicalNode> pnodes = new ArrayList<PhysicalNode>();
    for (String pnn : this.physical_node_names){
      pnodes.add(model.physicalnodemap.get(pnn));
    }
    return pnodes;
  }
  
  */
  

  public PhysicalBar(String id, String module_num, List<float[]> points, List<String> node_names,List<String> physical_node_names){
    super(new Fixture(points));
    this.id=id;
    this.module_num=module_num;
    this.bar_name=id.substring(0,8);
    this.inner_outer_mid="WIP";
    this.isActive = true;
    this.node_names = node_names;
    this.physical_node_names = physical_node_names;
    this.nodes = new ArrayList<Node>();
    this.physical_nodes = new ArrayList<PhysicalNode>();
   // this.bar = new Bar;
    
  }

  private static class Fixture extends LXAbstractFixture {
    private Fixture(List<float[]> points){
      for (float[] p : points ){
        LXPoint point=new LXPoint(p[0],p[1],p[2]);
        this.points.add(point);
      }
    }
  }
}




/*
DO NOT USE
DO NOT USE
DO NOT USE
PRETEND THIS DOESN'T EXIST
SCROLL UP
NOOOOOOOOOOOOOOOOOO
DAAAMN IIIIT
SCROLL UP
(unless you like things being more complicated)
(or need to access just one module's instance of a bar)
This is just for mapping the physical nodes (e.g. ABC-1 is node ABC in module 1)
Use Node instead
*/
public class PhysicalNode extends LXModel {

  //Node number with module number
  public final String id;
  public final String node_name;
  
  //xyz position of node
  public final float x;
  public final float y;
  public final float z;
  public final boolean ground;
  
  //public final Node node;
  
  //List of bar IDs connected to node.
  public final List<String> adjacent_bar_names;
  
  //List of bar IDs connected to node with module nums. (for dealing with double bars etc)
  public final List<String> adjacent_physical_bar_names;
  

  //List of node IDs connected to node with module nums. (for dealing with double nodes etc)
  public final List<String> adjacent_node_names;
  
  
  //List of node IDs connected to node with module nums. (for dealing with double nodes etc)
  public final List<String> adjacent_physical_node_names;

  //public ArrayList<Node> adjacent_nodes = new ArrayList<Node>();
  public ArrayList<PhysicalBar> adjacent_physical_bars = new ArrayList<PhysicalBar>();
  public ArrayList<PhysicalNode> adjacent_physical_nodes = new ArrayList<PhysicalNode>();


  //Probably deprecated, failed approach, java class issues
  //List of node IDs connected to node.
  public Node node(){
    Node nod = model.nodemap.get(this.node_name);
    return nod;
  }
  
  //Probably deprecated, failed approach, java class issues
  //List of node IDs connected to node.
  public ArrayList<Node> adjacent_nodes(){
    ArrayList<Node> nods = new ArrayList<Node>();
    for (String nn : this.adjacent_node_names){
      nods.add(model.nodemap.get(nn));
    }
    return nods;
  }

  //List of actual adjacent bars. (Status: TEST, not sure if this'll work well.)
  //FUCK YEAH. It does. For now.
  public ArrayList<PhysicalBar> adjacent_physical_bars(){
    ArrayList<PhysicalBar> pbars = new ArrayList<PhysicalBar>();
    println(this.adjacent_physical_bar_names.size());
    for (String pnn : this.adjacent_physical_bar_names){
      println(pnn);
      pbars.add(model.physicalbarmap.get(pnn));
    }
    return pbars;  
  }

  //List of actual adjacent bars. (Status: TEST, not sure if this'll work well.)
  //FUCK YEAH. It does. For now.
  public ArrayList<PhysicalNode> adjacent_physical_nodes(){
    ArrayList<PhysicalNode> pnodes = new ArrayList<PhysicalNode>();
    for (String pnn : this.adjacent_physical_node_names){
      pnodes.add(model.physicalnodemap.get(pnn));
    }
    return pnodes;
  }

  public PhysicalNode(String id, String module, float x, float y, float z, List<String> adjacent_node_names, List<String> adjacent_physical_node_names, List<String> adjacent_bar_names, List<String> adjacent_physical_bar_names, boolean ground){
    this.id=id;
    this.node_name = this.id.substring(0,3);
    this.x=x;
    this.y=y;
    this.z=z;
    this.adjacent_node_names=adjacent_node_names;
    this.adjacent_physical_node_names = adjacent_physical_node_names;
    this.adjacent_bar_names=adjacent_bar_names;
    this.adjacent_physical_bar_names=adjacent_physical_bar_names;
    this.ground = ground;
  /*  this.adjacent_nodes = new ArrayList<Node>();
    this.adjacent_physical_bars = new ArrayList<PhysicalBar>();
    this.adjacent_physical_nodes = new ArrayList<PhysicalNode>();*/
   // this.node = new Node;
  }
}


