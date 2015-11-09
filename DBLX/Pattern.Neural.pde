/*****************************************************************************
 *     NEURAL ANATOMY AND PHYSIOLOGICAL SIMULATIONS OR INSPIRED PATTERNS
 ****************************************************************************/



/** ********************************************************* AV BRAIN PATTERN
 * A rate model of the brain with semi-realistic connectivity and time delays
 * Responds to sound.
 * @author: rhancock@gmail.com. 
 ************************************************************************* **/
import java.util.Random;
import ddf.minim.*;
import ddf.minim.ugens.*;
// the effects package is needed because the filters are there for now.
import ddf.minim.effects.*;

class AVBrainPattern extends BrainPattern {

  //sound
  Minim minim;
  AudioInput audio_in;
  IIRFilter bpf;

  int audio_source_left = 84;
  int audio_source_right = 85;

  float[][] C;
  int[][] D;
  float[][] gain;
  int max_delay = 0;
  String[] lf_nodes = loadStrings("avbrain_resources/nodelist.txt");

  int n_sources;
  int n_nodes;
  //params
  //float sigma = .25;
  private final BasicParameter sigma = new BasicParameter("S", 50, 10, 1000);
  private final BasicParameter nsteps = new BasicParameter("SPD", 200, 100, 1000);
  private final BasicParameter audio_wt = new BasicParameter("VOL", 0, 0, 500);
  private final BasicParameter k = new BasicParameter("K", 100, 0, 1000);
  private final BasicParameter hueShiftSpeed = new BasicParameter("HSS", 5000, 0, 10000);
  private final SinLFO whatHue = new SinLFO(0, 360, hueShiftSpeed);



  float tstep = .001; //changing this requires updating the delay matrix
  //float k;

  //working variables
  float[][] act;
  float[] sensor_act;
  Random noise;
  List<Bar> barlist;
  public AVBrainPattern(LX lx) {
    super(lx);
    addParameter(sigma);
    addParameter(nsteps);
    addParameter(audio_wt);
    addParameter(k);
    addParameter(hueShiftSpeed);
    addModulator(whatHue).trigger();


    //audio
    minim = new Minim(this);
    //minim.debugOn();
    audio_in = minim.getLineIn(Minim.STEREO, 8192);
    bpf = new LowPassFS(400, audio_in.sampleRate());
    audio_in.addEffect(bpf);



    //load connectivity and delays
    String[] conn_rows = loadStrings("avbrain_resources/connectivity_norm.txt");
    String[] conn_cols;
    String[] delay_rows = loadStrings("avbrain_resources/T_discrete.txt");
    String[] delay_cols;
    C = new float[conn_rows.length][conn_rows.length];
    D = new int[delay_rows.length][delay_rows.length];
    for (int i=0; i < conn_rows.length; i++) {
      conn_cols = splitTokens(conn_rows[i]);
      delay_cols = splitTokens(delay_rows[i]);
      for (int j=0; j < conn_cols.length; j++) {
        C[i][j] = float(conn_cols[j]);
        D[i][j] = int(delay_cols[j]);
        max_delay=max(max(D[i]), max_delay);
      }
    }

    //load leadfield
    String[] gain_rows = loadStrings("avbrain_resources/leadfield1r.txt");
    //String[] gain_rows = loadStrings("avbrain_resources/leadfield1.txt");
    String[] gain_cols = splitTokens(gain_rows[0]);
    gain = new float[gain_rows.length][gain_cols.length];
    for (int i=0; i < gain_rows.length; i++) {
      gain_cols = splitTokens(gain_rows[i]);
      for (int j=0; j < gain_cols.length; j++) {
        gain[i][j] = float(gain_cols[j]);
      }
    }


    n_sources = gain_cols.length;
    n_nodes = lf_nodes.length;

    //initialize
    //k = 1/n_sources;
    act = new float[n_sources][max_delay+2];
    sensor_act = new float[n_nodes];

    noise = new Random();
    for (int i=0; i < n_sources; i++) {
      for (int j=0; j < max_delay; j++) {
        act[i][j]=(float)((noise.nextGaussian())*sigma.getValue()/100);
      }
    }

    //start the sim
    for (int t=0; t < max_delay; t++) {
      step_simulation();
    }
  }

