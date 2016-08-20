import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.io.IOException; 
import java.io.OutputStream; 
import java.net.ConnectException; 
import java.net.InetSocketAddress; 
import java.net.Socket; 
import heronarts.lx.LX; 
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
import processing.serial.*; 
import java.awt.Toolkit; 
import java.lang.reflect.*; 
import java.net.*; 
import java.util.*; 
import java.io.*; 
import java.nio.file.*; 
import java.util.*; 
import java.io.*; 
import java.nio.file.*; 
import java.util.*; 
import oscP5.*; 
import netP5.*; 
import java.awt.Color; 
import org.jcolorbrewer.ColorBrewer; 
import java.util.Random; 
import ddf.minim.*; 
import ddf.minim.ugens.*; 
import ddf.minim.effects.*; 
import processing.video.*; 
import oscP5.*; 
import netP5.*; 
import java.awt.AWTException; 
import java.awt.Robot; 
import java.awt.Rectangle; 
import java.awt.Toolkit; 
import java.awt.image.BufferedImage; 
import java.awt.image.BufferedImage.*; 
import java.io.*; 
import javax.imageio.ImageIO; 
import java.nio.*; 
import java.util.Arrays; 
import java.nio.*; 
import java.util.Arrays; 

import demo.*; 
import org.jcolorbrewer.*; 
import org.jcolorbrewer.ui.*; 
import netP5.*; 
import oscP5.*; 
import heronarts.lx.*; 
import heronarts.lx.audio.*; 
import heronarts.lx.color.*; 
import heronarts.lx.effect.*; 
import heronarts.lx.midi.*; 
import heronarts.lx.midi.device.*; 
import heronarts.lx.model.*; 
import heronarts.lx.modulator.*; 
import heronarts.lx.output.*; 
import heronarts.lx.parameter.*; 
import heronarts.lx.pattern.*; 
import heronarts.lx.transform.*; 
import heronarts.lx.transition.*; 
import heronarts.p2lx.*; 
import heronarts.p2lx.font.*; 
import heronarts.p2lx.ui.*; 
import heronarts.p2lx.ui.component.*; 
import heronarts.p2lx.ui.control.*; 
import heronarts.p2lx.video.*; 
import rwmidi.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class DBLX extends PApplet {

/*
** The Phage presents
**    Dr. Brainlove's brain
**
**  _______   _______   __        __    __ 
** /       \ /       \ /  |      /  |  /  |
** $$$$$$$  |$$$$$$$  |$$ |      $$ |  $$ |
** $$ |  $$ |$$ |__$$ |$$ |      $$  \/$$/ 
** $$ |  $$ |$$    $$< $$ |       $$  $$<  
** $$ |  $$ |$$$$$$$  |$$ |        $$$$  \ 
** $$ |__$$ |$$ |__$$ |$$ |_____  $$ /$$  |
** $$    $$/ $$    $$/ $$       |$$ |  $$ |
** $$$$$$$/  $$$$$$$/  $$$$$$$$/ $$/   $$/ 
** 
**        _---~~(~~-_.
**      _{        )   )
**    ,   ) -~~- ( ,-' )_
**   (  `-,_..`., )-- '_,)
**  ( ` _)  (  -~( -_ `,  }
**  (_-  _  ~_-~~~~`,  ,' )
**    `~ -^(    __;-,((()))
**          ~~~~ {_ -_(())
**                 `\  }
**                   { }
**                    
** Authors:
**   Alex Scouras
**   Alex Maki-Jokela
**   Mike Pesavento
**     + pattern designers
** 
** @date: 2015.08.26
**/


// Which bar selection to use. 
// For the hackathon we're using the full_brain but there are a few others
// for other reasons (single modules, reduced-bar-version, etc)
//String bar_selection = "Module_14";
// Brain we'll have lit on playa: Playa_Brain
String bar_selection = "Playa_Brain_2016_unfucked";



//---------------- Patterns
public LXPattern[] patterns(P2LX lx) {
  return new LXPattern[] {
    //new BarLengthTestPattern(lx),    
    new ShowModulesPattern(lx),
    new ShowMappingPattern(lx),
    new PixiePattern(lx),
    new Psychedelic(lx),
    new Swim(lx),
    new NeuroTracePattern(lx),
    new Scraper(lx),
    //new MuseConcMellow(lx),
    //new PixelOSCListener(lx),
    //new BrainRender(lx),
    new BrainStorm(lx),

    //new VidPattern(lx),
    new Swim(lx), // from sugarcubes
    new WaveFrontPattern(lx),
    //new MusicResponse(lx),
   // new AVBrainPattern(lx),
    new AHoleInMyBrain(lx),
    
    //had to comment out annaPattern because it wasn't working with the 
    //Playa_Brain subset - probably a specific node/bar thing.
    //She sent us a new finished version via email - 
    //TODO to add it back in and make it work! 
    //new annaPattern(lx), 
    //new RangersPattern(lx),
    
    new Voronoi(lx),
    new Serpents(lx),
    new BrainStorm(lx),
    new PixiePattern(lx),
    new MoireManifoldPattern(lx),
    new StrobePattern(lx),
    new ColorStatic(lx),
    new TestImagePattern(lx),
    //new HelloWorldPattern(lx),
    new GradientPattern(lx),
    //new LXPaletteDemo(lx),
    //new TestHemispheres(lx),
    new HeartBeatPattern(lx),
    new RandomBarFades(lx),
    new RainbowBarrelRoll(lx),
    new EQTesting(lx),
    //new LayerDemoPattern(lx),
    new CircleBounce(lx),
    new SampleNodeTraversalWithFade(lx),
    //new IteratorTestPattern(lx),
    //new TestBarPattern(lx),

  };
};


//---------------- Transitions
public LXTransition[] transitions(P2LX lx) {
  return new LXTransition[] {
    new AddTransition(lx),
    new DissolveTransition(lx),
    new MultiplyTransition(lx),
    new SubtractTransition(lx),
    new FadeTransition(lx),
    // TODO(mcslee): restore these blend modes in P2LX
    // new OverlayTransition(lx),
    // new DodgeTransition(lx),
    //new SlideTransition(lx),
    //new WipeTransition(lx),
    //new IrisTransition(lx),
  };
};


//---------------- Effects
class Effects {
  FlashEffect flash = new FlashEffect(lx);
  SparkleEffect sparkle = new SparkleEffect(lx);
  
  Effects() {
  }
}  
/** ************************************************************ BRAIN PATTERN
 * Creates a custom pattern class for writing patterns onto the brain model 
 * Don't modify unless you know what you're doing.
 ************************************************************************* **/
//private static ArrayList<BrainPattern> patterns = new ArrayList<BrainPattern>();
public abstract class BrainPattern extends LXPattern {
  protected Model model;
  public boolean visible = true;
  
  protected BrainPattern(LX lx) {
    super(lx);
    logTime("-- Initialized BrainPalette: " + this.getClass().getName());
    this.model = (Model) lx.model;
    // auto-register visible patterns to the global list
    //if (visible) { patterns.add(this); }
  }
}
/*
 * Motor cortex:
 * Create output to the LEDs via OSC packets to BeagleBone Black
 * Each BBB pushes up to 24 channels of <=512 pixels per channel
 *
 * @author mjp 2015.08.08
 */











int nPixPerChannel = 512; // OPC server is set to 512 pix per channel
int nChannelPerBoard = 48;

public int[] concatenateChannels(int boardNum) {
    // expects boardNum to be indexed starting at *1*
    //println("concatenating board " + boardNum);
    int[] pixIndex = new int[nPixPerChannel*nChannelPerBoard];
    int boardOffset =(boardNum-1)*nChannelPerBoard; 
    for (int i=boardOffset; i<boardOffset+nChannelPerBoard; i++) {
        println(i);
        int[] channelIx = model.channelMap.get(i);
        //println("adding channel " + i + ", "+ channelIx.length + " pix");
        for(int j=0; j<channelIx.length; j++) {
            //println( i * nPixPerChannel - boardOffset*nPixPerChannel + j);
            pixIndex[i * nPixPerChannel - boardOffset*nPixPerChannel + j] = channelIx[j];
        }
    }    
    return pixIndex;
}

public void buildOutputs() {
    lx.addOutput(new CortexOutput(lx, "192.168.1.81", 1, concatenateChannels(1)));
    lx.addOutput(new CortexOutput(lx ,"192.168.1.86", 2, concatenateChannels(2)));
    lx.addOutput(new CortexOutput(lx ,"192.168.1.87", 3, concatenateChannels(3)));
}


ArrayList<CortexOutput> cortexList = new ArrayList<CortexOutput>();


public class CortexOutput extends LXOutput {
  // constants for creating OPC header
  static final int HEADER_LEN = 4;
  static final int BYTES_PER_PIXEL = 3;
  static final int INDEX_CHANNEL = 0;
  static final int INDEX_COMMAND = 1;
  static final int INDEX_DATA_LEN_MSB = 2;
  static final int INDEX_DATA_LEN_LSB = 3;
  static final int INDEX_DATA = 4;
  static final int OFFSET_R = 0;
  static final int OFFSET_G = 1;
  static final int OFFSET_B = 2;

  static final int COMMAND_SET_PIXEL_COLORS = 0;

  static final int PORT = 7890; //the standard OPC port

  Socket socket;
  OutputStream output;
  String host;
  int port = 7890;

  public int boardNum;
  public int channelNum; 
  public byte[] packetData;

  private final int[] pointIndices;

  CortexOutput(LX lx, String _host, int _boardNum, int[] _pointIndices) {
    super(lx);
    this.host = _host;
    this.boardNum = _boardNum;
    this.pointIndices = _pointIndices;
    this.socket = null;
    this.output = null;
    enabled.setValue(true);

    cortexList.add(this);

    int dataLength = BYTES_PER_PIXEL*nPixPerChannel*nChannelPerBoard;
    this.packetData = new byte[HEADER_LEN + dataLength];
    this.packetData[INDEX_CHANNEL] = 0;
    this.packetData[INDEX_COMMAND] = COMMAND_SET_PIXEL_COLORS;
    this.packetData[INDEX_DATA_LEN_MSB] = (byte)(dataLength >>> 8);
    this.packetData[INDEX_DATA_LEN_LSB] = (byte)(dataLength & 0xFF);

    this.connect();

  }


  public boolean isConnected() {
    return (this.output != null);
  }

  private void connect() {
    // if (this.socket == null) {
    if (this.output == null) {
      try {
        this.socket = new Socket();
        this.socket.connect(new InetSocketAddress(this.host, this.port), 100);
        // this.socket.setTcpNoDelay(true); // disable on SugarCubes
        this.output = this.socket.getOutputStream();
        didConnect();
      } 
      catch (ConnectException cx) { 
        dispose(cx);
      } 
      catch (IOException iox) { 
        dispose(iox);
      }
    }
  }

  protected void didConnect() {
//    println("Connected to OPC server: " + host + " for channel " + channelNum);
  }
  
  protected void closeChannel() {
    try {
      this.output.close();
      this.socket.close();
    }
    catch (IOException e) {
      println("tried closing a channel and fucked up");
    }    
  }
  
  protected void dispose() {
    if (output != null) {
      closeChannel();
    }
    this.socket = null;
    this.output = null;
  }

  protected void dispose(Exception x) {
    if (output != null)  println("Disconnected from OPC server");
    this.socket = null;
    this.output = null;
    didDispose(x);
  }

  protected void didDispose(Exception x) {
//    println("Failed to connect to OPC server " + host);
//    println("disposed");
  }

  // @Override
  protected void onSend(int[] colors) {
    if (packetData == null || packetData.length == 0) return;

    for(int i=0; i<colors.length; i++){
      // TODO MJP: this might not work as expected, if we are dimming the global color array for each datagram that is sent
      LXColor.RGBtoHSB(colors[i], hsb);
      float b = hsb[2];
      colors[i] = lx.hsb(360.f*hsb[0], 100.f*hsb[1], 100*(b*(float)global_brightness)
  );
    }

    //connect();
    
    if (isConnected()) {
      try {
        this.output.write(getPacketData(colors));
      } 
      catch (IOException iox) {
        dispose(iox);
      }
    }
    
  }

  // @Override
  protected byte[] getPacketData(int[] colors) {
    for (int i = 0; i < this.pointIndices.length; ++i) {
      int dataOffset = INDEX_DATA + i * BYTES_PER_PIXEL;
      int c = colors[this.pointIndices[i]];
      this.packetData[dataOffset + OFFSET_R] = (byte) (0xFF & (c >> 16));
      this.packetData[dataOffset + OFFSET_G] = (byte) (0xFF & (c >> 8));
      this.packetData[dataOffset + OFFSET_B] = (byte) (0xFF & c);
    }
    // all other values in packetData should be 0 by default
    return this.packetData;
  }
}




//---------------------------------------------------------------------------------------------
// add UI components for the hardware, allowing enable/disable

class UIOutput extends UIWindow {
  UIOutput(UI ui, float x, float y, float w, float h) {
    super(ui, "OUTPUT", x, y, w, h);
    float yPos = UIWindow.TITLE_LABEL_HEIGHT - 2;
    List<UIItemList.Item> items = new ArrayList<UIItemList.Item>();
    items.add(new OutputItem());

    new UIItemList(1, yPos, width-2, 260)
      .setItems(items)
      .addToContainer(this);
  }

  class OutputItem extends UIItemList.AbstractItem {
    OutputItem() {
      for (CortexOutput ch : cortexList) {
        ch.enabled.addListener(new LXParameterListener() {
          public void onParameterChanged(LXParameter parameter) { 
            redraw();
          }
        }
        );
      }
    } 
    public String getLabel() { 
      return "ALL CHANNELS";
    }
    public boolean isSelected() { 
      // jut check the first one, since they either should all be on or all be off
      return cortexList.get(0).enabled.isOn();
    }
    public void onMousePressed() { 
      for (CortexOutput ch : cortexList) { 
        ch.enabled.toggle();
        if (ch.enabled.isOn()) {
          ch.connect();
        }
        else {
//          ch.closeChannel();
          ch.dispose();
        }
      }
    } // end onMousePressed
  }
  
}

//---------------------------------------------------------------------------------------------


class SparkleEffect extends LXEffect {

  SparkleEffect(LX lx) {
    super(lx, true);
  }

  public void run(double deltaMs) {

  }
}
//******************************************************************** IMPORTS



























//************************************************************ GLOBAL SETTINGS

//set screen size
Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
final int VIEWPORT_WIDTH  = 1200;
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

UIMuseControl uiMuseControl;
UIMuseHUD uiMuseHUD;

LXChannel L;
LXChannel R;

// Brain-computer interface and external sensor interaction

// define Muse globals
MuseConnect muse;
MuseHUD museHUD;
int MUSE_OSCPORT = 5000;
boolean museActivated = false;

// global parameter to adjust output brightness
// MJP: unclear if this affects display brightness as well
double global_brightness = 1.0f;

  


//************************************* Engine Construction and Initialization

public LXTransition _transition(P2LX lx) {
  return new DissolveTransition(lx).setDuration(1000);
}

public LXPattern[] _leftPatterns(P2LX lx) {
  LXPattern[] patterns = patterns(lx);
  for (LXPattern p : patterns) {
    p.setTransition(_transition(lx));
   }
  return patterns;
}

public LXPattern[] _rightPatterns(P2LX lx) {
  LXPattern[] patterns = _leftPatterns(lx);
  LXPattern[] rightPatterns = new LXPattern[patterns.length+1];
  int i = 0;
  rightPatterns[i++] = new BlankPattern(lx).setTransition(_transition(lx));
  for (LXPattern p : patterns) {
    rightPatterns[i++] = p;
  }
  return rightPatterns;
}

public LXEffect[] _effectsArray(Effects effects) {
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

public LXEffect getSelectedEffect() {
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
public void drawFPS() {  
  fill(0xff999999);
  textSize(9);
  textAlign(LEFT, BASELINE);
  text("FPS: " + ((int) (frameRate*10)) / 10.f + " / " + "60" + " (-/+)", 4, height-4);
}


public void logTime(String evt) {
  int now = millis();
  System.out.format("%5d ms: %s\n", (now - lastMillis), evt);
  lastMillis = now;
}


/** *************************************************************** MAIN SETUP
 * Set up models etc for whole package (Processing thing).
************************************************************************** **/
public void setup() {

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

  //==================================================== Initialize sensors
  //initialize the Muse connection
  // TODO: this should gracefully handle lack of Muse OSC input
  muse = new MuseConnect(this, MUSE_OSCPORT);
  museHUD = new MuseHUD(muse);
  logTime("added Muse OSC parser and HUD");


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

  //MJP channel initialization is now global
  L = lx.engine.getChannel(LEFT_CHANNEL);
  R = lx.engine.getChannel(RIGHT_CHANNEL);
  
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
    
    // Crossfader
    uiCrossfader = new UICrossfader(width/2-130, height-90, 180, 86),
    new UIBlendMode(width/2+54, height-90, 140, 86),
    
    // Overlays
    uiDebugText = new UIDebugText(148, height-138, width-304, 44),
    //uiMapping = new UIMapping(mappingTool, 4, 4, 140, 324)
      
    //add the MuseControl toggle UI & HUD
    uiMuseControl = new UIMuseControl(lx.ui, muse, width-150, height-350),
    uiMuseHUD = new UIMuseHUD(lx.ui, museHUD, width-150, height-300),
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
  logTime("Built output clients");



}


public byte[] messageDigest(String message, String algorithm) {
  try {
  java.security.MessageDigest md = java.security.MessageDigest.getInstance(algorithm);
  md.update(message.getBytes());
  return md.digest();
  } catch(java.security.NoSuchAlgorithmException e) {
    println(e.getMessage());
    return null;
  }
}

/**
 * Processing's draw loop.
*/
public void draw() {

  //pushMatrix();

  // Wipe the frame...
  background(40);
  int[] sendColors = lx.getColors();  
  long gammaStart = System.nanoTime();
  
  drawFPS();

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






//import processing.data.Table;

//Builds the brain model
//BEWARE. Lots of csvs and whatnot.
//It's uglier than sin, but the brain is complicated, internally redundant, and not always heirarchical.
//It works.
public Model buildTheBrain(String bar_selection_identifier) { 
  String mapping_data_location="mapping_datasets/"+bar_selection_identifier+"/";
  
  SortedMap<String, List<float[]>> barlists = new TreeMap<String, List<float[]>>();
  SortedMap<String, Integer> barstrips = new TreeMap<String, Integer>();
  SortedMap<String, Bar> bars = new TreeMap<String, Bar>();
  SortedMap<String, Node> nodes = new TreeMap<String, Node>();
  SortedMap<Integer, List<String>> stripMap = new TreeMap<Integer, List<String>>();
  for(int i=0; i<116; i++) {
   List<String> stringlist = new ArrayList<String>();
   stripMap.put(i,stringlist);
  }
  boolean newbar;
  boolean newnode;


  //Map the pixels to individual LEDs and in the process declare the physical bars.
  //As of 15/6/1 the physical bars are the only things that don't have their own declaration table
  //TODO: This is now mostly handled by the Bar class loading, so clean it up and get rid of the unnecessary parts.
  Table pixelmapping = loadTable(mapping_data_location+"pixel_mapping.csv", "header");
  List<float[]> bar_for_this_particular_led;
  Set barnames = new HashSet();
  Set nodenames = new HashSet();
  List<String> bars_in_pixel_order = new ArrayList<String>();
  for (processing.data.TableRow row : pixelmapping.rows()) {
    int pixel_num = row.getInt("Pixel_i");
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    float z = row.getFloat("Z");
    String node1 = row.getString("Node1");
    String node2 = row.getString("Node2");
    int strip_num = row.getInt("Strip");
    String bar_name=node1+"-"+node2;
    newbar=barnames.add(bar_name);
    if (newbar){
      bars_in_pixel_order.add(bar_name);
      List<float[]> poince = new ArrayList<float[]>();
      barlists.put(bar_name,poince); 
      barstrips.put(bar_name,strip_num);
    }
    bar_for_this_particular_led = barlists.get(bar_name);
    float[] point = new float[]{x,y,z};
    bar_for_this_particular_led.add(point);
  } 
  logTime("-- Finished loading pixel_mapping");
  
  
  //Load the node info for the model nodes. (ignores double nodes)
  Table node_csv = loadTable(mapping_data_location+"Model_Node_Info.csv","header");
  

  for (processing.data.TableRow row : node_csv.rows()) {
    String node = row.getString("Node");
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    float z = row.getFloat("Z");
    String csv_neighbors = row.getString("Neighbor_Nodes");
    String csv_connected_bars = row.getString("Bars");
//    String csv_connected_physical_bars = row.getString("Physical_Bars");
//    String csv_adjacent_physical_nodes = row.getString("Physical_Nodes");
    boolean ground;
    String groundstr = row.getString("Ground");
    String inner_outer = row.getString("Inner_Outer");
    String left_right_mid = row.getString("Left_Right_Mid");
    if (groundstr.equals("1")){
      ground=true;
    }
    else{
      ground=false;
    } 

    //all of those were strings - split by the underscores
    List<String> neighbors = Arrays.asList(csv_neighbors.split("_"));
    List<String> connected_bars = Arrays.asList(csv_connected_bars.split("_"));
    Node nod = new Node(node,x,y,z,connected_bars, neighbors, ground,inner_outer, left_right_mid); 
   
    nodes.put(node,nod);
  }
  logTime("-- Finished loading model_node_info");
  
  //Load the model bar info (which has conveniently abstracted away all of the double node jiggery-pokery)
  Table bars_csv = loadTable(mapping_data_location+"Model_Bar_Info.csv","header");
  
  for (processing.data.TableRow row : bars_csv.rows()) {
    String barname = row.getString("Bar_name");
    println(barname);
    float min_x = row.getFloat("Min_X");
    float min_y = row.getFloat("Min_Y");
    float min_z = row.getFloat("Min_Z");
    float max_x = row.getFloat("Max_X");
    float max_y = row.getFloat("Max_Y");
    float max_z = row.getFloat("Max_Z");
    String csv_nods=row.getString("Nodes");
    String module=row.getString("Module");
    String csv_adjacent_nodes = row.getString("Adjacent_Nodes");
    String csv_adjacent_bars = row.getString("Adjacent_Bars");
    String inner_outer = row.getString("Inner_Outer");
    String left_right_mid = row.getString("Left_Right_Mid");
    boolean ground;
    String groundstr = row.getString("Ground");
    if (groundstr.equals("1")){
      ground=true;
    }
    else{
      ground=false;
    } 
    //all of those were strings - split by the underscores
    List<String> nods=Arrays.asList(csv_nods.split("_"));
    List<String> connected_nodes = Arrays.asList(csv_adjacent_nodes.split("_"));
    List<String> connected_bars = Arrays.asList(csv_adjacent_bars.split("_"));
    float current_max_z=-10000;
    List<float[]> usethesepoints = new ArrayList<float[]>();
    usethesepoints = barlists.get(barname);
    int barstripnum=barstrips.get(barname);
    Bar barrrrrrr = new Bar(barname,usethesepoints,min_x,min_y,min_z,max_x,max_y,max_z,module,nods,connected_nodes,connected_bars, ground,inner_outer,left_right_mid,barstripnum);
  
  
    bars.put(barname,barrrrrrr);
  }


  //Load the strip info
  Table strips_csv = loadTable(mapping_data_location+"Node_to_node_in_strip_pixel_order.csv","header");
  
  for (processing.data.TableRow row : strips_csv.rows()) {
    int strip = row.getInt("Strip");
    String node1 = row.getString("Node1");
    String node2 = row.getString("Node2");
    String node1node2=node1+"_"+node2;
    println(strip,node1node2);
    List<String> existing_strip_in_stripMap = stripMap.get(strip);
    existing_strip_in_stripMap.add(node1node2);
    stripMap.put(strip,existing_strip_in_stripMap);
  }



  //Map the strip numbers to lengths so that they're easy to handle via  the pixelpusher
  IntList strip_lengths = new IntList();
  int current_strip=0;
  for (String pbarnam : bars_in_pixel_order){
   // String barnam=pbarnam.substring(0,8);
    Bar stripbar = bars.get(pbarnam);
    int strip_num = stripbar.strip_id;
    int pixels_in_pbar = stripbar.points.size();
    if (strip_num!=9999){ //9999 is the value for "there's no actual physical strip set up for this right now but show it in Processing anyways" 
      if (strip_num==current_strip){
        int existing_strip_length=strip_lengths.get(strip_num);
        int new_strip_length = existing_strip_length + pixels_in_pbar;
        strip_lengths.set(strip_num,new_strip_length);
      } else {
        strip_lengths.append(pixels_in_pbar);
        current_strip+=1;
      }
    }
  }


  println("Loaded Model bar info");
  
  Model model = new Model(nodes, bars, bars_in_pixel_order, strip_lengths, stripMap);
  // I can haz brain model.
  return model;
}
  
  
  
  
  
  
  
  
/**
 * This is a model OF A BRAIN!
 */




/** ******************************************************************** MODEL
 * This is the model for the whole brain. It contains four mappings, two of 
 * which users should use (Bar and Node) and two which are set up to deal 
 * with the physical reality of the actual brain, double bars and double
 * nodes and so on. 
 * @author Alex Maki-Jokela
 ************************************************************************* **/
public static class Model extends LXModel {

  //Note that these are stored in maps, not lists. 
  //Nodes are keyed by their three letter name ("LAB", "YAK", etc)
  //Bars are keyed by the two associated nodes in alphabetical order ("LAB-YAK", etc)
  public final SortedMap<String, Node> nodemap;
  public final SortedMap<String, Bar> barmap;

  public final List<String> bars_in_pixel_order;
  public final IntList strip_lengths;
  public final SortedMap<Integer,List<String>> stripMap;
  public ArrayList<int[]> channelMap;


  /** 
   * Constructor for Model. The parameters are all fed from Mappings.pde
   * @param nodemap is a mapping of node names to their objects
   * @param barmap is a mapping of bar names to their objects
   * @param bars_in_pixel_order is a list of the physical bars in order of 
   * LED indexes which is used for mapping them to LED strings
   */
  public Model(SortedMap<String, Node> nodemap, SortedMap<String, Bar> barmap, List<String> bars_in_pixel_order, IntList strip_lengths, SortedMap<Integer,List<String>> stripMap) {
    super(new Fixture(barmap, bars_in_pixel_order));
    this.nodemap = Collections.unmodifiableSortedMap(nodemap);
    this.barmap = Collections.unmodifiableSortedMap(barmap);
    this.bars_in_pixel_order = Collections.unmodifiableList(bars_in_pixel_order);
    this.strip_lengths = strip_lengths;
    this.stripMap = stripMap;
    this.channelMap = new ArrayList<int[]>();
  }

  public void initialize() {
    // Initialize Node-Bar Connections in Model
    for (String barname : barmap.keySet()){
      Bar bar = barmap.get(barname);
      bar.initialize_model_connections();
    }
    for (String nodename : nodemap.keySet()){
      Node node = nodemap.get(nodename);
      node.initialize_model_connections();
    }
  }



  /**
  * Maps the points from the bars into the brain. Note that it iterates through bars_in_pixel_order
  * @param barmap is the map of bars
  * @param bars_in_pixel_order is the list of bar names in order LED indexes
  */
  private static class Fixture extends LXAbstractFixture {
    private Fixture(SortedMap<String, Bar> barmap, List<String> bars_in_pixel_order) {
      for (String barname : bars_in_pixel_order) {
        Bar bar = barmap.get(barname);
        if (bar != null) {
          for (LXPoint p : bar.points) {
            this.points.add(p);
          }
        }
      }
    }
  }

  public void setChannelMap() {
    ArrayList<int[]> channelmap = new ArrayList<int[]>();
    for(int i=0; i<this.stripMap.size(); i++) {
     IntList intce = new IntList(512);
     int[] intcearray = intce.array();
     channelmap.add(intcearray);
     List<String> striplist=this.stripMap.get(i);
     for (String node1node2 : striplist) {
      List<String> nodes = Arrays.asList(node1node2.split("_"));
      Node node1 = this.nodemap.get(nodes.get(0));
      Node node2 = this.nodemap.get(nodes.get(1));
      List<LXPoint> nodetonodepoints = nodeToNodePoints(node1,node2);
      for (LXPoint p : nodetonodepoints) {
        intce.append(p.index);
      }
     }
    intcearray = intce.array();
    channelmap.set(i,intcearray);
    }
    this.channelMap=channelmap;
  }
     
     
     
  /**
  * Chooses a random node from the model.
  */
  public Node getRandomNode() {
    // TODO: Instead of declaring a new Random every call, can we just put 
    // one at the top outside of everything?
    Random randomized = new Random();
    // TODO: Can this be optimized better? We're using maps so Processing's 
    // random function doesn't seem to apply here
    List<String> nodekeys = new ArrayList<String>(this.nodemap.keySet());
    String randomnodekey = nodekeys.get( randomized.nextInt(nodekeys.size()) );
    Node randomnode = this.nodemap.get(randomnodekey);
    return randomnode;
  }
  
  
 public Node getFirstNodeAnnaPattern() {
    
    List<String> nodekeys = new ArrayList<String>(this.nodemap.keySet());
    String randomnodekey = nodekeys.get(8);
    Node randomnode = this.nodemap.get(randomnodekey);
    return randomnode;
  }

  /**
  * Gets a random bar from the model
  * If I could write getRandomIrishPub and have it work, I would.
  */
  public Bar getRandomBar() {
    //TODO: Instead of declaring a new Random every call, can we just put one at the top outside of everything?
    Random randomized = new Random();
    //TODO: Can this be optimized better? We're using maps so Processing's random function doesn't seem to apply here
    List<String> barkeys = new ArrayList<String>(this.barmap.keySet());
    String randombarkey = barkeys.get( randomized.nextInt(barkeys.size()) );
    Bar randombar = this.barmap.get(randombarkey);
    return randombar;
  }

  /**
   * Gets a random point from the model.
   */
  public LXPoint getRandomPoint() {
    Random randomized = new Random();
    Bar r = getRandomBar();
    return r.points.get(randomized.nextInt(r.points.size()));
  }

  /**
   * Gets random points from the model.
   */
  public ArrayList<LXPoint> getRandomPoints(int num_requested) {
    Random randomized = new Random();
    ArrayList<LXPoint> returnpoints = new ArrayList<LXPoint>();
    
    while (returnpoints.size () < num_requested) {
      returnpoints.add(this.getRandomPoint());
    }
    
    return returnpoints;
  }

  /**
  * Returns an arraylist of randomly selected nodes from the model
  * @param num_requested: How many randomly selected nodes does the user want?
  */
  public ArrayList<Node> getRandomNodes(int num_requested) {
    Random randomized = new Random();
    ArrayList<String> returnnodstrs = new ArrayList<String>();
    ArrayList<Node> returnnods = new ArrayList<Node>();
    List<String> nodekeys = new ArrayList<String>(this.nodemap.keySet());
    if (num_requested > nodekeys.size()) {
      num_requested = nodekeys.size();
    }
    while (returnnodstrs.size () < num_requested) {
      String randomnodekey = nodekeys.get( PApplet.parseInt(randomized.nextInt(nodekeys.size())) );
      if (!(Arrays.asList(returnnodstrs).contains(randomnodekey))) {
        returnnodstrs.add(randomnodekey);
      }
    }
    for (String randnod : returnnodstrs) {
      returnnods.add(this.nodemap.get(randnod));
    }
    return returnnods;
  }

  /**
  * Returns an arraylist of randomly selected bars from the model
  * @param num_requested: How many randomly selected bars does the user want?
  */
  public ArrayList<Bar> getRandomBars(int num_requested) {
    Random randomized = new Random();
    ArrayList<String> returnbarstrs = new ArrayList<String>();
    ArrayList<Bar> returnbars = new ArrayList<Bar>();
    List<String> barkeys = new ArrayList<String>(this.nodemap.keySet());
    if (num_requested > barkeys.size()) {
      num_requested = barkeys.size();
    }
    while (returnbarstrs.size () < num_requested) {
      String randombarkey = barkeys.get( PApplet.parseInt(randomized.nextInt(barkeys.size())) );
      if (!(Arrays.asList(returnbarstrs).contains(randombarkey))) {
        returnbarstrs.add(randombarkey);
      }
    }
    for (String randbar : returnbarstrs) {
      returnbars.add(this.barmap.get(randbar));
    }
    return returnbars;
  }
}



/** ********************************************************************* NODE
 * The Node class is the most useful tool for traversing the brain.
 * @param id: The node id ("BUG", "ZAP", etc)
 * @param x,y,z: The node xyz coords
 * @param ground: Is this node one of the ones on the bottom of the brain?
 * @param adjacent_bar_names: names of bars adjacent to this node
 * @param adjacent_node_names: names of nodes adjacent to this node
 * @param adjacent_bar_names: names of bars adjacent to this node
 * @param id: The node id ("BUG", "ZAP", etc)
 ************************************************************************* **/
public class Node extends LXModel {

  //Node number with module number
  public final String id;

  //Straightforward. If there are multiple physical nodes, this is the xyz from the node with the highest z
  public final float x;
  public final float y;
  public final float z;

  //xyz position of node
  //If it's a double or triple node, returns the coordinates of the highest-z-position instance of the node
  public final boolean ground;
  
  //inner layer or outer layer?
  public final String inner_outer;
  
  //inner layer or outer layer?
  public final String left_right_mid;

  //List of bar IDs connected to node.
  public final List<String> adjacent_bar_names;

  //List of node IDs connected to node.
  public final List<String> adjacent_node_names;


  //Declurrin' some arraylists
  public ArrayList<Bar> adjacent_bars = new ArrayList<Bar>();
  public ArrayList<Node> adjacent_nodes = new ArrayList<Node>();



  
  public Node(String id, float x, float y, float z, List<String> adjacent_bar_names, List<String> adjacent_node_names, boolean ground, String inner_outer, String left_right_mid) {
    this.id=id;
    this.x=x;
    this.y=y;
    this.z=z;
    this.adjacent_bar_names=adjacent_bar_names;
    this.adjacent_node_names = adjacent_node_names;
    this.ground = ground;
    this.inner_outer=inner_outer;
    this.left_right_mid=left_right_mid;
    this.adjacent_bars = new ArrayList<Bar>();
    this.adjacent_nodes = new ArrayList<Node>();
  }


  public void initialize_model_connections(){
    for (String abn : this.adjacent_bar_names){
      this.adjacent_bars.add(model.barmap.get(abn));
    }
    for (String ann : this.adjacent_node_names) {
      this.adjacent_nodes.add(model.nodemap.get(ann));
    }
  }


  /**
  * Returns one adjacent node
  */ 
    public Node random_adjacent_node() {
    String randomnodekey = adjacent_node_names.get( PApplet.parseInt(random(adjacent_node_names.size())) );
    Node returnnod=model.nodemap.get(randomnodekey);
    return returnnod;
  }

  /**
   * Returns an ArrayList of randomly selected adjacent nodes. 
   * @param num_requested: How many random adjacent nodes to return
   */
  public ArrayList<Node> random_adjacent_nodes(int num_requested) {
    ArrayList<String> returnnodstrs = new ArrayList<String>();
    ArrayList<Node> returnnods = new ArrayList<Node>();
    if (num_requested > this.adjacent_node_names.size()) {
      num_requested = this.adjacent_node_names.size();
    }
    while (returnnodstrs.size () < num_requested) {
      String randomnodekey = adjacent_node_names.get( PApplet.parseInt(random(adjacent_node_names.size())) );
      if (!(Arrays.asList(returnnodstrs).contains(randomnodekey))) {
        returnnodstrs.add(randomnodekey);
      }
    }
    for (String randnod : returnnodstrs) {
      returnnods.add(model.nodemap.get(randnod));
    }
    return returnnods;
  }



  /**
  * Returns one adjacent bar
  */ 
  public Bar random_adjacent_bar() {
    String randombarkey = adjacent_bar_names.get( PApplet.parseInt(random(adjacent_bar_names.size())) );
    Bar returnbar=model.barmap.get(randombarkey);
    return returnbar;
  }


  /**
   * Returns an ArrayList of randomly selected adjacent bars. 
   * @param num_requested: How many random adjacent bars to return
   */
  public ArrayList<Bar> random_adjacent_bars(int num_requested) {
    ArrayList<String> returnbarstrs = new ArrayList<String>();
    ArrayList<Bar> returnbars = new ArrayList<Bar>();
    if (num_requested > this.adjacent_bar_names.size()) {
      num_requested = this.adjacent_bar_names.size();
    }
    while (returnbarstrs.size () < num_requested) {
      String randombarkey = adjacent_bar_names.get( PApplet.parseInt(random(adjacent_bar_names.size())) );
      if (!(Arrays.asList(returnbarstrs).contains(randombarkey))) {
        returnbarstrs.add(randombarkey);
      }
    }
    for (String randbar : returnbarstrs) {
      returnbars.add(model.barmap.get(randbar));
    }
    return returnbars;
  }

  //List of adjacent bars
  public ArrayList<Bar> adjacent_bars() {
    ArrayList<Bar> baarrs = new ArrayList<Bar>();
    for (String pnn : this.adjacent_bar_names) {
      baarrs.add(model.barmap.get(pnn));
    }
    return baarrs;
  }
  
  //List of adjacent bars.
  public ArrayList<Node> adjacent_nodes() {
    ArrayList<Node> nods = new ArrayList<Node>();
    for (String pnn : this.adjacent_node_names) {
      nods.add(model.nodemap.get(pnn));
    }
    return nods;
  }
  
  //List of nearby points. No specific order.
  public List<LXPoint> adjacent_bar_points() {
    ArrayList<Bar> bars=this.adjacent_bars();
    List<LXPoint> returnpoints = new ArrayList<LXPoint>();
    for (Bar b : bars){
      for (LXPoint p : b.points){
        returnpoints.add(p);
      }
    }
    return returnpoints;
  }
  
  
  //List of nearby points. Arranged pointing outwards from node.
  public List<List<LXPoint>> pointlists_directed_out() {
    List<List<LXPoint>> outlist = new ArrayList<List<LXPoint>>();
    ArrayList<Node> nodes=this.adjacent_nodes();
    for (Node n : nodes){
      List<LXPoint> returnpoints = new ArrayList<LXPoint>();
      List<LXPoint> barpointsoutwards = nodeToNodePoints(this,n);
      for (LXPoint p : barpointsoutwards){
        returnpoints.add(p);
      }
      outlist.add(returnpoints);
    }
    return outlist;
  }

  //written by Anna in the July 2015 Hackathon
  public Node getNextNodeByVector(PVector v2) {
      
      //go through adjacent nodes to find ones in the right direction 
      //closest to the direction vector, so that product of the vectors is small
      List<Node> nodeCandidates;
      PVector v1; 
      PVector v3;
     // float goalAngle;
      
    //the angle we want is the angle between firstNode and V2, and we want our new node to be in the same direction
      //v3 = new PVector(firstNode.x, firstNode.y,firstNode.z);
      //goalAngle = PVector.angleBetween(v2,v3); //angle between cur node and destination
      
    //get candidates
      nodeCandidates= this.adjacent_nodes;
      
      //pull out first node candidate,pretend it is best 
      Node bestNode = nodeCandidates.get(0);
      v1 = new PVector(bestNode.x,bestNode.y,bestNode.z);
      float d = PVector.dist(v1,v2);
      float bestd = d; 

      //look for best node by comp with first candidate
       for (Node curCandidate : nodeCandidates ){

          v1 = new PVector(curCandidate.x,curCandidate.y,curCandidate.z);
          d = abs(PVector.dist(v1,v2));
        // println(d);    
        //we want do to be as close to zero as possible 
          if(d<bestd){
           bestd = d;
           bestNode = curCandidate; 
            
          }
        }
    return bestNode;
  }



}






/** ********************************************************************** BAR
 * The Bar class is the second-most-useful tool for traversing the brain.
 * @param id: The bar id ("BUG-ZAP", etc)
 * @param min_x,min_y,min_z: The minimum node xyz coords
 * @param max_x,max_y,max_z: The maximum node xyz coords
 * @param ground: Is this bar one of the ones on the bottom of the brain?
 * @param module_names: Which modules is this bar in? (can be more than one if it's a double-bar)
 * @param node_names: Nodes contained in this bar
 * @param adjacent_bar_names: names of bars adjacent to this node
 * @param adjacent_node_names: names of nodes adjacent to this node
 * @param adjacent_bar_names: names of bars adjacent to this node
 ************************************************************************* **/
public static class Bar extends LXModel {

  //bar name
  public final String id;

  //min and max xyz of bar TODO make these work again
  public final float min_x;
  public final float min_y;
  public final float min_z;
  public final float max_x;
  public final float max_y;
  public final float max_z;

  public final float angle_with_vertical;
  public final float angle_with_horizontal;

  //Is it on the ground? (or bottom of brain)
  public final boolean ground;

  //Inner bar? Outer bar? Mid bar?
  public final String inner_outer_mid;
  
  //Left Hemisphere? Right Hemisphere? Fissure?
  public final String left_right_mid;

  //list of strings of modules that this bar is in.
  public final String module;

  //List of node IDs connected to bar.
  //This is always exactly two elements, and:
  //this.id == this.node_names[0] + "-" + this.node_names[1]
  public final List<String> node_names;

  //List of bar IDs connected to our two adjancent nodes.
  public final List<String> adjacent_bar_names;

  //List of node IDs connected to adjacent_bar_names.
  public final List<String> adjacent_node_names;


  //Bar nodes
  public ArrayList<Node> nodes = new ArrayList<Node>();

  //Adjacent nodes to bar
  public ArrayList<Node> adjacent_nodes = new ArrayList<Node>();

  //Adjacent bars to bar
  public ArrayList<Bar> adjacent_bars = new ArrayList<Bar>();
  
  public int strip_id;        // what strip number?
  public int board_number;    // which beaglebone?
  public int channel_number;  // which channel?


   
  //This bar is open to the public.
  public Bar(String id, 
             List<float[]> points, 
             float min_x,float min_y,float min_z,
             float max_x,float max_y,float max_z, 
             String module, 
             List<String> node_names,
             List<String> adjacent_node_names, 
             List<String> adjacent_bar_names, 
             boolean ground, 
             String inner_outer_mid, 
             String left_right_mid, 
             int strip_id) {
    super(new Fixture(points));
    this.id=id;
    this.module=module;
    this.board_number=(PApplet.parseInt(module)-1)/4;
    this.strip_id=strip_id;
    this.channel_number=(this.strip_id%24);
    this.min_x=min_x;
    this.min_y=min_y; 
    this.min_z=min_z;
    this.max_x=max_x;
    this.max_y=max_y;
    this.max_z=max_z;
    float dx = this.max_x-this.min_x;
    float dy = this.max_y-this.min_y;
    float dz = this.max_z-this.min_z;
    float dxy = sqrt(sq(dx)+sq(dy));
    float raw_angle= PVector.angleBetween(new PVector(dx,dy,dz),new PVector(0,0,1));
    this.angle_with_vertical=min(raw_angle,PI-raw_angle);
    this.angle_with_horizontal=PI-this.angle_with_vertical;
    this.inner_outer_mid = inner_outer_mid;
    this.left_right_mid = left_right_mid;
    this.node_names = node_names;
    this.adjacent_node_names=adjacent_node_names;
    this.adjacent_bar_names=adjacent_bar_names;
    this.ground = ground;
    this.nodes = new ArrayList<Node>();
    this.adjacent_bars = new ArrayList<Bar>();
    this.adjacent_nodes = new ArrayList<Node>();
  }


   private static class Fixture extends LXAbstractFixture {
    private Fixture(List<float[]> points) {
      for (float[] p : points ) {
        LXPoint point=new LXPoint(p[0], p[1], p[2]);
        this.points.add(point);
      }
    }
  }

  public void initialize_model_connections(){
    for (String nn : this.node_names) {
      this.nodes.add(model.nodemap.get(nn));
    }
    for (String abn : this.adjacent_bar_names){
      this.adjacent_bars.add(model.barmap.get(abn));
    }
    for (String ann : this.adjacent_node_names) {
      this.adjacent_nodes.add(model.nodemap.get(ann));
    }
  }

  //List of adjacent bars
  public ArrayList<Bar> adjacent_bars() {
    ArrayList<Bar> adj_bars = new ArrayList<Bar>();
    for (String abn : this.adjacent_bar_names) {
      adj_bars.add(model.barmap.get(abn));
    }
    return adj_bars;
  }

  //Returns angle between bars. Bars must be adjacent
  //in radians
  public float angle_with_bar(Bar other_bar){
    if (!(this.adjacent_bars.contains(other_bar))){
      throw new IllegalArgumentException("Bars must be adjacent!");
    }
    return angleBetweenTwoBars(this,other_bar);
  }
}


/**
* Returns a list of LXPoints between two adjacent nodes, in order.
* e.g. if you wanted to get the nodes in order from ZAP to BUG (reverse alphabetical order) this is what you'd use
* reminder: by default the points always go in alphabetical order from one node to another
* returns null if the nodes aren't adjacent.
* @param node1: Start node
* @param node2: End node
*/
public static List<LXPoint> nodeToNodePoints(Node node1, Node node2) {
  String node1name = node1.id;
  String node2name = node2.id;
  int reverse_order = node1name.compareTo(node2name); //is this going in reverse order? 
  String barname;
  if (reverse_order<0) {
    barname = node1name + "-" + node2name;
  } else {
    barname = node2name + "-" + node1name;
  }
  Bar ze_bar = model.barmap.get(barname);

  if (ze_bar == null) { //the bar doesnt exist (non adjacent nodes etc)
    println(node1name,node2name);
    throw new IllegalArgumentException("Nodes must be adjacent!");
  } else {
    if (reverse_order>0) {
      List<LXPoint> zebarpoints = new ArrayList(ze_bar.points);
      Collections.reverse(zebarpoints);
      return zebarpoints;
    } else {
      return ze_bar.points;
    }
  }
}

/**
 * Given two nodes, return the bar between them, or null if they are not
 * directly connected. Simple but useful.
 * @param node1: a node
 * @param node2: another node.
*/
public static Bar barBetweenNodes(Node node1, Node node2){
  String node1name=node1.id;
  String node2name=node2.id;
  int reverse_order = node1name.compareTo(node2name);
  String barname;
  if (reverse_order<0) {
    barname = node1name + "-" + node2name;
  } else {
    barname = node2name + "-" + node1name;
  }
  if (model.barmap.keySet().contains(barname)){
      return model.barmap.get(barname);
  }
  return null;
}


/**
 * Given two nodes, see if they form a bar.
 * Simple but useful.
 * @param node1: a node
 * @param node2: another node.
*/
public static boolean twoNodesMakeABar(Node node1, Node node2){
  return barBetweenNodes(node1, node2) != null;
}


/**
 * Given two bars with a common node, find that node. Bars must be adjacent.
 * Simple but useful.
 * @param bar1: a bar
 * @param bar2: a connected bar
*/
public static Node sharedNode(Bar bar1, Bar bar2){
  List<Node> allnodes = new ArrayList<Node>();
  for (Node n : bar1.nodes){
    allnodes.add(n);
  }
  for (Node n : bar2.nodes){
    allnodes.add(n);
  }
  for (Node n : allnodes) {
    if (bar1.nodes.contains(n) && bar2.nodes.contains(n)) {
      return n;
    }
  }
  return null; //no matches :(
}

/**
 * Given a bar and a node in that bar, gets the other node from that bar.
 * Simple but useful.
 * @param bar: a bar
 * @param node: a node in that bar
*/
public static Node otherNode(Bar bar, Node node){
  if (bar.nodes.contains(node)){
    for (Node n : bar.nodes){
      if (!(n.id.equals(node.id))){
        return n;
      }
    } 
    throw new IllegalArgumentException("Something is wrong with the bar model.");
  }
  else{
    throw new IllegalArgumentException("Node must be in bar");
  }
}

/**
 * Gets the angle formed by two bars. They must be adjacent to each other.
 * @param Bar1: First bar
 * @param Bar2: Second bar
*/
public static float angleBetweenTwoBars(Bar bar1, Bar bar2){
  if (bar1.adjacent_bars.contains(bar2)){
    Node common_node = sharedNode(bar1,bar2);
    Node node1 = otherNode(bar1,common_node);
    Node node3 = otherNode(bar2,common_node);
    return angleBetweenThreeNodes(node1,common_node,node3);
  } else {
    throw new IllegalArgumentException("Bars must be adjacent!");
  }
}

/**
 * Gets the angle formed by three nodes. They must be adjacent to each other and connected via a bar.
 * @param Node1: The first node
 * @param Node2: The second node (the one where the angle is formed)
 * @param Node3: The third node
*/
public static float angleBetweenThreeNodes(Node node1,Node node2,Node node3){
  if (twoNodesMakeABar(node1,node2) && twoNodesMakeABar(node2,node3)){
    float dx1=node1.x-node2.x;
    float dy1=node1.y-node2.y;
    float dz1=node1.z-node2.z;
    float dx2=node3.x-node2.x;
    float dy2=node3.y-node2.y;
    float dz2=node3.z-node2.z;
    PVector vect1=new PVector(dx1,dy1,dz1);
    PVector vect2=new PVector(dx2,dy2,dz2);
    return PVector.angleBetween(vect1,vect2);
  } else{
    throw new IllegalArgumentException("Nodes must be adjacent!");
  }
}


/******************************************************************************/
/* Image mapping                                                              */
/******************************************************************************/


/**
 * Class for mapping images onto the brain.
 * Operates by doing all the math for which pixels in the image map to which pixels on the brain, once
 * Then shifts things around by changing the pixels in the image.
 * TODO: Could use some optimization magic. Does unkind things to the framerate.
 * @param imagecolors is a Processing PImage which stores the image
 * @param cartesian_canvas defines what coordinate system the image gets mapped to
 * @param imagedims is the dimensions of the image in pixels
 * @param compress_pct compresses the image by a certain percent to improve performance.  Will vary by image and machine.
*/ 
public class MentalImage {

  PImage imagecolors;
  String cartesian_canvas;
  int w;
  int h;
  
  SortedMap<Integer, int[]> pixel_to_pixel = new TreeMap<Integer, int[]>();
  SortedMap<Integer, float[]> led_colors = new TreeMap<Integer, float[]>();

  //Constructor for class
  public MentalImage(String imagepath, String cartesian_canvas, int compress_pct){
      this.imagecolors = loadImage(imagepath);
      loadPixels();
      this.imagecolors.resize(this.imagecolors.width*compress_pct/100,0);
      this.cartesian_canvas=cartesian_canvas;
      this.imagecolors.loadPixels();
      this.w=imagecolors.width;
      this.h=imagecolors.height;
      //Map the points in the image to the model, once.
      for (LXPoint p : model.points) {
        int[] point_loc_in_img=scaleLocationInImageToLocationInBrain(p);
        this.pixel_to_pixel.put(p.index,point_loc_in_img);
      }
  }
  
  //Constructor for class
  public MentalImage(PImage inputImage, String cartesian_canvas, int compress_pct){
      this.imagecolors = inputImage;
      loadPixels();
      this.imagecolors.resize(this.imagecolors.width*compress_pct/100,0);
      this.cartesian_canvas=cartesian_canvas;
      this.imagecolors.loadPixels();
      this.w=imagecolors.width;
      this.h=imagecolors.height;
      //Map the points in the image to the model, once.
      for (LXPoint p : model.points) {
        int[] point_loc_in_img=scaleLocationInImageToLocationInBrain(p);
        this.pixel_to_pixel.put(p.index,point_loc_in_img);
      }
  }

  public void updateImage(PImage newImage, String cartesian_canvas, int compress_pct)
  {
    this.imagecolors = newImage;
      loadPixels();
      this.imagecolors.resize(this.imagecolors.width*compress_pct/100,0);
      this.cartesian_canvas=cartesian_canvas;
      this.imagecolors.loadPixels();
      this.w=imagecolors.width;
      this.h=imagecolors.height;
      //Map the points in the image to the model, once.
      for (LXPoint p : model.points) {
        int[] point_loc_in_img=scaleLocationInImageToLocationInBrain(p);
        this.pixel_to_pixel.put(p.index,point_loc_in_img);
      }
  }
  /**
  * Outputs one frame of the image in its' current state to the pixel mapping.
  * @param colors: The master colors array
  */
  public int[] ImageToPixels(int[] colors){
    int pixelcolor;
    float[] hsb_that_pixel;
    int[] loc_in_img;
    for (LXPoint p : model.points) {
      loc_in_img = scaleLocationInImageToLocationInBrain(p);
      pixelcolor = this.imagecolors.get(loc_in_img[0],loc_in_img[1]);
      colors[p.index]= lx.hsb(hue(pixelcolor),saturation(pixelcolor),brightness(pixelcolor));
    }
    return colors;
  }


  /**
  * Outputs one frame of the image in its' current state to the pixel mapping.
  * Current preferred method for using moving images. Faster than translating the image under the mapping.
  * @param colors: The master colors array
  */
  public int[] shiftedImageToPixels(int[] colors, float xpctshift,float ypctshift){
    int[] colors2 = shiftedImageToPixels(colors, xpctshift, ypctshift, 1.0f);
    return colors2;
  }
  public int[] shiftedImageToPixels(int[] colors, float xpctshift,float ypctshift, float scale){
    int pixelcolor;
    float[] hsb_that_pixel;
    int[] loc_in_img;
    for (LXPoint p : model.points) {
      loc_in_img = scaleShiftedScaledLocationInImageToLocationInBrain(p,xpctshift,ypctshift,scale);
      pixelcolor = this.imagecolors.get(loc_in_img[0],loc_in_img[1]);
      colors[p.index]= lx.hsb(hue(pixelcolor),saturation(pixelcolor),brightness(pixelcolor));
    }
    return colors;
  }




  /**
  * Translates the image in either the x or y axis. 
  * Important to note that this is operating on the image itself, not on the pixel mapping, so it's just x and y
  * This seems to get worse performance than just recalculating the LED pixels across different positions in the image if looped.
  * Automatically wraps around.
  * @param which_axis: x or y or throw exception
  * @param pctrate: How much percentage of the image to translate?
  */
  public void translate_image(String which_axis, float pctrate) { //String which_axis, float percent, boolean wrap
    PImage translate_buffer;
    if (which_axis.equals("x")) {
      translate_buffer=imagecolors; 
      int rate = PApplet.parseInt(imagecolors.width*(pctrate/100.0f));
      for (int imgy = 0; imgy < imagecolors.height; imgy++) {
        for (int inc = 1; inc < rate+1; inc++) {
          imagecolors.set(imagecolors.width-inc,imgy,translate_buffer.get(0,imgy));
        }
      }
  
      for (int imgx = 0; imgx < imagecolors.width-rate; imgx++ ) {
        for (int imgy = 0; imgy < imagecolors.height; imgy++) {
          imagecolors.set(imgx,imgy,translate_buffer.get(imgx+rate,imgy));
        }
      }
    } else if (which_axis.equals("y")){
      translate_buffer=imagecolors; 
      int rate = PApplet.parseInt(imagecolors.height*(pctrate/100.0f));
      for (int imgx = 0; imgx < imagecolors.width; imgx++) {
        for (int inc = 1; inc < rate+1; inc++) {
          imagecolors.set(imgx,imagecolors.height-inc,translate_buffer.get(imgx,0));
        }
      }
  
      for (int imgy = 0; imgy < imagecolors.height-rate; imgy++ ) {
        for (int imgx = 0; imgx < imagecolors.width; imgx++) {
          imagecolors.set(imgx,imgy,translate_buffer.get(imgx,imgy+rate));
        }
      }
    } else{
      throw new IllegalArgumentException("Axis must be x or y. Image axis, not model axis :)");
    }
  }

  /**
  * Returns the coordinates for an LXPoint p (which has x,y,z) that correspond to a location on an image based on the coordinate system 
  * @param p: The LXPoint to get coordinates for.
  */
  private int[] scaleLocationInImageToLocationInBrain(LXPoint p) {
    float[][] minmaxxy;
    float newx;
    float newy;
    if (this.cartesian_canvas.equals("xy")){
      minmaxxy=new float[][]{{model.xMin,model.xMax},{model.yMin,model.yMax}};
      newx=(1-(p.x-minmaxxy[0][0])/(minmaxxy[0][1]-minmaxxy[0][0]))*this.w;
      newy=(1-(p.y-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))*this.h;
    }
    else if (this.cartesian_canvas.equals("xz")){
      minmaxxy=new float[][]{{model.xMin,model.xMax},{model.zMin,model.zMax}};
      newx=(1-(p.x-minmaxxy[0][0])/(minmaxxy[0][1]-minmaxxy[0][0]))*this.w;
      newy=(1-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))*this.h;
    }
    else if (this.cartesian_canvas.equals("yz")){
      minmaxxy=new float[][]{{model.yMin,model.yMax},{model.zMin,model.zMax}};
      newx=(1-(p.y-minmaxxy[0][0])/(minmaxxy[0][1]-minmaxxy[0][0]))*this.w;
      newy=(1-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))*this.h;
    }
    else if (this.cartesian_canvas.equals("cylindrical_x")){
      minmaxxy=new float[][]{{model.xMin,model.xMax},{model.xMin,model.xMax}};
      newx=(1-((atan2(p.z,p.y)+PI)/(2*PI)))*this.w;
      newy=(1-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))*this.h;
    }
    else if (this.cartesian_canvas.equals("cylindrical_y")){
      minmaxxy=new float[][]{{model.yMin,model.yMax},{model.yMin,model.yMax}};
      newx=(1-((atan2(p.z,p.x)+PI)/(2*PI)))*this.w;
      newy=(1-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))*this.h;
    }
    else if (this.cartesian_canvas.equals("cylindrical_z")){
      minmaxxy=new float[][]{{model.zMin,model.zMax},{model.zMin,model.zMax}};
      newx=(1-((atan2(p.y,p.x)+PI)/(2*PI)))*this.w;
      newy=(1-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))*this.h;
    }
    else{
      throw new IllegalArgumentException("Must enter plane xy, xz, yz, or cylindrical_x/y/z");
    }
      int newxint=(int)newx;
      int newyint=(int)newy;
      if (newxint>=this.w){
         newxint=newxint-1;
      }
      if (newxint<=0){
         newxint=newxint+1;
      }
      if (newyint>=this.h){
         newyint=newyint-1;
      }
      if (newyint<=0){
         newyint=newyint+1;
      }
      int[] result = new int[] {newxint,newyint};
      return result;
  }





  /**
  * Returns the SHIFTED coordinates for an LXPoint p (which has x,y,z) that correspond to a location on an image based on the coordinate system 
  * This seems to get better performance in the run loop than using translate on the image repetitively.
  * @param p: The LXPoint to get coordinates for.
  * @param xpctshift: How far to move the image in the x direction, as a percent of the image width
  * @param ypctshift: How far to move the image in the y direction, as a percent of the image height
  */
  private int[] scaleShiftedLocationInImageToLocationInBrain(LXPoint p, float xpctshift, float ypctshift){
    int[] result = scaleShiftedScaledLocationInImageToLocationInBrain(p, xpctshift, ypctshift, 1.0f);
    return result;
  }
  
  private int[] scaleShiftedScaledLocationInImageToLocationInBrain(LXPoint p, float xpctshift, float ypctshift, float scale) {
    float[][] minmaxxy;
    float newx;
    float newy;
    if (this.cartesian_canvas.equals("xy")){
      minmaxxy=new float[][]{{model.xMin,model.xMax},{model.yMin,model.yMax}};
      newx=(1+xpctshift-(p.x-minmaxxy[0][0])/(minmaxxy[0][1]-minmaxxy[0][0]))%1.0f*this.w*scale;
      newy=(1+ypctshift-(p.y-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))%1.0f*this.h*scale;
    }
    else if (this.cartesian_canvas.equals("xz")){
      minmaxxy=new float[][]{{model.xMin,model.xMax},{model.zMin,model.zMax}};
      newx=(1+xpctshift-(p.x-minmaxxy[0][0])/(minmaxxy[0][1]-minmaxxy[0][0]))%1.0f*this.w*scale;
      newy=(1+ypctshift-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))%1.0f*this.h*scale;
    }
    else if (this.cartesian_canvas.equals("yz")){
      minmaxxy=new float[][]{{model.yMin,model.yMax},{model.zMin,model.zMax}};
      newx=(1+xpctshift-(p.y-minmaxxy[0][0])/(minmaxxy[0][1]-minmaxxy[0][0]))%1.0f*this.w*scale;
      newy=(1+ypctshift-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))%1.0f*this.h*scale;
    }
    else if (this.cartesian_canvas.equals("cylindrical_x")){
      minmaxxy=new float[][]{{model.xMin,model.xMax},{model.xMin,model.xMax}};
      newx=(1+xpctshift-((atan2(p.z,p.y)+PI)/(2*PI)))%1.0f*this.w*scale;
      newy=(1+ypctshift-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))%1.0f*this.h*scale;
    }
    else if (this.cartesian_canvas.equals("cylindrical_y")){
      minmaxxy=new float[][]{{model.yMin,model.yMax},{model.yMin,model.yMax}};
      newx=(1+xpctshift-((atan2(p.z,p.x)+PI)/(2*PI)))%1.0f*this.w*scale;
      newy=(1+ypctshift-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))%1.0f*this.h*scale;
    }
    else if (this.cartesian_canvas.equals("cylindrical_z")){
      minmaxxy=new float[][]{{model.zMin,model.zMax},{model.zMin,model.zMax}};
      newx=(1+xpctshift-((atan2(p.y,p.x)+PI)/(2*PI)))%1.0f*this.w*scale;
      newy=(1+ypctshift-(p.z-minmaxxy[1][0])/(minmaxxy[1][1]-minmaxxy[1][0]))%1.0f*this.h*scale;
    }
    else{
      throw new IllegalArgumentException("Must enter plane xy, xz, yz, or cylindrical_x/y/z");
    }
      int newxint=PApplet.parseInt((newx % this.w+this.w)%this.w);
      int newyint=PApplet.parseInt((newy % this.h+this.h)%this.h);
      int[] result = new int[] {newxint,newyint};
      return result;
  }
}










