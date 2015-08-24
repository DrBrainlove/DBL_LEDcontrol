/**
* MuseConnect class
* written by Michael Pesavento
* 
* v0.1 2015.03.21
* v0.2 2015.08.20 updated for brainlove and DBLX
* 
* requires oscP5 package for Procesing
*
* --------------------------------------
* need to have muse-io installed, get SDK from here:
* https://sites.google.com/a/interaxon.ca/muse-developer-site/download
*
* load muse OSC output in command line with:
*      muse-io --preset 14 --osc osc.udp://localhost:5000 --device Muse-112E
*
*/


import oscP5.*;
import netP5.*;

boolean verboseMuse = false;


class MuseConnect {
  
  Object parent;

  OscP5 oscP5;
  NetAddress remoteOSCLocation;
  
  private String host = "127.0.0.1";
  private int port;
  
  public float[] delta_absolute = new float[] {0,0,0,0};
  public float[] theta_absolute = new float[] {0,0,0,0};
  public float[] alpha_absolute = new float[] {0,0,0,0};
  public float[] beta_absolute  = new float[] {0,0,0,0};
  public float[] gamma_absolute = new float[] {0,0,0,0};
  
  public float[] delta_rel = new float[] {0,0,0,0};
  public float[] theta_rel = new float[] {0,0,0,0};
  public float[] alpha_rel = new float[] {0,0,0,0};
  public float[] beta_rel  = new float[] {0,0,0,0};
  public float[] gamma_rel = new float[] {0,0,0,0};
  
  public float[] delta_session = new float[] {0,0,0,0};
  public float[] theta_session = new float[] {0,0,0,0};
  public float[] alpha_session = new float[] {0,0,0,0};
  public float[] beta_session  = new float[] {0,0,0,0};
  public float[] gamma_session = new float[] {0,0,0,0};
  
  public int touching_forehead = 0; //boolean, 1 is on forehead correctly
  public float[] horseshoe = new float[] {0,0,0,0}; // values: 1= good, 2=ok, 3=bad
  public float battery_level = 0; // percent battery remaining.
  public float concentration=0;
  public float mellow = 0; 
  
  public MuseConnect(Object parent) {
    this.parent = parent;
    this.port = 5000;
    oscP5 = new OscP5(parent, port); // read from the muse port
    remoteOSCLocation = new NetAddress(host, port);
    println("Connected to Muse headset");
  }

  public MuseConnect(Object parent, int _port) {
    this.port = _port;
    oscP5 = new OscP5(parent, port); // read from the muse port
    remoteOSCLocation = new NetAddress(host, this.port);
    println("Opened OSC port to Muse headset on " + this.host +":" + this.port);
  }

  public MuseConnect(Object parent, String _host, int _port) {
    this.host = _host;
    this.port = _port;
    oscP5 = new OscP5(parent, port); // read from the muse port
    remoteOSCLocation = new NetAddress(host, this.port);
    println("Opened OSC port to Muse headset on " + this.host +":" + this.port);
  }
  
  private void loadFromOsc(float[] arr, OscMessage msg, int n) {
    // n is the expected number of elements in the message
    for(int i=0; i<n; i++) {
      arr[i] = msg.get(i).floatValue();
    }
  }
  private void loadFromOsc(int[] arr, OscMessage msg, int n) {
    // n is the expected number of elements in the message
    for(int i=0; i<n; i++) {
      arr[i] = msg.get(i).intValue();
    }
  }
  
  public final String arr2str(float[] arr) {
    String s = "";
    for (int i=0; i< arr.length; i++) {
      s += str(arr[i]);
      if (i!=arr.length-1) {
        s += " ";
      }
    }
    return s;
  }
  
  //return true if all of the sensors are good (1.0)
  public boolean signalIsGood(float[] horseshoe) {
    boolean is_good = true;
    for (int i=0; i<horseshoe.length; i++) {
      if (horseshoe[i] != 1.0) {
        is_good = false;
        break;
      }
    }
    return is_good;
  }

