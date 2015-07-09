
/**
 * Muse concentration and mellow bar pattern
 * requires muse_connect.pde and install of muse-io
 * Author: Mike Pesavento
 * Initial version: 2015.07.01
 * 
 * Requires use of the muse_connect.pde file, which gives access to the muse headset data
 * Also written by MJP. 
 * Needs global object variable to be declared to access it in this pattern.
 * Run "muse-io' from command prompt, eg
 *    muse-io --preset 14 --osc osc.udp://localhost:5000
 *
 */
class MuseConcMellow extends BrainPattern {
  private final BasicParameter decay = new BasicParameter("decay", 0.1, 0.001, 1);

  private final BasicParameter concv = new BasicParameter("conc", 0.7, 0, 1);
  private final BasicParameter mellowv = new BasicParameter("mellow", 0.6, 0, 1);
  
  //public List<string> barKeys;
  public Map<String, Integer> barMinixList;
  public float conc = 0;
  public float mellow = 0; 

  private float tau = 0.1;
  
  private boolean firstrun = true;

  public MuseConcMellow(LX lx) {
    super(lx);
    addParameter(decay);
    addParameter(concv);
    addParameter(mellowv);
    
    if (muse==null) {
      println("***** MuseConnect object is null, needs to be initialized first");
    }
    
    barMinixList = new HashMap<String, Integer>(); // holds minimum global index for each bar
    //barkeys = new ArrayList<List<string>( model.barmap.keys()  );
    
    // load a list with the sorted indices for each bar, indexing at 0
    for( String bname : model.barmap.keySet()) {
      barMinixList.put(bname, findBarMinIndex(bname));
    }

  }
  
  private int findBarMinIndex(String bname) {
    Bar b = model.barmap.get(bname);
    int barminix = 9999999;
    for(LXPoint p : b.points) {
      if(p.index < barminix)
        barminix = p.index;
    }
    return barminix;
  }

  public void run(double deltaMs)  {
    Random rand = new Random();
    //this.conc = concv.getValuef(); // 0.8; //muse.concentration;
    //this.mellow = mellowv.getValuef(); //0.6; //muse.mellow;
    this.conc = muse.concentration;
    this.mellow = muse.mellow;

    this.tau = decay.getValuef();

    // update a buffer with rgb values before adding them to the model?
    
    for(String curBarName : model.barmap.keySet()) {
      Bar bar = model.barmap.get(curBarName);
      int n = bar.points.size();
      int[] barcolormap = new int[n];
      int gminix = barMinixList.get(curBarName);
      float taun = this.tau * n;

      //float damp = tau * conc; 
      int maxpix_conc = int(this.conc * n);
      int maxpix_mellow = int(this.mellow * n);
      
      if (firstrun) {
        println("bar "+ curBarName + ", gmin " + gminix);
      }

      //update bar with concentration, red
      // points will have index relative to whole frame, but bars should be in a 
      for( int i=0; i < maxpix_conc; i++) {
        float val = 1 - exp(-(maxpix_conc-i-1)/taun);
        barcolormap[i] += (int(val*255) & 0xFF) << 16; // red byte
      }

      //update mellow with blue
      for(int i=n-maxpix_mellow; i<n; i++) {
        float val = 1 - exp(- (i-(n-maxpix_mellow-1))/taun);
        barcolormap[i] += (int(val*255) & 0xFF); // blue byte
      }

      //turn on green for overlapping values
      
      for(int i=0; i<n; i++){
        //watch for translation from unsigned byte to signed int32!!
        byte r = LXColor.red(barcolormap[i]);
        byte b = LXColor.blue(barcolormap[i]);
        byte g = (byte)LXColor.BLACK;
        if (int(r) > 0 && int(b) > 0) {
          // if both are positive use the smaller value in green
          if (int(b) < int(r)) g = b;
          else       g = r;
          barcolormap[i] += (g << 8); // Shift to green and set
        }
        println();
      }

      // load global color buffer
      for(int i=0; i<n; i++)
        colors[gminix + i] = barcolormap[i];

    } //for barname
    firstrun = false;
  } //end run
  
}



 

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
    List<LXPoint> bar_poince = model.getOrderedLXPointsBetweenTwoAdjacentNodes(randnod,randnod2);
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
        new_points = model.getOrderedLXPointsBetweenTwoAdjacentNodes(previous_node,next_node);
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
          out_from_node = model.getOrderedLXPointsBetweenTwoAdjacentNodes(node,nn);
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
        float britness = max(0, 100 - 5*relative_distance*1000/soundLevel);
        addColor(p.index, lx.hsb(hoo, saturat, britness));
      }
    }
  }
}