  public void step_simulation() {

    int t=max_delay;
    for (int i=0; i<n_sources; i++) {
      float w=0;
      for (int j=0; j<n_sources; j++) {
        w = w+C[j][i]*act[j][t-D[j][i]];
      }
      //floats can't possibly be helping at this point
      act[i][t+1]=act[i][t]+tstep/.2*(-act[i][t]+(float)(k.getValue()/100/n_nodes)*w+(float)(sigma.getValue()/100*noise.nextGaussian()));
    }
    act[audio_source_left][t+1]=act[audio_source_left][t+1]+audio_in.left.get(0)*(float)(audio_wt.getValue()/1000);//*tstep;
    act[audio_source_right][t+1]=act[audio_source_right][t+1]+audio_in.right.get(0)*(float)(audio_wt.getValue()/1000);//*tstep;
    //System.out.println(act[84][t+1]);




    //update node values
    for (int i=0; i<n_nodes; i++) {
      for (int j=0; j<n_sources; j++) {
        sensor_act[i]=sensor_act[i] + gain[i][j]*act[j][t+1]*10;
      }
    }
    //ugh
    for (int j=1; j< max_delay+2; j++) {
      for (int i=0; i<n_sources; i++) {
        act[i][j-1]=act[i][j];
      }
    }
  }

  public void run(double deltaMs) {
    audio_source_right = noise.nextInt(n_sources);
    audio_source_left = noise.nextInt(n_sources);
    for (int s=0; s < nsteps.getValue (); s++) {
      step_simulation();
    }
    float dmin=min(sensor_act);
    float dmax=max(sensor_act);
    for (int i=0; i<n_nodes; i++) {
      float v = (sensor_act[i]-dmin)/(dmax-dmin);
      Node node = model.nodemap.get(lf_nodes[i]);
      barlist = node.adjacent_bars();
      for (Bar b : barlist) {
        for (LXPoint p : b.points) {
          colors[p.index]=lx.hsb((v*200-160+whatHue.getValuef())%360, 80, 80);
          //colors[p.index]=palette.getColor(bv);
        }
      }
    }
  }
}


/** ***********************************************************
 * Muse concentration and mellow bar pattern
 * requires muse_connect.pde and install of muse-io
 * @Author: Mike Pesavento
 * Initial version: 2015.07.01
 * 
 * Requires use of the muse_connect.pde file, which gives access to the muse headset data
 * Also written by MJP. 
 * Needs global object variable to be declared to access it in this pattern.
 * Run "muse-io' from command prompt, eg
 *    muse-io --preset 14 --osc osc.udp://localhost:5000
 *
 ************************************************************** **/
class MuseConcMellow extends BrainPattern {
  private final BasicParameter concv = new BasicParameter("conc", 0.7, 0, 1);
  private final BasicParameter mellowv = new BasicParameter("mellow", 0.6, 0, 1);
  private final BasicParameter decay = new BasicParameter("decay", 0.1, 0.001, 1);

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
    for ( String bname : model.barmap.keySet ()) {
      barMinixList.put(bname, findBarMinIndex(bname));
    }
  }

  private int findBarMinIndex(String bname) {
    Bar b = model.barmap.get(bname);
    int barminix = 9999999;
    for (LXPoint p : b.points) {
      if (p.index < barminix)
        barminix = p.index;
    }
    return barminix;
  }

  public void run(double deltaMs) {
    Random rand = new Random();
    //this.conc = concv.getValuef(); // 0.8; //muse.concentration;
    //this.mellow = mellowv.getValuef(); //0.6; //muse.mellow;
    this.conc = muse.concentration;
    this.mellow = muse.mellow;

    this.tau = decay.getValuef();

    // update a buffer with rgb values before adding them to the model?

    for (String curBarName : model.barmap.keySet ()) {
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
      for ( int i=0; i < maxpix_conc; i++) {
        float val = 1 - exp(-(maxpix_conc-i-1)/taun);
        barcolormap[i] += (int(val*255) & 0xFF) << 16; // red byte
      }

      //update mellow with blue
      for (int i=n-maxpix_mellow; i<n; i++) {
        float val = 1 - exp(- (i-(n-maxpix_mellow-1))/taun);
        barcolormap[i] += (int(val*255) & 0xFF); // blue byte
      }

      //turn on green for overlapping values

      for (int i=0; i<n; i++) {
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
      for (int i=0; i<n; i++)
        colors[gminix + i] = barcolormap[i];
    } //for barname
    firstrun = false;
  } //end run
}