/******************************************************************************/
/* LXPoint-to-model mapping                                                   */
/******************************************************************************/

private static Bar[] _pointToBarMap;
private static int[] _pointToIndexMap;

private static void _ensurePointToModelMap() {
  if (_pointToBarMap != null)
      return; // already initialized

  _pointToBarMap = new Bar[model.points.size()];
  _pointToIndexMap = new int[model.points.size()];

  for (String key : model.barmap.keySet()) {
    Bar bar = model.barmap.get(key);
    int i = 0;
    for (LXPoint point : bar.points) {
      _pointToBarMap[point.index] = bar;
      _pointToIndexMap[point.index] = i;
      i++;
    }
  }
}

// Return the Bar that contains the given point.
public static Bar barForPoint(LXPoint point) {
  _ensurePointToModelMap();
  return _pointToBarMap[point.index];
}

// Return the index of the point in the bar that contains it.
public static int barIndexForPoint(LXPoint point) {
  _ensurePointToModelMap();
  return _pointToIndexMap[point.index];
}


/******************************************************************************/
/* Walks                                                                      */
/******************************************************************************/

/**
 * This performs a walk where we start at a particular point, and then
 * walk a point at a time around the edge of the brain, changing
 * directions randomly when we hit a node (but never doubling back).
 *
 * @author Geoff Schmidt
 */

