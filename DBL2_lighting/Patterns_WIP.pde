
 /*
class SnakesDemoPattern extends BrainPattern {
  
}
*/

//Owner: Maki, though feel free to modify (doesn't work yet)
//Pattern: Neurons are represented by nodes, which decay but build up charge in response to sound
//At a certain amount of charge, it discharges into the surrounding bars which gets captured by other neurons
/*
class NeuronsFiring extends LXPattern {



  class Neuron {
    public Node centerNode;
    public float charge;
    public float something; 
    public enum state { NEURON_NOT_FIRING, NEURON_FIRING }

    public Neuron(Node centerNode){
      this.centerNode = centerNode;
      this.charge=10;

    }
  }

  public NeuronsFiring(LX lx) {
    super(lx);
    addLayer(new NeuronLayer(lx));
  }

  public void run(double deltaMs) {
    //layers run automatically
  }

  private class NeuronLayer extends LXLayer {

    private final BasicParameter numNeurons = new BasicParameter("Neurons",1,0,20);

    private NeuronLayer(LX lx) {
      super(lx);
      addParameter(numNeurons);
    }

    public void run(double deltaMS) {
      for (p : model.points) {
        if 
      }
    }
  }

}
*/

/*
class SampleImageScroll extends BrainPattern{
  Node randnod = model.getRandomNode();
  Node randnod2 = model.getRandomNode();
  List<Bar> barlist;
  
  
  public SampleNodeTraversal(LX lx){
    super(lx);
  }

  public void run(double deltaMS) {
    randnod = randnod.random_adjacent_nodes(1).get(0);
    randnod2 = randnod.random_adjacent_nodes(1).get(0);
    barlist = randnod.adjacent_bars();
    List<LXPoint> bar_poince = nodeToNodePoints(randnod,randnod2);
    for (LXPoint p: model.points) {
      colors[p.index]=lx.hsb(30,55,100);
    }

    for (Bar b: barlist) {
      for (LXPoint p: b.points){
        colors[p.index]=lx.hsb(200,256,100);
      }
    }

    int counta=0;
    for (LXPoint p:bar_poince){
      counta+=10;
      colors[p.index]=lx.hsb(counta,counta/2,100);
    }
  }
}

*/

class EQTesting extends BrainPattern {
  private GraphicEQ eq = null;
  List<List<LXPoint>> strips_emanating_from_nodes = new ArrayList<List<LXPoint>>();

  private DecibelMeter dbMeter = new DecibelMeter(lx.audioInput());

  /*
  public class BassWorm(){
    
    Node start_node;
    ArrayList<Node> wormnodes = new ArrayList<Node>;
    ArrayList<LXPoint> wormpoints = new ArrayList<LXPoint>();
      
    BassWorm(int numBars) {
      start_node = model.getRandomNode();
      next_node = start_node;
      previous_node = start_node;
      wormnodes.add(start_node);
      for (int i, int <= numBars, i++){
        while(wormnodes.contains(next_node){
          next_node = previous_node.random_adjacent_node();
        }
        wormnodes.add(next_node);
        new_points = nodeToNodePoints(previous_node,next_node);
        for (LXPoint p : new_points){
          wormpoints.add(p);
        }
        previous_node = next_node;
      }
    }
  }*/
  
  public EQTesting(LX lx) {
    super(lx);
    /*if (eq == null) {
      eq = new GraphicEQ(lx.audioInput());
      eq.range.setValue(48);
      eq.release.setValue(800);
      eq.gain.setValue(-6);
      eq.slope.setValue(6);
      addParameter(eq.gain);
      addParameter(eq.range);
      addParameter(eq.attack);
      addParameter(eq.release);
      addParameter(eq.slope);
      addModulator(eq).start();
    }*/
      addModulator(dbMeter).start();
      for (String n : model.nodemap.keySet()) {
        List<LXPoint> out_from_node = new ArrayList<LXPoint>();
        Node node = model.nodemap.get(n);
        List<Node> neighbornodes = node.adjacent_nodes();
        for (Node nn : neighbornodes) {
          out_from_node = nodeToNodePoints(node,nn);
          strips_emanating_from_nodes.add(out_from_node);
        }
      }
  }
  
  public void run(double deltaMs) {
    
    //float bassLevel = lx.audioInput.mix.level();//eq.getAveragef(0, 5) * 5000;
    float soundLevel = -dbMeter.getDecibelsf()*0.5;
    //println(bassLevel);
    for (LXPoint p: model.points) {
      colors[p.index] = lx.hsb(random(100,120),40,40);
    }
    for (List<LXPoint> strip : strips_emanating_from_nodes) {
      int distance_from_node=0;
      int striplength = strip.size();
      for (LXPoint p : strip) {
        distance_from_node+=1;
        float relative_distance = (float) distance_from_node / striplength;
        float hoo = 300- 5*relative_distance*2500/soundLevel;
        float saturat = 100;
        float britness = max(0, 100 - 3*relative_distance*2500/soundLevel);
        addColor(p.index, lx.hsb(hoo, saturat, britness));
      }
    }
  }
}
