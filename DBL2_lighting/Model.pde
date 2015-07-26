/**
 * This is a model OF A BRAIN!
 */
import java.io.*;
import java.nio.file.*;
import java.util.*;

/**
 * This is the model for the whole brain. It contains four mappings, two of which users should use (Bar and Node)
 * and two which are set up to deal with the physical reality of the actual brain, double bars and double nodes
 * and so on. 
 * @author Alex Maki-Jokela
*/
public static class Model extends LXModel {

  //Note that these are stored in maps, not lists. 
  //Nodes are keyed by their three letter name ("LAB", "YAK", etc)
  //Bars are keyed by the two associated nodes in alphabetical order ("LAB-YAK", etc)
  public final SortedMap<String, Node> nodemap;
  public final SortedMap<String, Bar> barmap;

  public final List<String> bars_in_pixel_order;


  /** 
   * Constructor for Model. The parameters are all fed from Mappings.pde
   * @param nodemap is a mapping of node names to their objects
   * @param barmap is a mapping of bar names to their objects
   * @param bars_in_pixel_order is a list of the physical bars in order of LED indexes which is used for mapping them to LED strings
   */
  public Model(SortedMap<String, Node> nodemap, SortedMap<String, Bar> barmap, List<String> bars_in_pixel_order) {
    super(new Fixture(barmap, bars_in_pixel_order));
    this.nodemap = Collections.unmodifiableSortedMap(nodemap);
    this.barmap = Collections.unmodifiableSortedMap(barmap);
    this.bars_in_pixel_order = Collections.unmodifiableList(bars_in_pixel_order);
  }

  /**
  * Maps the points from the bars into the brain. Note that it iterates through bars_in_pixel_order
  * @param barmap is the map of bars
  * @param bars_in_pixel_order is the list of bar names in order LED indexes
  */
  private static class Fixture extends LXAbstractFixture {
    private Fixture(SortedMap<String, Bar> barmap, List<String> bars_in_pixel_order) {
      for (String barname : bars_in_pixel_order) {
        Bar bar = barmap.get(barname);
        if (bar != null) {
          for (LXPoint p : bar.points) {
            this.points.add(p);
          }
        }
      }
    }
  }

  /**
  * Chooses a random node from the model.
  */
  public Node getRandomNode() {
    //TODO: Instead of declaring a new Random every call, can we just put one at the top outside of everything?
    Random randomized = new Random();
    //TODO: Can this be optimized better? We're using maps so Processing's random function doesn't seem to apply here
    List<String> nodekeys = new ArrayList<String>(this.nodemap.keySet());
    String randomnodekey = nodekeys.get( randomized.nextInt(nodekeys.size()) );
    Node randomnode = this.nodemap.get(randomnodekey);
    return randomnode;
  }
  
  
 public Node getFirstNodeAnnaPattern() {
    
    List<String> nodekeys = new ArrayList<String>(this.nodemap.keySet());
    String randomnodekey = nodekeys.get(8);
    Node randomnode = this.nodemap.get(randomnodekey);
    return randomnode;
  }

  /**
  * Gets a random bar from the model
  * If I could write getRandomIrishPub and have it work, I would.
  */
  public Bar getRandomBar() {
    //TODO: Instead of declaring a new Random every call, can we just put one at the top outside of everything?
    Random randomized = new Random();
    //TODO: Can this be optimized better? We're using maps so Processing's random function doesn't seem to apply here
    List<String> barkeys = new ArrayList<String>(this.barmap.keySet());
    String randombarkey = barkeys.get( randomized.nextInt(barkeys.size()) );
    Bar randombar = this.barmap.get(randombarkey);
    return randombar;
  }

  /**
   * Gets a random point from the model.
   */
  public LXPoint getRandomPoint() {
    Random randomized = new Random();
    Bar r = getRandomBar();
    return r.points.get(randomized.nextInt(r.points.size()));
  }

  /**
   * Gets random points from the model.
   */
  public ArrayList<LXPoint> getRandomPoints(int num_requested) {
    Random randomized = new Random();
    ArrayList<LXPoint> returnpoints = new ArrayList<LXPoint>();
    
    while (returnpoints.size () < num_requested) {
      returnpoints.add(this.getRandomPoint());
    }
    
    return returnpoints;
  }

  /**
  * Returns an arraylist of randomly selected nodes from the model
  * @param num_requested: How many randomly selected nodes does the user want?
  */
  public ArrayList<Node> getRandomNodes(int num_requested) {
    Random randomized = new Random();
    ArrayList<String> returnnodstrs = new ArrayList<String>();
    ArrayList<Node> returnnods = new ArrayList<Node>();
    List<String> nodekeys = new ArrayList<String>(this.nodemap.keySet());
    if (num_requested > nodekeys.size()) {
      num_requested = nodekeys.size();
    }
    while (returnnodstrs.size () < num_requested) {
      String randomnodekey = nodekeys.get( int(randomized.nextInt(nodekeys.size())) );
      if (!(Arrays.asList(returnnodstrs).contains(randomnodekey))) {
        returnnodstrs.add(randomnodekey);
      }
    }
    for (String randnod : returnnodstrs) {
      returnnods.add(this.nodemap.get(randnod));
    }
    return returnnods;
  }

