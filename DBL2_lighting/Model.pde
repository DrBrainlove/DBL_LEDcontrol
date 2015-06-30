/**
 * This is a model OF A BRAIN!
 */
import java.io.*;
import java.nio.file.*;
import java.util.*;


public static class Model extends LXModel {

//Note that these are stored in maps, not lists.
public final SortedMap<String, Node> nodemap;
public final SortedMap<String, Bar> barmap;

//You should only need to use nodemap and barmap, unless you have some really specific reason for dealing with double nodes etc
public final SortedMap<String, PhysicalBar> physicalbarmap;
public final SortedMap<String, PhysicalNode> physicalnodemap;



//Ze brain model
public Model(SortedMap<String, Node> nodemap, SortedMap<String,Bar> barmap, SortedMap<String,PhysicalNode> physicalnodemap, SortedMap<String, PhysicalBar> physicalbarmap, List<String> bars_in_load_order) {
    super(new Fixture(physicalbarmap, bars_in_load_order));
    this.nodemap = Collections.unmodifiableSortedMap(nodemap);
    this.barmap = Collections.unmodifiableSortedMap(barmap);
    this.physicalbarmap = Collections.unmodifiableSortedMap(physicalbarmap);
    this.physicalnodemap = Collections.unmodifiableSortedMap(physicalnodemap);
  }
  
  //Map the points from the physical bars into the brain.
  private static class Fixture extends LXAbstractFixture {
    private Fixture(SortedMap<String, PhysicalBar> physicalbarmap, List<String> bars_in_load_order){
      for (String barname : bars_in_load_order) {
        PhysicalBar bar = physicalbarmap.get(barname);
        if (bar != null) {
          for (LXPoint p : bar.points) {
            this.points.add(p);
          }
        }
      }
    }
  }

  //Definitely doesn't get a random node. No sirree.
  public Node getRandomNode() {
    //TODO: Instead of declaring a new Random every call, can we just put one at the top outside of everything?
    Random randomized = new Random();
    //TODO: Can this be optimized better? We're using maps so Processing's random function doesn't seem to apply here
    List<String> nodekeys = new ArrayList<String>(this.nodemap.keySet());
    String randomnodekey = nodekeys.get( randomized.nextInt(nodekeys.size()) );
    Node randomnode = this.nodemap.get(randomnodekey);
    return randomnode;
  }


  //If I could write getRandomIrishPub and have it work, I would.
  public Bar getRandomBar() {
    //TODO: Instead of declaring a new Random every call, can we just put one at the top outside of everything?
    Random randomized = new Random();
    //TODO: Can this be optimized better? We're using maps so Processing's random function doesn't seem to apply here
    List<String> barkeys = new ArrayList<String>(this.barmap.keySet());
    String randombarkey = barkeys.get( randomized.nextInt(barkeys.size()) );
    Bar randombar = this.barmap.get(randombarkey);
    return randombar;
  }

    ///Returns an ArrayList of randomly selected nodes. 
  public ArrayList<Node> getRandomNodes(int num_requested){
    Random randomized = new Random();
    ArrayList<String> returnnodstrs = new ArrayList<String>();
    ArrayList<Node> returnnods = new ArrayList<Node>();
    List<String> nodekeys = new ArrayList<String>(this.nodemap.keySet());
    if (num_requested > nodekeys.size()){
      num_requested = nodekeys.size();
    }
    while (returnnodstrs.size() < num_requested){
       String randomnodekey = nodekeys.get( int(randomized.nextInt(nodekeys.size())) );
       if (!(Arrays.asList(returnnodstrs).contains(randomnodekey))){
         returnnodstrs.add(randomnodekey);
       }
    }
    for (String randnod : returnnodstrs){
      returnnods.add(this.nodemap.get(randnod));
    }
    return returnnods;
  }

    ///Returns an ArrayList of randomly selected adjacent bars. 
  public ArrayList<Bar> getRandomBars(int num_requested){
    Random randomized = new Random();
    ArrayList<String> returnbarstrs = new ArrayList<String>();
    ArrayList<Bar> returnbars = new ArrayList<Bar>();
    List<String> barkeys = new ArrayList<String>(this.nodemap.keySet());
    if (num_requested > barkeys.size()){
      num_requested = barkeys.size();
    }
    while (returnbarstrs.size() < num_requested){
       String randombarkey = barkeys.get( int(randomized.nextInt(barkeys.size())) );
       if (!(Arrays.asList(returnbarstrs).contains(randombarkey))){
         returnbarstrs.add(randombarkey);
       }
    }
    for (String randbar : returnbarstrs){
      returnbars.add(this.barmap.get(randbar));
    }
    return returnbars;
  }

