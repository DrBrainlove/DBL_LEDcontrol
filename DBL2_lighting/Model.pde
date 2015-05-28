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

public final SortedMap<String, PhysicalBar> physicalbarmap;
public final SortedMap<String, Node> nodemap;
public final SortedMap<String, PhysicalNode> physicalnodesmap;

public Model(SortedMap<String, PhysicalBar> physicalbarmap, SortedMap<String, Node> nodemap, SortedMap<String,PhysicalNode> physicalnodesmap) {
    super(new Fixture(physicalbarmap));
    this.physicalbarmap = Collections.unmodifiableSortedMap(physicalbarmap);
    this.nodemap = Collections.unmodifiableSortedMap(nodemap);
    this.physicalnodesmap = Collections.unmodifiableSortedMap(physicalnodesmap);
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

/*
 * Returns an ordered list of points between any two adjacent nodes
 * If the two nodes have a double bar between them, it will by default return just the top bar
 * If explicitly calling both double bars is the intent, use getAllPointsBetweenTwoNodes
 */

/*
  public List<LXPoint> getPointsBetweenTwoNodes(Node startnode, Node endnode){
  }
  
*/
/*
 * Returns an ordered list of points between any two adjacent nodes with defined modules
 * Since module numbers are explicit, not possible to call a double bar (though you can call one bar of a pair)
 * If explicitly calling both double bars is the intent, use getAllPointsBetweenTwoNodes
 */
 
 /*
  public List<LXPoint> getPointsBetweenTwoNodesWithModuleNums(PhysicalNode startnode, PhysicalNode endnode){
    
    //figures out if the two bars are in alphabetical order. (points are listed in alpha order, so if it's reversed the order is reversed)
    boolean alphabetical_order = startnode.id > endnode.id;
     = GetPhysicalBarFromTwoNodesWithModuleNums(startnode, endnode);
    //figure out what bar they are
  }
  
  */
/*
 * Returns an ordered list of lists of points between any two adjacent nodes with defined modules
 * IMPORTANT: RETURNS A LIST OF LISTS OF POINTS, NOT JUST A LIST OF POINTS, even if there's only one bar.
 * If explicitly calling both double bars is the intent, use this.
 */
 /*
  public List<List<LXPoint>> getPointsBetweenTwoNodesWithModuleNums(Node startnode, Node endnode){
  }
  */
  
  
}

/*
public static class Bar extends LXModel {




}*/  



//WRITE BAR CLASS HERE





//Use this
public class Node extends LXModel {

  //Node number with module number
  public final String id;
  
  //xyz position of node
  //If it's a double or triple node, returns the coordinates of the highest-z-position instance of the node
  public final float x;
  public final float y;
  public final float z;
  public final boolean ground;
  
  //List of bar IDs connected to node.
  public final List<String> adjacent_bar_names;
  
  

  
  //Do not use unless you have a good reason to
  //List of bar IDs connected to node with module nums. (for dealing with double bars etc)
  public final List<String> adjacent_physical_bar_names;

  //Do not use unless you have a good reason to
  //Sometimes there are more than one physical node per node because they have the same label but are in different modules
  public final List<String> adjacent_physical_node_names;

  //List of adjacent bars. (Status: TEST, not sure if this'll work well.)
  //FUCK YEAH. It does. For now.
//  public ArrayList<Bar> adjacent_bars(){
//    ArrayList<Bar> baarrs = new ArrayList<Bar>();
//    for (String pnn : this.adjacent_bar_names){
//      baarrs.add(model.physicalbarmap.get(pnn));
//    }
 //   return baarrs;
 // }

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
  public ArrayList<PhysicalNode> adjacent_physical_nodes(){
    ArrayList<PhysicalNode> pnodes = new ArrayList<PhysicalNode>();
    for (String pnn : this.adjacent_physical_node_names){
      pnodes.add(model.physicalnodesmap.get(pnn));
    }
    return pnodes;
  }
  

  public Node(String id, float x, float y, float z, List<String> adjacent_physical_bar_names, List<String> adjacent_bar_names, List<String> adjacent_physical_node_names, boolean ground){
    this.id=id;
    this.x=x;
    this.y=y;
    this.z=z;
    this.adjacent_physical_bar_names=adjacent_physical_bar_names;
    this.adjacent_bar_names=adjacent_bar_names;
    this.adjacent_physical_node_names = adjacent_physical_node_names;
    this.ground = ground;
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
This is just for mapping the physical bars (e.g. ABC-DEF-1 is module 1)
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
  
  //
  //public final float xmin;
  //public final float ymin;
  //public final float zmin;
  //public final float xmax;
  //public final float ymax;
  //public final float zmax;

  public String bar_name;

  //public Bar bar;
  
  public final List<String> node_names;
  
  public final List<String> physical_node_names;
/*
  public ArrayList<Node> nodes(){
    ArrayList<Node> nods = new ArrayList<Node>();
    for (String nn : this.node_names){
      nods.add(model.nodesmap.get(nn));
    }
    return nods;
  }
    
  
  public ArrayList<PhysicalNode> physical_nodes(){
    ArrayList<PhysicalNode> pnodes = new ArrayList<PhysicalNode>();
    for (String pnn : this.physical_node_names){
      pnodes.add(model.physicalnodesmap.get(pnn));
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
  
  //xyz position of node
  public final float x;
  public final float y;
  public final float z;
  public final boolean ground;
  
  //List of bar IDs connected to node.
  public final List<String> adjacent_bar_names;
  
  //List of bar IDs connected to node with module nums. (for dealing with double bars etc)
  public final List<String> adjacent_physical_bar_names;
  

  //List of node IDs connected to node with module nums. (for dealing with double nodes etc)
  public final List<String> adjacent_node_names;
  
  
  //List of node IDs connected to node with module nums. (for dealing with double nodes etc)
  public final List<String> adjacent_physical_node_names;
  
  /*
  //List of node IDs connected to node.
  public ArrayList<Node> adjacent_nodes(){
    ArrayList<Node> nods = new ArrayList<Node>();
    for (String nn : this.adjacent_node_names){
      nods.add(model.nodesmap.get(nn));
    }
    return nods;
  }

  //List of actual adjacent bars. (Status: TEST, not sure if this'll work well.)
  //FUCK YEAH. It does. For now.
  public ArrayList<PhysicalBar> adjacent_physical_bars(){
    ArrayList<PhysicalBar> pbars = new ArrayList<PhysicalBar>();
    for (String pnn : this.adjacent_physical_bar_names){
      pbars.add(model.physicalbarsmap.get(pnn));
    }
    return pbars;
  }

  //List of actual adjacent bars. (Status: TEST, not sure if this'll work well.)
  //FUCK YEAH. It does. For now.
  public ArrayList<PhysicalNode> adjacent_physical_nodes(){
    ArrayList<PhysicalNode> pnodes = new ArrayList<PhysicalNode>();
    for (String pnn : this.adjacent_physical_node_names){
      pnodes.add(model.physicalnodesmap.get(pnn));
    }
    return pnodes;
  }*/

  public PhysicalNode(String id, String module, float x, float y, float z, List<String> adjacent_node_names, List<String> adjacent_physical_node_names, List<String> adjacent_bar_names, List<String> adjacent_physical_bar_names, boolean ground){
    this.id=id;
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