  /**
  * Returns an arraylist of randomly selected bars from the model
  * @param num_requested: How many randomly selected bars does the user want?
  */
  public ArrayList<Bar> getRandomBars(int num_requested) {
    Random randomized = new Random();
    ArrayList<String> returnbarstrs = new ArrayList<String>();
    ArrayList<Bar> returnbars = new ArrayList<Bar>();
    List<String> barkeys = new ArrayList<String>(this.nodemap.keySet());
    if (num_requested > barkeys.size()) {
      num_requested = barkeys.size();
    }
    while (returnbarstrs.size () < num_requested) {
      String randombarkey = barkeys.get( int(randomized.nextInt(barkeys.size())) );
      if (!(Arrays.asList(returnbarstrs).contains(randombarkey))) {
        returnbarstrs.add(randombarkey);
      }
    }
    for (String randbar : returnbarstrs) {
      returnbars.add(this.barmap.get(randbar));
    }
    return returnbars;
  }
}



/**
 * The Node class is the most useful tool for traversing the brain.
 * @param id: The node id ("BUG", "ZAP", etc)
 * @param x,y,z: The node xyz coords
 * @param ground: Is this node one of the ones on the bottom of the brain?
 * @param adjacent_bar_names: names of bars adjacent to this node
 * @param adjacent_node_names: names of nodes adjacent to this node
 * @param adjacent_bar_names: names of bars adjacent to this node
 * @param id: The node id ("BUG", "ZAP", etc)
*/
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
  
  //inner layer or outer layer?
  public final String inner_outer;
  
  //inner layer or outer layer?
  public final String left_right_mid;

  //List of bar IDs connected to node.
  public final List<String> adjacent_bar_names;

  //List of node IDs connected to node.
  public final List<String> adjacent_node_names;


  //Declurrin' some arraylists
  public ArrayList<Bar> adjacent_bars = new ArrayList<Bar>();
  public ArrayList<Node> adjacent_nodes = new ArrayList<Node>();



  
  public Node(String id, float x, float y, float z, List<String> adjacent_bar_names, List<String> adjacent_node_names, boolean ground, String inner_outer, String left_right_mid) {
    this.id=id;
    this.x=x;
    this.y=y;
    this.z=z;
    this.adjacent_bar_names=adjacent_bar_names;
    this.adjacent_node_names = adjacent_node_names;
    this.ground = ground;
    this.inner_outer=inner_outer;
    this.left_right_mid=left_right_mid;
    this.adjacent_bars = new ArrayList<Bar>();
    this.adjacent_nodes = new ArrayList<Node>();
  }


  public void initialize_model_connections(){
    for (String abn : this.adjacent_bar_names){
      this.adjacent_bars.add(model.barmap.get(abn));
    }
    for (String ann : this.adjacent_node_names) {
      this.adjacent_nodes.add(model.nodemap.get(ann));
    }
  }


  /**
  * Returns one adjacent node
  */ 
    public Node random_adjacent_node() {
    String randomnodekey = adjacent_node_names.get( int(random(adjacent_node_names.size())) );
    Node returnnod=model.nodemap.get(randomnodekey);
    return returnnod;
  }

  /**
   * Returns an ArrayList of randomly selected adjacent nodes. 
   * @param num_requested: How many random adjacent nodes to return
   */
  public ArrayList<Node> random_adjacent_nodes(int num_requested) {
    ArrayList<String> returnnodstrs = new ArrayList<String>();
    ArrayList<Node> returnnods = new ArrayList<Node>();
    if (num_requested > this.adjacent_node_names.size()) {
      num_requested = this.adjacent_node_names.size();
    }
    while (returnnodstrs.size () < num_requested) {
      String randomnodekey = adjacent_node_names.get( int(random(adjacent_node_names.size())) );
      if (!(Arrays.asList(returnnodstrs).contains(randomnodekey))) {
        returnnodstrs.add(randomnodekey);
      }
    }
    for (String randnod : returnnodstrs) {
      returnnods.add(model.nodemap.get(randnod));
    }
    return returnnods;
  }



  /**
  * Returns one adjacent bar
  */ 
  public Bar random_adjacent_bar() {
    String randombarkey = adjacent_bar_names.get( int(random(adjacent_bar_names.size())) );
    Bar returnbar=model.barmap.get(randombarkey);
    return returnbar;
  }


  /**
   * Returns an ArrayList of randomly selected adjacent bars. 
   * @param num_requested: How many random adjacent bars to return
   */
  public ArrayList<Bar> random_adjacent_bars(int num_requested) {
    ArrayList<String> returnbarstrs = new ArrayList<String>();
    ArrayList<Bar> returnbars = new ArrayList<Bar>();
    if (num_requested > this.adjacent_bar_names.size()) {
      num_requested = this.adjacent_bar_names.size();
    }
    while (returnbarstrs.size () < num_requested) {
      String randombarkey = adjacent_bar_names.get( int(random(adjacent_bar_names.size())) );
      if (!(Arrays.asList(returnbarstrs).contains(randombarkey))) {
        returnbarstrs.add(randombarkey);
      }
    }
    for (String randbar : returnbarstrs) {
      returnbars.add(model.barmap.get(randbar));
    }
    return returnbars;
  }

  //List of adjacent bars
  public ArrayList<Bar> adjacent_bars() {
    ArrayList<Bar> baarrs = new ArrayList<Bar>();
    for (String pnn : this.adjacent_bar_names) {
      baarrs.add(model.barmap.get(pnn));
    }
    return baarrs;
  }
  
  //List of adjacent bars.
  public ArrayList<Node> adjacent_nodes() {
    ArrayList<Node> nods = new ArrayList<Node>();
    for (String pnn : this.adjacent_node_names) {
      nods.add(model.nodemap.get(pnn));
    }
    return nods;
  }
  
  //List of nearby points. No specific order.
  public List<LXPoint> adjacent_bar_points() {
    ArrayList<Bar> bars=this.adjacent_bars();
    List<LXPoint> returnpoints = new ArrayList<LXPoint>();
    for (Bar b : bars){
      for (LXPoint p : b.points){
        returnpoints.add(p);
      }
    }
    return returnpoints;
  }

  //written by Anna in the July 2015 Hackathon
  public Node getNextNodeByVector(PVector v2) {
      
      //go through adjacent nodes to find ones in the right direction 
      //closest to the direction vector, so that product of the vectors is small
      List<Node> nodeCandidates;
      PVector v1; 
      PVector v3;
     // float goalAngle;
      
    //the angle we want is the angle between firstNode and V2, and we want our new node to be in the same direction
      //v3 = new PVector(firstNode.x, firstNode.y,firstNode.z);
      //goalAngle = PVector.angleBetween(v2,v3); //angle between cur node and destination
      
    //get candidates
      nodeCandidates= this.adjacent_nodes;
      
      //pull out first node candidate,pretend it is best 
      Node bestNode = nodeCandidates.get(0);
      v1 = new PVector(bestNode.x,bestNode.y,bestNode.z);
      float d = PVector.dist(v1,v2);
      float bestd = d; 

      //look for best node by comp with first candidate
       for (Node curCandidate : nodeCandidates ){

          v1 = new PVector(curCandidate.x,curCandidate.y,curCandidate.z);
          d = abs(PVector.dist(v1,v2));
        // println(d);    
        //we want do to be as close to zero as possible 
          if(d<bestd){
           bestd = d;
           bestNode = curCandidate; 
            
          }
        }
    return bestNode;
  }



}






