/**
 * This is a very basic model OF A BRAIN!
 */
import java.io.*;
import java.nio.file.*;
import java.util.*;

static String lines[];

public static class Model extends LXModel {

public  SortedMap<String, BarWithModuleNum> barmap;

public Model(SortedMap<String, BarWithModuleNum> barmap ) {
    super(new Fixture(barmap));
    this.barmap = Collections.unmodifiableSortedMap(barmap);
  }
  
  private static class Fixture extends LXAbstractFixture {
    
    private Fixture(SortedMap<String, BarWithModuleNum> barmap){
      for (BarWithModuleNum bar : barmap.values()) {
        if (bar != null) {
          for (LXPoint p : bar.points) {
            this.points.add(p);
        }
      }
    }
    }
    

}
}

//This is currently the bar with the module number on top of it.
//TODO: Build one just labeled "Bar" which does not have the module num and abstracts modules away. 
//I (Maki) have a mapped out design for these but need to iterate on it one or two more times before I code it
public static class BarWithModuleNum extends LXModel {

  //Bar name
  public final String id;


public BarWithModuleNum(String id, List<float[]> points){
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


//Not functional or tested or used anywhere yet. WIP.
public static class NodeWithModuleNum extends LXModel {

  //Node number with module number
  public final String id;
  
  //List of bar IDs connected to node.
  public final List<String> bars;
  
  //List of bar IDs connected to node with module nums. (for dealing with double bars etc)
  public final List<String> bars_with_module_nums;


public NodeWithModuleNum(String id, List<String> bars, List<String> bars_with_module_nums){
  this.id=id;
  this.bars=bars;
  this.bars_with_module_nums=bars_with_module_nums;
}
}



//Not functional or tested or used anywhere yet. WIP.
public static class Node extends LXModel {

  //Node number with module number
  public final String id;
  
  //List of bar IDs connected to node.
  public final List<String> bars;
  
  //List of bar IDs connected to node with module nums. (for dealing with double bars etc)
  public final List<String> bars_with_module_nums;

  //Sometimes there are more than one physical node per node because they have the same label but are in different modules
  public final List<NodeWithModuleNum> nodes_with_module_nums;
  

public Node(String id, List<String> bars_with_module_nums, List<String> bars, List<NodeWithModuleNum> nodes_with_module_nums){
  this.id=id;
  this.bars_with_module_nums=bars_with_module_nums;
  this.bars=bars;
  this.nodes_with_module_nums = nodes_with_module_nums;
}
}