  private float average(float arr[]) {
    float out=0;
    for (int i=0; i<arr.length; i++)
      out+=arr[i];
    return out/arr.length;
  }

  /**
   * only take the average of the middle two sensors, which should be FP1 and FP2
   */
  private float averageFront(float arr[]) {
    if (arr.length != 4) 
      throw new RuntimeException("Bandwidth arrays dont have length 4, incorrect input");
    return (arr[1]+arr[2])/2;
  }

  /**
   * only take the average of the outer two sensors, which should be TP9 and TP10
   */
  private float averageTemporal(float arr[]) {
    if (arr.length != 4) 
      throw new RuntimeException("Bandwidth arrays dont have length 4, incorrect input");
    return (arr[0]+arr[3])/2;
  }  
  
} //end MuseConnect


// globally accessible conversion of array to string
String arr2str(float[] arr) {
  String s = "";
  for (int i=0; i< arr.length; i++) {
    s += str(arr[i]);
    if (i!=arr.length-1) {
      s += " ";
    }
  }
  return s;
}


//*********************************************************************************************
// global function to catch all OSC messages
public void oscEvent(OscMessage msg) {
  
  if(msg.checkAddrPattern("/muse/elements/horseshoe")==true) {
    muse.loadFromOsc(muse.horseshoe, msg, 4);
    if (verboseMuse) println("reading signal quality: " + arr2str(muse.horseshoe));
  }
  else if(msg.checkAddrPattern("/muse/batt")==true) {
    muse.battery_level = msg.get(0).intValue() / 100;
    if (verboseMuse) println("******* received battery level: " + str(muse.battery_level));
  }
  
  else if(msg.checkAddrPattern("/muse/elements/touching_forehead")==true) {
    muse.touching_forehead = msg.get(0).intValue();
  }
  //*************************
  // catch and report absolute bandwidth values
  else if(msg.checkAddrPattern("/muse/elements/delta_absolute")==true) {
    muse.loadFromOsc(muse.delta_absolute, msg, 4);
    if (verboseMuse) println("received /muse/elements/delta_absolute: " + arr2str(muse.delta_absolute));
  }
  else if(msg.checkAddrPattern("/muse/elements/theta_absolute")==true) {
    muse.loadFromOsc(muse.theta_absolute, msg, 4);
    if (verboseMuse) println("received /muse/elements/theta_absolute: " + arr2str(muse.theta_absolute));
  }
  else if(msg.checkAddrPattern("/muse/elements/alpha_absolute")==true) {
    muse.loadFromOsc(muse.alpha_absolute, msg, 4);
    if (verboseMuse) println("received /muse/elements/alpha_absolute: "+ arr2str(muse.alpha_absolute));
  }
  else if(msg.checkAddrPattern("/muse/elements/beta_absolute")==true) {
    muse.loadFromOsc(muse.beta_absolute, msg, 4);
    if (verboseMuse) println("received /muse/elements/beta_absolute: " + arr2str(muse.beta_absolute));
  }
  else if(msg.checkAddrPattern("/muse/elements/gamma_absolute")==true) {
    muse.loadFromOsc(muse.gamma_absolute, msg, 4);
    if (verboseMuse) println("received /muse/elements/gamma_absolute: " + arr2str(muse.gamma_absolute));
  }
  //*************************
  // catch and report session scores
  else if(msg.checkAddrPattern("/muse/elements/delta_session_score")==true) {
    muse.loadFromOsc(muse.delta_session, msg, 4);
    if (verboseMuse) println("received /muse/elements/delta_session_score: " + arr2str(muse.delta_session));
  }
  else if(msg.checkAddrPattern("/muse/elements/theta_session_score")==true) {
    muse.loadFromOsc(muse.theta_session, msg, 4);
    if (verboseMuse) println("received /muse/elements/theta_session_score: " + arr2str(muse.theta_session));
  }
  else if(msg.checkAddrPattern("/muse/elements/alpha_session_score")==true) {
    muse.loadFromOsc(muse.alpha_session, msg, 4);
    if (verboseMuse) println("received /muse/elements/alpha_session_score: "+ arr2str(muse.alpha_session));
  }
  else if(msg.checkAddrPattern("/muse/elements/beta_session_score")==true) {
    muse.loadFromOsc(muse.beta_session, msg, 4);
    if (verboseMuse) println("received /muse/elements/beta_session_score: " + arr2str(muse.beta_session));
  }
  else if(msg.checkAddrPattern("/muse/elements/gamma_session_score")==true) {
    muse.loadFromOsc(muse.gamma_session, msg, 4);
    if (verboseMuse) println("received /muse/elements/gamma_session_score: " + arr2str(muse.gamma_session));
  }
  //*************************
  // catch and report session scores
  else if(msg.checkAddrPattern("/muse/elements/delta_relative")==true) {
    muse.loadFromOsc(muse.delta_rel, msg, 4);
    if (verboseMuse) println("received /muse/elements/delta_relative: " + arr2str(muse.delta_rel));
  }
  else if(msg.checkAddrPattern("/muse/elements/theta_relative")==true) {
    muse.loadFromOsc(muse.theta_rel, msg, 4);
    if (verboseMuse) println("received /muse/elements/theta_relative: " + arr2str(muse.theta_rel));
  }
  else if(msg.checkAddrPattern("/muse/elements/alpha_relative")==true) {
    muse.loadFromOsc(muse.alpha_rel, msg, 4);
    if (verboseMuse) println("received /muse/elements/alpha_relative: "+ arr2str(muse.alpha_rel));
  }
  else if(msg.checkAddrPattern("/muse/elements/beta_relative")==true) {
    muse.loadFromOsc(muse.beta_rel, msg, 4);
    if (verboseMuse) println("received /muse/elements/beta_relative: " + arr2str(muse.beta_rel));
  }
  else if(msg.checkAddrPattern("/muse/elements/gamma_relative")==true) {
    muse.loadFromOsc(muse.gamma_rel, msg, 4);
    if (verboseMuse) println("received /muse/elements/gamma_relative: " + arr2str(muse.gamma_rel));
  }
  
  // concentration and mellow metrics
  else if(msg.checkAddrPattern("/muse/elements/experimental/concentration")==true) {
    muse.concentration = msg.get(0).floatValue();
    if (verboseMuse) println("received /muse/elements/experimental/concentration: " + muse.concentration);
  }
  else if(msg.checkAddrPattern("/muse/elements/experimental/mellow")==true) {
    muse.mellow = msg.get(0).floatValue();
    if (verboseMuse) println("received /muse/elements/experimental/mellow: " +muse.mellow);
  }

} // end oscEvent()