/**
 * The Bar class is the second-most-useful tool for traversing the brain.
 * @param id: The bar id ("BUG-ZAP", etc)
 * @param min_x,min_y,min_z: The minimum node xyz coords
 * @param max_x,max_y,max_z: The maximum node xyz coords
 * @param ground: Is this bar one of the ones on the bottom of the brain?
 * @param module_names: Which modules is this bar in? (can be more than one if it's a double-bar)
 * @param node_names: Nodes contained in this bar
 * @param adjacent_bar_names: names of bars adjacent to this node
 * @param adjacent_node_names: names of nodes adjacent to this node
 * @param adjacent_bar_names: names of bars adjacent to this node
*/
public static class Bar extends LXModel {

  //bar name
  public final String id;

  //min and max xyz of bar TODO make these work again
  public final float min_x;
  public final float min_y;
  public final float min_z;
  public final float max_x;
  public final float max_y;
  public final float max_z;

  public final float angle_with_vertical;
  public final float angle_with_horizontal;

  //Is it on the ground? (or bottom of brain)
  public final boolean ground;

  //Inner bar? Outer bar? Mid bar?
  public final String inner_outer_mid;
  
  //Left Hemisphere? Right Hemisphere? Fissure?
  public final String left_right_mid;

  //list of strings of modules that this bar is in.
  public final String module;

  //List of node IDs connected to bar.
  //This is always exactly two elements, and:
  //this.id == this.node_names[0] + "-" + this.node_names[1]
  public final List<String> node_names;

  //List of bar IDs connected to our two adjancent nodes.
  public final List<String> adjacent_bar_names;

  //List of node IDs connected to adjacent_bar_names.
  public final List<String> adjacent_node_names;


  //Bar nodes
  public ArrayList<Node> nodes = new ArrayList<Node>();

  //Adjacent nodes to bar
  public ArrayList<Node> adjacent_nodes = new ArrayList<Node>();

  //Adjacent bars to bar
  public ArrayList<Bar> adjacent_bars = new ArrayList<Bar>();
  
