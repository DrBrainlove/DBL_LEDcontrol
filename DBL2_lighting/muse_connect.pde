/**
* MuseConnect class
* written by Michael Pesavento
* 
* v0.1 2015.03.21
* 
* TODO: be aware of threading issues with Processing. How will multiple instances of this class run on one computer?
*
* eventually split out a separate class to hold /muse/elements?
*
* requires oscP5 package for Procesing
*
* --------------------------------------
* need to have muse-io installed
* load muse OSc output in command line with:
*      muse-io --preset 14 --osc osc.udp://localhost:5000
*
*/



/*

Commented out to avoid dependencies - uncomment and install Muse drivers if you plan to use the Muse headset

import oscP5.*;
import netP5.*;


class MuseConnect {
  
  Object parent;

  OscP5 oscP5;
  NetAddress remoteOSCLocation;
  
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
    remoteOSCLocation = new NetAddress("127.0.0.1", port);
    println("Connected to Muse headset");
  }
  public MuseConnect(Object parent, int port_) {
    this.port = port_;
    oscP5 = new OscP5(parent, port); // read from the muse port
    remoteOSCLocation = new NetAddress("127.0.0.1", this.port);
    println("Connected to Muse headset, port: " + this.port);
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
  
  private String arr2str(float[] arr) {
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

  
  
} //end MuseConnect

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
    println("reading signal quality: " + arr2str(muse.horseshoe));
  }
  else if(msg.checkAddrPattern("/muse/batt")==true) {
    muse.battery_level = msg.get(0).intValue() / 100;
    println("******* received battery level: " + str(muse.battery_level));
  }
  
  else if(msg.checkAddrPattern("/muse/elements/touching_forehead")==true) {
    muse.touching_forehead = msg.get(0).intValue();
  }
  //*************************
  // catch and report absolute bandwidth values
  else if(msg.checkAddrPattern("/muse/elements/delta_absolute")==true) {
    muse.loadFromOsc(muse.delta_absolute, msg, 4);
    println("received /muse/elements/delta_absolute: " + arr2str(muse.delta_absolute));
  }
  else if(msg.checkAddrPattern("/muse/elements/theta_absolute")==true) {
    muse.loadFromOsc(muse.theta_absolute, msg, 4);
    println("received /muse/elements/theta_absolute: " + arr2str(muse.theta_absolute));
  }
  else if(msg.checkAddrPattern("/muse/elements/alpha_absolute")==true) {
    muse.loadFromOsc(muse.alpha_absolute, msg, 4);
    println("received /muse/elements/alpha_absolute: "+ arr2str(muse.alpha_absolute));
  }
  else if(msg.checkAddrPattern("/muse/elements/beta_absolute")==true) {
    muse.loadFromOsc(muse.beta_absolute, msg, 4);
    println("received /muse/elements/beta_absolute: " + arr2str(muse.beta_absolute));
  }
  else if(msg.checkAddrPattern("/muse/elements/gamma_absolute")==true) {
    muse.loadFromOsc(muse.gamma_absolute, msg, 4);
    println("received /muse/elements/gamma_absolute: " + arr2str(muse.gamma_absolute));
  }
  //*************************
  // catch and report session scores
  else if(msg.checkAddrPattern("/muse/elements/delta_session_score")==true) {
    muse.loadFromOsc(muse.delta_session, msg, 4);
    println("received /muse/elements/delta_session_score: " + arr2str(muse.delta_session));
  }
  else if(msg.checkAddrPattern("/muse/elements/theta_session_score")==true) {
    muse.loadFromOsc(muse.theta_session, msg, 4);
    println("received /muse/elements/theta_session_score: " + arr2str(muse.theta_session));
  }
  else if(msg.checkAddrPattern("/muse/elements/alpha_session_score")==true) {
    muse.loadFromOsc(muse.alpha_session, msg, 4);
    println("received /muse/elements/alpha_session_score: "+ arr2str(muse.alpha_session));
  }
  else if(msg.checkAddrPattern("/muse/elements/beta_session_score")==true) {
    muse.loadFromOsc(muse.beta_session, msg, 4);
    println("received /muse/elements/beta_session_score: " + arr2str(muse.beta_session));
  }
  else if(msg.checkAddrPattern("/muse/elements/gamma_session_score")==true) {
    muse.loadFromOsc(muse.gamma_session, msg, 4);
    println("received /muse/elements/gamma_session_score: " + arr2str(muse.gamma_session));
  }
  //*************************
  // catch and report session scores
  else if(msg.checkAddrPattern("/muse/elements/delta_relative")==true) {
    muse.loadFromOsc(muse.delta_rel, msg, 4);
    println("received /muse/elements/delta_relative: " + arr2str(muse.delta_rel));
  }
  else if(msg.checkAddrPattern("/muse/elements/theta_relative")==true) {
    muse.loadFromOsc(muse.theta_rel, msg, 4);
    println("received /muse/elements/theta_relative: " + arr2str(muse.theta_rel));
  }
  else if(msg.checkAddrPattern("/muse/elements/alpha_relative")==true) {
    muse.loadFromOsc(muse.alpha_rel, msg, 4);
    println("received /muse/elements/alpha_relative: "+ arr2str(muse.alpha_rel));
  }
  else if(msg.checkAddrPattern("/muse/elements/beta_relative")==true) {
    muse.loadFromOsc(muse.beta_rel, msg, 4);
    println("received /muse/elements/beta_relative: " + arr2str(muse.beta_rel));
  }
  else if(msg.checkAddrPattern("/muse/elements/gamma_relative")==true) {
    muse.loadFromOsc(muse.gamma_rel, msg, 4);
    println("received /muse/elements/gamma_relative: " + arr2str(muse.gamma_rel));
  }
  
  // concentration and mellow metrics
  else if(msg.checkAddrPattern("/muse/elements/experimental/concentration")==true) {
    muse.concentration = msg.get(0).floatValue();
    println("received /muse/elements/experimental/concentration: " + muse.concentration);
  }
  else if(msg.checkAddrPattern("/muse/elements/experimental/mellow")==true) {
    muse.mellow = msg.get(0).floatValue();
    println("received /muse/elements/experimental/mellow: " +muse.mellow);
  }

} // end oscEvent()

*/