/** ********************************************************************
 * Muse bandwidth energy pattern
 *
 * Does variation of Pixies pattern, with multiple layers
 * @author Mike Pesavento
 * original by Geoff Schmiddt
 */
class NeuroTracePattern extends BrainPattern {
  // Brightness adjustment factor.
  // private final BasicParameter brightness = new BasicParameter("BRITE", 0.5, 0, 1.0);
  private final BasicParameter brightness = new BasicParameter("BRITE", 1.0, .25, 2.0);

  // How long the trails persist. (Decay factor/percent for the trails, updated each frame.)
  private final BasicParameter fade = new BasicParameter("FADE", 0.90, 0.8, 0.99);
  
  private final BasicParameter globalSpeed = new BasicParameter("SPD", 1, 0, 2.0);

  // speed will be manually set, in pixels per second. 
  // Typical range= 10-1000, good starting value might be 60 (about a bar a second)

  private final BasicParameter gammaScale = new BasicParameter("gamma", 0.2, 0, 1.0);
  private final BasicParameter betaScale = new BasicParameter("beta", 0.3, 0, 1.0);
  private final BasicParameter alphaScale = new BasicParameter("alpha", 0.6, 0, 1.0);
  private final BasicParameter thetaScale = new BasicParameter("theta", 0.7, 0, 1.0);
  private final BasicParameter deltaScale = new BasicParameter("delta", 0.8, 0, 1.0);


  // a good colormap to use is from the ColorBrewer palette, 5-class "Spectral"
  // RGB values: red (215, 25, 28), orange (253, 174,97), yellow (255,255,191), green (171,221,164), blue (43,131,186)
  // HSV values:     (359, 88, 84),         (30, 62, 99),        (60, 25, 100),       (113, 26, 87),      (203, 77, 73)

  public NeuroTracePattern(LX lx) {
    super(lx);
    addParameter(brightness);
    addParameter(fade);
    addParameter(globalSpeed);
    addParameter(gammaScale);
    addParameter(betaScale);
    addParameter(alphaScale);
    addParameter(thetaScale);
    addParameter(deltaScale);

    addLayer(new PixiePattern(lx, 4, gammaScale, lx.hsb(60, 25, 100), 20)); // yellow
    addLayer(new PixiePattern(lx, 3, betaScale, lx.hsb(359, 82, 84), 20)); //red 
    addLayer(new PixiePattern(lx, 2, alphaScale, lx.hsb(30, 82, 99), 20)); //orange
    addLayer(new PixiePattern(lx, 1, thetaScale, lx.hsb(113, 82, 87), 20)); //green
    addLayer(new PixiePattern(lx, 0, deltaScale, lx.hsb(203, 82, 73), 20)); //blue
  }

  public float getMuseSessionScore(int bandID) {
    switch (bandID) {
    case 0: // delta (2-6 Hz)
      return muse.averageTemporal(muse.delta_session);
    case 1: // theta (4-8 Hz)
      return muse.averageTemporal(muse.theta_session);
    case 2: // alpha (8-12 Hz)
      return muse.averageTemporal(muse.alpha_session);
    case 3: // beta (14-26 Hz)
      return muse.averageTemporal(muse.beta_session);
    case 4: // gamma (26-40 Hz)
      return muse.averageTemporal(muse.gamma_session);
    }
    return -1; // somehow not getting where we need to be
  }

  public void run(double deltaMs) {
    // the layers run themselves
  }