  //what strip number?
  public int strip_id;


   
  //This bar is open to the public.
  public Bar(String id, List<float[]> points, float min_x,float min_y,float min_z,float max_x,float max_y,float max_z, String module, List<String> node_names,
  List<String> adjacent_node_names, List<String> adjacent_bar_names, boolean ground, String inner_outer_mid, String left_right_mid, int strip_id) {
    super(new Fixture(points));
    this.id=id;
    this.module=module;
    this.min_x=min_x;
    this.min_y=min_y; 
    this.min_z=min_z;
    this.max_x=max_x;
    this.max_y=max_y;
    this.max_z=max_z;
    float dx = this.max_x-this.min_x;
    float dy = this.max_y-this.min_y;
    float dz = this.max_z-this.min_z;
    float dxy = sqrt(sq(dx)+sq(dy));
    float raw_angle= PVector.angleBetween(new PVector(dx,dy,dz),new PVector(0,0,1));
    this.angle_with_vertical=min(raw_angle,PI-raw_angle);
    this.angle_with_horizontal=PI-this.angle_with_vertical;
    this.inner_outer_mid = inner_outer_mid;
    this.left_right_mid = left_right_mid;
    this.node_names = node_names;
    this.adjacent_node_names=adjacent_node_names;
    this.adjacent_bar_names=adjacent_bar_names;
    this.ground = ground;
    this.nodes = new ArrayList<Node>();
    this.adjacent_bars = new ArrayList<Bar>();
    this.adjacent_nodes = new ArrayList<Node>();
    this.strip_id=strip_id;
  }


   private static class Fixture extends LXAbstractFixture {
    private Fixture(List<float[]> points) {
      for (float[] p : points ) {
        LXPoint point=new LXPoint(p[0], p[1], p[2]);
        this.points.add(point);
      }
    }
  }

  public void initialize_model_connections(){
    for (String nn : this.node_names) {
      this.nodes.add(model.nodemap.get(nn));
    }
    for (String abn : this.adjacent_bar_names){
      this.adjacent_bars.add(model.barmap.get(abn));
    }
    for (String ann : this.adjacent_node_names) {
      this.adjacent_nodes.add(model.nodemap.get(ann));
    }
  }

  //List of adjacent bars
  public ArrayList<Bar> adjacent_bars() {
    ArrayList<Bar> adj_bars = new ArrayList<Bar>();
    for (String abn : this.adjacent_bar_names) {
      adj_bars.add(model.barmap.get(abn));
    }
    return adj_bars;
  }

  //Returns angle between bars. Bars must be adjacent
  //in radians
  public float angle_with_bar(Bar other_bar){
    if (!(this.adjacent_bars.contains(other_bar))){
      throw new IllegalArgumentException("Bars must be adjacent!");
    }
    return angleBetweenTwoBars(this,other_bar);
  }
}


/**
* Returns a list of LXPoints between two adjacent nodes, in order.
* e.g. if you wanted to get the nodes in order from ZAP to BUG (reverse alphabetical order) this is what you'd use
* reminder: by default the points always go in alphabetical order from one node to another
* returns null if the nodes aren't adjacent.
* @param node1: Start node
* @param node2: End node
*/
public static List<LXPoint> nodeToNodePoints(Node node1, Node node2) {
  String node1name = node1.id;
  String node2name = node2.id;
  int reverse_order = node1name.compareTo(node2name); //is this going in reverse order? 
  String barname;
  if (reverse_order<0) {
    barname = node1name + "-" + node2name;
  } else {
    barname = node2name + "-" + node1name;
  }
  Bar ze_bar = model.barmap.get(barname);

  if (ze_bar == null) { //the bar doesnt exist (non adjacent nodes etc)
    throw new IllegalArgumentException("Nodes must be adjacent!");
  } else {
    if (reverse_order>0) {
      List<LXPoint> zebarpoints = new ArrayList(ze_bar.points);
      Collections.reverse(zebarpoints);
      return zebarpoints;
    } else {
      return ze_bar.points;
    }
  }
}

/**
 * Given two nodes, return the bar between them, or null if they are not
 * directly connected. Simple but useful.
 * @param node1: a node
 * @param node2: another node.
*/
public static Bar barBetweenNodes(Node node1, Node node2){
  String node1name=node1.id;
  String node2name=node2.id;
  int reverse_order = node1name.compareTo(node2name);
  String barname;
  if (reverse_order<0) {
    barname = node1name + "-" + node2name;
  } else {
    barname = node2name + "-" + node1name;
  }
  if (model.barmap.keySet().contains(barname)){
      return model.barmap.get(barname);
  }
  return null;
}


/**
 * Given two nodes, see if they form a bar.
 * Simple but useful.
 * @param node1: a node
 * @param node2: another node.
*/
public static boolean twoNodesMakeABar(Node node1, Node node2){
  return barBetweenNodes(node1, node2) != null;
}


/**
 * Given two bars with a common node, find that node. Bars must be adjacent.
 * Simple but useful.
 * @param bar1: a bar
 * @param bar2: a connected bar
*/
public static Node sharedNode(Bar bar1, Bar bar2){
  List<Node> allnodes = new ArrayList<Node>();
  for (Node n : bar1.nodes){
    allnodes.add(n);
  }
  for (Node n : bar2.nodes){
    allnodes.add(n);
  }
  for (Node n : allnodes) {
    if (bar1.nodes.contains(n) && bar2.nodes.contains(n)) {
      return n;
    }
  }
  return null; //no matches :(
}

