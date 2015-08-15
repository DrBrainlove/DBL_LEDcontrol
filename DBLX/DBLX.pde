// Get all our imports out of the way
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
import processing.opengl.*;
import java.awt.Dimension;
import java.awt.Toolkit;
import rwmidi.*;


//set screen size
Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
final int VIEWPORT_WIDTH = 1200;
final int VIEWPORT_HEIGHT = 900;
static final int LEFT_CHANNEL = 0;
static final int RIGHT_CHANNEL = 1;

HueCyclePalette palette;

// Let's work in inches
final static int INCHES = 1;
final static int FEET = 12*INCHES;
float[] hsb = new float[3];

// Top-level, we have a model and a P2LX instance
P2LX              lx;
static Model             model;
LXPattern[]       patterns;
LXTransition[]    transitions;
//Effects           effects;
//LXEffect[]        effectsArr;
NerveBundle       nervebundle;

// PixelPusher objects
// NOTE: Uncomment these to enable PixelPusher
//PixelPusherObserver ppObserver;
//DeviceRegistry registry;

// Always draw FPS meter
int FPS_TARGET = 60;  
void drawFPS() {  
  fill(#999999);
  textSize(9);
  textAlign(LEFT, BASELINE);
  text("FPS: " + ((int) (frameRate*10)) / 10. + " / " + "60" + " (-/+)", 4, height-4);
}


//---------------- Patterns
LXPattern[] patterns(P2LX lx) {
  return new LXPattern[] {
    new ShowMappingPattern(lx),
    new ShowModulesPattern(lx),
    new BarLengthTestPattern(lx),
    new Psychedelic(lx),
    new VidPattern(lx),
    //new Swim(lx), # not displaying sugarcubes patterns
    new WaveFrontPattern(lx),
    //new MusicResponse(lx),
    new AVBrainPattern(lx),
    //new AHoleInMyBrain(lx),
    //had to comment out annaPattern because it wasn't working with the Playa_Brain subset - probably a specific node/bar thing.
    //She sent us a new finished version via email - TODO to add it back in and make it work! 
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
LXTransition[] transitions(P2LX lx) {
  return new LXTransition[] {
    new DissolveTransition(lx),
    new AddTransition(lx),
    new MultiplyTransition(lx),
    // TODO(mcslee): restore these blend modes in P2LX
    // new OverlayTransition(lx),
    // new DodgeTransition(lx),
    //new SwipeTransition(lx),
    //new FadeTransition(lx),
  };
};


//---------------- Effects
class Effects {
  FlashEffect flash = new FlashEffect(lx);
  SparkleEffect sparkle = new SparkleEffect(lx);
  
  Effects() {
  }
}  



/**
 * Set up models etc for whole package (Processing thing).
*/
void setup() {
  
  //set Processing color mode to HSB instead of RGB
  colorMode(HSB);
  
  //set screen size
  size(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, OPENGL);
  frame.setResizable(true);
  
  //not necessary, uncomment and play with it if the frame has issues
  //size((int)screenSize.getWidth(), (int)screenSize.getHeight(), OPENGL);
  //frame.setSize((int)screenSize.getWidth(), (int)screenSize.getHeight());
  
  //framerates
  frameRate(FPS_TARGET);
  noSmooth();
 

  // NOTE: Uncomment these to enable PixelPusher
  //Make a pixelpusher registry and observer
  //registry = new DeviceRegistry();
  //ppObserver = new PixelPusherObserver();
  //registry.addObserver(ppObserver);
  
 
  //==================================================================== Model 
  // Which bar selection to use. 
  // For the hackathon we're using the full_brain but there are a few others
  // for other reasons (single modules, reduced-bar-version, etc)
  //String bar_selection = "Module_14";
  // Brain we'll have lit on playa: Playa_Brain
  String bar_selection = "Playa_Brain";

  
  //Actually builds the model (per mappings.pde)
  model = buildTheBrain(bar_selection);
  
  // Initialize Node-Bar Connections in Model
  for (String barname : model.barmap.keySet()){
    Bar bar = model.barmap.get(barname);
    bar.initialize_model_connections();
  }
  for (String nodename : model.nodemap.keySet()){
    Node node = model.nodemap.get(nodename);
    node.initialize_model_connections();
  }
  for (String barname : model.barmap.keySet()){
    Bar bar = model.barmap.get(barname);
    bar.initialize_model_connections();
  }
  for (String nodename : model.nodemap.keySet()){
    Node node = model.nodemap.get(nodename);
    node.initialize_model_connections();
  }
  for (String barname : model.barmap.keySet()){
    Bar bar = model.barmap.get(barname);
    bar.initialize_model_connections();
  }
  for (String nodename : model.nodemap.keySet()){
    Node node = model.nodemap.get(nodename);
    node.initialize_model_connections();
  }
  model.setChannelMap();
  /* uncomment to check pixel indexes
  for (int i =0; i<48; i++){
     println(i);
    println(model.channelMap.get(i)); 
  }*/
  
  println("Total # pixels in model: " + model.points.size());
  
  //===================================================================== P2LX
  lx = new P2LX(this, model);
  lx.enableKeyboardTempo();
  
  //-------------- Engine
  println("Initializing LXEngine"); 
  LXEngine engine = lx.engine;
  engine.framesPerSecond.setValue(FPS_TARGET);
  engine.setThreaded(false);
  
  //-------------- Patterns
  engine.setPatterns(patterns = patterns(lx));
  //engine.setPatterns(patterns = _leftPatterns(lx));
  //engine.addChannel(_rightPatterns(lx));
  
  //-------------- Transitions
  //transitions = transitions(lx);
  //engine.getChannel(RIGHT_CHANNEL).setFaderTransition(transitions[0]); 
  lx.enableAutoTransition(120000);
  for (LXPattern pattern : patterns) {
    pattern.setTransition(new DissolveTransition(lx).setDuration(5000));
    //pattern.setTransition(new AddTransition(lx).setDuration(5000));
    //pattern.setTransition(new MultiplyTransition(lx).setDuration(5000));
  }
  
  //-------------- Effects
  //lx.addEffects(effectsArr = _effectsArray(effects = new Effects()));
  //selectedEffect = new DiscreteParameter("EFFECT", effectsArr.length);
  //logTime("Built effects");

  //-------------- Presets
  //presetManager = new PresetManager();
  //logTime("Loaded presets");

  //-------------- MIDI
  //midiEngine = new MidiEngine();
  //logTime("Setup MIDI devices");

  //-------------- Nerve Bundle
  nervebundle = new NerveBundle(lx);
 
  
  //-------------- Global Palette
  //println("Available Capture Devices: " + Capture.list());
  println("Initializing LXPalette"); 
  palette = new HueCyclePalette(lx);
  palette.hueMode.setValue(LXPalette.HUE_MODE_CYCLE);
  engine.getChannel(0).setPalette(palette);
  engine.addLoopTask(palette);


  //====================================================== 3D Simulation Layer
  //adjust this if you want to play with the initial camera setting.
  // A camera layer makes an OpenGL layer that we can easily 
  // pivot around with the mouse
  UI3dContext context = 
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
    .setRadius(40*FEET) // Distance
    .setTheta(PI) // look at front of model
    //.setPhi(PI/24)
    //.setRotateVelocity(12*PI) // broken?
    //.setRotateAcceleration(3*PI) // broken?
    
    // Let's add a point cloud of our animation points
    .addComponent(new UIBrainComponent())
    
    // And a custom UI object of our own
    // .addComponent(new UIWalls())
    ;
  lx.ui.addLayer(context);
 
 
  //=========================================================== 2D Control GUI 
  // A basic built-in 2-D control for a channel
  lx.ui.addLayer(new UIChannelControl(lx.ui, lx.engine.getChannel(0), 4, 4));
  lx.ui.addLayer(new UIEngineControl(lx.ui, 4, 326));
  lx.ui.addLayer(new UIComponentsDemo(lx.ui, width-144, 4));
  lx.ui.addLayer(new UIGlobalControl(lx.ui, width-288, 4));
  lx.ui.addLayer(new UICameraControl(lx.ui, context, 4, 450));

  //==================================================== Output to Controllers
  //-------------- PixelPusher
  //Make a pixelpusher registry and observer
  //registry = new DeviceRegistry();
  //ppObserver = new PixelPusherObserver();
  //registry.addObserver(ppObserver);
  //buildOutputs();
}


/**
 * Processing's draw loop.
*/
void draw() {
  // Wipe the frame...
  background(40);
  color[] sendColors = lx.getColors();  
  long gammaStart = System.nanoTime();
  
  drawFPS();
  //NOTE: Uncomment to enable PixelPusher
  //push_pixels(sendColors);



  // Comment out to COMMENT_OUT_PIXELPUSHER if push_pixels is uncommented (it's included in push_pixels)
  /*

  // Gamma correction here. Apply a cubic to the brightness
  // for better representation of dynamic range
  for (int i = 0; i < sendColors.length; ++i) {
    LXColor.RGBtoHSB(sendColors[i], hsb);
    float b = hsb[2];
    sendColors[i] = lx.hsb(360.*hsb[0], 100.*hsb[1], 100.*(b*b*b));
  }

  */

  // ...and everything else is handled by P2LX!
}



/** ************************************************************ BRAIN PATTERN
 * Creates a custom pattern class for writing patterns onto the brain model 
 * Don't modify unless you know what you're doing.
 ************************************************************************* **/
//private static ArrayList<BrainPattern> patterns = new ArrayList<BrainPattern>();
public static abstract class BrainPattern extends LXPattern {
  protected Model model;
  public static boolean visible = true;
  
  protected BrainPattern(LX lx) {
    super(lx);
    println("Initializing BrainPalette: " + this.getClass().getName());
    this.model = (Model) lx.model;
    // auto-register visible patterns to the global list
    //if (visible) { patterns.add(this); }
  }
}