public class SemiRandomWalk {
  private LXPoint where;
  Node fromNode, toNode;
  Bar currentBar;
  int index;
  double fractionalStep;

  public SemiRandomWalk(LXPoint start) {
    where = start;
    currentBar = barForPoint(where);
    boolean direction = new Random().nextBoolean();
    fromNode = currentBar.nodes.get(direction ? 0 : 1);
    toNode = currentBar.nodes.get(direction ? 1 : 0);
    index = direction ?
        barIndexForPoint(where) :
        currentBar.points.size() - barIndexForPoint(where) - 1;
    fractionalStep = 0;
  }

  // Step forward in the walk by n points, and return the new position.
  //
  // You can pass a fractional number of steps. They will accumulate
  // over subsequent calls to step().
  public LXPoint step(double n) {
    fractionalStep += n;
    int stepsToTake = (int)Math.floor(fractionalStep);
    fractionalStep = fractionalStep % 1.0f;

    while (stepsToTake > 0) {
      int barLength = currentBar.points.size();
      int steps = Math.min(stepsToTake, barLength - 1 - index);
      stepsToTake -= steps;
      index += steps;

      if (index == barLength - 1 && stepsToTake > 0) {
        // Step across the node to a different bar
        Node oldFromNode = fromNode;
        fromNode = toNode;
        do {
          toNode = fromNode.random_adjacent_node();
        } while (angleBetweenThreeNodes(oldFromNode, fromNode, toNode)
                   < 4*PI/360*3); // don't go back the way we came
        currentBar = barBetweenNodes(fromNode, toNode);
        index = 0;
        stepsToTake --;
      }
    }

    List<LXPoint> points = nodeToNodePoints(fromNode, toNode);
    where = points.get(index);
    return where;
  }
}


/******************************************************************************/
/* Distance fields                                                            */
/******************************************************************************/

/**
 * Given a point, return the shortest distance from that point to all other
 * points.
 *
 * Distance is measured like an ant walking across the bars, counting
 * one unit of distance for each LED.
 *
 * Returns the distance from the input point to every other point, as
 * an array set up the same way as 'colors' (indexed by the 'index'
 * property of LXPoint).
 *
 * Note: Internally, this also computes the actual shortest paths (not
 * just the distance), but the information is thrown away. If
 * necessary, it would be possible to save it in order to compute
 * shortest paths efficiently.
 *
 * @author Geoff Schmidt
 */

public static int[] distanceFieldFromPoint(LXPoint startPoint) {
  class Route {
    Node toNode;
    int distanceSoFar;
    Route previous;

    Route(Node _toNode, int _distanceSoFar, Route _previous) {
      toNode = _toNode;
      distanceSoFar = _distanceSoFar;
      previous = _previous;
    }
  }

  class RouteDistanceComparator implements Comparator<Route> {
    @Override
    public int compare(Route x, Route y) {
      if (x.distanceSoFar < y.distanceSoFar)
        return -1;
      if (x.distanceSoFar > y.distanceSoFar)
        return 1;
      return 0;
    }
  }

  Comparator<Route> comparator = new RouteDistanceComparator();
  PriorityQueue<Route> queue = new PriorityQueue<Route>(100, comparator);

  int[] distances = new int[model.points.size()];
  Map<String, Route> shortestRoute = new HashMap<String, Route>();

  // Handle the starting point and the edge it's on
  Bar startBar = barForPoint(startPoint);
  int startIndex = barIndexForPoint(startPoint);

  int i = 0;
  for (LXPoint p : startBar.points) {
    distances[p.index] = Math.abs(startIndex - i);
    i++;
  }
  queue.add(new Route(startBar.nodes.get(0), startIndex + 1, null));
  queue.add(new Route(startBar.nodes.get(1),
                      startBar.points.size() - startIndex,
                      null));

  // Get distance to every node
  while (queue.size() != 0 && shortestRoute.size() != model.barmap.size()) {
    Route r = queue.remove();

    if (shortestRoute.containsKey(r.toNode.id))
      continue; // already found a shorter path here
    shortestRoute.put(r.toNode.id, r);
    /*
    System.out.format("%s: %d away (via %s)\n",
                      r.toNode.id, r.distanceSoFar,
                      r.previous == null ? "start" : r.previous.toNode.id);
    */

    for (Bar nextBar : r.toNode.adjacent_bars) {
      Node otherEnd =
          nextBar.nodes.get(0) == r.toNode ? nextBar.nodes.get(1) :
                                             nextBar.nodes.get(0);
      if (shortestRoute.containsKey(otherEnd.id))
        continue;
      queue.add(new Route(otherEnd, r.distanceSoFar + nextBar.points.size(),
                          r));
    }
  }

  // (Possible improvement: stop here, save shortestRoute, and compute
  // distance to individual points only on demand.. You could query it
  // for paths too. Unlikely to be an efficiency improvement, since
  // most patterns that use distance fields do end up evaluating the
  // distance field at every point in the model)
  
  // Get distance to every point
  for (String key : model.barmap.keySet()) {
    Bar b = model.barmap.get(key);
    if (b == startBar)
        continue; // already did this one

    int node0Dist = shortestRoute.get(b.nodes.get(0).id).distanceSoFar;
    int node1Dist = shortestRoute.get(b.nodes.get(1).id).distanceSoFar;
    /*
    System.out.format("%s (%d) to %s (%d):\n",
                      b.nodes.get(0).id, node0Dist,
                      b.nodes.get(1).id, node1Dist);
    */
    i = 0;
    for (LXPoint p : b.points) {
      int d1 = i + node0Dist;
      int d2 = (startBar.points.size() - 1 - i) + node1Dist;
      distances[p.index] = Math.min(d1, d2);
      /*
      System.out.format("  %d: %d (%d vs %d) @%d\n", i, distances[p.index],
                        d1, d2, p.index);
      */
      i++;
    }
  }

  return distances;
}
/**
*
* MuseConnect
*
* author: Michael J. Pesavento, Ph.D.
*         PezTek
*         mike@peztek.com
*
* copywrite (c) 2015 PezTek
*
* This software is created and distributed under the
* GNU General Public License v3
* http://www.gnu.org/licenses/gpl.html
*
* --------------------------------------
* 
* v0.1 2015.03.21
* v0.2 2015.08.20 updated for brainlove and DBLX
* v0.3 2015.11.15 updated MuseHUD to display metrics
*
* --------------------------------------
* Requirements:
* requires oscP5 library package for Processing 2
*
* need to have muse-io installed, get SDK from here:
* https://sites.google.com/a/interaxon.ca/muse-developer-site/download
*
* load muse OSC output in command line with:
*      muse-io --preset 14 --osc osc.udp://localhost:5000
*
*/





// turn this on for debugging
boolean verboseMuse = false;

class MuseConnect {
  
  Object parent; //need to have root Processing object - this - passed to constructor

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
  public float[] horseshoe = new float[] {3,3,3,3}; // values: 1= good, 2=ok, 3=bad
  public float battery_level = 0; // percent battery remaining.
  public float concentration=0;
  public float mellow = 0; 
  