/**
 * Given a bar and a node in that bar, gets the other node from that bar.
 * Simple but useful.
 * @param bar: a bar
 * @param node: a node in that bar
*/
public static Node otherNode(Bar bar, Node node){
  if (bar.nodes.contains(node)){
    for (Node n : bar.nodes){
      if (!(n.id.equals(node.id))){
        return n;
      }
    } 
    throw new IllegalArgumentException("Something is wrong with the bar model.");
  }
  else{
    throw new IllegalArgumentException("Node must be in bar");
  }
}

/**
 * Gets the angle formed by two bars. They must be adjacent to each other.
 * @param Bar1: First bar
 * @param Bar2: Second bar
*/
public static float angleBetweenTwoBars(Bar bar1, Bar bar2){
  if (bar1.adjacent_bars.contains(bar2)){
    Node common_node = sharedNode(bar1,bar2);
    Node node1 = otherNode(bar1,common_node);
    Node node3 = otherNode(bar2,common_node);
    return angleBetweenThreeNodes(node1,common_node,node3);
  } else {
    throw new IllegalArgumentException("Bars must be adjacent!");
  }
}

/**
 * Gets the angle formed by three nodes. They must be adjacent to each other and connected via a bar.
 * @param Node1: The first node
 * @param Node2: The second node (the one where the angle is formed)
 * @param Node3: The third node
*/
public static float angleBetweenThreeNodes(Node node1,Node node2,Node node3){
  if (twoNodesMakeABar(node1,node2) && twoNodesMakeABar(node2,node3)){
    float dx1=node1.x-node2.x;
    float dy1=node1.y-node2.y;
    float dz1=node1.z-node2.z;
    float dx2=node3.x-node2.x;
    float dy2=node3.y-node2.y;
    float dz2=node3.z-node2.z;
    PVector vect1=new PVector(dx1,dy1,dz1);
    PVector vect2=new PVector(dx2,dy2,dz2);
    return PVector.angleBetween(vect1,vect2);
  } else{
    throw new IllegalArgumentException("Nodes must be adjacent!");
  }
}


/******************************************************************************/
/* Image mapping                                                              */
/******************************************************************************/


/**
 * Class for mapping images onto the brain.
 * Operates by doing all the math for which pixels in the image map to which pixels on the brain, once
 * Then shifts things around by changing the pixels in the image.
 * TODO: Could use some optimization magic. Does unkind things to the framerate.
 * @param imagecolors is a Processing PImage which stores the image
 * @param cartesian_canvas defines what coordinate system the image gets mapped to
 * @param imagedims is the dimensions of the image in pixels
 * @param compress_pct compresses the image by a certain percent to improve performance.  Will vary by image and machine.
*/ 
public class MentalImage {

  PImage imagecolors;
  String cartesian_canvas;
  int w;
  int h;
  
  SortedMap<Integer, int[]> pixel_to_pixel = new TreeMap<Integer, int[]>();
  SortedMap<Integer, float[]> led_colors = new TreeMap<Integer, float[]>();

  //Constructor for class
  public MentalImage(String imagepath, String cartesian_canvas, int compress_pct){
      this.imagecolors = loadImage(imagepath);
      loadPixels();
      this.imagecolors.resize(this.imagecolors.width*compress_pct/100,0);
      this.cartesian_canvas=cartesian_canvas;
      this.imagecolors.loadPixels();
      this.w=imagecolors.width;
      this.h=imagecolors.height;
      //Map the points in the image to the model, once.
      for (LXPoint p : model.points) {
        int[] point_loc_in_img=scaleLocationInImageToLocationInBrain(p);
        this.pixel_to_pixel.put(p.index,point_loc_in_img);
      }
  }

  /**
  * Outputs one frame of the image in its' current state to the pixel mapping.
  * @param colors: The master colors array
  */
  public int[] ImageToPixels(int[] colors){
    color pixelcolor;
    float[] hsb_that_pixel;
    int[] loc_in_img;
    for (LXPoint p : model.points) {
      loc_in_img = scaleLocationInImageToLocationInBrain(p);
      pixelcolor = this.imagecolors.get(loc_in_img[0],loc_in_img[1]);
      colors[p.index]= lx.hsb(hue(pixelcolor),saturation(pixelcolor),brightness(pixelcolor));
    }
    return colors;
  }


  /**
  * Outputs one frame of the image in its' current state to the pixel mapping.
  * Current preferred method for using moving images. Faster than translating the image under the mapping.
  * @param colors: The master colors array
  */
  public int[] shiftedImageToPixels(int[] colors, float xpctshift,float ypctshift){
    color pixelcolor;
    float[] hsb_that_pixel;
    int[] loc_in_img;
    for (LXPoint p : model.points) {
      loc_in_img = scaleShiftedLocationInImageToLocationInBrain(p,xpctshift,ypctshift);
      pixelcolor = this.imagecolors.get(loc_in_img[0],loc_in_img[1]);
      colors[p.index]= lx.hsb(hue(pixelcolor),saturation(pixelcolor),brightness(pixelcolor));
    }
    return colors;
  }