  // pixie concept borrowed from Geoff Schmidt's Pixie Pattern
  class PixiePattern extends LXLayer {

    public int bandID;
    public BasicParameter scale;
    public int pixieColor = lx.hsb(0, 0, 100); // basic color for this instance of the pattern, matches bandwidth energy
    public float speed; // controls speed of particles, roughly in pixels/sec 
    
    final static int MAX_PIXIES = 1000;
    final static int MAX_MUSE_PIXIES = 500;
    
    private class Pixie {
      public Node fromNode, toNode;
      public double offset = 0; // not initialized in other version, should be zero?
      public int pixieColor;

      public Pixie() {
      }
    }

    private ArrayList<Pixie> pixies = new ArrayList<Pixie>();

    public PixiePattern(LX lx, int bandID, BasicParameter scaleDial, int pixieColor, float speed) {
      super(lx);
      this.bandID = bandID;
      this.scale = scaleDial;
      addParameter(scale);
      this.pixieColor = pixieColor;
      this.speed = speed;
    }

    public void setPixieCount(int count) {
      while ( this.pixies.size () < count) {
        Pixie p = new Pixie();
        p.fromNode = NeuroTracePattern.this.model.getRandomNode();
        p.toNode = p.fromNode.random_adjacent_node();
        p.pixieColor = this.pixieColor;
        this.pixies.add(p);
      }
      // if we have too many pixies in the list, take them off of the end of the list, FILO
      if (this.pixies.size() > count) {
        this.pixies.subList(count, this.pixies.size()).clear();
      }
    }

    public void run(double deltaMs) {
      float pixieScale = 0;
      if (museActivated) {
        //println("*** Muse Activated!!!");
        pixieScale = scale.getValuef() * MAX_PIXIES;
        // pixieScale = getMuseSessionScore(this.bandID) * MAX_MUSE_PIXIES;
      } else {
        pixieScale = scale.getValuef() * MAX_PIXIES;
      }
      this.setPixieCount(Math.round(pixieScale));

      for (LXPoint p : model.points) {
        colors[p.index] = LXColor.scaleBrightness(colors[p.index], fade.getValuef());
      }

      for (Pixie p : this.pixies) {
        double drawOffset = p.offset;
        p.offset += (deltaMs / 1000.0) * this.speed;
        while (drawOffset < p.offset) {
          List<LXPoint> points = nodeToNodePoints(p.fromNode, p.toNode);

          int index = (int)Math.floor(drawOffset);
          if (index >= points.size()) {
            //swap nodes to find new direction
            Node oldFromNode = p.fromNode;
            p.fromNode = p.toNode;
            do {
              p.toNode = p.fromNode.random_adjacent_node();
            } 
            while (angleBetweenThreeNodes (oldFromNode, p.fromNode, p.toNode) 
              < 4*PI/360*3 ); // go forward, not backwards
            drawOffset -= points.size();
            p.offset -= points.size();
            continue;
          }
          // How long, notionally, was the pixie at this pixel during
          // this frame? If we are moving at 100 pixels per second, say,
          // then timeHereMs will add up to 1/100th of a second for each
          // pixel in the pixie's path, possibly accumulated over
          // multiple frames.
          double end = Math.min(p.offset, Math.ceil(drawOffset + .000000001));
          double timeHereMs = (end - drawOffset) / this.speed * globalSpeed.getValuef() * 1000.0;

          LXPoint here = points.get((int)Math.floor(drawOffset));
          //        System.out.format("%.2fms at offset %d\n", timeHereMs, (int)Math.floor(drawOffset));

          addColor(here.index, 
              LXColor.scaleBrightness(p.pixieColor, 
              (float)timeHereMs / 1000.0
                * this.speed * globalSpeed.getValuef() * brightness.getValuef()));
          drawOffset = end;
        }
      }
    } // end run
  } //end PixiePattern
} //end NeuroTrace


/** *************************************************************** HEART BEAT
 * Hackathon patterns go here!
 * @author: Toby Holtzman. 
 ************************************************************************* **/

