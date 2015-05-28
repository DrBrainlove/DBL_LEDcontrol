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

public final SortedMap<String, PhysicalBar> barmap;
public final SortedMap<String, Node> nodemap;
public final SortedMap<String,PhysicalNode> physicalnodesmap;

public Model(SortedMap<String, PhysicalBar> barmap, SortedMap<String, Node> nodemap, SortedMap<String,PhysicalNode> physicalnodesmap) {
    super(new Fixture(barmap));
    this.barmap = Collections.unmodifiableSortedMap(barmap);
    this.nodemap = Collections.unmodifiableSortedMap(nodemap);
    this.physicalnodesmap = Collections.unmodifiableSortedMap(physicalnodesmap);
  }
  
  private static class Fixture extends LXAbstractFixture {
    
    private Fixture(SortedMap<String, PhysicalBar> barmap){
      for (PhysicalBar bar : barmap.values()) {
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


public static class Bar extends LXModel {




}









//Not functional or tested or used anywhere yet. WIP.
public static class Node extends LXModel {

  //Node number with module number
  public final String id;
  
  //xyz position of node
  //If it's a double or triple node, returns the coordinates of the highest-z-position instance of the node
  public final float x;
  public final float y;
  public final float z;
  public final boolean ground;
  
  //List of bar IDs connected to node.
  public final List<String> bars;
  
  //List of bar IDs connected to node with module nums. (for dealing with double bars etc)
  public final List<String> physical_bars;

  //Sometimes there are more than one physical node per node because they have the same label but are in different modules
  public final List<String> physical_nodes;
  

  public Node(String id, float x, float y, float z, List<String> physical_bars, List<String> bars, List<String> physical_nodes, boolean ground){
    this.id=id;
    this.x=x;
    this.y=y;
    this.z=z;
    this.physical_bars=physical_bars;
    this.bars=bars;
    this.physical_nodes = physical_nodes;
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
  
  //Captures whether the bar is an inner bar, outer bar, or in-between bar
  //public final String innerOuterInBetween;
  
  //xyz coordinates of the forwardmost node in the bar
  //public final float x;
  //public final float y;
  //public final float z;


  public PhysicalBar(String id, List<float[]> points){
    super(new Fixture(points));
    this.id=id;
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
public static class PhysicalNode extends LXModel {

  //Node number with module number
  public final String id;
  
  //xyz position of node
  public final float x;
  public final float y;
  public final float z;
  public final boolean ground;
  
  //List of bar IDs connected to node.
  public final List<String> bars;
  
  //List of bar IDs connected to node with module nums. (for dealing with double bars etc)
  public final List<String> physical_bars;


  public PhysicalNode(String id, String module, float x, float y, float z, List<String> bars, List<String> physical_bars, boolean ground){
    this.id=id;
    this.x=x;
    this.y=y;
    this.z=z;
    this.bars=bars;
    this.physical_bars=physical_bars;
    this.ground = ground;
  }
}