  /**
  * Translates the image in either the x or y axis. 
  * Important to note that this is operating on the image itself, not on the pixel mapping, so it's just x and y
  * This seems to get worse performance than just recalculating the LED pixels across different positions in the image if looped.
  * Automatically wraps around.
  * @param which_axis: x or y or throw exception
  * @param pctrate: How much percentage of the image to translate?
  */
  public void translate_image(String which_axis, float pctrate) { //String which_axis, float percent, boolean wrap
    PImage translate_buffer;
    if (which_axis.equals("x")) {
      translate_buffer=imagecolors; 
      int rate = int(imagecolors.width*(pctrate/100.0));
      for (int imgy = 0; imgy < imagecolors.height; imgy++) {
        for (int inc = 1; inc < rate+1; inc++) {
          imagecolors.set(imagecolors.width-inc,imgy,translate_buffer.get(0,imgy));
        }
      }
  
      for (int imgx = 0; imgx < imagecolors.width-rate; imgx++ ) {
        for (int imgy = 0; imgy < imagecolors.height; imgy++) {
          imagecolors.set(imgx,imgy,translate_buffer.get(imgx+rate,imgy));
        }
      }
    } else if (which_axis.equals("y")){
      translate_buffer=imagecolors; 
      int rate = int(imagecolors.height*(pctrate/100.0));
      for (int imgx = 0; imgx < imagecolors.width; imgx++) {
        for (int inc = 1; inc < rate+1; inc++) {
          imagecolors.set(imgx,imagecolors.height-inc,translate_buffer.get(imgx,0));
        }
      }
  
      for (int imgy = 0; imgy < imagecolors.height-rate; imgy++ ) {
        for (int imgx = 0; imgx < imagecolors.width; imgx++) {
          imagecolors.set(imgx,imgy,translate_buffer.get(imgx,imgy+rate));
        }
      }
    } else{
      throw new IllegalArgumentException("Axis must be x or y. Image axis, not model axis :)");
    }
  }