class HeartBeatPattern extends BrainPattern {
  MentalImage mentalimage_small = new MentalImage("media/images/heart-small.png", "yz", 100);
  MentalImage mentalimage_big = new MentalImage("media/images/heart-big.png", "yz", 100);
  BasicParameter beatPer = new BasicParameter("BPD", 1500, 1000, 20000);
  SawLFO beatmodulator = new SawLFO(0.0, 1.0, beatPer);
  ArrayList<BloodFlow> bflist = new ArrayList<BloodFlow>();
  ArrayList<Boolean> runlist = new ArrayList<Boolean>();
  CircleBounce bounce;

  public HeartBeatPattern(LX lx) {
    super(lx);
    addModulator(beatmodulator).start();
    for (int i=0; i<100; i++) {
      bflist.add(new BloodFlow(model.getRandomNode()));
    }
    for (int i=0; i<bflist.size ()/2; i++) {
      runlist.add(false);
    }
    bounce = new CircleBounce(lx);
  }

  class BloodFlow {
    public LinearEnvelope timeline = new LinearEnvelope(0, 100, 4000);
    public List<LXPoint> bloodpoints = new ArrayList<LXPoint>();
    public Node startNode;
    public Node endNode;
    public boolean isFinished;
    public int bloodlength;
    public int bloodhue = 0;

    public BloodFlow(Node startNode) {
      addModulator(timeline).start();
      this.startNode = startNode;
      Node prevNode = startNode.random_adjacent_node();
      Node currentNode = startNode;
      Node nextNode = currentNode.random_adjacent_node();
      int count = 0;
      for (int i=0; i<4; i++) {
        nextNode=currentNode.random_adjacent_node();
        while (angleBetweenThreeNodes (prevNode, currentNode, nextNode)<(PI/4)) {
          nextNode=currentNode.random_adjacent_node();
        }
        List<LXPoint> addpoints=nodeToNodePoints(currentNode, nextNode);
        for (LXPoint p : addpoints) {
          this.bloodpoints.add(p);
        }
        prevNode=currentNode;
        currentNode=nextNode;
      }
      this.bloodlength=this.bloodpoints.size();
      this.endNode = currentNode;
      this.isFinished = false;
    }

    public Node getLastNode() {
      return this.endNode;
    }

    public boolean isFinished() {
      return this.isFinished;
    }

    public void setFinished(boolean finished) {
      this.isFinished = finished;
    }

    public void run(double deltaMs) {
      float phase=timeline.getValuef();
      if (phase <70) {
        int ptcount=0;
        for (LXPoint p : bloodpoints) {
          float pctthru=float(ptcount)/float(bloodlength);
          if (pctthru<((phase-20)/50)) {
            colors[p.index]=lx.hsb(bloodhue, 100, 41);
          }
          ptcount+=1;
        }
      }
      if (phase>=50 && phase <=52) {
        setFinished(true);
      }
      if (phase>70 && phase <100) {
        int ptcount=0;
        for (LXPoint p : bloodpoints) {
          float pctthru=float(ptcount)/float(bloodlength);
          if (pctthru>((phase-70)/30)) {
            colors[p.index]=lx.hsb(bloodhue, 100, 41);
          }
          ptcount+=1;
        }
      }
    }
  }

  public void run(double deltaMS) {
    if (beatmodulator.getValuef()<0.5) {
      colors=this.mentalimage_small.shiftedImageToPixels(colors, 0, 0);
    } else {
      colors=this.mentalimage_big.shiftedImageToPixels(colors, 0, 0);
    }
    for (int i=0; i<bflist.size ()-1; i+=2) {
      BloodFlow bf_a = bflist.get(i);
      BloodFlow bf_b = bflist.get(i+1);
      if (bf_a.isFinished()) {
        runlist.set(i/2, true);
        bf_a.setFinished(false);
        bflist.set(i+1, new BloodFlow(bf_a.getLastNode()));
      }
      if (bf_b.isFinished()) {
        runlist.set(i/2, true);
        bf_b.setFinished(false);
        bflist.set(i, new BloodFlow(bf_b.getLastNode()));
      }
      bf_a.run(deltaMS);
      if (runlist.get(i/2)) {
        bf_b.run(deltaMS);
      }
    }
    bounce.run(deltaMS);
  }
}





