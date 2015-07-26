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



//set screen size
Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
final int VIEWPORT_WIDTH = 1200;
final int VIEWPORT_HEIGHT = 900;

HueCyclePalette palette;

// Let's work in inches
final static int INCHES = 1;
final static int FEET = 12*INCHES;
float[] hsb = new float[3];

// Top-level, we have a model and a P2LX instance
static Model model;
P2LX lx;

// Target frame rate
int FPS_TARGET = 60;  



  // Always draw FPS meter
void drawFPS() {  
  fill(#999999);
  textSize(9);
  textAlign(LEFT, BASELINE);
  text("FPS: " + ((int) (frameRate*10)) / 10. + " / " + "60" + " (-/+)", 4, height-4);
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
 
  //==================================================================== Model 
  // Which bar selection to use. 
  // For the hackathon we're using the full_brain but there are a few others
  // for other reasons (single modules, reduced-bar-version, etc)
  String bar_selection = "Full_Brain";

  
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
  println("Total # pixels in model: " + model.points.size());
  
  //=================================================== Create the P2LX Engine
  lx = new P2LX(this, model);
  lx.enableKeyboardTempo(); 
  
  LXEngine engine = lx.engine;
  lx.engine.framesPerSecond.setValue(FPS_TARGET);
  lx.engine.setThreaded(false);
  
  palette = new HueCyclePalette(lx);
  palette.hueMode.setValue(LXPalette.HUE_MODE_CYCLE);
  engine.getChannel(0).setPalette(palette);
  engine.addLoopTask(palette);

  //========================================================= SET THE PATTERNS
  engine.setPatterns(new LXPattern[] {
    new AVBrainPattern(lx),
    new AHoleInMyBrain(lx),
    new annaPattern(lx),
    new RangersPattern(lx),
    new Voronoi(lx),
    new Serpents(lx),
    new Brainstorm(lx),
    new PixiePattern(lx),
    new MoireManifoldPattern(lx),
    new StrobePattern(lx),
    new AHoleInMyBrain(lx),
    new TestImagePattern(lx),
    new HelloWorldPattern(lx),
    new PaletteDemo(lx),
    new GradientPattern(lx),
    new TestHuePattern(lx),
    new TestHemispheres(lx),
    new RandomBarFades(lx),
    new RainbowBarrelRoll(lx),
    new EQTesting(lx),
    new LayerDemoPattern(lx),
    new CircleBounce(lx),
    new SampleNodeTraversalWithFade(lx),
    new SampleNodeTraversal(lx),
    new TestXPattern(lx),
    new IteratorTestPattern(lx),
    new TestBarPattern(lx),
  });
  println("Initialized patterns");


  //================================================================= Build UI
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
  
    // Let's look at the center of our model
    //.setCenter(5,5,5)
    
    // Let's position our eye some distance away
    .setRadius(40*FEET)
      
    // Spin around so we're looking at the top of the brain
    .setTheta(PI)
    //.setPhi(PI/24)
      
    //.setRotateVelocity(12*PI)
    //.setRotateAcceleration(3*PI)
      
    // Let's add a point cloud of our animation points
    .addComponent(new UIBrainComponent())
      
    // And a custom UI object of our own
    // .addComponent(new UIWalls())
    ;
  lx.ui.addLayer(context);
  
  // A basic built-in 2-D control for a channel
  lx.ui.addLayer(new UIChannelControl(lx.ui, lx.engine.getChannel(0), 4, 4));
  lx.ui.addLayer(new UIEngineControl(lx.ui, 4, 326));
  lx.ui.addLayer(new UIComponentsDemo(lx.ui, width-144, 4));
  lx.ui.addLayer(new UIGlobalControl(lx.ui, width-144, 4));

  lx.ui.addLayer(new UICameraControl(lx.ui, context, 4, 450));

  // output to controllers
  // buildOutputs();

  lx.engine.framesPerSecond.setValue(FPS_TARGET);
  lx.engine.setThreaded(false);
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

  // Gamma correction here. Apply a cubic to the brightness
  // for better representation of dynamic range
  for (int i = 0; i < sendColors.length; ++i) {
    LXColor.RGBtoHSB(sendColors[i], hsb);
    float b = hsb[2];
    sendColors[i] = lx.hsb(360.*hsb[0], 100.*hsb[1], 100.*(b*b*b));
  }

  // ...and everything else is handled by P2LX!
}



/**
 * Creates a custom pattern class for writing patterns onto the brain model 
 * Don't modify unless you know what you're doing.
*/
public static abstract class BrainPattern extends LXPattern {
  protected Model model;
  
  protected BrainPattern(LX lx) {
    super(lx);
    this.model = (Model) lx.model;
  }
}