  //The bars are always in alphabetical order. Often it's helpful to get the list of points from one node to the other, in that order.
  public List<LXPoint> getOrderedLXPointsBetweenTwoAdjacentNodes(Node node1, Node node2){
    String node1nam = node1.id;
    String node2nam = node2.id;
    int reverse_order = node1nam.compareTo(node2nam);
    String barnam;
    if (reverse_order<0){
      barnam = node1nam + "-" + node2nam;
    }
    else{
      barnam = node2nam + "-" + node1nam;
    }
    Bar ze_bar = this.barmap.get(barnam);

    //Nodes aren't adjacent or bar doesn't exist.
    if (ze_bar == null){
      return null; 
    }
    else {
      if (reverse_order>0){
        List<LXPoint> zebarpoints = new ArrayList(ze_bar.points);
        Collections.reverse(zebarpoints);
        return zebarpoints;
      }
      else {
        return ze_bar.points;
      }
    }
  }


}



//Probably the most useful abstraction for traversing the brain.
public class Node extends LXModel {

  //Node number with module number
  public final String id;

  //Straightforward. If there are multiple physical nodes, this is the xyz from the node with the highest z
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


  //Do not use unless you have a good reason to
  //Physical node names associated with node (ABC-1, ABC-4 etc)
  public final List<String> physical_node_names;


  //Just declurrin' some arraylists
  public ArrayList<Bar> adjacent_bars = new ArrayList<Bar>();
  public ArrayList<Node> adjacent_nodes = new ArrayList<Node>();
  public ArrayList<PhysicalBar> adjacent_physical_bars = new ArrayList<PhysicalBar>();
  public ArrayList<PhysicalNode> adjacent_physical_nodes = new ArrayList<PhysicalNode>();




  // Returns just one random adjacent node.
  // Redundant? Yes. But nice to have regardless.
  public Node random_adjacent_node(){
    String randomnodekey = adjacent_node_names.get( int(random(adjacent_node_names.size())) );
    Node returnnod=model.nodemap.get(randomnodekey);
    return returnnod;
  }

  ///Returns an ArrayList of randomly selected adjacent nodes. 
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



  // Returns just one random adjacent bar.
  // Redundant? Yes. But nice to have regardless.
  public Bar random_adjacent_bar(){
    String randombarkey = adjacent_bar_names.get( int(random(adjacent_bar_names.size())) );
    Bar returnbar=model.barmap.get(randombarkey);
    return returnbar;
  }


  ///Returns an ArrayList of randomly selected adjacent bars. 
  public ArrayList<Bar> random_adjacent_bars(int num_requested){
    ArrayList<String> returnbarstrs = new ArrayList<String>();
    ArrayList<Bar> returnbars = new ArrayList<Bar>();
    if (num_requested > this.adjacent_bar_names.size()){
      num_requested = this.adjacent_bar_names.size();
    }
    while (returnbarstrs.size() < num_requested){
       String randombarkey = adjacent_bar_names.get( int(random(adjacent_bar_names.size())) );
       if (!(Arrays.asList(returnbarstrs).contains(randombarkey))){
         returnbarstrs.add(randombarkey);
       }
    }
    for (String randbar : returnbarstrs){
      returnbars.add(model.barmap.get(randbar));
    }
    return returnbars;
  }
  
  //List of adjacent bars
  public ArrayList<Bar> adjacent_bars(){
    ArrayList<Bar> baarrs = new ArrayList<Bar>();
    for (String pnn : this.adjacent_bar_names){
      baarrs.add(model.barmap.get(pnn));
    }
   return baarrs;
  }

  //List of adjacent nodes. 
  public ArrayList<PhysicalNode> physical_nodes(){
    ArrayList<PhysicalNode> pnodes = new ArrayList<PhysicalNode>();
    for (String pnn : this.physical_node_names){
      pnodes.add(model.physicalnodemap.get(pnn));
    }
    return pnodes;
  }

 //List of adjacent bars.
  public ArrayList<Node> adjacent_nodes(){
    ArrayList<Node> nods = new ArrayList<Node>();
    for (String pnn : this.adjacent_node_names){
      nods.add(model.nodemap.get(pnn));
    }
   return nods;
  }

  //Do not use unless you know what you're doing
  //List of actual adjacent physical bars. 
  public ArrayList<PhysicalBar> adjacent_physical_bars(){
    ArrayList<PhysicalBar> pbars = new ArrayList<PhysicalBar>();
    for (String pnn : this.adjacent_physical_bar_names){
      pbars.add(model.physicalbarmap.get(pnn));
    }
    return pbars;
  }