//============================================================================
//============================================================================

class MuseHUD {
  /*
  * Displays the connection quality and battery of a Muse headset.
  * Currently doesnt apppear on the screen, should eventually dynamically
  * adjust position to be in lower left corner
  * This is using Processing primitives, not the LX framework for a UI. 
  * Could definitely use a revamp
  */
  MuseConnect muse; //have reference to muse object
  PGraphics museHUD; //have basic PGraphics image to display on screen

  // colors for muse horseshoe HUD
  color morange = color(204,102,0);
  color mgreen = color(102, 204, 0);
  color mblue = color(0, 102, 204);
  color mred = color(204, 0, 102);
  color morangel = color(233, 187, 142);
  color mgreenl = color(187, 233, 142);
  color mbluel = color(142, 187, 233);
  color mredl = color(233, 142, 187);
  public MuseHUD(MuseConnect _muse) {
    this.muse = muse;
    museHUD = createGraphics(100, 100);
  }
  
  void drawHUD() { //int head, int bl, int fl, int fr, int br, int battery ) {
    int backColor = 50;
    int foreColor = 200;
    fill(foreColor);
    stroke(0);  
    museHUD.beginDraw();
    museHUD.smooth();
    museHUD.background(50);
    museHUD.stroke(0);
    museHUD.fill(backColor);
    museHUD.ellipseMode(RADIUS);
    museHUD.ellipse(50, 40, 35, 40); //head
  
    museHUD.stroke(0);
    museHUD.strokeWeight(3);
    if (muse.touching_forehead==1)  museHUD.fill(foreColor);
    else museHUD.fill(backColor);
    museHUD.ellipse(50, 18, 5, 4); //on_forehead
    
    // horseshoe values: 1= good, 2=ok, 3=bad
    museHUD.stroke(morange);
    if (muse.horseshoe[0]==1) {  museHUD.fill(morange); }
    else if(muse.horseshoe[0]==2) { museHUD.fill(morangel); }
    else { museHUD.fill(backColor); }  
    museHUD.ellipse(33, 55, 6, 8); // TP9  
    
    museHUD.stroke(mgreen);
    if (muse.horseshoe[1]==1) {  museHUD.fill(mgreen); }
    else if(muse.horseshoe[1]==2) { museHUD.fill(mgreenl); }
    else { museHUD.fill(backColor); }  
    museHUD.ellipse(30, 30, 6, 8); //FP1  
    
    museHUD.stroke(mblue);
    if (muse.horseshoe[2]==1) {  museHUD.fill(mblue); }
    else if(muse.horseshoe[2]==2) { museHUD.fill(mbluel); }
    else { museHUD.fill(backColor); }  
    museHUD.ellipse(70, 30, 6, 8); //FP2
  
    museHUD.stroke(mred);
    if (muse.horseshoe[3]==1) {  museHUD.fill(mred); }
    else if(muse.horseshoe[3]==2) { museHUD.fill(mredl); }
    else { museHUD.fill(backColor); }  
    museHUD.ellipse(67, 55, 6, 8); //TP10
    
    int battery = int(muse.battery_level * 100);
    String battstr = "batt: " + str(battery) + "%";
    color battfill = color(255); //white for default
    if (battery < 10) {
      battfill = color(255, 0, 0);
    }
    else if (battery < 20) {
      battfill = color(255,230,0);
    }
    museHUD.stroke(battfill);
    museHUD.fill(battfill);
    museHUD.textSize(16);
    museHUD.text(battstr, 3, 96);
    
    museHUD.endDraw();
    image(museHUD, 200, 100); //height-100); //should be robust to translation()?
  }
}


