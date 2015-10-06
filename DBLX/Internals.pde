//******************************************************************** IMPORTS
import heronarts.lx.*;
import heronarts.lx.audio.*;
import heronarts.lx.color.*;
import heronarts.lx.model.*;
import heronarts.lx.modulator.*;
import heronarts.lx.parameter.*;
import heronarts.lx.pattern.*;
import heronarts.lx.transition.*;
import heronarts.p2lx.*;
import heronarts.p2lx.ui.*;
import heronarts.p2lx.ui.control.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import rwmidi.*;

import java.awt.Dimension;
import processing.opengl.*;

import java.awt.Toolkit;
import java.lang.reflect.*;
import java.net.*;
import java.util.*;
import java.nio.*;


OscP5 global_sender;

//************************************************************ GLOBAL SETTINGS

//set screen size
Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
final int VIEWPORT_WIDTH  = 900;
final int VIEWPORT_HEIGHT = 900;

// Display configuration mode
boolean mappingMode    = false;
boolean debugMode      = false;
boolean simulationOn   = true ;
boolean structureOn    = false;
boolean diagnosticsOn  = false;
boolean drawTrailer    = false;

static final int LEFT_CHANNEL = 0;
static final int RIGHT_CHANNEL = 1;

// Let's work in inches
final static int INCHES = 1;
final static int FEET = 12*INCHES;
float[] hsb = new float[3];

// Top-level, we have a model and a P2LX instance
P2LX              lx;
static Model      model;
LXPattern[]       patterns;
LXTransition[]    transitions;
Effects           effects;
LXEffect[]        effectsArr;
DiscreteParameter selectedEffect;
//MappingTool       mappingTool;
PresetManager     presetManager;
//MidiEngine        midiEngine;

NerveBundle       nervebundle;
HueCyclePalette   palette;

//
// Handles to UI objects
UIChannelControl uiPatternA;
UIChannelControl uiPatternL;
UIChannelControl uiPatternR;
UICrossfader uiCrossfader;
//UIMidi uiMidi;
//UIMapping uiMapping;
UIDebugText uiDebugText;
UISpeed uiSpeed;
UITempo uiTempo; 
UIBrainlove uiBrainlove;
UIMuse uiMuse;
boolean osc_send=false;
OscP5 pixelListener;
color[] oscColors;

double global_brightness = 1.0;

//************************************* Engine Construction and Initialization

LXTransition _transition(P2LX lx) {
  return new DissolveTransition(lx).setDuration(1000);
}

LXPattern[] _leftPatterns(P2LX lx) {
  LXPattern[] patterns = patterns(lx);
  for (LXPattern p : patterns) {
    p.setTransition(_transition(lx));
   }
  return patterns;
}

LXPattern[] _rightPatterns(P2LX lx) {
  LXPattern[] patterns = _leftPatterns(lx);
  LXPattern[] rightPatterns = new LXPattern[patterns.length+1];
  int i = 0;
  rightPatterns[i++] = new BlankPattern(lx).setTransition(_transition(lx));
  for (LXPattern p : patterns) {
    rightPatterns[i++] = p;
  }
  return rightPatterns;
}

LXEffect[] _effectsArray(Effects effects) {
  List<LXEffect> effectList = new ArrayList<LXEffect>();
  for (Field f : effects.getClass().getDeclaredFields()) {
    try {
      Object val = f.get(effects);
      if (val instanceof LXEffect) {
        effectList.add((LXEffect)val);
      }
    } catch (IllegalAccessException iax) {}
  }
  return effectList.toArray(new LXEffect[]{});
}

LXEffect getSelectedEffect() {
  return effectsArr[selectedEffect.getValuei()];
}


//---------------------------------------------------------------- PixelPusher
// NOTE: Uncomment these to enable PixelPusher
//PixelPusherObserver ppObserver;
//DeviceRegistry registry;
//float[] hsb = new float[3];