  /**
  * Returns the coordinates for an LXPoint p (which has x,y,z) that correspond to a location on an image based on the coordinate system 
  * @param p: The LXPoint to get coordinates for.
  */
  private int[] scaleLocationInImageToLocationInBrain(LXPoint p) {
    float[][] minmaxxy;
    float newx;
    float newy;
    if (this.cartesian_canvas.equals("xy")){
      minmaxxy=new float[][]{{model.xMin,model.xMax},{model.yMin,model.yMax}};
      newx=(1-(p.x-minmaxxy[0][0])/(minmaxxy[0][1]-minmaxxy[0][0]))*this.w;
      newy=(1-(p.y-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))*this.h;
    }
    else if (this.cartesian_canvas.equals("xz")){
      minmaxxy=new float[][]{{model.xMin,model.xMax},{model.zMin,model.zMax}};
      newx=(1-(p.x-minmaxxy[0][0])/(minmaxxy[0][1]-minmaxxy[0][0]))*this.w;
      newy=(1-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))*this.h;
    }
    else if (this.cartesian_canvas.equals("yz")){
      minmaxxy=new float[][]{{model.yMin,model.yMax},{model.zMin,model.zMax}};
      newx=(1-(p.y-minmaxxy[0][0])/(minmaxxy[0][1]-minmaxxy[0][0]))*this.w;
      newy=(1-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))*this.h;
    }
    else if (this.cartesian_canvas.equals("cylindrical_x")){
      minmaxxy=new float[][]{{model.xMin,model.xMax},{model.xMin,model.xMax}};
      newx=(1-((atan2(p.z,p.y)+PI)/(2*PI)))*this.w;
      newy=(1-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))*this.h;
    }
    else if (this.cartesian_canvas.equals("cylindrical_y")){
      minmaxxy=new float[][]{{model.yMin,model.yMax},{model.yMin,model.yMax}};
      newx=(1-((atan2(p.z,p.x)+PI)/(2*PI)))*this.w;
      newy=(1-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))*this.h;
    }
    else if (this.cartesian_canvas.equals("cylindrical_z")){
      minmaxxy=new float[][]{{model.zMin,model.zMax},{model.zMin,model.zMax}};
      newx=(1-((atan2(p.y,p.x)+PI)/(2*PI)))*this.w;
      newy=(1-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))*this.h;
    }
    else{
      throw new IllegalArgumentException("Must enter plane xy, xz, yz, or cylindrical_x/y/z");
    }
      int newxint=(int)newx;
      int newyint=(int)newy;
      if (newxint>=this.w){
         newxint=newxint-1;
      }
      if (newxint<=0){
         newxint=newxint+1;
      }
      if (newyint>=this.h){
         newyint=newyint-1;
      }
      if (newyint<=0){
         newyint=newyint+1;
      }
      int[] result = new int[] {newxint,newyint};
      return result;
  }





  /**
  * Returns the SHIFTED coordinates for an LXPoint p (which has x,y,z) that correspond to a location on an image based on the coordinate system 
  * This seems to get better performance in the run loop than using translate on the image repetitively.
  * @param p: The LXPoint to get coordinates for.
  * @param xpctshift: How far to move the image in the x direction, as a percent of the image width
  * @param ypctshift: How far to move the image in the y direction, as a percent of the image height
  */
  private int[] scaleShiftedLocationInImageToLocationInBrain(LXPoint p, float xpctshift, float ypctshift) {
    float[][] minmaxxy;
    float newx;
    float newy;
    if (this.cartesian_canvas.equals("xy")){
      minmaxxy=new float[][]{{model.xMin,model.xMax},{model.yMin,model.yMax}};
      newx=(1+xpctshift-(p.x-minmaxxy[0][0])/(minmaxxy[0][1]-minmaxxy[0][0]))%1.0*this.w;
      newy=(1+ypctshift-(p.y-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))%1.0*this.h;
    }
    else if (this.cartesian_canvas.equals("xz")){
      minmaxxy=new float[][]{{model.xMin,model.xMax},{model.zMin,model.zMax}};
      newx=(1+xpctshift-(p.x-minmaxxy[0][0])/(minmaxxy[0][1]-minmaxxy[0][0]))%1.0*this.w;
      newy=(1+ypctshift-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))%1.0*this.h;
    }
    else if (this.cartesian_canvas.equals("yz")){
      minmaxxy=new float[][]{{model.yMin,model.yMax},{model.zMin,model.zMax}};
      newx=(1+xpctshift-(p.y-minmaxxy[0][0])/(minmaxxy[0][1]-minmaxxy[0][0]))%1.0*this.w;
      newy=(1+ypctshift-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))%1.0*this.h;
    }
    else if (this.cartesian_canvas.equals("cylindrical_x")){
      minmaxxy=new float[][]{{model.xMin,model.xMax},{model.xMin,model.xMax}};
      newx=(1+xpctshift-((atan2(p.z,p.y)+PI)/(2*PI)))%1.0*this.w;
      newy=(1+ypctshift-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))%1.0*this.h;
    }
    else if (this.cartesian_canvas.equals("cylindrical_y")){
      minmaxxy=new float[][]{{model.yMin,model.yMax},{model.yMin,model.yMax}};
      newx=(1+xpctshift-((atan2(p.z,p.x)+PI)/(2*PI)))%1.0*this.w;
      newy=(1+ypctshift-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))%1.0*this.h;
    }
    else if (this.cartesian_canvas.equals("cylindrical_z")){
      minmaxxy=new float[][]{{model.zMin,model.zMax},{model.zMin,model.zMax}};
      newx=(1+xpctshift-((atan2(p.y,p.x)+PI)/(2*PI)))%1.0*this.w;
      newy=(1+ypctshift-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))%1.0*this.h;
    }
    else{
      throw new IllegalArgumentException("Must enter plane xy, xz, yz, or cylindrical_x/y/z");
    }
      int newxint=int((newx % this.w+this.w)%this.w);
      int newyint=int((newy % this.h+this.h)%this.h);
      int[] result = new int[] {newxint,newyint};
      return result;
  }
}


/******************************************************************************/
/* LXPoint-to-model mapping                                                   */
/******************************************************************************/

private static Bar[] _pointToBarMap;
private static int[] _pointToIndexMap;

private static void _ensurePointToModelMap() {
  if (_pointToBarMap != null)
      return; // already initialized

  _pointToBarMap = new Bar[model.points.size()];
  _pointToIndexMap = new int[model.points.size()];

  for (String key : model.barmap.keySet()) {
    Bar bar = model.barmap.get(key);
    int i = 0;
    for (LXPoint point : bar.points) {
      _pointToBarMap[point.index] = bar;
      _pointToIndexMap[point.index] = i;
      i++;
    }
  }
}

// Return the Bar that contains the given point.
public static Bar barForPoint(LXPoint point) {
  _ensurePointToModelMap();
  return _pointToBarMap[point.index];
}

// Return the index of the point in the bar that contains it.
public static int barIndexForPoint(LXPoint point) {
  _ensurePointToModelMap();
  return _pointToIndexMap[point.index];
}


/******************************************************************************/
/* Walks                                                                      */
/******************************************************************************/

// This performs a walk where we start at a particular point, and then
// walk a point at a time around the edge of the brain, changing
// directions randomly when we hit a node (but never doubling back).
public class SemiRandomWalk {
  private LXPoint where;
  Node fromNode, toNode;
  Bar currentBar;
  int index;
  double fractionalStep;

  public SemiRandomWalk(LXPoint start) {
    where = start;
    currentBar = barForPoint(where);
    boolean direction = new Random().nextBoolean();
    fromNode = currentBar.nodes.get(direction ? 0 : 1);
    toNode = currentBar.nodes.get(direction ? 1 : 0);
    index = direction ?
        barIndexForPoint(where) :
        currentBar.points.size() - barIndexForPoint(where) - 1;
    fractionalStep = 0;
  }