//***************************************************************************************
// EEGState, used for collecting the current eeg state in a handy class.

public class EEGState {
  public int timestamp = 0; // in processing, will typically be the milliseconds, as called by millis(), since starting the program
  public float delta = 0;
  public float theta = 0;
  public float alpha = 0;
  public float beta = 0;
  public float gamma = 0;
  public float concentration=0;
  public float mellow = 0;
  
  private String[] energyNames = {"delta", "theta", "alpha", "beta", "gamma"  };

  // int flag that indicates how to collapse the arrays passed in
  // 2 = average just the two front sensors, 4 = average all 4 sensors
  private int collapseMode = 2; 

  public void EEGState() {
    timestamp = 0;
    delta = 0;
    theta = 0;
    alpha = 0;
    beta = 0;
    gamma = 0;
    concentration = 0;
    mellow = 0;
  }

  public EEGState(int time, float delta, float theta, float alpha, float beta, float gamma) {
    this.timestamp = time;
    this.delta = delta;
    this.theta = theta;
    this.alpha = alpha;
    this.beta = beta;
    this.gamma = gamma;
    this.concentration = 0;
    this.mellow=0;
  }

  public EEGState(int time, float delta, float theta, float alpha, float beta, float gamma, float conc, float mellow) {
    this.timestamp = time;
    this.delta = delta;
    this.theta = theta;
    this.alpha = alpha;
    this.beta = beta;
    this.gamma = gamma;
    this.concentration = conc;
    this.mellow = mellow;
  }