  public boolean museActive = false; // true if touching_forehead and all horseshoes are 'good'
  
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
  public boolean signalIsGood() {
    boolean is_good = true;
    if (this.touching_forehead != 1) {
      this.museActive = false;
      return false;
    }
    for (int i=0; i<this.horseshoe.length; i++) {
      if (this.horseshoe[i] != 1.0f) {
        is_good = false;
        break;
      }
    }
    this.museActive = is_good;
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

  // select a single method to flatten the 4 sensor array for output in the getX() methods
  private float flattenSensor(float[] arr) {
    return arr[1]; // just use front left (FP1) for now
    // return averageFront(arr);
    // return average(arr);
  }


  public float getMellow() {
    return this.mellow;
  }

  public float getConcentration() {
    return this.concentration;
  }

  public float getDelta() {
    return flattenSensor(this.delta_session);
  }

  public float getTheta() {
    return flattenSensor(this.theta_session);
  }

  public float getAlpha() {
    return flattenSensor(this.theta_session);
  }

  public float getBeta() {
    return flattenSensor(this.alpha_session);
  }

  public float getGamma() {
    return flattenSensor(this.gamma_session);
  }


  
} //end MuseConnect


// globally accessible conversion of array to string
public String arr2str(float[] arr) {
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
// NOTE: this will conflict with any other use of oscP5 and definitions of this method!
// future versions will be in pure java to avoid this problem

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
  // catch and report relative bandwidth values
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
  PGraphics pgMuseHUD; //have basic PGraphics image to display on screen
 
  public final int WIDTH = 140;  
  public final int HEIGHT = 240;
  public final int VOFFSET = -10; 
  
  public final int GRAPHBASE = 100;
  public final int GRAPHHEIGHT = 80;
  public final int BARWIDTH = 8;


  // colors for muse horseshoe HUD
//  colorMode(RGB, 255);
  private int morange = 0;
  private int mgreen = 0;
  private int mblue = 0;
  private int mred = 0;
  private int morangel = 0;
  private int mgreenl = 0;
  private int mbluel = 0;
  private int mredl = 0;
  
  public MuseHUD(MuseConnect muse) {
    this.muse = muse;
    if (muse == null) {
      println("Muse object has not been instantiated yet");
    }
    pgMuseHUD = createGraphics(WIDTH, HEIGHT);
    
    // set up horseshoe colors
    colorMode(RGB, 255);
    morange = color(204,102,0);
    mgreen = color(102, 204, 0);
    mblue = color(0, 102, 204);
    mred = color(204, 0, 102);
    morangel = color(233, 187, 142);
    mgreenl = color(187, 233, 142);
    mbluel = color(142, 187, 233);
    mredl = color(233, 142, 187);
    
  }
  
  private int barHeight(int maxHeight, float value) {
    if (value > 1.0f) {
      value = 1;
    }
    return PApplet.parseInt(floor( - (maxHeight * value)));
  }
  
  private void updateHUD(PGraphics image) {
    colorMode(RGB, 255);
    int backColor = 50; //dark gray
    int foreColor = 200; // not quite white
    fill(foreColor);
    stroke(0);  
    image.beginDraw();
    image.smooth();
    image.background(0xff444444); // color from ui.theme.windowBackgroundColor
    image.stroke(0);
    image.fill(backColor);
    image.ellipseMode(RADIUS);
    image.ellipse(WIDTH/2, HEIGHT-60+VOFFSET, 35, 40); //head
    
    // println("Muse state: " + str(muse.touching_forehead) + " " + str(muse.horseshoe[0]) + " " + str(muse.horseshoe[1]) + " " + str(muse.horseshoe[2]) + " " + str(muse.horseshoe[3]));
  
    image.stroke(0);
    image.strokeWeight(3);
    if (muse.touching_forehead==1)  image.fill(0);
    else image.fill(backColor);
    image.ellipse(WIDTH/2, HEIGHT-82+VOFFSET, 5, 4); //on_forehead
    
    if (muse.touching_forehead==1) {
      // horseshoe values: 1= good, 2=ok, 3=bad
      // left temporal
      image.stroke(morange);

      if (muse.horseshoe[0]==1) {  image.fill(morange); }
      else if(muse.horseshoe[0]==2) { image.fill(morangel); }
      else { image.fill(backColor); }  
      image.ellipse(WIDTH/2 - 17, HEIGHT-45+VOFFSET, 6, 8); // TP9  
      
      // left frontal
      image.stroke(mgreen);
      if (muse.horseshoe[1]==1) {  image.fill(mgreen); }
      else if(muse.horseshoe[1]==2) { image.fill(mgreenl); }
      else { image.fill(backColor); }  
      image.ellipse(WIDTH/2 - 20, HEIGHT-70+VOFFSET, 6, 8); //FP1  
      
      // right frontal
      image.stroke(mblue);
      if (muse.horseshoe[2]==1) {  image.fill(mblue); }
      else if(muse.horseshoe[2]==2) { image.fill(mbluel); }
      else { image.fill(backColor); }  
      image.ellipse(WIDTH/2 + 20, HEIGHT-70+VOFFSET, 6, 8); //FP2
      
      // right temporal
      image.stroke(mred);
      if (muse.horseshoe[3]==1) {  image.fill(mred); }
      else if(muse.horseshoe[3]==2) { image.fill(mredl); }
      else { image.fill(backColor); }  
      image.ellipse(WIDTH/2 + 17, HEIGHT-45+VOFFSET, 6, 8); //TP10
    }
    else {
      // we probably dont have the headset on, no point in trying to color the rest
      image.stroke(0);
      image.fill(backColor);
      image.ellipse(WIDTH/2 - 17, HEIGHT-45+VOFFSET, 6, 8); // TP9
      image.ellipse(WIDTH/2 - 20, HEIGHT-70+VOFFSET, 6, 8); //FP1
      image.ellipse(WIDTH/2 + 20, HEIGHT-70+VOFFSET, 6, 8); //FP2
      image.ellipse(WIDTH/2 + 17, HEIGHT-45+VOFFSET, 6, 8); //TP10
    }
    
    int battery = PApplet.parseInt(muse.battery_level);
    String battstr = "batt: " + str(battery) + "%";
    int battfill = color(255); //white for default
    if (muse.touching_forehead==0) {
      battfill = color(0,0,0); // disabled battery
    }      
    else if (battery < 10) {
      battfill = color(255, 0, 0); // red battery warning
    }
    else if (battery < 20) {
      battfill = color(255,230,0); // yellow battery warning
    }
    image.stroke(battfill);
    image.fill(battfill);
    image.textSize(16);
    image.text(battstr, 3, HEIGHT-10+VOFFSET);
    
    // plot the graphs
    image.stroke(0);
    image.strokeWeight(1);
    image.line(10, GRAPHBASE, 130, GRAPHBASE);
    image.line(50, GRAPHBASE, 50, GRAPHBASE-GRAPHHEIGHT);
    textSize(10);
    image.fill(200);
    // image.text("M C      D T A B G", 13, GRAPHBASE);
    image.text("M C      \u03B4 \u03B8 \u03B1 \u03B2 \u03B3", 13, GRAPHBASE);
        
    if (muse.signalIsGood()) { // (true)
      image.stroke(0);
      image.fill(7, 145, 178); //blue
      image.rect(15, GRAPHBASE, BARWIDTH, barHeight(GRAPHHEIGHT, muse.getMellow()));
      image.fill(178, 85,0); //orange
      image.rect(28, GRAPHBASE, BARWIDTH, barHeight(GRAPHHEIGHT, muse.getConcentration()));

      image.fill(43, 131, 186); //blue
      image.rect(60, GRAPHBASE, BARWIDTH, barHeight(GRAPHHEIGHT, muse.getDelta()));
      image.fill(171, 221, 164); //green
      image.rect(72, GRAPHBASE, BARWIDTH, barHeight(GRAPHHEIGHT, muse.getTheta()));
      image.fill(253, 174, 97); //orange
      image.rect(84, GRAPHBASE, BARWIDTH, barHeight(GRAPHHEIGHT, muse.getAlpha()));
      image.fill(215, 25, 28); //red
      image.rect(96, GRAPHBASE, BARWIDTH, barHeight(GRAPHHEIGHT, muse.getBeta()));
      image.fill(255, 255, 191); //offwhite
      image.rect(108, GRAPHBASE, BARWIDTH, barHeight(GRAPHHEIGHT, muse.getGamma()));

    }
    
    image.endDraw();
  }
  
  // use this if drawing in MuseHUD's buffer
  public void drawHUD() {
    //this.pgMuseHUD = updateHUD(this.pgMuseHUD);
    updateHUD(this.pgMuseHUD);
  }

  // use this version if drawing in someone else's buffer
  public void drawHUD(PGraphics buffer) {
    //buffer = updateHUD(buffer);
    updateHUD(buffer);
  }
}





//import de.voidplus.leapmotion.*;


boolean MIDI_ENABLED = false;
EvolutionUC16 EV;
//LeapMotion leap;

class NerveBundle {

  NerveBundle(P2LX lx) {

    //leap = new LeapMotion(this);

    for (MidiInputDevice device : RWMidi.getInputDevices()) { 
      if (device.getName().contains("UC-16")) { 
        EV = EvolutionUC16.getEvolution(lx);
        MIDI_ENABLED = true;
        EV.bindDeviceControlKnobs(lx.engine.getChannel(0));
        //lx.engine.focusedChannel.addListener(EV.deviceControlListener);
        println("Evolution UC-16 Discovered. MIDI control enabled.");
      }
    }
  }
}



/*


AI will manage transitions

NerveBundle manages the mapping options between various sensors and senses and whatever.
The AI will actually control the mapping using NerveBundle container class

patterns etc register parameters with the NerveBundle
Sensors are hard coded into the NerveBundle



LXVirtualParameter
LXEffect
LXChannel - Has a lot of functionality we need to explore.



// Lame Ass transitions
  lx.enableAutoTransition(120000);
  
  for (LXPattern pattern : patterns) {
    pattern.setTransition(new MultiplyTransition(lx).setDuration(5000));
  }
  
*/

/*
 = EvolutionUC16.getEvolution(lx);


    println("Did we find an EV? ");
    println(EV);
    EV.bindKnob(colorHue, 0);
    EV.bindKnob(colorSat, 8);
    EV.bindKnob(colorBrt, 7);
    


// Steal pattern change detection and associated parameters for 
// Sensor-Sense mapping

  public UIChannelControl(UI ui, LXChannel channel, String label, int numKnobs, float x, float y) {
    super(ui, label, x, y, WIDTH, BASE_HEIGHT + KNOB_ROW_HEIGHT * (numKnobs / KNOBS_PER_ROW));

    this.channel = channel;
    int yp = TITLE_LABEL_HEIGHT;

    new UIButton(width-18, 4, 14, 14)
    .setParameter(channel.autoTransitionEnabled)
    .setLabel("A")
    .setActiveColor(ui.theme.getControlBackgroundColor())
    .addToContainer(this);

    List<UIItemList.Item> items = new ArrayList<UIItemList.Item>();
    for (LXPattern p : channel.getPatterns()) {
      items.add(new PatternScrollItem(p));
    }
    final UIItemList patternList =
      new UIItemList(1, yp, this.width - 2, 140)
      .setItems(items);
    patternList
    .setBackgroundColor(ui.theme.getWindowBackgroundColor())
    .addToContainer(this);
    yp += patternList.getHeight() + 10;

    final UIKnob[] knobs = new UIKnob[numKnobs];
    for (int ki = 0; ki < knobs.length; ++ki) {
      knobs[ki] = new UIKnob(5 + 34 * (ki % KNOBS_PER_ROW), yp
          + (ki / KNOBS_PER_ROW) * KNOB_ROW_HEIGHT);
      knobs[ki].addToContainer(this);
    }

      @Override
      public void patternDidChange(LXChannel channel, LXPattern pattern) {
        if (not MIDI_ENABLED) { return }
        int pi = 0;
        for (LXParameter parameter : pattern.getParameters()) {
          if (pi >= EvolutionUC16.KNOBS.length) {
            break;
          }
          if (parameter instanceof LXListenableNormalizedParameter) {
            knobs[pi++].setParameter((LXListenableNormalizedParameter) parameter);
          }
        }
      }
    };

    channel.addListener(lxListener);
    lxListener.patternDidChange(channel, channel.getActivePattern());
  }
*/



class HueCyclePalette extends LXPalette {
  
  final BasicParameter zeriod = new BasicParameter("Period", 5000, 0, 30000);
  final BasicParameter spread = new BasicParameter("Spread", 2, 0, 8);
  final BasicParameter center = new BasicParameter("Center", model.cx - 10*INCHES, model.xMin, model.xMax);
  
  HueCyclePalette(LX lx) {
    super(lx);
    addParameter(zeriod);
    addParameter(spread);
    addParameter(center);
  
    zeriod.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        period.setValue(zeriod.getValue());
      }
    });
    
  }
  
  public double getHue(LXPoint p) {
    return super.getHue() + spread.getValue() * (abs(p.x - center.getValuef()) + abs(p.y - model.cy));
  }
}




/************** COLOR BREWER PALETTES *************/


public static class GradientCB {
  public static final int Sequential = 3;
  public static final int Diverging = 2;
  public static final int Qualitative = 1;
  
  public static Color[] getGradient(int paletteType, int paletteIndex, int colors) {
    boolean colorBlindSave = false;
    ColorBrewer[] palettes;
    if (paletteType == Sequential) { 
        palettes = ColorBrewer.getSequentialColorPalettes(colorBlindSave);
    } else if (paletteType == Diverging) { 
        palettes = ColorBrewer.getDivergingColorPalettes(colorBlindSave);
    } else { 
        palettes = ColorBrewer.getQualitativeColorPalettes(colorBlindSave);
    }
    Color[] gradient = palettes[paletteIndex].getColorPalette(colors);
    return gradient;
  }
}



public static class DBLPalette { 


  public static Color[] toColors(int[] ints) { 
    Color[] colors = new Color[ints.length];
    for (int i=0; i<ints.length; i++) {
      Color c = new Color(ints[i]);
      colors[i] = c;
    }
    return colors;
  }

  public static int[] toColorInts(Color[] colors) { 
    int[] ints = new int[colors.length];
    for (int i=0; i<colors.length; i++) {
      int c = colors[i].getRGB();
      ints[i] = c;
    }
    return ints;
  }

  public static Color[] interpolate(Color[] gradient, int colorCount) {
    Color[] colors = new Color[colorCount];
    float scale = (float)(gradient.length-1)/(float)(colorCount-1);

    for (int i = 0; i < colorCount; i++) {
      float value = scale * i;
      int index = (int)Math.floor(value);

      Color c1 = gradient[index];
      float remainder = 0.0f;
      Color c2 = null;
      if (index+1 < gradient.length) {
        c2 = gradient[index+1];
        remainder = value - index;
      } else {
        c2 = gradient[index];
      }
      //		 System.out.println("value: " + value + " index: " + index + " remainder: " + remainder);
      int red   = Math.round((1 - remainder) * c1.getRed()    + (remainder) * c2.getRed());
      int green = Math.round((1 - remainder) * c1.getGreen()  + (remainder) * c2.getGreen());
      int blue  = Math.round((1 - remainder) * c1.getBlue()   + (remainder) * c2.getBlue());

      colors[i] = new Color(red, green, blue);
    }
    return colors;
  }

  public static int[] interpolate(int[] gradient, int colorCount) { 
    Color[] gradientColor = toColors(gradient);
    int[] ints = toColorInts(interpolate(gradientColor, colorCount));   
    return ints;
  }

}
/*****************************************************************************
 *    PATTERNS PRIMARILY INTENDED TO DEMO CONCEPTS, BUT NOT BE DISPLAYED
 ****************************************************************************/
class BlankPattern extends BrainPattern {
  BlankPattern(LX lx) {
    super(lx);
  }
  
  public void run(double deltaMs) {
    setColors(0xff000000);
  }
}

/** ************************************************************** HELLO WORLD
 * Basic Hello World pattern
 * @author Alex Maki-Jokela
 ************************************************************************* **/
class HelloWorldPattern extends BrainPattern{ 

  private final BasicParameter colorChangeSpeed = new BasicParameter("SPD",  5000, 0, 10000);
  private final SinLFO whatcolor = new SinLFO(0, 360, colorChangeSpeed);
  
  public HelloWorldPattern(LX lx){
    super(lx);
    addParameter(colorChangeSpeed);
    addModulator(whatcolor).trigger();
  }

  public void run(double deltaMs){
    for (LXPoint p : model.points) {
      float h=whatcolor.getValuef();
      int s=100;
      int b=100;
      colors[p.index]=lx.hsb(h,s,b);
    }
  }
}




/** ************************************************************** EMERGENCY
 * SOS pattern. Only for emergencies. Just white light.
 * Turning the chgOrNot knob (labeled "OSCI for oscillation" down stops the fluctuations and emits just constant white light
 * Not at a hundred percent brightness because that might overload power. (and 20k LEDs at 60% will be BRIGHT regardless)
 * @author Alex Maki-Jokela
 ************************************************************************* **/
class EmergencyPattern extends BrainPattern{ 

  private final DiscreteParameter chgOrNot = new DiscreteParameter("OSCI",  1, 0, 2);
  private final SinLFO whatbrightness = new SinLFO(0, 1, 8000);
  
  public EmergencyPattern(LX lx){
    super(lx);
    addParameter(chgOrNot);
    addModulator(whatbrightness).trigger();
  }

  public void run(double deltaMs){
    float brtness=40;
    if (chgOrNot.getValuef()==0) {
      brtness=40;
    }
    else {
      brtness=40*whatbrightness.getValuef();
    }
    for (LXPoint p : model.points) {
      float h=0;
      int s=0;
      int b=PApplet.parseInt(20+brtness);
      colors[p.index]=lx.hsb(h,s,b);
    }
  }
}





/** ************************************************************** Countdown Timer
 * Countdown Timer Pattern
 * @author Alex Maki-Jokela
 ************************************************************************* **/
 
 /*WIP WIP WIP
class CountdownTimer extends BrainPattern{ 

  private final BasicParameter colorChangeSpeed = new BasicParameter("SPD",  5000, 0, 10000);
  private final SinLFO whatcolor = new SinLFO(0, 360, colorChangeSpeed);
  PGraphics letters = createGraphics(80, 30);
  PGraphics squares = createGraphics(80, 30);
  MentalImage mentalimage;
  float shift;
  double starttime;
  
  public CountdownTimer(LX lx){
    super(lx);
    addParameter(colorChangeSpeed);
    addModulator(whatcolor).trigger();
    shift=0.0;
    starttime=30000;
      letters.beginDraw();
      letters.text("10:15", 15, 15);
      letters.endDraw();
      squares.beginDraw();
      squares.fill(#000044);
      squares.rect(random(width), random(height), 40, 40);
      squares.endDraw();
  
     
      mentalimage = new MentalImage(letters,"cylindrical_z",100);
  }

  public void run(double deltaMs){
    starttime=starttime-deltaMs;
    println(starttime);
     shift+=0.005;
    if(shift>1){
      shift=0.0;
    }
      colors=mentalimage.shiftedImageToPixels(colors,shift,0);
    
  }
}

*/




/** ************************************************************** HELLO WORLD
 * Basic Hello World pattern
 * @author Alex Maki-Jokela
 ************************************************************************* **/
class BarLengthTestPattern extends BrainPattern{ 


  private final Click whatcolor = new Click(5000); //rotate the colors erry 30 seconds in case there are two close colors next to each other
  private IntList hoos = new IntList();
  
  public BarLengthTestPattern(LX lx){
    super(lx);
    addModulator(whatcolor).start();
    for (String s : model.barmap.keySet()){
      hoos.append(PApplet.parseInt(random(360)));
    }
  }

  public void run(double deltaMs){
    if (whatcolor.getValuef()==1){
      hoos = new IntList();
      for (String s : model.barmap.keySet()){
        hoos.append(PApplet.parseInt(random(360)));
      }
    }
    int countr=0;
    int hoo_culla;
    for (String s:model.barmap.keySet()) {
      Bar b = model.barmap.get(s);
      int barstripid=PApplet.parseInt(b.strip_id);
      hoo_culla=hoos.get(countr);
      countr+=1;
      int barstripcount=-1;
      for (LXPoint p : b.points) {
        colors[p.index]=lx.hsb(hoo_culla,100,100);
        if (barstripcount>=0 && barstripcount <=barstripid){
          colors[p.index]=lx.hsb(hoo_culla,0,20);
        }
        barstripcount+=1;
      }
    }
  }
}



class ShowModulesPattern extends BrainPattern{ 


  private final Click whatcolor = new Click(5000); //rotate the colors erry 30 seconds in case there are two close colors next to each other
  private IntList hoos = new IntList();
  
  public ShowModulesPattern(LX lx){
    super(lx);
    addModulator(whatcolor).start();
    for (String s : model.barmap.keySet()){
      int modul = PApplet.parseInt(model.barmap.get(s).module);
      hoos.append(modul*40);
    }
  }

  public void run(double deltaMs){
   /* if (whatcolor.getValuef()==1){
      hoos = new IntList();
      for (String s : model.barmap.keySet()){
        hoos.append(int(random(360)));
      }
    }*/
    int countr=0;
    int hoo_culla;
    for (String s:model.barmap.keySet()) {
      Bar b = model.barmap.get(s);
      hoo_culla=hoos.get(countr);
      countr+=1;
      for (LXPoint p : b.points) {
        colors[p.index]=lx.hsb(hoo_culla,100,100);
      }
      /* uncomment to light specific bars*/
      if (b.id.equals("BAH-WIN")){
        for (LXPoint p : b.points) {
          colors[p.index]=lx.hsb(hoo_culla,0,100);
        } 
      }
      
    }
  }
}





class ShowMappingPattern extends BrainPattern{ 

  List<String> nodenames=new ArrayList<String>();
  List<String> nodenames2=new ArrayList<String>();
  
  public ShowMappingPattern(LX lx){
    super(lx);
    
    //todo make these automatically just start from the mapping
    //these are the nodes where the boxes go
    nodenames.add("COP");
    nodenames.add("PAW");
    nodenames.add("MAY");
    nodenames.add("YAY");
    nodenames.add("CIS");
    nodenames.add("NIX");
    nodenames.add("LAB");
    nodenames.add("JUG");
    
    //these are the other nodes where we're having strips start (no more than 1 bar from a box node)
    nodenames2.add("GET");
    nodenames2.add("CUP");
    nodenames2.add("SIP");
    nodenames2.add("SEX");
    nodenames2.add("BAH");
    nodenames2.add("OVA");
    nodenames2.add("AHI");
  }

  public void run(double deltaMs){
    
    //comment out these two for loops if you just want to see the start nodes
    for (LXPoint p : model.points) {
        colors[p.index]=lx.hsb(0,0,100);
      }
    for (String s:model.barmap.keySet()) {
      Bar b = model.barmap.get(s);
      int hoo_culla=PApplet.parseInt(b.strip_id)*30;
      for (LXPoint p : b.points) {
        colors[p.index]=lx.hsb(hoo_culla,100,100);
      }
    }
    
    /*  for (String s : nodenames2){
        Node n = model.nodemap.get(s);
        List<List<LXPoint>> pointsoutfromnode = n.pointlists_directed_out();
        for (List<LXPoint> lp : pointsoutfromnode){
          for (int i=0; i<10; i++){
            LXPoint p = lp.get(i);
            colors[p.index]=lx.hsb(200,100,100);
          }
        }
      }
      for (String s : nodenames){
        Node n = model.nodemap.get(s);
        List<List<LXPoint>> pointsoutfromnode = n.pointlists_directed_out();
        for (List<LXPoint> lp : pointsoutfromnode){
          for (int i=0; i<10; i++){
            LXPoint p = lp.get(i);
            colors[p.index]=lx.hsb(100,100,100);
          }
        }
      }*/
  }
}








/** ************************************************* NODE TRAVERSAL WITH FADE
 * Basic path traversal with global fading. 
 ************************************************************************** */
class SampleNodeTraversalWithFade extends BrainPattern{
  Node randnod = model.getRandomNode();
  Node randnod2 = model.getRandomNode();
  private final BasicParameter colorFade = new BasicParameter("Fade", 0.95f, 0.9f, 1.0f);
  List<Bar> barlist;

  public SampleNodeTraversalWithFade(LX lx){
    super(lx);
    addParameter(colorFade);
    for (LXPoint p: model.points) {
      colors[p.index]=lx.hsb(0,0,0);
    }
  }

  public void run(double deltaMS) {
    randnod = randnod.random_adjacent_nodes(1).get(0);
    randnod2 = randnod.random_adjacent_nodes(1).get(0);
    barlist = randnod.adjacent_bars();
    List<LXPoint> bar_poince = nodeToNodePoints(randnod,randnod2);
    for (LXPoint p: model.points) {
      colors[p.index] = LXColor.scaleBrightness(colors[p.index], colorFade.getValuef());
    }

    for (Bar b: barlist) {
      for (LXPoint p: b.points){
        colors[p.index]=lx.hsb(200,100,100);
      }
    }
    int counta=0;
    for (LXPoint p:bar_poince){
      counta+=10;
      colors[p.index]=lx.hsb(counta,counta/2,100);
    }
  }
}


/** *********************************************************** DISPLAY IMAGES
 * Simple demonstration of using the MentalImage class
 * Chooses an image, and gradually rotates it across the brain.
 ************************************************************************* **/
class TestImagePattern extends BrainPattern {

  MentalImage mentalimage = new MentalImage("media/images/starry_night.jpg","cylindrical_z",100);
  int counter;
  float shift=0.0f;
  
  public TestImagePattern(LX lx) {
    super(lx);
  }
  
  public void run(double deltaMs) {
    shift+=0.0003f;
    if(shift>1){
      shift=0.0f;
    }
    colors=this.mentalimage.shiftedImageToPixels(colors,shift,0);
  } 
}


/** ********************************************************** LX PALETTE DEMO
 * Simplest demonstration of using the rotating master hue.
 * All pixels are full-on the same color.
 ************************************************************************* **/
class LXPaletteDemo extends BrainPattern {
  
  public LXPaletteDemo(LX lx) {
    super(lx);
  }
  
  public void run(double deltaMs) {
    // Access the core master hue via this method call
    float hv = lx.getBaseHuef();
    for (int i = 0; i < colors.length; ++i) {
      colors[i] = lx.hsb(palette.getHuef(), 100, 100);
    }
  } 
}


/** ***************************************************************** GRADIENT
 * Example class making use of LXPalette's X/Y/Z interpolation to set
 * the color of each point in the model
 * @author Scouras
 ************************************************************************* **/

class GradientPattern extends BrainPattern {
  GradientPattern(LX lx) {
    super(lx);
  }
  
  public void run(double deltaMs) {
    for (LXPoint p : model.points) {
      colors[p.index] = palette.getColor(p);
    }
  }
}





/** ********************************************************* RANDOM BAR FADES
 * Selects random sets of bars and sets them to random colors fading in and out
 * @author Alex Maki-Jokela
 ************************************************************************* **/
class RandomBarFades extends BrainPattern {
   
  SortedMap<String, Bar> active_bars = new TreeMap<String, Bar>();
  SortedMap<String, String> random_bar_colors = new TreeMap<String, String>();
  List<String> all_bar_names= new ArrayList<String>(model.barmap.keySet());;
  Random randomness = new Random();
  Bar b;
  String randomKey;
  int phase = -1;
  String random_color_str;
    
  public RandomBarFades(LX lx){
    super(lx);
  }