  // Step forward in the walk by n points, and return the new position.
  //
  // You can pass a fractional number of steps. They will accumulate
  // over subsequent calls to step().
  public LXPoint step(double n) {
    fractionalStep += n;
    int stepsToTake = (int)Math.floor(fractionalStep);
    fractionalStep = fractionalStep % 1.0;

    while (stepsToTake > 0) {
      int barLength = currentBar.points.size();
      int steps = Math.min(stepsToTake, barLength - 1 - index);
      stepsToTake -= steps;
      index += steps;

      if (index == barLength - 1 && stepsToTake > 0) {
        // Step across the node to a different bar
        Node oldFromNode = fromNode;
        fromNode = toNode;
        do {
          toNode = fromNode.random_adjacent_node();
        } while (angleBetweenThreeNodes(oldFromNode, fromNode, toNode)
                   < 4*PI/360*3); // don't go back the way we came
        currentBar = barBetweenNodes(fromNode, toNode);
        index = 0;
        stepsToTake --;
      }
    }

    List<LXPoint> points = nodeToNodePoints(fromNode, toNode);
    where = points.get(index);
    return where;
  }
}


/******************************************************************************/
/* Distance fields                                                            */
/******************************************************************************/

/**
 * Given a point, return the shortest distance from that point to all other
 * points.
 *
 * Distance is measured like an ant walking across the bars, counting
 * one unit of distance for each LED.
 *
 * Returns the distance from the input point to every other point, as
 * an array set up the same way as 'colors' (indexed by the 'index'
 * property of LXPoint).
 *
 * @author Geoff Schmidt
 */

public static int[] distanceFieldFromPoint(LXPoint startPoint) {
  class Route {
    Node toNode;
    int distanceSoFar;
    Route previous;

    Route(Node _toNode, int _distanceSoFar, Route _previous) {
      toNode = _toNode;
      distanceSoFar = _distanceSoFar;
      previous = _previous;
    }
  }

  class RouteDistanceComparator implements Comparator<Route> {
    @Override
    public int compare(Route x, Route y) {
      if (x.distanceSoFar < y.distanceSoFar)
        return -1;
      if (x.distanceSoFar > y.distanceSoFar)
        return 1;
      return 0;
    }
  }

  Comparator<Route> comparator = new RouteDistanceComparator();
  PriorityQueue<Route> queue = new PriorityQueue<Route>(100, comparator);

  int[] distances = new int[model.points.size()];
  Map<String, Route> shortestRoute = new HashMap<String, Route>();

  // Handle the starting point and the edge it's on
  Bar startBar = barForPoint(startPoint);
  int startIndex = barIndexForPoint(startPoint);

  int i = 0;
  for (LXPoint p : startBar.points) {
    distances[p.index] = Math.abs(startIndex - i);
    i++;
  }
  queue.add(new Route(startBar.nodes.get(0), startIndex + 1, null));
  queue.add(new Route(startBar.nodes.get(1),
                      startBar.points.size() - startIndex,
                      null));

  // Get distance to every node
  while (queue.size() != 0 && shortestRoute.size() != model.barmap.size()) {
    Route r = queue.remove();

    if (shortestRoute.containsKey(r.toNode.id))
      continue; // already found a shorter path here
    shortestRoute.put(r.toNode.id, r);
    /*
    System.out.format("%s: %d away (via %s)\n",
                      r.toNode.id, r.distanceSoFar,
                      r.previous == null ? "start" : r.previous.toNode.id);
    */

    for (Bar nextBar : r.toNode.adjacent_bars) {
      Node otherEnd =
          nextBar.nodes.get(0) == r.toNode ? nextBar.nodes.get(1) :
                                             nextBar.nodes.get(0);
      if (shortestRoute.containsKey(otherEnd.id))
        continue;
      queue.add(new Route(otherEnd, r.distanceSoFar + nextBar.points.size(),
                          r));
    }
  }

  // Get distance to every point
  for (String key : model.barmap.keySet()) {
    Bar b = model.barmap.get(key);
    if (b == startBar)
        continue; // already did this one

    int node0Dist = shortestRoute.get(b.nodes.get(0).id).distanceSoFar;
    int node1Dist = shortestRoute.get(b.nodes.get(1).id).distanceSoFar;
    /*
    System.out.format("%s (%d) to %s (%d):\n",
                      b.nodes.get(0).id, node0Dist,
                      b.nodes.get(1).id, node1Dist);
    */
    i = 0;
    for (LXPoint p : b.points) {
      int d1 = i + node0Dist;
      int d2 = (startBar.points.size() - 1 - i) + node1Dist;
      distances[p.index] = Math.min(d1, d2);
      /*
      System.out.format("  %d: %d (%d vs %d) @%d\n", i, distances[p.index],
                        d1, d2, p.index);
      */
      i++;
    }
  }

  return distances;
}