//------------------------------------------------------------------ FPS Meter
long simulationNanos = 0;
int startMillis, lastMillis;
int FPS_TARGET = 60;  
void drawFPS() {  
  fill(#999999);
  textSize(9);
  textAlign(LEFT, BASELINE);
  text("FPS: " + ((int) (frameRate*10)) / 10. + " / " + "60" + " (-/+)", 4, height-4);
}


public void logTime(String evt) {
  int now = millis();
  System.out.format("%5d ms: %s\n", (now - lastMillis), evt);
  lastMillis = now;
}



/** *************************************************************** MAIN SETUP
 * Set up models etc for whole package (Processing thing).
************************************************************************** **/
void setup() {

  startMillis = lastMillis = millis();
  logTime("Setting up DBLX");

  colorMode(HSB);                                 // nicer color mode
  size(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, OPENGL);  // startup screen size
  frame.setResizable(true);                       // but is resizable
  
  //not necessary, uncomment and play with it if the frame has issues
  //size((int)screenSize.getWidth(), (int)screenSize.getHeight(), OPENGL);
  //frame.setSize((int)screenSize.getWidth(), (int)screenSize.getHeight());
  
  //framerates
  frameRate(FPS_TARGET);
  noSmooth();
  logTime("Created viewport");
 

  //==================================================================== Model 
  
  //Actually builds the model (per mappings.pde)
  model = buildTheBrain(bar_selection);
  logTime("Loaded Model");
  model.initialize();
  model.setChannelMap();
  /* uncomment to check pixel indexes
  for (int i =0; i<48; i++){
     println(i);
    println(model.channelMap.get(i)); 
  }*/
  
  logTime("Initialized Model " + bar_selection 
        + ". Total pixels: " + model.points.size());
  
  //===================================================================== P2LX
  lx = new P2LX(this, model);
  lx.enableKeyboardTempo();
  logTime("Initialized LX"); 
  
  //-------------- Engine
  LXEngine engine = lx.engine;
  //engine.framesPerSecond.setValue(FPS_TARGET);
  engine.setThreaded(false);
  logTime("Initialized Engine"); 
  
  //-------------- Patterns
  engine.setPatterns(patterns = _leftPatterns(lx));
  engine.addChannel(_rightPatterns(lx));
  logTime("Initialized Patterns"); 
  
  //-------------- Transitions
  transitions = transitions(lx);
  engine.getChannel(RIGHT_CHANNEL)
        .setFaderTransition(transitions[0]); 
  logTime("Initialized Transitions"); 
  
  //-------------- Effects
  lx.addEffects(effectsArr = _effectsArray(effects = new Effects()));
  selectedEffect = new DiscreteParameter("EFFECT", effectsArr.length);
  logTime("Built Effects");

  //-------------- Presets
  presetManager = new PresetManager();
  logTime("Loaded Presets");

  //-------------- MIDI
  //midiEngine = new MidiEngine();
  //logTime("Setup MIDI devices");

  //-------------- Nerve Bundle
  nervebundle = new NerveBundle(lx);
 
  
  //-------------- Global Palette
  //println("Available Capture Devices: " + Capture.list());
  palette = new HueCyclePalette(lx);
  palette.hueMode.setValue(LXPalette.HUE_MODE_CYCLE);
  engine.getChannel(0).setPalette(palette);
  engine.addLoopTask(palette);
  logTime("Created deprecated global color palette");


  //====================================================== 3D Simulation Layer
  //adjust this if you want to play with the initial camera setting.
  // A camera layer makes an OpenGL layer that we can easily 
  // pivot around with the mouse
 
  UI3dContext context3d = 
    new UI3dContext(lx.ui) {
      protected void beforeDraw(UI ui, PGraphics pg) {
        // Let's add lighting and depth-testing to our 3-D simulation
        pointLight(0, 0, 40, model.cx, model.cy, -20*FEET);
        pointLight(0, 0, 50, model.cx, model.yMax + 10*FEET, model.cz);
        pointLight(0, 0, 20, model.cx, model.yMin - 10*FEET, model.cz);
        //hint(ENABLE_DEPTH_TEST);
      }
      protected void afterDraw(UI ui, PGraphics pg) {
        // Turn off the lights and kill depth testing before the 2D layers
        noLights();
        hint(DISABLE_DEPTH_TEST);
      } 
    }
    .setRadius(50*FEET)             // distance
    .setTheta(PI)                   // look at front of model
    //.setPhi(PI/24)                // which axis?
    //.setRotateVelocity(12*PI)     // broken?
    //.setRotateAcceleration(3*PI)  // broken?
    .setPerspective(0)
    .setCenter(model.cx, model.cy, model.cz)
    
    // Let's add a point cloud of our animation points
    .addComponent(new UIBrainComponent())
    ;
  lx.ui.addLayer(context3d);
 
 
  //=========================================================== 2D Control GUI 
  // A basic built-in 2-D control for a channel
  //lx.ui.addLayer(new UIChannelControl(lx.ui, lx.engine.getChannel(0), 4, 4));
  //lx.ui.addLayer(new UIEngineControl(lx.ui, 4, 326));
  //lx.ui.addLayer(new UIComponentsDemo(lx.ui, width-144, 4));
  //lx.ui.addLayer(new UIGlobalControl(lx.ui, width-288, 4));
  //lx.ui.addLayer(new UICameraControl(lx.ui, context, 4, 450));

  LXChannel L = lx.engine.getChannel(LEFT_CHANNEL);
  LXChannel R = lx.engine.getChannel(RIGHT_CHANNEL);
  
  uiPatternL = new UIChannelControl(lx.ui, L, "PRIMARY PATTERNS", 16, 4, 4);
  uiPatternR = new UIChannelControl(lx.ui, R, "MIXING PATTERNS", 16, width-144, 4);
  uiPatternA = uiPatternL;

  UI2dContext[] layers = new UI2dContext[] {
    // Left controls
    uiPatternL,
    new UIEffects(4, 374, 140, 144),
    uiTempo = new UITempo(4, 522, 140, 50),
    uiSpeed = new UISpeed(4, 576, 140, 50),
    uiBrainlove = new UIBrainlove(4,620,140,100),    
    // Right controls
    uiPatternR,
    //uiMidi = new UIMidi(midiEngine, width-144, 374, 140, 158),
    //new UIOutput(width-144, 536, 140, 106),
    
    // Crossfader
    uiCrossfader = new UICrossfader(width/2-130, height-90, 180, 86),
    new UIBlendMode(width/2+54, height-90, 140, 86),
    
    // Overlays
    uiDebugText = new UIDebugText(148, height-138, width-304, 44),
    //uiMapping = new UIMapping(mappingTool, 4, 4, 140, 324)
    uiMuse = new UIMuse(width-144,height-180,144,170),    
  };


  //layers.addLayer(uiPatternL);
  //layers.addLayer(uiPatternR);
  
      //uiMapping.setVisible(false);  
  for (UI2dContext layer : layers) {
    lx.ui.addLayer(layer);
  }

  //add the Output toggle UI
  lx.ui.addLayer(new UIOutput(lx.ui, width-144, 400, 140, 106));


  logTime("Built UI");  

  //==================================================== Output to Controllers
  // create outputs via CortexOutput
  buildOutputs();
  pixelListener = new OscP5(this, 20001, OscP5.TCP);
  oscColors = lx.getColors().clone();
 }


/**
 * Processing's draw loop.
*/
void draw() {

  //pushMatrix();

  // Wipe the frame...
  background(40);
  color[] sendColors = lx.getColors();  
  long gammaStart = System.nanoTime();
  
  drawFPS();
  //NOTE: Uncomment to enable PixelPusher
  //push_pixels(sendColors);

  for(int i=0; i<sendColors.length; i++){
    LXColor.RGBtoHSB(sendColors[i], hsb);
    float b = hsb[2];
    sendColors[i] = lx.hsb(360.*hsb[0], 100.*hsb[1], 100*(b*(float)global_brightness));
  }
  if(osc_send) {
    if(global_sender==null){
       //replace with IP of receiver
       //global_sender=new OscP5(this, "192.168.1.10", 20001,OscP5.TCP);
       global_sender=new OscP5(this, "127.0.0.1", 20001,OscP5.TCP);
    }
    ByteBuffer bb = ByteBuffer.allocate(sendColors.length*4);
    bb.asIntBuffer().put((int[])sendColors);
    bb.compact();
    byte[] oscOut = bb.array();
    global_sender.send("/pixels", new Object[] { oscOut });
  }
    

  // Comment out to COMMENT_OUT_PIXELPUSHER if push_pixels is uncommented (it's included in push_pixels)
  // DMK:  Somewhat strongly suspect cubic gamma on APA102 is wild overkill, but we'll check /
  //       add as a config
  // Gamma correction here. Apply a cubic to the brightness
  // for better representation of dynamic range
  /*for (int i = 0; i < sendColors.length; ++i) {
    LXColor.RGBtoHSB(sendColors[i], hsb);
    float b = hsb[2];
    sendColors[i] = lx.hsb(360.*hsb[0], 100.*hsb[1], 100.*(b*b*b));
  }*/
  


  // ...and everything else is handled by P2LX!
  //popMatrix();
}

void oscEvent(OscMessage msg){
  // don't know if this works yet
  if(msg.checkAddrPattern("/pixels")){
    byte[] oscBytes = msg.get(0).bytesValue();
    ByteBuffer oscByteBuffer = ByteBuffer.wrap(oscBytes);
    for(int i=0; i<oscColors.length; i++){
      oscColors[i] = oscByteBuffer.asIntBuffer().get(i);
    }
  }
}