  public void run(double deltaMs) {
    if (phase < 0){  
      for (int i = 0; i < 400; i=i+1) {
        String stringi = str(i);
        randomKey = all_bar_names.get( randomness.nextInt(all_bar_names.size()) );
        b = model.barmap.get(randomKey);
        active_bars.put(stringi,b);
        random_color_str = str(PApplet.parseInt(random(360)));
        random_bar_colors.put(stringi,random_color_str);
        phase=1;
      }
    }
    phase=phase+3;
    if (phase < 100){
      for (String j : active_bars.keySet()){
        Bar bb = active_bars.get(j);
        random_color_str = random_bar_colors.get(j);
        for (LXPoint p : bb.points) {
          colors[p.index]=lx.hsb(PApplet.parseInt(random_color_str),100,phase);
        }
      }
    }
    else{
      for (String j : active_bars.keySet()){
        Bar bb = active_bars.get(j);
        random_color_str = random_bar_colors.get(j);
        for (LXPoint p : bb.points) {
          colors[p.index]=lx.hsb(PApplet.parseInt(random_color_str),100,200-phase);
        }
      }
    }
    if (phase>200){
      phase=phase % 200;
      for (LXPoint p: model.points) {
        colors[p.index]=lx.hsb(0,0,0);
      }
      active_bars = new TreeMap<String, Bar>();
      random_bar_colors = new TreeMap<String, String>();
      for (int i = 0; i < 400; i++) {
        String stringi = str(i);
        String randomKey = all_bar_names.get( randomness.nextInt(all_bar_names.size()) );
        b = model.barmap.get(randomKey);
        active_bars.put(stringi,b);
        random_color_str = str(PApplet.parseInt(random(360)));
        random_bar_colors.put(stringi,random_color_str);
      }
    }  
  }
}


  
/** **************************************************************** TEST BARS
 * Test of lighting up the bars one by one rapidly. 
 * Todo: Make this way less ugly and more importantly, write one that 
 * traverses the node graph
 ************************************************************************* **/
class TestBarPattern extends BrainPattern {
  public String current_bar_name="FOG-LAW"; //can be any 
  public String current_node_name="FOG";
  public Random randomness = new Random();
  public TestBarPattern(LX lx) {
    super(lx);
  }
  public void run(double deltaMs) {
    Random random = new Random();
    List<String> bar_node_names=Arrays.asList(current_bar_name.split("-"));
    String next_node_name = ""; 
    for (String node_name_i : bar_node_names){ 
      if (node_name_i.length()==3 && !node_name_i.equals(current_node_name)){ //is it a node name? is it not the same node name?
        next_node_name=node_name_i;
    }
    }
    Node next_node_node = model.nodemap.get(next_node_name);
    List<String> possible_next_bars = next_node_node.adjacent_bar_names;
    String next_bar_name = possible_next_bars.get(randomness.nextInt(possible_next_bars.size()));
    current_bar_name=next_bar_name;
    current_node_name=next_node_name;
    List<String> keys = new ArrayList<String>(model.barmap.keySet());
    String randomKey = keys.get( random.nextInt(keys.size()) );
    Bar b = model.barmap.get(next_bar_name);
    float hv = lx.getBaseHuef();
    int i = 0;
    int j = 0;
    for (LXPoint p: model.points) {
      colors[p.index]=lx.hsb(0,100,0);
    }
      for (LXPoint p: b.points) {
      j +=1;
      colors[p.index] = lx.hsb(100, 100, 100);
    }
  }
}





/** *************************************************************** LAYER DEMO
 * Demonstration of layering patterns
 ************************************************************************* **/
class LayerDemoPattern extends LXPattern {
  
  private final BasicParameter colorSpread = new BasicParameter("Clr", 0.5f, 0, 3);
  private final BasicParameter stars = new BasicParameter("Stars", 100, 0, 100);
  
  public LayerDemoPattern(LX lx) {
    super(lx);
    addParameter(colorSpread);
    addParameter(stars);
    for (int i = 0; i < 200; ++i) {
      addLayer(new StarLayer(lx));
    }
    addLayer(new CircleLayer(lx));
    addLayer(new RodLayer(lx));
  }

  public void run(double deltaMs) {
    // The layers run automatically
  }

  private class CircleLayer extends LXLayer {

    private final SinLFO xPeriod = new SinLFO(3400, 7900, 11000); 
    private final SinLFO brightnessX = new SinLFO(model.xMin, model.xMax, xPeriod);

    private CircleLayer(LX lx) {
      super(lx);
      addModulator(xPeriod).start();
      addModulator(brightnessX).start();
    }

    public void run(double deltaMs) {
      // The layers run automatically
      float falloff = 100 / (4*FEET);
      for (LXPoint p : model.points) {
        float yWave = model.yRange/2 * sin(p.x / model.xRange * PI); 
        float distanceFromCenter = dist(p.x, p.y, model.cx, model.cy);
        float distanceFromBrightness = dist(p.x, abs(p.y - model.cy), brightnessX.getValuef(), yWave);
        colors[p.index] = LXColor.hsb(
          lx.getBaseHuef() + colorSpread.getValuef() * distanceFromCenter,
          100,
          max(0, 100 - falloff*distanceFromBrightness)
        );
      }
    }
  }

  private class RodLayer extends LXLayer {
    
    private final SinLFO zPeriod = new SinLFO(2000, 5000, 9000);
    private final SinLFO zPos = new SinLFO(model.zMin, model.zMax, zPeriod);
    
    private RodLayer(LX lx) {
      super(lx);
      addModulator(zPeriod).start();
      addModulator(zPos).start();
    }
    
    public void run(double deltaMs) {
      for (LXPoint p : model.points) {
        float b = 100 - dist(p.x, p.y, model.cx, model.cy) - abs(p.z - zPos.getValuef());
        if (b > 0) {
          addColor(p.index, LXColor.hsb(
            lx.getBaseHuef() + p.z,
            100,
            b
          ));
        }
      }
    }
  }
  
  private class StarLayer extends LXLayer {
    
    private final TriangleLFO maxBright = new TriangleLFO(0, stars, random(2000, 8000));
    private final SinLFO brightness = new SinLFO(-1, maxBright, random(3000, 9000)); 
    
    private int index = 0;
    
    private StarLayer(LX lx) { 
      super(lx);
      addModulator(maxBright).start();
      addModulator(brightness).start();
      pickStar();
    }
    
    private void pickStar() {
      index = (int) random(0, model.size-1);
    }
    
    public void run(double deltaMs) {
      if (brightness.getValuef() <= 0) {
        pickStar();
      } else {
        addColor(index, LXColor.hsb(lx.getBaseHuef(), 50, brightness.getValuef()));
      }
    }
  }
}




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
    float soundLevel = -dbMeter.getDecibelsf()*0.5f;
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





class MusicResponse extends BrainPattern {
  private GraphicEQ eq = null;
  List<List<LXPoint>> strips_emanating_from_nodes = new ArrayList<List<LXPoint>>();

  double ms = 0.0f;
  double offset = 0.0f;
  private final BasicParameter colorScheme = new BasicParameter("SCM", 0, 3);
  private final BasicParameter cycleSpeed = new BasicParameter("SPD",  100, 0, 1000);
  private final BasicParameter colorSpread = new BasicParameter("LEN", 100, 0, 1000);
  private final BasicParameter colorHue = new BasicParameter("HUE",  0.f, 0.f, 359.f);
  private final BasicParameter colorSat = new BasicParameter("SAT", 80.f, 0.f, 100.f);
  private final BasicParameter colorBrt = new BasicParameter("BRT", 80.f, 0.f, 100.f);
  private DecibelMeter dbMeter = new DecibelMeter(lx.audioInput());
  private GeneratorPalette gp = 
      new GeneratorPalette(
          new ColorOffset(0xDD0000).setHue(colorHue)
                                   .setSaturation(colorSat)
                                   .setBrightness(colorBrt),
          GeneratorPalette.ColorScheme.Monochromatic,
          40
      );
  private int scheme = 0;

  public MusicResponse(LX lx) {
    super(lx);
    addParameter(colorScheme);
    addParameter(cycleSpeed);
    addParameter(colorSpread);
    addParameter(colorHue);
    addParameter(colorSat);
    addParameter(colorBrt);
    
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
    int newScheme = (int)Math.floor(colorScheme.getValue());
    if ( newScheme != scheme) { 
      switch(newScheme) { 
        case 0: gp.setScheme(GeneratorPalette.ColorScheme.Analogous); break;
        case 1: gp.setScheme(GeneratorPalette.ColorScheme.Monochromatic); break;
        case 2: gp.setScheme(GeneratorPalette.ColorScheme.Triad); break;
        case 3: gp.setScheme(GeneratorPalette.ColorScheme.Complementary); break;
      }
      scheme = newScheme;
    }

    ms += deltaMs;
    offset += deltaMs*cycleSpeed.getValue()/1000.f;
    //int steps = (int)colorSpread.getValue();
    //if (steps != gp.steps) { 
    //  gp.setSteps(steps);
    //}
    //gp.reset((int)offset);
    colorHue.setValue(offset%360.f);
    double progress = lx.tempo.ramp();
    //float bassLevel = lx.audioInput.mix.level();//eq.getAveragef(0, 5) * 5000;
    float soundLevel = -dbMeter.getDecibelsf()*0.5f;
    double adsr = Math.cos(progress)/2.0f+0.5f;
    //println(dbMeter.getDecibelsf() + "    " + soundLevel);
    for (LXPoint p: model.points) {
      colors[p.index] = 0;
      //colors[p.index] = gp.getColor();
      //colors[p.index] = lx.hsb(LXColor.h(gp.getColor()),40.,(float)(progress*100.));
    }
    for (List<LXPoint> strip : strips_emanating_from_nodes) {
      gp.reset();
      int distance_from_node=0;
      int striplength = strip.size();
      int steps = (int)Math.ceil(strip.size());
      //int steps = (int)Math.floor(strip.size()*adsr);
      gp.setSteps(steps);
      for (LXPoint p : strip) {
        distance_from_node+=1;
        //if (distance_from_node > steps) {
        //  break;
        //}
        /*
        float relative_distance = (float) distance_from_node / striplength;
        float hoo = 300- 5*relative_distance*2500/soundLevel;
        float saturat = 100;
        float britness = max(0, 100 - 3*relative_distance*2500/soundLevel);
        //addColor(p.index, lx.hsb(hoo, saturat, britness));
        */
        int clr = gp.getColor(adsr);
        colors[p.index] = lx.hsb(LXColor.h(clr),
                                 LXColor.s(clr),
                                 LXColor.b(clr));
                                 //LXColor.b(clr)*constrain(soundLevel/20., 0., 1.));
      }
    }
  }
}




/*****************************************************************************
 *     NEURAL ANATOMY AND PHYSIOLOGICAL SIMULATIONS OR INSPIRED PATTERNS
 ****************************************************************************/



/** ********************************************************* AV BRAIN PATTERN
 * A rate model of the brain with semi-realistic connectivity and time delays
 * Responds to sound.
 * @author: rhancock@gmail.com. 
 ************************************************************************* **/



// the effects package is needed because the filters are there for now.


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



  float tstep = .001f; //changing this requires updating the delay matrix
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
        C[i][j] = PApplet.parseFloat(conn_cols[j]);
        D[i][j] = PApplet.parseInt(delay_cols[j]);
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
        gain[i][j] = PApplet.parseFloat(gain_cols[j]);
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
      act[i][t+1]=act[i][t]+tstep/.2f*(-act[i][t]+(float)(k.getValue()/100/n_nodes)*w+(float)(sigma.getValue()/100*noise.nextGaussian()));
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



/** ********************************************************************
 * Muse bandwidth energy pattern
 *
 * Does variation of Pixies pattern, with multiple layers
 * @author Mike Pesavento
 * original by Geoff Schmiddt
 *
 * Requires use of the muse_connect.pde file, which gives access to the muse headset data
 * Also written by MJP. 
 * Needs global object variable to be declared to access it in this pattern.
 * Run "muse-io' from command prompt, eg
 *    muse-io --preset 14 --osc osc.udp://localhost:5000
 *
 */
class NeuroTracePattern extends BrainPattern {
  // Brightness adjustment factor.
  // private final BasicParameter brightness = new BasicParameter("BRITE", 0.5, 0, 1.0);
  private final BasicParameter brightness = new BasicParameter("BRITE", 1.0f, .25f, 2.0f);

  // How long the trails persist. (Decay factor/percent for the trails, updated each frame.)
  private final BasicParameter fade = new BasicParameter("FADE", 0.90f, 0.8f, 0.99f);
  
  private final BasicParameter globalSpeed = new BasicParameter("SPD", 1, 0, 2.0f);

  // speed will be manually set, in pixels per second. 
  // Typical range= 10-1000, good starting value might be 60 (about a bar a second)

  private final BasicParameter gammaScale = new BasicParameter("gamma", 0.2f, 0, 1.0f);
  private final BasicParameter betaScale = new BasicParameter("beta", 0.3f, 0, 1.0f);
  private final BasicParameter alphaScale = new BasicParameter("alpha", 0.6f, 0, 1.0f);
  private final BasicParameter thetaScale = new BasicParameter("theta", 0.7f, 0, 1.0f);
  private final BasicParameter deltaScale = new BasicParameter("delta", 0.8f, 0, 1.0f);


  // a good colormap to use is from the ColorBrewer palette, 5-class "Spectral"
  // RGB values: red (215, 25, 28), orange (253, 174,97), yellow (255,255,191), green (135,206,125), blue (43,131,186)
  // HSV values:     (359, 88, 84),         (30, 62, 99),        (60, 25, 100),       (113, 45, 65),      (203, 77, 73)

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
    addLayer(new PixiePattern(lx, 1, thetaScale, lx.hsb(113, 45, 65), 20)); //green
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
        p.offset += (deltaMs / 1000.0f) * this.speed;
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
          double end = Math.min(p.offset, Math.ceil(drawOffset + .000000001f));
          double timeHereMs = (end - drawOffset) / this.speed * globalSpeed.getValuef() * 1000.0f;

          LXPoint here = points.get((int)Math.floor(drawOffset));
          //        System.out.format("%.2fms at offset %d\n", timeHereMs, (int)Math.floor(drawOffset));

