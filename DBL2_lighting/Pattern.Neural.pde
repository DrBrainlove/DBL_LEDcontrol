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



/** *************************************************************** HEART BEAT
 * Hackathon patterns go here!
 * @author: Toby Holtzman. 
 ************************************************************************* **/

class HeartBeatPattern extends BrainPattern{
  MentalImage mentalimage_small = new MentalImage("media/images/heart-small.png","yz",100);
  MentalImage mentalimage_big = new MentalImage("media/images/heart-big.png","yz",100);
  BasicParameter beatPer = new BasicParameter("BPD",1500,1000,20000);
  SawLFO beatmodulator = new SawLFO(0.0,1.0,beatPer);
  ArrayList<BloodFlow> bflist = new ArrayList<BloodFlow>();
  ArrayList<Boolean> runlist = new ArrayList<Boolean>();
  CircleBounce bounce;
  
  public HeartBeatPattern(LX lx){
    super(lx);
  addModulator(beatmodulator).start();
  for(int i=0;i<100;i++){
    bflist.add(new BloodFlow(model.getRandomNode()));
  }
  for(int i=0;i<bflist.size()/2;i++){
    runlist.add(false);
  }
  bounce = new CircleBounce(lx);
  }
  
  class BloodFlow{
  public LinearEnvelope timeline = new LinearEnvelope(0,100,4000);
  public List<LXPoint> bloodpoints = new ArrayList<LXPoint>();
  public Node startNode;
  public Node endNode;
  public boolean isFinished;
  public int bloodlength;
  public int bloodhue = 0;
  
  public BloodFlow(Node startNode){
    addModulator(timeline).start();
    this.startNode = startNode;
    Node prevNode = startNode.random_adjacent_node();
    Node currentNode = startNode;
    Node nextNode = currentNode.random_adjacent_node();
    int count = 0;
    for(int i=0;i<4;i++){
      nextNode=currentNode.random_adjacent_node();
      while(angleBetweenThreeNodes(prevNode,currentNode,nextNode)<(PI/4)){
        nextNode=currentNode.random_adjacent_node();
      }
    List<LXPoint> addpoints=nodeToNodePoints(currentNode,nextNode);
        for (LXPoint p : addpoints){
          this.bloodpoints.add(p);
        }
        prevNode=currentNode;
        currentNode=nextNode;
    }
      this.bloodlength=this.bloodpoints.size();
    this.endNode = currentNode;
    this.isFinished = false;
  }
  
  public Node getLastNode(){
    return this.endNode;
  }
  
  public boolean isFinished(){
    return this.isFinished;
  }
  
  public void setFinished(boolean finished){
    this.isFinished = finished;
  }
  
  public void run(double deltaMs){
      float phase=timeline.getValuef();
      if (phase <70){
        int ptcount=0;
        for (LXPoint p : bloodpoints){
          float pctthru=float(ptcount)/float(bloodlength);
          if (pctthru<((phase-20)/50)){
            colors[p.index]=lx.hsb(bloodhue,100,41);
          }
          ptcount+=1;
        }
      }
    if(phase>=50 && phase <=52){
      setFinished(true);
    }
      if (phase>70 && phase <100){
        int ptcount=0;
        for (LXPoint p : bloodpoints){
          float pctthru=float(ptcount)/float(bloodlength);
          if (pctthru>((phase-70)/30)){
            colors[p.index]=lx.hsb(bloodhue,100,41);
          }
          ptcount+=1;
        }
      }
    }
  }
  
  public void run(double deltaMS){
    if(beatmodulator.getValuef()<0.5){
    colors=this.mentalimage_small.shiftedImageToPixels(colors,0,0);
  }
  else{
    colors=this.mentalimage_big.shiftedImageToPixels(colors,0,0);
  }
  for(int i=0;i<bflist.size()-1;i+=2){
    BloodFlow bf_a = bflist.get(i);
    BloodFlow bf_b = bflist.get(i+1);
    if(bf_a.isFinished()){
      runlist.set(i/2,true);
      bf_a.setFinished(false);
      bflist.set(i+1,new BloodFlow(bf_a.getLastNode()));
    }
    if(bf_b.isFinished()){
      runlist.set(i/2,true);
      bf_b.setFinished(false);
      bflist.set(i,new BloodFlow(bf_b.getLastNode()));
    }
    bf_a.run(deltaMS);
    if(runlist.get(i/2)){
      bf_b.run(deltaMS);
    }
  }
  bounce.run(deltaMS);
  }
}