  //Do not use unless you know what you're doing
  //List of actual adjacent physical nodes. 
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







public static class Bar extends LXModel {

  //bar name
  public final String id;
  
  //min and max xyz of bar
  public final float min_x;
  public final float min_y;
  public final float min_z;
  public final float max_x;
  public final float max_y;
  public final float max_z;

  //Is it on the ground? (or bottom of brain)
  public final boolean ground;

  //Inner bar? Outer bar? Mid bar?
  public final String inner_outer_mid;

  //list of strings of modules that this bar is in.
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



  //NOTE: There's an issue with the Bar class in which we can't both declare it a private static fixture and have references to
  // the non-static class model to call neighboring nodes, etc. If you know how to resolve this, let me (Maki) know, for now just use
  // the _names functions which are lists of strings and call them from the model.

  //Bar nodes
  public ArrayList<Node> nodes = new ArrayList<Node>();

  //Physical nodes attached to bar
  public ArrayList<PhysicalNode> physical_nodes = new ArrayList<PhysicalNode>();

  //Physucak bars attached to bar.
  public ArrayList<PhysicalBar> physical_bars = new ArrayList<PhysicalBar>();

  //Adjacent nodes to bar
  public ArrayList<Node> adjacent_nodes = new ArrayList<Node>();

  //Adjacent bars to bar
  public ArrayList<Bar> adjacent_bars = new ArrayList<Bar>();

  //Adjacent physical bars to bar
  public ArrayList<PhysicalBar> adjacent_physical_bars = new ArrayList<PhysicalBar>();

  //Adjacent physical nodes to bar
  public ArrayList<PhysicalNode> adjacent_physical_nodes = new ArrayList<PhysicalNode>();


  //This bar is open to the public.
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


/*

BEWARE ALL YE WHO SCROLL PAST THIS POINT.

THE MODELS ABOVE ARE FRIENDLY AND CUDDLY. THEY DEAL WITH NODES AND BARS AS IF THERE ARE NO MODULES AND DOUBLE BARS AND TRIPLE NODES AND ISIS AND SHIT.

YOU CAN PET IT. IT DOESN'T BITE.

THE MODELS BELOW ARE PAIN. 

USE THE PHYSICAL NODES AND BARS. AND DOUBLE NODES. AND DOUBLE BARS.

*/



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
(or need to access just one really specific module's instance of a bar)
This is just for mapping the physical bars (e.g. ABC-DEF-1 is node ABD to node DEF in  module 1)
Use Bar instead
It's so much easier. 
*/
public static class PhysicalBar extends LXModel {

  //Bar name
  public final String id;

  //What module is it a part of
  public final String module_num;
  
  //Inner bar? Outer bar? Neither?
  public final String inner_outer_mid;
  
  //Are we actually usin' this mofo?
  public boolean isActive;
  
  //What strip is this bar on
  public int strip_num;
  
  //min and max xyz
  public  float min_x;
  public  float min_y;
  public  float min_z;
  public  float max_x;
  public  float max_y;
  public  float max_z;
  
  //Not to be confused with physical bar name. ABC-DEF-1 bar name is ABC-DEF
  public String bar_name;
  
  //Node names in the bar
  public final List<String> node_names;
  
  //Physical node names in the bar
  public final List<String> physical_node_names;

  //Not yet useful. Nodes attached to bar
  public ArrayList<Node> nodes = new ArrayList<Node>();

  //Not yet useful. Physical nodes attached to bar.
  public ArrayList<PhysicalNode> physical_nodes = new ArrayList<PhysicalNode>();


//TODO: Figure out the nasty static/etc models with this so these are just directly accessible as methods
//Right now this raises a java class error because model is not static and PhysicalBar is (Bar has the same issue)
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
  
  //A physical bar is a bar where a lot of physicists hang out.
  //Wait...
  public PhysicalBar(String id, String module_num, List<float[]> points, List<String> node_names,List<String> physical_node_names, int strip_num){
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
    this.strip_num = strip_num;
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
(or need to access just one module's specific instance of a node)
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


  //Node model linked to physical node. So, physical node ABC-1 is linked to node ABC
  public Node node(){
    Node nod = model.nodemap.get(this.node_name);
    return nod;
  }
  
  //Probably deprecated, failed approach, java class issues
  //List of nodes connected to physical node.
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

  //Physical node is the opposite of physical yes'd.
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
  }
}