          addColor(here.index, 
              LXColor.scaleBrightness(p.pixieColor, 
              (float)timeHereMs / 1000.0f
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
  SawLFO beatmodulator = new SawLFO(0.0f, 1.0f, beatPer);
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
          float pctthru=PApplet.parseFloat(ptcount)/PApplet.parseFloat(bloodlength);
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
          float pctthru=PApplet.parseFloat(ptcount)/PApplet.parseFloat(bloodlength);
          if (pctthru>((phase-70)/30)) {
            colors[p.index]=lx.hsb(bloodhue, 100, 41);
          }
          ptcount+=1;
        }
      }
    }
  }

  public void run(double deltaMS) {
    if (beatmodulator.getValuef()<0.5f) {
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
  public final BasicParameter colorSpread = new BasicParameter("Clr", 0.5f, 0, 3);
  BasicParameter xPer = new BasicParameter("XPD", 6000, 5000, 20000);
  BasicParameter yPer = new BasicParameter("YPD", 6000, 5000, 20000);
  SawLFO linenvx = new SawLFO(0.0f, 1.0f, xPer);
  SawLFO linenvy = new SawLFO(0.0f, 1.0f, yPer);

  public final SinLFO xPeriod = new SinLFO(3400, 7900, 11000); 
  public final SinLFO brightness = new SinLFO(model.xMin, model.xMax, xPeriod);

  ////  private final SinLFO brightnessX = new SinLFO(model.xMin, model.xMax, xPeriod);
  private final BasicParameter colorFade = new BasicParameter("Fade", 0.95f, 0.9f, 1.0f);
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

/*****************************************************************************
 *    PATTERNS THAT ARE NOT TO BE DISLPAYED FOR SOME REASON
 ****************************************************************************/


/** **************************************************************************
 * ported from sugarcubes by Jeanie 
 * Do not want to trample on sugarcubes IP though.
 ************************************************************************* **/ 
class Swim extends BrainPattern {

  // Projection stuff
  private final LXProjection projection;
  SawLFO rotation = new SawLFO(0, TWO_PI, 19000);
  SinLFO yPos = new SinLFO(-25, 25, 12323);
  final BasicParameter xAngle = new BasicParameter("XANG", 0.9f);
  final BasicParameter yAngle = new BasicParameter("YANG", 0.3f);
  final BasicParameter zAngle = new BasicParameter("ZANG", 0.3f);

  final BasicParameter hueScale = new BasicParameter("HUE", 0.3f);

  public Swim(LX lx) {
    super(lx);
    projection = new LXProjection(model);

    addParameter(xAngle);
    addParameter(yAngle);
    addParameter(zAngle);
    addParameter(hueScale);

    addModulator(rotation).trigger();
    addModulator(yPos).trigger();
  }


  int beat = 0;
  float prevRamp = 0;
  public void run(double deltaMs) {

    // Sync to the beat
    float ramp = (float)lx.tempo.ramp();
    if (ramp < prevRamp) {
      beat = (beat + 1) % 4;
    }
    prevRamp = ramp;
    float phase = (beat+ramp) / 2.0f * 2 * PI;

    float denominator = max(xAngle.getValuef() + yAngle.getValuef() + zAngle.getValuef(), 1);

   projection.reset()
      // Swim around the world
     .rotate(rotation.getValuef(), xAngle.getValuef() / denominator, yAngle.getValuef() / denominator, zAngle.getValuef() / denominator)
      .translateCenter(0, 50 + yPos.getValuef(), 0);

    float model_height =  model.yMax - model.yMin;
    float model_width =  model.xMax - model.xMin;
    for (LXVector p : projection) {
      float x_percentage = (p.x - model.xMin)/model_width;

      // Multiply by 1.4 to shrink the size of the sin wave to be less than the height of the cubes.
      float y_in_range = 1.4f * (2*p.y - model.yMax - model.yMin) / model_height;
      float sin_x =  sin(phase + 2 * PI * x_percentage);       

      // Color fade near the top of the sin wave
      float v1 = sin_x > y_in_range  ? (100 + 100*(y_in_range - sin_x)) : 0;     

      float hue_color = (lx.getBaseHuef() + hueScale.getValuef() * (abs(p.x-model.xMax/2.f)*.3f + abs(p.y-model.yMax/2)*.9f + abs(p.z - model.zMax/2.f))) % 360;
      colors[p.index] = lx.hsb(hue_color, 70, v1);
    }
  }
}







//**************************************************** COMMAND LINE PROCESSING
// To run Processing2 from the command line, install the CLI client:
//   Processing2 -> Tools -> Install "processing-java"
// Then go to your local DBL2_lighting directory in a terminal:
//   processing-java --run --sketch=`pwd` --output=/tmp/something --force
//****************************************************************************
 
  
/** ******************************************************************** VIDEO
 * Hackathon Entry
 * @author Tom Bishop
 * TODO: This pattern will prevent DBLX from launching if it cannot find a 
 * camera to connect to. Going to disable it by default for now, but we should
 * find a graceful way to handle it.
 * Available cameras: [Ljava.lang.String;@b0e9f8b
 * TODO: Move video capture to Senses.pde
 ************************************************************************* **/

PApplet parentApplet = this;
class VidPattern extends BrainPattern {
  MentalImage mentalimage = new MentalImage("media/images/stormclouds_purple.jpg","xy",110);  
  BasicParameter xPer = new BasicParameter("XPD",50000,5000,50000);
  BasicParameter yPer = new BasicParameter("YPD",50000,5000,50000);
  BasicParameter scl = new BasicParameter("Scale",100,10,400);
  SawLFO linenvx = new SawLFO(0.0f,1.0f,xPer);
  SawLFO linenvy = new SawLFO(0.0f,1.0f,yPer);
  float add_to_xPer=0.0f;
  float add_to_yPer=0.0f;
  Capture cam;
  
  public VidPattern(LX lx){
    super(lx);
    addModulator(linenvx).start();
    addModulator(linenvy).start();
    addParameter(xPer);
    addParameter(yPer);
    addParameter(scl);
    
    println("Available cameras: " + Capture.list()); 
    cam = new Capture(parentApplet,640,480);
    cam.start();  
  }
 public void run(double deltaMs) {                    
    if(linenvx.getValuef()<0.01f){
      add_to_xPer=random(-1000,1000);
      xPer.setValue(xPer.getValuef()+add_to_xPer);
    }
    if(linenvy.getValuef()<0.01f){
      add_to_yPer=random(-1000,1000);
      yPer.setValue(yPer.getValuef()+add_to_xPer);
    }
    
    if (cam.available() == true) {
      cam.read();
      PImage img = cam;
      mentalimage.updateImage(img,"xy",100);
    }
    
    colors=this.mentalimage.shiftedImageToPixels(colors,linenvx.getValuef(),linenvy.getValuef(),scl.getValuef()/100.0f );
  } 
}



/** *********************************************** POWER RANGERS MASK PATTERN
 * Hackathon Entry
 * @author Shruthi Kubatur
 * All 5 ranges in less than 4 minutes
 ************************************************************************* **/

class RangersPattern extends BrainPattern {
  public String current_bar_name="FOG-LAW"; //can be any 
  public String current_node_name="FOG";
  public Random randomness = new Random();
  
  private int j = 0, j_color = 0, color_step = 60, T = 700, persist = 10000;
  
  public List<Integer> painted = new ArrayList<Integer>();
  
  Node randomnode;
  Node nextrandomnode;
  List<Bar> barlist;
  
  private final BasicParameter colorChangeSpeed = new BasicParameter("SPD",  300000, 0, 1000000);
  private final SinLFO whatcolor = new SinLFO(0, 360, colorChangeSpeed);
  
  public RangersPattern(LX lx) {
    super(lx);
    randomnode = model.getRandomNode(); //SampleNodeTraversal
    addParameter(colorChangeSpeed);
    addModulator(whatcolor).trigger();
  }
  
  MentalImage mentalimage = new MentalImage("media/images/rangers_eyes_2.png", "yz", 250);
  int counter;
  float shift=0.0f;
  
  public void run(double deltaMs) {  
    
    randomnode = randomnode.random_adjacent_nodes(1).get(0);
    nextrandomnode = randomnode.random_adjacent_nodes(1).get(0);
    barlist = randomnode.adjacent_bars();

    float h = whatcolor.getValuef();
    colors = this.mentalimage.shiftedImageToPixels(colors, 0, 0);
    
    for (Integer z: painted){
       if (colors[z] == lx.hsb(0, 0, 0)){
       colors[z] = lx.hsb(j_color, 100, 90);
       }
    }
    
    for (Bar b: barlist) {
      for (LXPoint p: b.points){
        painted.add(p.index);
        colors[p.index] = lx.hsb(j_color, 100, 90);
      }
    }
    
    if ((j > 4) && ((j%T == 0) || (j%T == 1) || (j%T == 2) || (j%T == 3) || (j%T == 4)))
    {
    for (LXPoint z: model.points){
          if (colors[z.index] == lx.hsb(0, 0, 0))
             colors[z.index] = lx.hsb(65, 0, 5000); // flash
       }
    
    }
    
    if (j%T == 5)
       painted.clear();
    
    j_color = (color_step*(j-(j%T))/T)%301;
    j = j+1;
    
  } // End of "run" method
}




/** ****************************************************************** VORONOI
 * Hackathon Entry
 * @author Irene Zhou
 ************************************************************************* **/

class Voronoi extends BrainPattern {
  public BasicParameter speed = new BasicParameter("SPEED", 10, 0, 20);
  public BasicParameter width = new BasicParameter("WIDTH", 0.5f, 0.2f, 1);
  public BasicParameter hue = new BasicParameter("HUE", 0, 0, 360);
  public DiscreteParameter num = new DiscreteParameter("NUM", 14, 5, 28);
  private List<Site> sites = new ArrayList<Site>();
  public float xMaxDist = model.xMax - model.xMin;
  public float yMaxDist = model.yMax - model.yMin;
  public float zMaxDist = model.zMax - model.zMin;

  class Site {
    float xPos = 0;
    float yPos = 0;
    float zPos = 0;
    PVector velocity = new PVector(0,0,0);

    public Site() {
        xPos = random(model.xMin, model.xMax);
        yPos = random(model.yMin, model.yMax);
        zPos = random(model.zMin, model.zMax);
        velocity = new PVector(random(-1,1), random(-1,1), random(-1,1));
    }

    public void move(float speed) {
      xPos += speed * velocity.x;
      if ((xPos < model.xMin - 20) || (xPos > model.xMax + 20)) {
        velocity.x *= -1;
      }
      yPos += speed * velocity.y;
      if ((yPos < model.yMin - 20) || (yPos > model.yMax + 20)) {
        velocity.y *= -1;
      }
      zPos += speed * velocity.z;
      if ((zPos < model.zMin - 20) || (zPos > model.zMax + 20)) {
        velocity.z *= -1;
      }
    }
  }

  public Voronoi(LX lx) {
    super(lx);
    addParameter(speed);
    addParameter(width);
    addParameter(hue);
    addParameter(num);
  }

  public void run(double deltaMs) {
    for (LXPoint p: model.points) {
      float numSites = num.getValuef();
      float lineWidth = width.getValuef();

      while(sites.size()>numSites){
        sites.remove(0);
      }

      while(sites.size()<numSites){
        sites.add(new Site());
      }

      float minDistSq = 10000;
      float nextMinDistSq = 10000;
      float calcRestraintConst = 20 / (numSites + 15);
      lineWidth = lineWidth * 40 / (numSites + 20);

      for (Site site : sites) {
        float dx = site.xPos - p.x;
        float dy = site.yPos - p.y;
        float dz = site.zPos - p.z;

        if (abs(dy) < yMaxDist * calcRestraintConst &&
            abs(dx) < xMaxDist * calcRestraintConst &&
            abs(dz) < zMaxDist * calcRestraintConst) { //restraint on calculation
          float distSq = dx * dx + dy * dy + dz * dz;
          if (distSq < nextMinDistSq) {
            if (distSq < minDistSq) {
              nextMinDistSq = minDistSq;
              minDistSq = distSq;
            } else {
              nextMinDistSq = distSq;
            }
          }
        }
      }
      colors[p.index] = lx.hsb(
        (lx.getBaseHuef() + hue.getValuef()) % 360,
        100,
        max(0, min(100, 100 - sqrt(nextMinDistSq - minDistSq) / lineWidth))
      );
    }
    for (Site site: sites) {
      site.move(speed.getValuef());
    }
  }
}



/** ***************************************************************** SERPENTS
 * Snake traces. I'm going to see if there's a good way to make this a 
 * class people can just call on to add snakes to their patterns tomorrow.
 * Feel free to adapt and work into your own patterns.
 * @author Alex Maki-Jokela
 ************************************************************************* **/

class Serpents extends BrainPattern{
  
  public DiscreteParameter howmanysnakes = new DiscreteParameter("NUM",4,0,20);
  public DiscreteParameter serperiod = new DiscreteParameter("PER",300,50,400);
  public DiscreteParameter serlength = new DiscreteParameter("LEN",10,1,20);
  public List<Serpent> serpence = new ArrayList<Serpent>();
  
  class Serpent {
    
    float slength;
    float speriod;
    float prevphase=0.0f;
    int hoo;
    SawLFO wormthroughbar;
    List<Node> snakeNodes = new ArrayList<Node>();
    List<LXPoint> snakeDots = new ArrayList<LXPoint>();
    
    public Serpent(float period, float slength, int hoo){
      this.speriod = constrain(period,10,20000);
      this.wormthroughbar = new SawLFO(0,100,this.speriod);
      this.slength=slength;
      this.hoo=hoo;
      
      addModulator(this.wormthroughbar).start();
      Node previternode;
      Node iternode=model.getRandomNode();
      snakeNodes.add(iternode);
      while (snakeNodes.size()<(slength+2)){
        previternode=iternode;
        iternode=iternode.random_adjacent_node();
        List<LXPoint> dotsBetween = nodeToNodePoints(previternode,iternode);
        for (LXPoint p : dotsBetween){
          snakeDots.add(p);
        }
        snakeNodes.add(iternode);
      }
    }
    
    public void run(double deltaMs) {
      float phase=wormthroughbar.getValuef();
      
      //handle disposing/adding new nodes    
      if(phase<prevphase){ //aka if the saw lfo looped back around again
        snakeNodes.remove(0);
        Node lastnode=snakeNodes.get(snakeNodes.size() - 1);
        Node prevlastnode=snakeNodes.get(snakeNodes.size() - 2);
        Node nextnode=lastnode.random_adjacent_node();
        int cnt=0;
        while (nextnode.id==prevlastnode.id){
          cnt=cnt+1;
          nextnode=lastnode.random_adjacent_node();
          if (cnt>45){
            println("LN",lastnode.id);
            println("NN",nextnode.id);
          }
        }
        snakeNodes.add(nextnode);
      }
      
      Node prevnode=snakeNodes.get(0);
      boolean firstnode=true;
      Node sn=snakeNodes.get(0);
      for(int i=0;i<snakeNodes.size()-1;i++){
        sn=snakeNodes.get(i+1);
        prevnode=snakeNodes.get(i);
          List<LXPoint> the_bar= nodeToNodePoints(prevnode,sn);
          float barlen = the_bar.size();
          if (i==0){
            float pointcounter=0;
            for (LXPoint p : the_bar){
              if (pointcounter/barlen*100>phase){
                addColor(p.index,lx.hsb(hoo,100,100));
              }
              pointcounter+=1;
            }
          } else {
            if (i==snakeNodes.size()-2){
              int pointcounter=0;
              for (LXPoint p : the_bar){
                if (pointcounter/barlen*100<phase){
                   addColor(p.index,lx.hsb(hoo,100,100));
                 }
                 pointcounter++;
              }
            } else {
            for (LXPoint p : the_bar){
              addColor(p.index,lx.hsb(hoo,100,100));
            }
          }
          }
        prevnode=sn;
        }
          
      prevphase=phase;
      }
  }

  public Serpents(LX lx){
    super(lx);
    addParameter(howmanysnakes);
    addParameter(serperiod);
    addParameter(serlength);
  }  
  
  public void run(double deltaMs){
    for (LXPoint p : model.points) {
      colors[p.index]=0;
    }
    while(serpence.size()>howmanysnakes.getValuef()){
      serpence.remove(0);
    }
    while(serpence.size()<howmanysnakes.getValuef()){
      int hoo = PApplet.parseInt(random(360));
      serpence.add(new Serpent(serperiod.getValuef(),serlength.getValuef(),hoo));
    }
    for (Serpent serpent : serpence){
      serpent.run(deltaMs);
    }  
  }
    
}
      
  
  
  
/**
 * Uses the MentalImage class and a picture of the night sky 
 * to play a night sky slowly sparkling across the brain
 * @author Alex Maki-Jokela
 */
class SparklingNightSky extends BrainPattern {

  MentalImage mentalimage = new MentalImage("media/images/stars.jpg","xy",100);
  public BasicParameter xPer = new BasicParameter("XPD",70000.0f,50000.0f,100000.0f);
  public BasicParameter yPer = new BasicParameter("YPD",70000,50000,100000);
  public SawLFO linenvx = new SawLFO(0.0f,1.0f,xPer);
  public SawLFO linenvy = new SawLFO(0.0f,1.0f,yPer);
  int counter;
  float add_to_xPer;
  float add_to_yPer;
  float shift=0.0f;
  
  public SparklingNightSky(LX lx) {
    super(lx);
     addModulator(linenvx).start();
     addModulator(linenvy).start();
     addParameter(xPer);
     addParameter(yPer);
  }
  
  public void run(double deltaMs) {
    
    if(linenvx.getValuef()<0.01f){
      add_to_xPer=random(-1000,1000);
      xPer.setValue(xPer.getValuef()+add_to_xPer);
    }
    if(linenvy.getValuef()<0.01f){
      add_to_yPer=random(-1000,1000);
      yPer.setValue(yPer.getValuef()+add_to_xPer);
    }
    colors=this.mentalimage.shiftedImageToPixels(colors,linenvx.getValuef(),linenvy.getValuef());

  } 
}





/** ************************************************************** BRAIN STORM
 * Creates a thundercloud with lightning strikes pattern
 * Also an example of basic node traversal
 * @author: Alex Maki-Jokela
 ************************************************************************* **/
 
 
class BrainStorm extends BrainPattern {
  MentalImage mentalimage = new MentalImage("media/images/stormclouds_purple_alpha.png","xy",100); //looks worse on the sim but better on the pixels with white set to alpha via GIMP
  public BasicParameter xPer = new BasicParameter("XPD",6000.0f,5000.0f,20000.0f);
  public BasicParameter yPer = new BasicParameter("YPD",6000,5000,20000);
  public BasicParameter lightningFreq = new BasicParameter("LFR",400,200,800);
  public BasicParameter lightningFreq2 = new BasicParameter("LFR",400,200,800);
  public SawLFO linenvx = new SawLFO(0.0f,1.0f,xPer);
  public SawLFO linenvy = new SawLFO(0.0f,1.0f,yPer);
  public Click lightningtrigger = new Click(lightningFreq);
  public Click lightningtrigger2 = new Click(lightningFreq2);
  public float add_to_xPer=0.0f;
  public float add_to_yPer=0.0f;
  public LightningBolt lb;
  public LightningBolt lb2;
  
  public BrainStorm(LX lx){
     super(lx);
     addModulator(linenvx).start();
     addModulator(linenvy).start();
     addModulator(lightningtrigger).start();
     addModulator(lightningtrigger2).start();
     addParameter(xPer);
     addParameter(yPer);
     addParameter(lightningFreq);
     addParameter(lightningFreq2);
     lb = new LightningBolt();
     lb2 = new LightningBolt();
  }
 
    
  class LightningBolt {
    public LinearEnvelope timeline = new LinearEnvelope(0,100,200);
    public List<LXPoint> boltpoints = new ArrayList<LXPoint>();
    public Node startNode;
    public Node endNode;
    public int boltlength;
    public Random randombool = new Random();
    public int bolthue = 65; //65 = yellow
    
    public LightningBolt(){
      addModulator(timeline).start();
      this.startNode = model.getRandomNode();
      while (this.startNode.ground) {
        this.startNode = model.getRandomNode();
      }
      Node prevNode = startNode.random_adjacent_node();
      Node currentNode = startNode;
      Node nextNode;
      while (!(currentNode.ground)) {
        nextNode=currentNode.random_adjacent_node();
        while (angleBetweenThreeNodes(prevNode,currentNode,nextNode)<(PI/4.0f)){
          nextNode=currentNode.random_adjacent_node();
        }
        List<LXPoint> addpoints=nodeToNodePoints(currentNode,nextNode);
        for (LXPoint p : addpoints){
          this.boltpoints.add(p);
        }
        prevNode=currentNode;
        currentNode=nextNode;
      }
      this.boltlength=boltpoints.size();
      this.endNode=currentNode;
    }
    
    public void run(double deltaMs){
      float phase=timeline.getValuef();
      if (phase<5){
        for (LXPoint p : model.points){
          addColor(p.index,lx.hsb(bolthue,20,20));
        }
      }
      if (phase<20){
        for (LXPoint p : startNode.adjacent_bar_points()){
          addColor(p.index,lx.hsb(bolthue,70,90));
        }
      }
      if (phase>20 && phase <70){
        int ptcount=0;
        for (LXPoint p : boltpoints){
          float pctthru=PApplet.parseFloat(ptcount)/PApplet.parseFloat(boltlength);
          if (pctthru<((phase-20)/50)){
            addColor(p.index,lx.hsb(bolthue,70,90));
          }
          ptcount+=1;
        }
      }
      if (phase>70 && phase <100){
        int ptcount=0;
        for (LXPoint p : boltpoints){
          float pctthru=PApplet.parseFloat(ptcount)/PApplet.parseFloat(boltlength);
          if (pctthru>((phase-70)/30)){
            addColor(p.index,lx.hsb(bolthue,70,90));
          }
          ptcount+=1;
        }
      }
    }
  }
  
  public void run(double deltaMs) {
    if (lightningtrigger.getValuef()==1){
        lightningFreq.setValue(random(100,1000));
      lb=new LightningBolt();
    }
    if (lightningtrigger2.getValuef()==1){
        lightningFreq2.setValue(random(100,1000));
      lb2=new LightningBolt();
    }
    if(linenvx.getValuef()<0.01f){
      add_to_xPer=random(-1000,1000);
      xPer.setValue(xPer.getValuef()+add_to_xPer);
    }
    if(linenvy.getValuef()<0.01f){
      add_to_yPer=random(-1000,1000);
      yPer.setValue(yPer.getValuef()+add_to_xPer);
    }
    colors=this.mentalimage.shiftedImageToPixels(colors,linenvx.getValuef(),linenvy.getValuef());
    lb.run(deltaMs);
    lb2.run(deltaMs);
  } 
}


/** ************************************************************** HEMISPHERES
 * Test of hemispheres functionality
 ************************************************************************* **/
class TestHemispheres extends BrainPattern {
  private final SinLFO xPos = new SinLFO(0, model.xMax, 4000);
  public TestHemispheres(LX lx) {
    super(lx);
    addModulator(xPos).trigger();
  }
  public void run(double deltaMs) {
    float hv = lx.getBaseHuef();
    int i = 0;
    int j = 0;
    Bar bar = model.barmap.get("FOG-LAW");
    Bar otherbar = model.barmap.get("LAW-OLD");;
    float x = bar.angle_with_bar(otherbar);
    for (String bb : model.barmap.keySet()){
      Bar b = model.barmap.get(bb);
      hv=200;
      if (b.left_right_mid.equals("left")){
        hv=100;
      }
      if (b.left_right_mid.equals("right")){
        hv=200;
      }
      if (b.left_right_mid.equals("mid")){
        hv=300;
      }
      
      for (LXPoint p : b.points) {
        colors[p.index] = lx.hsb(hv, 100, 100);
      }
    }
  }
}

 
 
/** ****************************************************** RAINBOW BARREL ROLL
 * A colored plane of light rotates around an axis
 ************************************************************************* **/
class RainbowBarrelRoll extends BrainPattern {
   float hoo;
   float anglemod = 0;
    
  public RainbowBarrelRoll(LX lx){
     super(lx);
  }
  
 public void run(double deltaMs) {
     anglemod=anglemod+1;
     if (anglemod > 360){
       anglemod = anglemod % 360;
     }
     
    for (LXPoint p: model.points) {
      //conveniently, hue is on a scale of 0-360
      hoo=((atan(p.x/p.z))*360/PI+anglemod);
      colors[p.index]=lx.hsb(hoo,80,100);
    }
  }
}

 
/** ************************************************************ CIRCLE BOUNCE
 * A plane bounces up and down the brain, making a circle of color.
 ************************************************************************** */
class CircleBounce extends LXPattern {
  
  private final BasicParameter bounceSpeed 
      = new BasicParameter("BNC",  1000, 0, 10000);
  private final BasicParameter colorSpread 
      = new BasicParameter("CLR", 0.0f, 0.0f, 360.0f);
  private final BasicParameter colorFade   
      = new BasicParameter("FADE", 1, 0.0f, 10.0f);

  public CircleBounce(LX lx) {
    super(lx);
    addParameter(bounceSpeed);
    addParameter(colorSpread);
    addParameter(colorFade);
    addLayer(new CircleLayer(lx));
  }

  public void run(double deltaMs) {}

  private class CircleLayer extends LXLayer {
    private final SinLFO xPeriod = new SinLFO(model.zMin, model.zMax, bounceSpeed);

    private CircleLayer(LX lx) {
      super(lx);
      addModulator(xPeriod).start();
    }

    public void run(double deltaMs) {
      float falloff = 5.0f / colorFade.getValuef();
      for (LXPoint p : model.points) {
        float distanceFromBrightness = abs(xPeriod.getValuef() - p.z);
        colors[p.index] = LXColor.hsb(
          lx.getBaseHuef() + colorSpread.getValuef(),
          100.0f,
          max(0.0f, 100.0f - falloff*distanceFromBrightness)
        );
      }
    }
  }
}

    
/** ************************************************************** PSYCHEDELIC
 * Colors entire brain in modulatable psychadelic color palettes
 * Demo pattern for GeneratorPalette.
 * @author scouras
 ************************************************************************** */
class Psychedelic extends BrainPattern {
 
  double ms = 0.0f;
  double offset = 0.0f;
  private final BasicParameter colorScheme = new BasicParameter("SCM", 0, 3);
  private final BasicParameter cycleSpeed = new BasicParameter("SPD",  50, 0, 200);
  private final BasicParameter colorSpread = new BasicParameter("LEN", 100, 0, 1000);
  private final BasicParameter colorHue = new BasicParameter("HUE",  0.f, 0.f, 359.f);
  private final BasicParameter colorSat = new BasicParameter("SAT", 80.f, 0.f, 100.f);
  private final BasicParameter colorBrt = new BasicParameter("BRT", 80.f, 0.f, 100.f);
  private GeneratorPalette gp = 
      new GeneratorPalette(
          new ColorOffset(0xDD0000).setHue(colorHue)
                                   .setSaturation(colorSat)
                                   .setBrightness(colorBrt),
          //GeneratorPalette.ColorScheme.Complementary,
          GeneratorPalette.ColorScheme.Monochromatic,
          //GeneratorPalette.ColorScheme.Triad,
          //GeneratorPalette.ColorScheme.Analogous,
          100
      );
  private int scheme = 0;
  //private EvolutionUC16 EV = EvolutionUC16.getEvolution(lx);

  public Psychedelic(LX lx) {
    super(lx);
    addParameter(colorScheme);
    addParameter(cycleSpeed);
    addParameter(colorSpread);
    addParameter(colorHue);
    addParameter(colorSat);
    addParameter(colorBrt);
    /*println("Did we find an EV? ");
    println(EV);
    EV.bindKnob(colorHue, 0);
    EV.bindKnob(colorSat, 8);
    EV.bindKnob(colorBrt, 7);
    */
  }
    
    public void run(double deltaMs) {
    int newScheme = (int)Math.floor(colorScheme.getValue());
    if ( newScheme != scheme) { 
      switch(newScheme) { 
        case 0: gp.setScheme(GeneratorPalette.ColorScheme.Analogous); break;
        case 1: gp.setScheme(GeneratorPalette.ColorScheme.Monochromatic); break;
        case 2: gp.setScheme(GeneratorPalette.ColorScheme.Triad); break;
        case 3: gp.setScheme(GeneratorPalette.ColorScheme.Complementary); break;
        }
      scheme = newScheme;
      }

    ms += deltaMs;
    offset += deltaMs*cycleSpeed.getValue()/1000.f;
    int steps = (int)colorSpread.getValue();
    if (steps != gp.steps) { 
      gp.setSteps(steps);
    }
    gp.reset((int)offset);
    for (LXPoint p : model.points) {
      colors[p.index] = gp.getColor();
    }
  }
}
  
    
/** ******************************************************* A HOLE IN MY BRAIN
 * Hackathon Entry
 * @author Codey Christensen
 ************************************************************************* **/
    
class AHoleInMyBrain extends BrainPattern {
   int b = 0;
   int s=100;
   float h=100;
   float otherColor = 40;
    
   int i = 0;
   int xpos = 50;
   int ypos = 100;
   int zpos = 45;
   
   private final BasicParameter colorChangeSpeed = new BasicParameter("CLR",  7000, 0, 8000);
   private final BasicParameter len = new BasicParameter("LEN",  220, 10, 225);
   private final BasicParameter changeSpeed = new BasicParameter("SPD",  1, 1, 10);
   private final BasicParameter holeSize = new BasicParameter("HOL",  50, 1, 1000);
    
   private final SinLFO whatColor = new SinLFO(0, 360, colorChangeSpeed);
   private final SinLFO sizeChange = new SinLFO(30, 600, 500);
   
  public AHoleInMyBrain(LX lx){
     super(lx);
     addParameter(colorChangeSpeed);
     addParameter(len);
     addParameter(changeSpeed);
     addParameter(holeSize);
     addModulator(whatColor).trigger();
     addModulator(sizeChange).trigger();
    }
    
    public void run(double deltaMs) {
   i = i + PApplet.parseInt(changeSpeed.getValuef());
   xpos = i % PApplet.parseInt(len.getValuef());
   ypos = (i % PApplet.parseInt(len.getValuef())) + PApplet.parseInt(holeSize.getValuef());
   
   //complimentary color
   otherColor = (whatColor.getValuef() + 180) % 360;
   
   for (LXPoint p : model.points) {
      if (p.x-model.xMin < xpos || p.x-model.xMin  > ypos) {
        b = 100;
      } else if (p.y-model.yMin < xpos || p.y-model.yMin  > ypos) {
        h = otherColor;
        b = 100;
      } else {
        b = 0;
        h = whatColor.getValuef();
      }
      colors[p.index]=lx.hsb(h,s,b);
    }
  }
}

/** ************************************************************ PIXIE PATTERN
 * Points of light that chase along the edges.
 *
 * More ideas for later:
 * - Scatter/gather (they swarm around one point, then fly by
 *   divergent paths to another point)
 * - Fireworks (explosion of them coming out of one point)
 * - Multiple colors (maybe just a few in a different color)
 *
 * @author Geoff Schmiddt
 ************************************************************************* **/
class PixiePattern extends BrainPattern {
  // How many pixies are zipping around.
  private final BasicParameter numPixies =
      new BasicParameter("NUM", 100, 0, 1000);
  // How fast each pixie moves, in pixels per second.
  private final BasicParameter speed =
      new BasicParameter("SPD", 60.0f, 10.0f, 1000.0f);
  // How long the trails persist. (Decay factor for the trails, each frame.)
  // XXX really should be scaled by frame time
  private final BasicParameter fade =
      new BasicParameter("FADE", 0.9f, 0.8f, .99f);
  // Brightness adjustment factor.
  private final BasicParameter brightness =
      new BasicParameter("BRIGHT", 1.0f, .25f, 2.0f);
  private final BasicParameter colorHue = new BasicParameter("HUE", 210, 0, 359.0f);
  private final BasicParameter colorSat = new BasicParameter("SAT", 63.0f, 0.0f, 100.0f);


  class Pixie {
    public Node fromNode, toNode;
    public double offset;
    public int kolor;

    public Pixie() {
    }
  }
  private ArrayList<Pixie> pixies = new ArrayList<Pixie>();

  public PixiePattern(LX lx) {
    super(lx);
    addParameter(numPixies);
    addParameter(fade);
    addParameter(speed);
    addParameter(brightness);
    addParameter(colorHue);
    addParameter(colorSat);

  }

  public void setPixieCount(int count) {
    //make sure all pixies are set to current color
    for (Pixie p : this.pixies) {
      p.kolor = lx.hsb(colorHue.getValuef(), colorSat.getValuef(), 100);
    }
      
    while (this.pixies.size() < count) {
      Pixie p = new Pixie();
      p.fromNode = model.getRandomNode();
      p.toNode = p.fromNode.random_adjacent_node();
      p.kolor = lx.hsb(colorHue.getValuef(), colorSat.getValuef(), 100);
      this.pixies.add(p);
    }
    if (this.pixies.size() > count) {
      this.pixies.subList(count, this.pixies.size()).clear();
    }
  } 

  public void run(double deltaMs) {
    this.setPixieCount(Math.round(numPixies.getValuef()));
    //    System.out.format("FRAME %.2f\n", deltaMs);
    float fadeRate = 0;
    float speedRate = 0;
    if (museActivated) {
      fadeRate = map(muse.getMellow(), 0.0f, 1.0f, (float)fade.range.min, (float)fade.range.max);
      speedRate = map(muse.getConcentration(), 0.0f, 1.0f, (float)20.0f, 300);
    }
    else {
      fadeRate = fade.getValuef();
      speedRate = speed.getValuef();
    }

    for (LXPoint p : model.points) {
     colors[p.index] =
         LXColor.scaleBrightness(colors[p.index], fadeRate);
    }

    for (Pixie p : this.pixies) {
      double drawOffset = p.offset;
      p.offset += (deltaMs / 1000.0f) * speedRate;
      //      System.out.format("from %.2f to %.2f\n", drawOffset, p.offset);

      while (drawOffset < p.offset) {
          //        System.out.format("at %.2f, going to %.2f\n", drawOffset, p.offset);
        List<LXPoint> points = nodeToNodePoints(p.fromNode, p.toNode);

        int index = (int)Math.floor(drawOffset);
        if (index >= points.size()) {
          Node oldFromNode = p.fromNode;
          p.fromNode = p.toNode;
          do {
            p.toNode = p.fromNode.random_adjacent_node();
          } while (angleBetweenThreeNodes(oldFromNode, p.fromNode, p.toNode)
                   < 4*PI/360*3); // don't go back the way we came
          drawOffset -= points.size();
          p.offset -= points.size();
          //          System.out.format("next edge\n");
          continue;
        }

        // How long, notionally, was the pixie at this pixel during
        // this frame? If we are moving at 100 pixels per second, say,
        // then timeHereMs will add up to 1/100th of a second for each
        // pixel in the pixie's path, possibly accumulated over
        // multiple frames.
        double end = Math.min(p.offset, Math.ceil(drawOffset + .000000001f));
        double timeHereMs = (end - drawOffset) /
            speedRate * 1000.0f;

        LXPoint here = points.get((int)Math.floor(drawOffset));
        //        System.out.format("%.2fms at offset %d\n", timeHereMs, (int)Math.floor(drawOffset));

        addColor(here.index,
                 LXColor.scaleBrightness(p.kolor,
                                         (float)timeHereMs / 1000.0f
                                         * speedRate
                                         * brightness.getValuef()));
        drawOffset = end;
      }
    }
  }
}

/** ******************************************************************* STROBE
 * Simple monochrome strobe light.
 * @author Geoff Schmidt
 ************************************************************************* **/

class StrobePattern extends BrainPattern {
  private final BasicParameter speed = new BasicParameter("SPD",  5000, 0, 10000);
  private final BasicParameter min = new BasicParameter("MIN",  60, 10, 500);
  private final BasicParameter max = new BasicParameter("MAX",  500, 0, 2000);
  private final SinLFO rate = new SinLFO(min, max, speed);
  private final SquareLFO strobe = new SquareLFO(0, 100, rate);

  private final BasicParameter saturation =
      new BasicParameter("SAT", 100, 0, 100);
  // hue rotation in cycles per minute
  private final BasicParameter hueSpeed = new BasicParameter("HUE", 15, 0, 120);
  private final LinearEnvelope hue = new LinearEnvelope(0, 360, 0);

  private boolean wasOn = false;
  private int latchedColor = 0;

  public StrobePattern(LX lx) {
    super(lx);
    addParameter(speed);
    addParameter(min);
    addParameter(max);
    addModulator(rate).start();
    addModulator(strobe).start();
    addParameter(saturation);
    addParameter(hueSpeed);
    hue.setLooping(true);
    addModulator(hue).start();
  }

  public void run(double deltaMs) {
    hue.setPeriod(60 * 1000 / (hueSpeed.getValuef() + .00000001f));

    boolean isOn = strobe.getValuef() > .5f;
    if (isOn && ! wasOn) {
      latchedColor =
        lx.hsb(hue.getValuef(), saturation.getValuef(), 100);
  }
  
    wasOn = isOn;
    int kolor = isOn? latchedColor : LXColor.BLACK;
    for (LXPoint p : model.points) {
      colors[p.index] = kolor;
    }
 }
}


/** ******************************************************************** MOIRE
 * Moire patterns, computed across the actual topology of the brain.
 *
 * Basically this is the classic demoscene Moire effect:
 * http://www.youtube.com/watch?v=XtCW-axRJV8&t=2m54s
 *
 * but distance is defined as the actual shortest path along the bars,
 * so the effect happens across the actual brain structure (rather
 * than a 2D plane).
 *
 * Potential improvements:
 * - Map to a nice color gradient, then run several of these in parallel
 *   (eg, 2 sets of 2 generators, each with a different palette)
 *   and mix the colors
 * - Make it more efficient so you can sustain full framerate even with
 *   higher numbers of generators
 *
 * @author Geoff Schmidt
 ************************************************************************* **/

class MovableDistanceField {
  private LXPoint origin;
  double width;
  int[] distanceField;
  SemiRandomWalk walk;

  public LXPoint getOrigin() {
    return origin;
  }

  public void setOrigin(LXPoint newOrigin) {
    origin = newOrigin;
    distanceField = distanceFieldFromPoint(origin);
    walk = new SemiRandomWalk(origin);
  }

  public void advanceOnWalk(double howFar) {
    origin = walk.step(howFar);
    distanceField = distanceFieldFromPoint(origin);
  }
};

class MoireManifoldPattern extends BrainPattern {
  // Stripe width (generator field periodicity), in pixels
  private final BasicParameter width = new BasicParameter("WID", 65, 500);
  // Rate of movement of generator centers, in pixels per second
  private final BasicParameter walkSpeed = new BasicParameter("SPD", 100, 1000);
  // Number of generators
  private final DiscreteParameter numGenerators =
      new DiscreteParameter("GEN", 2, 1, 8 + 1);
  // Number of generators that are smooth
  private final DiscreteParameter numSmooth =
      new DiscreteParameter("SMOOTH", 2, 0, 8 + 1);

  ArrayList<Generator> generators = new ArrayList<Generator>();

  class Generator extends MovableDistanceField {
    boolean smooth = false;

    public double contributionAtPoint(LXPoint where) {
      int dist = distanceField[where.index];
      double ramp = ((float)dist % (float)width) / (float)width;
      if (smooth) {
        return ramp;
      } else {
        return ramp < .5f ? 0.5f : 0.0f;
  }
      }
      }
      
  public MoireManifoldPattern(LX lx) {
    super(lx);
    addParameter(width);
    addParameter(walkSpeed);
    addParameter(numGenerators);
    addParameter(numSmooth);
    }
      
  public void setGeneratorCount(int count) {
    while (generators.size() < count) {
      Generator g = new Generator();
      g.setOrigin(model.getRandomPoint());
      generators.add(g);
    }
    if (generators.size() > count) {
      generators.subList(count, generators.size()).clear();
        }
      }
      
  public void run(double deltaMs) {
    setGeneratorCount(numGenerators.getValuei());
    numSmooth.setRange(0, numGenerators.getValuei() + 1);

    int i = 0;
    for (Generator g : generators) {
      g.width = width.getValuef();
      g.advanceOnWalk(deltaMs / 1000.0f * walkSpeed.getValuef());
      g.smooth = i < numSmooth.getValuei();
      i ++;
        }

    for (LXPoint p : model.points) {
      float sumField = 0;
      for (Generator g : generators) {
        sumField += g.contributionAtPoint(p);
      }

      sumField = (cos(sumField * 2 * PI) + 1)/2;
      colors[p.index] = lx.hsb(0.0f, 0.0f, sumField * 100);
    }
      
    /*
    for (Generator g : generators) {
      colors[g.getOrigin().index] = LXColor.RED;
    }
    */
  } 
}


/** *************************************************************** WAVE FRONT
 * Colorful splats that spread out across the topology of the brain
 * and wobble a bit as they go.
 *
 * Simple application of MovableDistanceField.
 *
 * Potential improvements:
 * - Nicer set of color gradients. Maybe 1D textures?
 *
 * Some nice settings (NUM/WSPD/GSPD/WID):
 * - 6, 170, 285, 190
 * - 1, 0, 85, 162.5
 * - 5, 110, 85, 7.5
 *
 * @author Geoff Schmidt
 ************************************************************************* **/

class WaveFrontPattern extends BrainPattern {
  // Number of splats
  private final DiscreteParameter numSplats =
      new DiscreteParameter("NUM", 4, 1, 10 + 1);
  // Rate at which splat center moves (pixels / sec)
  private final BasicParameter walkSpeed =
      new BasicParameter("WSPD", 70, 0, 1000);
  // Rate at which splats grow (pixels / sec)
  private final BasicParameter growSpeed =
      new BasicParameter("GSPD", 125, 0, 500);
  // Width of splat band (pixels)
  private final BasicParameter width =
      new BasicParameter("WID", 30, 0, 250);

  class Splat extends MovableDistanceField {
    double age; // seconds
    double size; // pixels
    double walkSpeed;
    double growSpeed;
    double width = 50;
    double baseHue;
    double hueWidth = 90; // degrees of hue covered by the band
    double timeSinceAnyUnreached = 0;
    double timeToReset = -1;

    Splat() {
      this.reset();
    }

    public void reset() {
      age = 0;
      size = 0;
      baseHue = (new Random()).nextDouble() * 360;
      timeSinceAnyUnreached = 0;
      timeToReset = -1;
      this.setOrigin(model.getRandomPoint());
    }

    public void advanceTime(double deltaMs) {
      age += deltaMs / 1000;
      timeSinceAnyUnreached += deltaMs / 1000;
      size += deltaMs / 1000 * growSpeed;
      this.advanceOnWalk(deltaMs / 1000.0f * walkSpeed);

      if (timeSinceAnyUnreached > .5f && timeToReset < 0) {
        // For the last half a second, we've been big enough to cover
        // the whole brain. Time to think about resetting. Do it at a
        // random point in the future such that we're active about 80%
        // of the time. This will help the resets of different splats
        // to stay spaced out rather than getting bunched up.
        timeToReset = age + age * (new Random()).nextDouble() * .25f;
      }

      if (timeToReset > 0 && age > timeToReset)
        // The planned reset time has come.
        reset();
    }

    public int colorAtPoint(LXPoint p) {
      double pixelsBehindFrontier = size - (double)distanceField[p.index];
      if (pixelsBehindFrontier < 0) {
        timeSinceAnyUnreached = 0;
        return LXColor.hsba(0, 0, 0, 0);
      } else {
        double positionInBand = 1.0f - pixelsBehindFrontier / width;
        if (positionInBand < 0.0f) {
          return LXColor.hsba(0, 0, 0, 0);
        } else {
            double hoo = baseHue + positionInBand * hueWidth;
    
            // return LXColor.hsba(hoo, Math.min((1 - positionInBand) * 250, 100), Math.min(100, 500 + positionInBand * 100), 1.0);
            return LXColor.hsba(hoo, 100, 100, 1.0f);
  }
      }
    }
      }

  ArrayList<Splat> splats = new ArrayList<Splat>();

  public WaveFrontPattern(LX lx) {
    super(lx);
    addParameter(numSplats);
    addParameter(walkSpeed);
    addParameter(growSpeed);
    addParameter(width);
    }

  public void setSplatCount(int count) {
    while (splats.size() < count) {
      splats.add(new Splat());
        }
    if (splats.size() > count) {
      splats.subList(count, splats.size()).clear();
      }
    }

  public void run(double deltaMs) {
    setSplatCount(numSplats.getValuei());
    for (Splat s : splats) {
      s.advanceTime(deltaMs);
      s.walkSpeed = walkSpeed.getValuef();
      s.growSpeed = growSpeed.getValuef();
      s.width = width.getValuef();
      }

    Random rand = new Random();
    for (LXPoint p : model.points) {
      int kolor = LXColor.BLACK;
      for (Splat s : splats) {
        kolor = LXColor.blend(kolor, s.colorAtPoint(p), LXColor.Blend.ADD);
      }
      colors[p.index] = kolor;
   }  
  }
}
 
/** *********************************************************** COLORED STATIC
 * MultiColored static, with black and white mode
 * @author: Codey Christensen
 ************************************************************************* **/
 
class ColorStatic extends BrainPattern {
 
  ArrayList<LXPoint> current_points = new ArrayList<LXPoint>();
  ArrayList<LXPoint> random_points = new ArrayList<LXPoint>();
 
  int i;
  int h;
  int s;
  int b;
 
  private final BasicParameter number_of_points = new BasicParameter("PIX",  340, 50, 1000);
  private final BasicParameter decay = new BasicParameter("DEC",  0, 5, 100);
  private final BasicParameter black_and_white = new BasicParameter("BNW",  0, 0, 1);
   
  private final BasicParameter color_change_speed = new BasicParameter("SPD",  205, 0, 360);
  private final SinLFO whatColor = new SinLFO(0, 360, color_change_speed);
    
  public ColorStatic(LX lx){
     super(lx);
     addParameter(number_of_points);
     addParameter(decay);
     addParameter(color_change_speed);
     addParameter(black_and_white);
     addModulator(whatColor).trigger();
  }
  
 public void run(double deltaMs) {
   i = i + 1;
     
   random_points = model.getRandomPoints(PApplet.parseInt(number_of_points.getValuef()));

   for (LXPoint p : random_points) {
      h = PApplet.parseInt(whatColor.getValuef());
      if(PApplet.parseInt(black_and_white.getValuef()) == 1) {
        s = 0;
      } else {
        s = 100;
 }
      b = 100;

      colors[p.index]=lx.hsb(h,s,b);
      current_points.add(p);
  }

   if(i % PApplet.parseInt(decay.getValuef()) == 0) {
     for (LXPoint p : current_points) {
        h = 0;
        s = 0;
        b = 0;

        colors[p.index]=lx.hsb(h,s,b);
    }
     current_points.clear();
    }
  }
}











class Scraper extends BrainPattern{
  private final LXProjection projection;
  int[] pixels;
  boolean didset=false;
  int[][] pixelstack;
  int[] offset;
  int h,w,d;
  float count=0;
  
  public Scraper(LX lx) {
    super(lx);
    w=320;
    h=240;
    d=1;
    projection = new LXProjection(model);
    pixelstack = new int[d][h*w];
    offset = new int[1];
    ScraperRunnable sr = new ScraperRunnable(pixelstack, offset, w, h, d);
    Thread srThread = new Thread(sr, "ScraperRunnable");
    srThread.start();
   }
   
  public void run(double deltaMs){
    /*if(ui!=null && !didset) {
       ui.setTheta(PI/2);
       didset=true;
    }*/


    float xr=0,xp=0,xt=0;
    int mode=1;
/*     projection.reset()
      // Swim around the world
     .rotate(2.0, 15.0, 15.0, 15.0)
     .translateCenter(0, 50, 0);*/
    for(LXVector p: projection){
      // should be optimized for normalized coords on point object
      float sx,sy,sz;
      sx=sy=sz=0;
      sx=p.x;
      sy=p.y;
      sz=p.z;
      sx-=model.xMin;
      sy-=model.yMin;
      sz-=model.zMin;
      sx/=(model.xMax-model.xMin);
      sy/=(model.yMax-model.yMin);
      sz/=(model.zMax-model.zMin);
      float tmp;
      switch(mode) {
        case 1:
          tmp=sx;
          sx=sy;
          sy=sz;
          sz=tmp;
          break;
        case 2:
          float dx = 0.5f-sx;
          float dy = 0.5f-sy;
          dx*=2;dy*=2;
          dx*=dx; 
          dy*=dy; 
          dx/=2;
          dy/=2;
          if(sx>0.5f) { dx=-dx; }
          if(sy>0.5f) { dy=-dy; }
          sx = 0.5f+dx;
          sy = 0.5f+dy;
          break;
      };
      /*xr = sqrt(sx*sx + sy*sy + sz*sz);
      xp = acos(sx/xr);
      xt = atan2(sx,sz);
      
      sx = xp/(PI/2);
      sy = xt/(PI/2);*/
      
      // CLAMP
      
      sx = max(sx, 0); sx=min(sx, 1);
      sy = max(sy, 0); sy=min(sy, 1);
      
      int ix = w-1-PApplet.parseInt(ceil(sx*(w-1)));
      int iy = h-1-PApplet.parseInt(ceil(sy*(h-1)));
      int iz = d-1-PApplet.parseInt(ceil(sz*(d-1)));
      synchronized(offset){
        iz+=offset[0];
        iz%=d;
        //iz=offset[0];
        colors[p.index] = pixelstack[iz][w*iy+ix];   
      }
    }    
  }
}    

class ScraperRunnable implements Runnable {
  int[][] pixelstack;
  int[] offset;
  float prev;
  DirectRobot dr;
  int w,h,d;
  public ScraperRunnable(int[][] p, int[] o, int xw, int xh, int xd){
    offset=o;
    w=xw;
    h=xh;
    d=xd;
    pixelstack=p;
    prev=0;
    try { dr = new DirectRobot(); } catch(Exception e) {}
  }
  public void run(){  
    while(true){
      float diff = millis()-prev;      
      if(diff>=1000/60){
        synchronized(offset){
         offset[0] = (offset[0]+1)%d;
         dr.getRGBPixels(20,20,w,h,pixelstack[offset[0]]);      
         prev=millis();
        }
      } else {
         delay(PApplet.parseInt(1000/60 - diff));
      }
    }
  }
}
  
class AutoOSC extends BrainPattern {
  OscP5 local_oscP5;
  public void oscEvent(OscMessage o){
    println(o);
  }
  public AutoOSC(LX lx) {
    super(lx);
    local_oscP5 = new OscP5(this,12000); 
  }
  public void run(double deltaMs){}
}

/*class PixelOSCListener extends BrainPattern {
  public PixelOSCListener(LX lx) {    
    super(lx);
  }
  public void run(double deltaMs){
    for(int i=0; i<colors.length; i++){
      colors[i] = oscColors[i];
    }  
  }
}*/

  

class DMK1 extends BrainPattern {
 
  OscP5 local_oscP5;  
  private final LXProjection projection;
  public void oscEvent(OscMessage o){
    if(o.checkAddrPattern("/multi/1")) {
      ox[0] = o.get(0).floatValue();
      oy[0] = o.get(1).floatValue();
    }      
    if(o.checkAddrPattern("/multi/2")) {
      ox[1] = o.get(0).floatValue();
      oy[1] = o.get(1).floatValue();
    }      
    if(o.checkAddrPattern("/multi/3")) {
      ox[2] = o.get(0).floatValue();
      oy[2] = o.get(1).floatValue();
    }      
    if(o.checkAddrPattern("/multi/4")) {
      ox[3] = o.get(0).floatValue();
      oy[3] = o.get(1).floatValue();
    }      
    if(o.checkAddrPattern("/multi/5")) {
      ox[4] = o.get(0).floatValue();
      oy[4] = o.get(1).floatValue();
    }      
    if(o.checkAddrPattern("/accelerometer")) {
      avgx=avgy=avgz=0;
      for(int i=1; i<30; i++){
        accx[i] = accx[i-1];
        accy[i] = accy[i-1];        
      }      
      accx[0] = o.get(0).floatValue();
      accy[0] = o.get(1).floatValue();
      maxx=maxy=-9999;
      minx=miny=9999;
      for(int i=0; i<30; i++){
        if(accx[i]<minx) { minx=accx[i]; }
        if(accy[i]<miny) { miny=accy[i]; }
        if(accx[i]>maxx) { maxx=accx[i]; }
        if(accx[i]>maxy) { maxy=accy[i]; }
        avgx+=accx[i];
        avgy+=accy[i];
      }
      avgx/=30;
      avgy/=30;
      float sx, sy;
      sx = accx[0];
      sy = accy[0];
      sx-=minx;
      sy-=miny;
      sx/=maxx-minx;
      sy/=maxy-miny;            
      ox[0] = sx;
      oy[0] = sy;
    }
    println("--");
    
  }
  float[] ox,oy,oz;
  float[] accx,accy,accz;
  float   avgx, avgy, avgz;
  float   minx, maxx, miny, maxy;
  
  float xFactor, yFactor, zFactor;

  public DMK1(LX lx) {
    super(lx);
    projection = new LXProjection(model);
    // OSC
    local_oscP5 = new OscP5(this,12000); 
    ox= new float[5];
    oy= new float[5];
    
    accx = new float[30];
    accy = new float[30];
    for(int i=0; i<30; i++){ accx[i]=0; accy[i]=0; }
    for(int i=0; i<5; i++){ ox[i]=0; oy[i]=0; }
  }
  public void run(double deltaMs){   
    float ax,ay;
    ax=ay=0;
    for (LXPoint p : model.points) {
      float sx=p.x;
      float sy=p.y;
      sx-=model.xMin;
      sy-=model.yMin;
      sx/=(model.xMax-model.xMin);
      sy/=(model.yMax-model.yMin);
      
      colors[p.index] = lx.hsb(0,0,0);
      if(abs(sx-ox[0])<0.1f && abs(sy-oy[0])<0.1f) { colors[p.index] = lx.hsb(0,100,100); }
      if(abs(sx-ox[1])<0.1f && abs(sy-oy[1])<0.1f) { colors[p.index] = lx.hsb(40,100,100); }
      if(abs(sx-ox[2])<0.1f && abs(sy-oy[2])<0.1f) { colors[p.index] = lx.hsb(80,100,100); }
      if(abs(sx-ox[3])<0.1f && abs(sy-oy[3])<0.1f) { colors[p.index] = lx.hsb(120,100,100); }
      if(abs(sx-ox[4])<0.1f && abs(sy-oy[4])<0.1f) { colors[p.index] = lx.hsb(160,100,100); }
      ax=p.x;
      ay=p.y;
    }    
  }
}
interface PresetListener {
  public void onPresetSelected(LXChannel channel, Preset preset);
  public void onPresetStored(LXChannel channel, Preset preset);
  public void onPresetDirty(LXChannel channel, Preset preset);
}

class PresetManager {
  
  public static final int NUM_PRESETS = 8;
  public static final String FILENAME = "data/presets.txt";
  public static final String DELIMITER = "\t";
  
  class ChannelState implements LXParameterListener {
    
    final LXChannel channel;
    LXPattern selectedPattern = null;    
    Preset selectedPreset = null;
    boolean isDirty = false;

    ChannelState(LXChannel channel) {
      this.channel = channel;
      channel.addListener(new LXChannel.AbstractListener() {
        public void patternDidChange(LXChannel channel, LXPattern pattern) {
          if (selectedPattern != pattern) {
            onDirty();
          }
        }
      });
    }

    private void onSelect(Preset preset, LXPattern pattern) {
      if ((selectedPattern != pattern) && (selectedPattern != null)) {
        for (LXParameter p : selectedPattern.getParameters()) {
          ((LXListenableParameter) p).removeListener(this);
        }
      }
      selectedPreset = preset;
      selectedPattern = pattern;
      isDirty = false;
      for (LXParameter p : pattern.getParameters()) {
        ((LXListenableParameter) p).addListener(this);
      }
      for (PresetListener listener : listeners) {
        listener.onPresetSelected(channel, preset);
      }
    }
    
    private void onStore(Preset preset, LXPattern pattern) {
      selectedPreset = preset;
      selectedPattern = pattern;
      isDirty = false;
      for (PresetListener listener : listeners) {
        listener.onPresetStored(channel, preset);
      }
    }
    
    private void onDirty() {
      if (selectedPreset != null) {
        isDirty = true;
        for (PresetListener listener : listeners) {
          listener.onPresetDirty(channel, selectedPreset);
        }
      }
    }
    
    public void onParameterChanged(LXParameter parameter) {
      onDirty();
    }
  }
  
  private final ChannelState[] channelState = new ChannelState[lx.engine.getChannels().size()];
  private final Preset[] presets = new Preset[NUM_PRESETS];
  private final List<PresetListener> listeners = new ArrayList<PresetListener>();
  
  PresetManager() {
    for (int i = 0; i < presets.length; ++i) {
      presets[i] = new Preset(this, i);
    }
    String[] values = loadStrings(FILENAME);
    if (values == null) {
      write();
    } else {
      int i = 0;
      for (String serialized : values) {
        presets[i++].load(serialized);
        if (i >= NUM_PRESETS) {
          break;
        }
      }
    }
    for (LXChannel channel : lx.engine.getChannels()) {
      channelState[channel.getIndex()] = new ChannelState(channel);
    }
  }
  
  public void addListener(PresetListener listener) {
    listeners.add(listener);
  }
  
  public void select(LXChannel channel, int index) {
    presets[index].select(channel);
  }

  public void store(LXChannel channel, int index) {
    presets[index].store(channel);
  }
  
  public void dirty(LXChannel channel) {
    channelState[channel.getIndex()].onDirty();
  }
  
  public void dirty(LXPattern pattern) {
    dirty(pattern.getChannel());
  }

  public void onStore(LXChannel channel, Preset preset, LXPattern pattern) {
    channelState[channel.getIndex()].onStore(preset, pattern);
  }
  
  public void onSelect(LXChannel channel, Preset preset, LXPattern pattern) {
    channelState[channel.getIndex()].onSelect(preset, pattern);
  }
    
  public void write() {
    String[] lines = new String[NUM_PRESETS];
    int i = 0;
    for (Preset preset : presets) {
      lines[i++] = preset.serialize(); 
    }
    saveStrings(FILENAME, lines);
  }
}

class Preset {
  
  final PresetManager manager;
  final int index;
  
  String className;
  final Map<String, Float> parameters = new HashMap<String, Float>();
  
  Preset(PresetManager manager, int index) {
    this.manager = manager;
    this.index = index;
  }
  
  public void load(String serialized) {
    className = null;
    parameters.clear();
    try {
      String[] parts = serialized.split(PresetManager.DELIMITER);
      className = parts[0];
      int i = 1;
      while (i < parts.length - 1) {
        parameters.put(parts[i], Float.parseFloat(parts[i+1]));
        i += 2;
      }
    } catch (Exception x) {
      className = null;
      parameters.clear();
    }
  }
  
  public String serialize() {
    if (className == null) {
      return "null";
    }
    String val = className + PresetManager.DELIMITER;
    for (String pKey : parameters.keySet()) {
      val += pKey + PresetManager.DELIMITER + parameters.get(pKey) + PresetManager.DELIMITER;
    }
    return val;
  }
  
  public void store(LXChannel channel) {
    LXPattern pattern = channel.getActivePattern();
    className = pattern.getClass().getName();
    parameters.clear();
    for (LXParameter p : pattern.getParameters()) {
      parameters.put(p.getLabel(), p.getValuef());
    }
//    if (pattern instanceof DPat) {
//      DPat dpattern = (DPat) pattern;
//      for (DBool bool : dpattern.bools) {
//        parameters.put(bool.tag, bool.b ? 1.f : 0.f);
//      }
//      for (Pick pick : dpattern.picks) {
//        parameters.put(pick.tag, pick.CurRow + pick.CurCol/100.f);
//      }
//    }
    manager.write();
    manager.onStore(channel, this, pattern);
  }
  
  public void select(LXChannel channel) {
    for (LXPattern pattern : channel.getPatterns()) {
      if (pattern.getClass().getName().equals(className)) {
        for (String pLabel : parameters.keySet()) {
          for (LXParameter p : pattern.getParameters()) {
            if (p.getLabel().equals(pLabel)) {
              p.setValue(parameters.get(pLabel));
            }
          }
//          if (pattern instanceof DPat) {
//            DPat dpattern = (DPat) pattern;
//            for (DBool bool : dpattern.bools) {
//              if (bool.tag.equals(pLabel)) {
//                bool.set(bool.row, bool.col, parameters.get(pLabel) > 0);
//              }
//            }
//            for (Pick pick : dpattern.picks) {
//              if (pick.tag.equals(pLabel)) {
//                float f = parameters.get(pLabel);
//                pick.set((int) floor(f), (int) round((f%1)*100.));
//              }
//            }
//          }
        }
        channel.goPattern(pattern);
//        if (pattern instanceof DPat) {
//          ((DPat)pattern).updateLights();
//        }
        manager.onSelect(channel, this, pattern);
        break;
      }
    }
  }
}

/**
 * Here's a simple extension of a camera component. This will be
 * rendered inside the camera view context. We just override the
 * onDraw method and invoke Processing drawing methods directly.
 */





/** ********************************************************* UIBrainComponent
 * Selects colors for each point based on patterns/transitions/channels. 
 * Sends that data to the pointCloud to actually draw it.
 ************************************************************************** */
class UIBrainComponent extends UI3dComponent {
 
  final UIPointCloudVBO pointCloud = new UIPointCloudVBO();
  
  public void onDraw(UI ui, PGraphics pg) {
    int[] simulationColors = lx.getColors();

    String displayMode = uiCrossfader.getDisplayMode();
    if (displayMode.equals("A")) {
      simulationColors = lx.engine.getChannel(LEFT_CHANNEL).getColors();
    } else if (displayMode.equals("B")) {
      simulationColors = lx.engine.getChannel(RIGHT_CHANNEL).getColors();
    }
    long simulationStart = System.nanoTime();
    if (simulationOn) {
      hint(ENABLE_DEPTH_TEST);
      drawSimulation(simulationColors);
      hint(DISABLE_DEPTH_TEST);
    }
    simulationNanos = System.nanoTime() - simulationStart;

    // translate(0,50,-400); //remove this if we're using whole brain
    //rotateX(PI*4.1); // this doesn't seem to do anything?
    camera(); 
    strokeWeight(1);
  }
  
  public void drawSimulation(int[] simulationColors) {
    noStroke();
    noFill();
    pointCloud.draw(simulationColors);
  }
}

// MJP: Kaminsky put this outside the class, why? How is this different than double global_brightness?
//BasicParameter brightness;

class UIBrainlove extends UIWindow {

  final BasicParameter g_brightness;

  UIBrainlove(float x, float y, float w, float h) {
    super(lx.ui, "BRIGHTNESS", x, y, w, h);
    g_brightness = new BasicParameter("BRIGHTNESS", 1.0f);
    g_brightness.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter parameter) {
        global_brightness = (float) parameter.getValuef();
      }
    });
    y= UIWindow.TITLE_LABEL_HEIGHT;
    new UISlider(4, UIWindow.TITLE_LABEL_HEIGHT, w-10, 20)
        .setParameter(g_brightness)
        .addToContainer(this);

    //y+=25 ;
    /*new UIButton(4, y, width-8, 20) {
       protected void onToggle(boolean enabled) {
          osc_send=enabled;
          if(!enabled) { global_sender=null; }
       }}
    .setLabel("Send Pixels")
    .addToContainer(this);*/

  }
  /*protected void onDraw(UI ui, PGraphics pg) {
    super.onDraw(ui, pg);
    pg.fill(#FFFFFF);
    pg.rect(0,0,width,height);
    redraw();
  }*/

}