  public EEGState(int time, float delta[], float theta[], float alpha[], float beta[], float gamma[]) {
    this.timestamp = time;
    if (collapseMode==2) {
      //frontal lobe averaging
      
      this.delta = averageFront(delta);
      this.theta = averageFront(theta);
      this.alpha = averageFront(alpha);
      this.beta = averageFront(beta);
      this.gamma = averageFront(gamma);
      /*
      // Temporal lobe averaging
      this.delta = averageTemporal(delta);
      this.theta = averageTemporal(theta);
      this.alpha = averageTemporal(alpha);
      this.beta = averageTemporal(beta);
      this.gamma = averageTemporal(gamma);
      */
    } 
    else if (collapseMode==4) {
      this.delta = average(delta);
      this.theta = average(theta);
      this.alpha = average(alpha);
      this.beta = average(beta);
      this.gamma = average(gamma);
    }
    this.concentration=0;
    this.mellow=0;
  }

  public EEGState(int time, float delta[], float theta[], float alpha[], float beta[], float gamma[], float conc, float mellow) {
    this.timestamp = time;
    if (collapseMode==2) {
      //frontal lobe averaging
      /*
      this.delta = averageFront(delta);
      this.theta = averageFront(theta);
      this.alpha = averageFront(alpha);
      this.beta = averageFront(beta);
      this.gamma = averageFront(gamma);
      */
      // Temporal lobe averaging
      this.delta = averageTemporal(delta);
      this.theta = averageTemporal(theta);
      this.alpha = averageTemporal(alpha);
      this.beta = averageTemporal(beta);
      this.gamma = averageTemporal(gamma);
    } 
    else if (collapseMode==4) {
      this.delta = average(delta);
      this.theta = average(theta);
      this.alpha = average(alpha);
      this.beta = average(beta);
      this.gamma = average(gamma);
    }
    this.concentration = conc;
    this.mellow = mellow;
  }


  public void setCollapseMode(int mode) {
    if (mode != 2 || mode != 4) 
      throw new RuntimeException("trying to set the collapseMode to soemthing other than 2 or 4");
    this.collapseMode = mode;
  }

  private float average(float arr[]) {
    float out=0;
    for (int i=0; i<arr.length; i++)
      out+=arr[i];
    return out/arr.length;
  }

  /**
   * only take the average of the middle two sensors, which should be FP1 and FP2
   */
  private float averageFront(float arr[]) {
    if (arr.length != 4) 
      throw new RuntimeException("Bandwidth arrays dont have length 4, incorrect input");
    return (arr[1]+arr[2])/2;
  }

  /**
   * only take the average of the outer two sensors, which should be TP9 and TP10
   */
  private float averageTemporal(float arr[]) {
    if (arr.length != 4) 
      throw new RuntimeException("Bandwidth arrays dont have length 4, incorrect input");
    return (arr[0]+arr[3])/2;
  }
  
  public String[] getTop3Energies() {
    ArrayList<String> names = new ArrayList<String>();
    ArrayList<Float> vals = new ArrayList<Float>();
    float[] a = {delta, theta, alpha, beta, gamma};
    //datalog.print("getTop3: ");
    for (int i=0; i<a.length; i++) {
      vals.add(a[i]);
      names.add(energyNames[i]);
      //datalog.print(energyNames[i]+":"+a[i]+" ");
    }
    //datalog.println("");
    
    int ix=0;
    for (int i=0; i<2; i++) {
      ix = vals.indexOf(Collections.min(vals));
      vals.remove(ix);
      names.remove(ix);
    }
    
    String topKeys[] = new String[3];
    return names.toArray(topKeys);
  }
  
} //end EEGState