/** **************************************************************************
 * Per Anna: Pattern is still WIP, this is its' current state.
 * Anna Leshinskaya
 ************************************************************************* **/

class annaPattern extends BrainPattern { 

  Node firstNode;
  public final BasicParameter colorSpread = new BasicParameter("Clr", 0.5, 0, 3);
  BasicParameter xPer = new BasicParameter("XPD", 6000, 5000, 20000);
  BasicParameter yPer = new BasicParameter("YPD", 6000, 5000, 20000);
  SawLFO linenvx = new SawLFO(0.0, 1.0, xPer);
  SawLFO linenvy = new SawLFO(0.0, 1.0, yPer);

  public final SinLFO xPeriod = new SinLFO(3400, 7900, 11000); 
  public final SinLFO brightness = new SinLFO(model.xMin, model.xMax, xPeriod);

  ////  private final SinLFO brightnessX = new SinLFO(model.xMin, model.xMax, xPeriod);
  private final BasicParameter colorFade = new BasicParameter("Fade", 0.95, 0.9, 1.0);
  public PVector destination; 
  //define direction vector, i.e.  , destination
  public final ArrayList<Node> streamPath; 


  public annaPattern(LX lx) {

    super(lx);
    addParameter(colorSpread);    
    addModulator(linenvx).start();
    addModulator(linenvy).start();
    addParameter(xPer);
    addParameter(yPer);
    addModulator(xPeriod).start();
    addModulator(brightness).start();
    firstNode = model.getFirstNodeAnnaPattern();
    //try the sawlfo modulator next
    destination = new PVector(-100, -100, -100);

    //makes a dark blue brain to start with
    for (LXPoint p : model.points) {
      float h=250; //hue
      int s=100; //saturation
      int b=100; // brightness
      colors[p.index]=lx.hsb(h, s, b); //sets colors of the node, point has attribute index
    }

    //defines the vector of nodes along path we want
    streamPath = new ArrayList();
    PVector whereamI;
    Node nextNode;
    float howFarFromGoal;
    howFarFromGoal = 100;

    while (howFarFromGoal>55 && firstNode.y != model.yMin && firstNode.y != model.xMin) {

      //to demo it, colors each node light blue

      //start with first node
      List<Bar> barlist;
      barlist = firstNode.adjacent_bars();
      for (Bar b : barlist) {
        for (LXPoint p : b.points) {
          colors[p.index]=lx.hsb(200, 100, 100);
        }
      }

      //pass to getNextNode
      //(ALEX MAKI-JOKELA) - I changed this line a little bit -your getNextNode function is super useful
      //so I renamed it and incorporated it into the Node class
      nextNode = firstNode.getNextNodeByVector(destination);
      whereamI = new PVector(nextNode.x, nextNode.y, nextNode.z);

      //ok now color the points to the next node
      List<LXPoint> bar_points = nodeToNodePoints(firstNode, nextNode);
      for (LXPoint p : bar_points) {
        colors[p.index]=lx.hsb(200, 100, 100);
      }

      howFarFromGoal = PVector.dist(whereamI, destination);
      //println(howFarFromGoal);
      //nextNode now becomes First Node, until destination is reached.
      firstNode = nextNode;
      //add to array
      streamPath.add(nextNode);
    }//end while
  }

  public void run (double deltaMS) {
    //for the set of items:
    //modulate base hue from modulator
    //adjust by order to spread it, very incrementally
    List<Bar> barlist;
    int count = 1;
    //  Collections.reverse(streamPath);

    for (Node n : streamPath) {
      count++;
      barlist = n.adjacent_bars();
      for (Bar b : barlist) {
        for (LXPoint p : b.points) {

          colors[p.index]=lx.hsb(
          100 - (linenvy.getValuef() * 100 * count ), 
          100, 100);
        }
      }
    }
  }
} 