/** ********************************************************** UIPointCloudVBO
 *
 ************************************************************************** */
class UIPointCloudVBO {

  PShader shader;
  FloatBuffer vertexData;
  int vertexBufferObjectName;
  
  UIPointCloudVBO() {
    // Load shader
    shader = loadShader("frag.glsl", "vert.glsl");
    // Create a buffer for vertex data
    vertexData = ByteBuffer
      .allocateDirect(model.points.size() * 7 * Float.SIZE/8)
      .order(ByteOrder.nativeOrder())
      .asFloatBuffer();
    
    // Put all the points into the buffer
    vertexData.rewind();
    for (LXPoint point : model.points) {
      // Each point has 7 floats, XYZRGBA
      vertexData.put(point.x);
      vertexData.put(point.y);
      vertexData.put(point.z);
      vertexData.put(0f);
      vertexData.put(0f);
      vertexData.put(0f);
      vertexData.put(1f);
    }
    vertexData.position(0);
    
    // Generate a buffer binding
    IntBuffer resultBuffer = ByteBuffer
      .allocateDirect(1 * Integer.SIZE/8)
      .order(ByteOrder.nativeOrder())
      .asIntBuffer();
    
    PGL pgl = beginPGL();
    pgl.genBuffers(1, resultBuffer); // Generates a buffer, places its id in resultBuffer[0]
    vertexBufferObjectName = resultBuffer.get(0); // Grab our buffer name
    endPGL();
  }
  
  public void draw(int[] colors) {
    // Put our new colors in the vertex data
    for (int i = 0; i < colors.length; ++i) {
      int c = colors[i];

      vertexData.put(7*i + 3, (0xff & (c >> 16)) / 255f); // R
      vertexData.put(7*i + 4, (0xff & (c >> 8)) / 255f); // G
      vertexData.put(7*i + 5, (0xff & (c)) / 255f); // B
    }
    
    PGL pgl = beginPGL();
    
    // Bind to our vertex buffer object, place the new color data
    pgl.bindBuffer(PGL.ARRAY_BUFFER, vertexBufferObjectName);
    pgl.bufferData(PGL.ARRAY_BUFFER, colors.length * 7 * Float.SIZE/8, vertexData, PGL.DYNAMIC_DRAW);
    
    shader.bind();
    int vertexLocation = pgl.getAttribLocation(shader.glProgram, "vertex");
    int colorLocation = pgl.getAttribLocation(shader.glProgram, "color");
    pgl.enableVertexAttribArray(vertexLocation);
    pgl.enableVertexAttribArray(colorLocation);
    pgl.vertexAttribPointer(vertexLocation, 3, PGL.FLOAT, false, 7 * Float.SIZE/8, 0);
    pgl.vertexAttribPointer(colorLocation, 4, PGL.FLOAT, false, 7 * Float.SIZE/8, 3 * Float.SIZE/8);
    javax.media.opengl.GL2 gl2 = (javax.media.opengl.GL2) ((PJOGL)pgl).gl;
    gl2.glPointSize(2);
    pgl.drawArrays(PGL.POINTS, 0, colors.length);
    pgl.disableVertexAttribArray(vertexLocation);
    pgl.disableVertexAttribArray(colorLocation);
    shader.unbind();
    
    pgl.bindBuffer(PGL.ARRAY_BUFFER, 0);
    endPGL();
  }
}


/** ********************************************************** UIEngineControl
 *
 ************************************************************************** */
class UIEngineControl extends UIWindow {
  
  final UIKnob fpsKnob;
  
  UIEngineControl(UI ui, float x, float y) {
    super(ui, "ENGINE", x, y, UIChannelControl.WIDTH, 96);
        
    y = UIWindow.TITLE_LABEL_HEIGHT;
    new UIButton(4, y, width-8, 20) {
      protected void onToggle(boolean enabled) {
        lx.engine.setThreaded(enabled);
        fpsKnob.setEnabled(enabled);
      }
    }
    .setActiveLabel("Multi-Threaded")
    .setInactiveLabel("Single-Threaded")
    .addToContainer(this);
    
    y += 24;
    fpsKnob = new UIKnob(4, y);    
    fpsKnob
    .setParameter(lx.engine.framesPerSecond)
    .setEnabled(lx.engine.isThreaded())
    .addToContainer(this);
  }
}


// class UIMuse extends UIWindow {
    
//   UIMuse(float x, float y, float w, float h) {
//     super(lx.ui, "MUSE", x, y, w, h);
//   }
//   protected void onDraw(UI ui, PGraphics pg) {
//     super.onDraw(ui, pg);
//     pg.fill(#FFFFFF);
//     pg.rect(0,24,width,height);
//     redraw();    
//   }
  
// }


/** ********************************************************** 
 * UIMuseControl
 ************************************************************************** */
class UIMuseControl extends UIWindow {
  // requires the MuseConnect and MuseHUD objects to be created on the global space
  private MuseConnect muse;
  private final static int WIDTH = 140;
  private final static int HEIGHT = 50;

  public UIMuseControl(UI ui, MuseConnect muse, float x, float y) {
    super(lx.ui, "MUSE CONTROL", x, y, WIDTH, HEIGHT);
    this.muse = muse;
    float yp = UIWindow.TITLE_LABEL_HEIGHT;

    final BooleanParameter bMuseActivated = new BooleanParameter("bMuseActivated");

    new UIButton(4, yp, WIDTH -8, 20)
      .setActiveLabel("Muse Activated")
      .setParameter(bMuseActivated)
      .setInactiveLabel("Muse Deactivated")
      .addToContainer(this);
    bMuseActivated.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter parameter) {
        museActivated = parameter.getValue() > 0.f;
      }
    });
    yp += 24;

  }

}

/** ********************************************************** 
 * UIMuseHUD
 ************************************************************************** */

public class UIMuseHUD extends UIWindow {
  private final static int WIDTH = 120;
  private final static int HEIGHT = 120;
  private final MuseHUD museHUD;

  public UIMuseHUD(UI ui, MuseHUD museHUD, float x, float y) {
    super(ui, "MUSE HUD", x, y, museHUD.WIDTH, museHUD.HEIGHT);
    this.museHUD = museHUD;
  }
  protected void onDraw(UI ui, PGraphics pg) {
    super.onDraw(ui, pg);
    museHUD.drawHUD(pg);
    // image(pg, mouseX-pg.width/2-VIEWPORT_WIDTH, mouseY-pg.height/2-VIEWPORT_HEIGHT);
    // pg.fill(#FFFFFF);
    // pg.rect(0,24,width,height);
    redraw();
  }
}

/** ********************************************************* UIComponentsDemo
 *
 ************************************************************************** */
/*
class UIComponentsDemo extends UIWindow {
  
  static final int NUM_KNOBS = 4; 
  final BasicParameter[] knobParameters = new BasicParameter[NUM_KNOBS];  
  
  UIComponentsDemo(UI ui, float x, float y) {
    super(ui, "UI COMPONENTS", x, y, 140, 10);
    
    for (int i = 0; i < knobParameters.length; ++i) {
      knobParameters[i] = new BasicParameter("Knb" + (i+1), i+1, 0, 4);
      knobParameters[i].addListener(new LXParameterListener() {
        public void onParameterChanged(LXParameter p) {
          println(p.getLabel() + " value:" + p.getValue());
        }
      });
    }
    
    y = UIWindow.TITLE_LABEL_HEIGHT;
    
    new UIButton(4, y, width-8, 20)
    .setLabel("Toggle Button")
    .addToContainer(this);
    y += 24;
    
    new UIButton(4, y, width-8, 20)
    .setActiveLabel("Boop!")
    .setInactiveLabel("Momentary Button")
    .setMomentary(true)
    .addToContainer(this);
    y += 24;
    
    for (int i = 0; i < 4; ++i) {
      new UIKnob(4 + i*34, y)
      .setParameter(knobParameters[i])
      .setEnabled(i % 2 == 0)
      .addToContainer(this);
    }
    y += 48;
    
    for (int i = 0; i < 4; ++i) {
      new UISlider(UISlider.Direction.VERTICAL, 4 + i*34, y, 30, 60)
      .setParameter(new BasicParameter("VSl" + i, (i+1)*.25))
      .setEnabled(i % 2 == 1)
      .addToContainer(this);
    }
    y += 64;
    
    for (int i = 0; i < 2; ++i) {
      new UISlider(4, y, width-8, 24)
      .setParameter(new BasicParameter("HSl" + i, (i + 1) * .25))
      .setEnabled(i % 2 == 0)
      .addToContainer(this);
      y += 28;
    }
    
    new UIToggleSet(4, y, width-8, 24)
    .setParameter(new DiscreteParameter("Ltrs", new String[] { "A", "B", "C", "D" }))
    .addToContainer(this);
    y += 28;
    
    for (int i = 0; i < 4; ++i) {
      new UIIntegerBox(4 + i*34, y, 30, 22)
      .setParameter(new DiscreteParameter("Dcrt", 10))
      .addToContainer(this);
    }
    y += 26;
    
    new UILabel(4, y, width-8, 24)
    .setLabel("This is just a label.")
    .setAlignment(CENTER, CENTER)
    .setBorderColor(ui.theme.getControlDisabledColor())
    .addToContainer(this);
    y += 28;
    
    setSize(width, y);
  }
} 
*/


/** ********************************************************** UIGlobalControl
 *
 ************************************************************************** */
class UIGlobalControl extends UIWindow {
  UIGlobalControl(UI ui, float x, float y) {
    super(ui, "GLOBAL", x, y, 140, 246);
    float yp = TITLE_LABEL_HEIGHT;
    final UIColorSwatch swatch = new UIColorSwatch(palette, 4, yp, width-8, 60) {
      protected void onDraw(UI ui, PGraphics pg) {
        super.onDraw(ui, pg);
        if (palette.hueMode.getValuei() == LXPalette.HUE_MODE_CYCLE) {
          palette.clr.hue.setValue(palette.getHue());
          redraw();
        }
      }
    };
    new UIKnob(4, yp).setParameter(palette.spread).addToContainer(this);
    new UIKnob(40, yp).setParameter(palette.center).addToContainer(this);
    
    final BooleanParameter hueCycle = new BooleanParameter("Cycle", palette.hueMode.getValuei() == LXPalette.HUE_MODE_CYCLE);
    new UISwitch(76, yp).setParameter(hueCycle).addToContainer(this);
    yp += 48;
    
    swatch.setEnabled(palette.hueMode.getValuei() == LXPalette.HUE_MODE_STATIC).setPosition(4, yp).addToContainer(this);
    yp += 64;
    
    hueCycle.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        palette.hueMode.setValue(hueCycle.isOn() ? LXPalette.HUE_MODE_CYCLE : LXPalette.HUE_MODE_STATIC);
      }
    });
    
    palette.hueMode.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        swatch.setEnabled(palette.hueMode.getValuei() == LXPalette.HUE_MODE_STATIC);
        hueCycle.setValue(palette.hueMode.getValuei() == LXPalette.HUE_MODE_CYCLE);
      }
    });
    
    new UISlider(3, yp, width-6, 30).setParameter(palette.zeriod).setLabel("Color Speed").addToContainer(this);
    yp += 58;
    new UISlider(3, yp, width-6, 30).setParameter(lx.engine.speed).setLabel("Speed").addToContainer(this);
  }
}
/**
 *     DOUBLE BLACK DIAMOND        DOUBLE BLACK DIAMOND
 *
 *         //\\   //\\                 //\\   //\\  
 *        ///\\\ ///\\\               ///\\\ ///\\\
 *        \\\/// \\\///               \\\/// \\\///
 *         \\//   \\//                 \\//   \\//
 *
 *        EXPERTS ONLY!!              EXPERTS ONLY!!
 *
 * Custom UI components using the framework.
 */




PFont labelFont = createFont("Arial", 12);

/** ************************************************************** UIBlendMode
 *
 ************************************************************************** */
class UIBlendMode extends UIWindow {
  public UIBlendMode(float x, float y, float w, float h) {
    super(lx.ui, "BLEND MODE", x, y, w, h);
    List<UIItemList.Item> items = new ArrayList<UIItemList.Item>();
    for (LXTransition t : transitions) {
      items.add(new TransitionItem(t));
    }
    final UIItemList tList;
    (tList = new UIItemList(1, UIWindow.TITLE_LABEL_HEIGHT, w-2, 60))
        .setItems(items)
        .addToContainer(this);

    lx.engine.getChannel(RIGHT_CHANNEL)
             .addListener(new LXChannel.AbstractListener() {
      public void faderTransitionDidChange(LXChannel channel, 
                                           LXTransition transition) {
        tList.redraw();
      }
    });
  }

  class TransitionItem extends UIItemList.AbstractItem {
    private final LXTransition transition;
    private final String label;
    
    TransitionItem(LXTransition transition) {
      this.transition = transition;
      this.label = className(transition, "Transition");
    }
    
    public String getLabel() {
      return label;
    }
    
    public boolean isSelected() {
      return this.transition == lx.engine
                                  .getChannel(RIGHT_CHANNEL)
                                  .getFaderTransition();
    }
    
    public boolean isPending() {
      return false;
    }
    
    public void onMousePressed() {
      lx.engine
        .getChannel(RIGHT_CHANNEL)
        .setFaderTransition(this.transition);
    }
  }

}


/** ************************************************************* UICrossfader
 *
 ************************************************************************** */
class UICrossfader extends UIWindow {
  
  private final UIToggleSet displayMode;
  
  public UICrossfader(float x, float y, float w, float h) {
    super(lx.ui, "CROSSFADER", x, y, w, h);

    new UISlider(4, UIWindow.TITLE_LABEL_HEIGHT, w-9, 32)
        .setParameter(lx.engine.getChannel(RIGHT_CHANNEL).getFader())
        .addToContainer(this);
    (displayMode = new UIToggleSet(4, UIWindow.TITLE_LABEL_HEIGHT + 36, w-9, 20))
        .setOptions(new String[] { "A", "COMP", "B" })
        .setValue("COMP")
        .addToContainer(this);
  }
  
  public UICrossfader setDisplayMode(String value) {
    displayMode.setValue(value);
    return this;
  }
  
  public String getDisplayMode() {
    return displayMode.getValue();
  }
}

/** ************************************************************* UICrossfader
 *
 ************************************************************************** */
class UIEffects extends UIWindow {
  UIEffects(float x, float y, float w, float h) {
    super(lx.ui, "FX", x, y, w, h);

    int yp = UIWindow.TITLE_LABEL_HEIGHT;
    List<UIItemList.Item> items = new ArrayList<UIItemList.Item>();
    int i = 0;
    for (LXEffect fx : effectsArr) {
      items.add(new FXScrollItem(fx, i++));
    }    
    final UIItemList effectsList = new UIItemList(1, yp, w-2, 60).setItems(items);
    effectsList.addToContainer(this);
    yp += effectsList.getHeight() + 10;
    
    final UIKnob[] parameterKnobs = new UIKnob[4];
    for (int ki = 0; ki < parameterKnobs.length; ++ki) {
      parameterKnobs[ki] = new UIKnob(5 + 34*(ki % 4), yp + (ki/4) * 48);
      parameterKnobs[ki].addToContainer(this);
    }
    
    LXParameterListener fxListener = new LXParameterListener() {
      public void onParameterChanged(LXParameter parameter) {
        int i = 0;
        for (LXParameter p : getSelectedEffect().getParameters()) {
          if (i >= parameterKnobs.length) {
            break;
          }
          if (p instanceof BasicParameter) {
            parameterKnobs[i++].setParameter((BasicParameter) p);
          }
        }
        while (i < parameterKnobs.length) {
          parameterKnobs[i++].setParameter(null);
        }
      }
    };
    
    selectedEffect.addListener(fxListener);
    fxListener.onParameterChanged(null);

  }
  
  class FXScrollItem extends UIItemList.AbstractItem {
    
    private final LXEffect effect;
    private final int index;
    private final String label;
    
    FXScrollItem(LXEffect effect, int index) {
      this.effect = effect;
      this.index = index;
      this.label = className(effect, "Effect");
    }
    
    public String getLabel() {
      return label;
    }
    
    public boolean isSelected() {
      return !effect.isEnabled() && (effect == getSelectedEffect());
    }
    
    public boolean isPending() {
      return effect.isEnabled();
    }
    
    public void onMousePressed() {
      if (effect == getSelectedEffect()) {
        if (effect.isMomentary()) {
          effect.enable();
        } else {
          effect.toggle();
        }
      } else {
        selectedEffect.setValue(index);
      }
    }
    
    public void onMouseReleased() {
      if (effect.isMomentary()) {
        effect.disable();
      }
    }

  }

}

/** ************************************************************* UICrossfader
 *
 ************************************************************************** */
class UITempo extends UIWindow {
  
  private final UIButton tempoButton;
  UIKnob tempoKnobFine;
  UIKnob tempoKnobCoarse;
  BasicParameter tempoAdjustFine;
  BasicParameter tempoAdjustCoarse;  
  
  UITempo(float x, float y, float w, float h) {
    super(lx.ui, "TEMPO", x, y, w, h);
  
    tempoButton = new UIButton(4, UIWindow.TITLE_LABEL_HEIGHT, w-75, 20) {
      protected void onToggle(boolean active) {
        if (active) {
          lx.tempo.tap();
        }
      }
    }.setMomentary(true);

    LXParameterListener tempoListener = new LXParameterListener() {
      public void onParameterChanged(LXParameter parameter) {
        if (parameter == tempoAdjustFine) {
          tempoKnobFine.setParameter(tempoAdjustFine);
        } else if (parameter == tempoAdjustCoarse) {
          tempoKnobCoarse.setParameter(tempoAdjustCoarse);
        }
      }
    };   
    
    tempoKnobFine = new UIKnob(w-65, UIWindow.TITLE_LABEL_HEIGHT-20);
    tempoKnobCoarse = new UIKnob(w-35, UIWindow.TITLE_LABEL_HEIGHT-20); 
    
    tempoAdjustFine = new BasicParameter("temF", 0, -3, 3); 
    tempoAdjustCoarse= new BasicParameter("temC", 0, 0, 300 ); 
    tempoAdjustFine.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter tempoAdjustFine)  {
       lx.tempo.adjustBpm(tempoAdjustFine.getValue());
      }
    });
    tempoAdjustCoarse.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter tempoAdjustCoarse)  {
        lx.tempo.setBpm(tempoAdjustCoarse.getValuef());
      }
    });
    tempoKnobFine.setParameter(tempoAdjustFine);
    tempoKnobCoarse.setParameter(tempoAdjustCoarse);
    tempoKnobFine.addToContainer(this); 
    tempoKnobCoarse.addToContainer(this);
    tempoButton.addToContainer(this);
    
    new UITempoBlipper(8, UIWindow.TITLE_LABEL_HEIGHT + 4, 12, 12).addToContainer(this);
  }
  
  class UITempoBlipper extends UI2dComponent {
    UITempoBlipper(float x, float y, float w, float h) {
      super(x, y, w, h);
    }
    
    public void onDraw(UI ui, PGraphics pg) {
      tempoButton.setLabel("" + ((int)(lx.tempo.bpm() * 10)) / 10.f);
    
      // Overlay tempo thing with openGL, redraw faster than button UI
      pg.fill(color(0, 0, 24 - 8*lx.tempo.rampf()));
      pg.noStroke();
      pg.rect(0, 0, width, height);           
      redraw();
    }
  }
  
}

/** ************************************************************** UIDebugText
 *
 ************************************************************************** */
class UIDebugText extends UI2dContext {
  
  private String line1 = "";
  private String line2 = "";
  
  UIDebugText(float x, float y, float w, float h) {
    super(lx.ui, x, y, w, h);
  }

  public UIDebugText setText(String line1) {
    return setText(line1, "");
  }
  
  public UIDebugText setText(String line1, String line2) {
    if (!line1.equals(this.line1) || !line2.equals(this.line2)) {
      this.line1 = line1;
      this.line2 = line2;
      setVisible(line1.length() + line2.length() > 0);
      redraw();
    }
    return this;
  }
  
  protected void onDraw(UI ui, PGraphics pg) {
    super.onDraw(ui, pg);
    if (line1.length() + line2.length() > 0) {
      pg.noStroke();
      pg.fill(0xff444444);
      pg.rect(0, 0, width, height);
      pg.textFont(ui.theme.getControlFont());
      pg.textSize(10);
      pg.textAlign(LEFT, TOP);
      pg.fill(0xffcccccc);
      pg.text(line1, 4, 4);
      pg.text(line2, 4, 24);
    }
  }
}

/** ****************************************************************** UISpeed
 *
 ************************************************************************** */
class UISpeed extends UIWindow {
  
  final BasicParameter speed;
  
  UISpeed(float x, float y, float w, float h) {
    super(lx.ui, "SPEED", x, y, w, h);
    speed = new BasicParameter("SPEED", 0.5f);
    speed.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter parameter) {
        lx.setSpeed(parameter.getValuef() * 2);
      }
    });
    new UISlider(4, UIWindow.TITLE_LABEL_HEIGHT, w-10, 20)
        .setParameter(speed)
        .addToContainer(this);
  }
}


public String className(Object p, String suffix) {
  String s = p.getClass().getName();
  int li;
  if ((li = s.lastIndexOf(".")) > 0) {
    s = s.substring(li + 1);
  }
  if (s.indexOf("SugarCubes$") == 0) {
    s = s.substring("SugarCubes$".length());
  }
  if ((suffix != null) && ((li = s.indexOf(suffix)) != -1)) {
    s = s.substring(0, li);
  }
  return s;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "DBLX" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
