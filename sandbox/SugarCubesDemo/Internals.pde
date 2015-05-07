/**
 *     DOUBLE BLACK DIAMOND        DOUBLE BLACK DIAMOND
 *
 *         //\\   //\\                 //\\   //\\  
 *        ///\\\ ///\\\               ///\\\ ///\\\
 *        \\\/// \\\///               \\\/// \\\///
 *         \\//   \\//                 \\//   \\//H
 *
 *        EXPERTS ONLY!!              EXPERTS ONLY!!
 *
 * If you are an artist, you may ignore this file! It just sets
 * up the framework to run the patterns. Should not need modification
 * for general animation work.
 */

import heronarts.lx.*;
import heronarts.lx.audio.*;
import heronarts.lx.effect.*;
import heronarts.lx.model.*;
import heronarts.lx.modulator.*;
import heronarts.lx.parameter.*;
import heronarts.lx.pattern.*;
import heronarts.lx.transform.*;
import heronarts.lx.transition.*;
import heronarts.p2lx.*;
import heronarts.p2lx.ui.*;
import heronarts.p2lx.ui.component.*;
import heronarts.p2lx.ui.control.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.opengl.*;
import rwmidi.*;
import java.lang.reflect.*;
import java.net.*;
import java.util.*;

static final int VIEWPORT_WIDTH = 900;
static final int VIEWPORT_HEIGHT = 700;

static final int LEFT_CHANNEL = 0;
static final int RIGHT_CHANNEL = 1;

// The trailer is measured from the outside of the black metal (but not including the higher welded part on the front)
static final float TRAILER_WIDTH = 192;
static final float TRAILER_DEPTH = 192;
static final float TRAILER_HEIGHT = 33;

int targetFramerate = 60;
int startMillis, lastMillis;

// Core engine variables
P2LX              lx;
Model             model;
LXPattern[]       patterns;
LXTransition[]    transitions;
Effects           effects;
LXEffect[]        effectsArr;
DiscreteParameter selectedEffect;
MappingTool       mappingTool;
PresetManager     presetManager;
MidiEngine        midiEngine;

// Display configuration mode
boolean mappingMode    = false;
boolean debugMode      = false;
boolean simulationOn   = true ;
boolean structureOn    = false;
boolean diagnosticsOn  = false;
boolean drawTrailer    = false;
LXPattern restoreToPattern = null;
PImage logo;
float[] hsb = new float[3];

// Handles to UI objects
UIChannelControl uiPatternA;
UICrossfader uiCrossfader;
UIMidi uiMidi;
UIMapping uiMapping;
UIDebugText uiDebugText;
UISpeed uiSpeed;
UITempo uiTempo; 
/**
 * Engine construction and initialization.
 */

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

void logTime(String evt) {
  int now = millis();
  println(evt + ": " + (now - lastMillis) + "ms");
  lastMillis = now;
}

void setup() {
  startMillis = lastMillis = millis();

  // Initialize the Processing graphics environment
  size(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, OPENGL);
  frame.setResizable(true);
  frameRate(targetFramerate);
  noSmooth();
  logTime("Created viewport");

  // Create the model
  model = buildModel();
  logTime("Built Model");
  println("# of cubes: "+ model.cubes.size());
  
  // LX engine
  lx = new P2LX(this, model);
  lx.enableKeyboardTempo();
  logTime("Built LX engine");
    
  // Set the patterns
  LXEngine engine = lx.engine;
  engine.setPatterns(patterns = _leftPatterns(lx));
  engine.addChannel(_rightPatterns(lx));
  logTime("Built patterns");

  // Transitions
  transitions = transitions(lx);
  lx.engine.getChannel(RIGHT_CHANNEL).setFaderTransition(transitions[0]);
  logTime("Built transitions");
  
  // Effects
  lx.addEffects(effectsArr = _effectsArray(effects = new Effects()));
  selectedEffect = new DiscreteParameter("EFFECT", effectsArr.length);
  logTime("Built effects");

  // Preset manager
  presetManager = new PresetManager();
  logTime("Loaded presets");

  // MIDI devices
  midiEngine = new MidiEngine();
  logTime("Setup MIDI devices");

  buildOutputs();
  logTime("Built Outputs");
  
  // Mapping tool
  mappingTool = new MappingTool(lx);
  logTime("Built Mapping Tool");
  
  // 3D camera layer
  lx.ui.addLayer(
    // Camera layer
    new UI3dContext(lx.ui)
      .setCenter(model.cx, model.cy, model.cz)
      .setRadius(290).addComponent(new UICubesComponent())
  );
  
  // Build overlay UI
  UI2dContext[] layers = new UI2dContext[] {
    
    // Left controls
    uiPatternA = new UIChannelControl(lx.ui, lx.engine.getChannel(LEFT_CHANNEL), "PATTERN A", 16, 4, 4),
    new UIEffects(4, 374, 140, 144),
    uiTempo = new UITempo(4, 522, 140, 50),
    uiSpeed = new UISpeed(4, 576, 140, 50),
        
    // Right controls
    new UIChannelControl(lx.ui, lx.engine.getChannel(RIGHT_CHANNEL), "PATTERN B", 16, width-144, 4),
    uiMidi = new UIMidi(midiEngine, width-144, 374, 140, 158),
    new UIOutput(width-144, 536, 140, 106),
    
    // Crossfader
    uiCrossfader = new UICrossfader(width/2-130, height-90, 180, 86),
    new UIBlendMode(width/2+54, height-90, 140, 86),
    
    // Overlays
    uiDebugText = new UIDebugText(148, height-138, width-304, 44),
    uiMapping = new UIMapping(mappingTool, 4, 4, 140, 324)
  };
  uiMapping.setVisible(false);  
  for (UI2dContext layer : layers) {
    lx.ui.addLayer(layer);
  }
  logTime("Built UI");

  // Load logo image
  logo = loadImage("data/logo.png");
  logTime("Loaded logo image");
  println("Total setup: " + (millis() - startMillis) + "ms");
  
  lx.engine.framesPerSecond.setValue(60);
  lx.engine.setThreaded(false);
}

public SCPattern getPattern() {
  return (SCPattern) lx.getPattern();
}	

/**
 * Subclass of LXPattern specific to sugar cubes. These patterns
 * get access to the state and geometry, and have some
 * little helpers for interacting with the model.
 */
public static abstract class SCPattern extends LXPattern {
		
  protected Model model;
  
  protected SCPattern(LX lx) {
    super(lx);
    this.model = (Model) lx.model;
  }
	
  /**
   * Reset this pattern to its default state.
   */
  public final void reset() {
    for (LXParameter parameter : getParameters()) {
      parameter.reset();
    }
    onReset();
  }
	
  /**
   * Subclasses may override to add additional reset functionality.
   */
  protected /*abstract*/ void onReset() {}
	
  /**
   * Invoked by the engine when a grid controller button press occurs
   * 
   * @param row Row index on the gird
   * @param col Column index on the grid
   * @return True if the event was consumed, false otherwise
   */
  public boolean gridPressed(int row, int col) {
    return false;
  }
	
  /**
   * Invoked by the engine when a grid controller button release occurs
   * 
   * @param row Row index on the gird
   * @param col Column index on the grid
   * @return True if the event was consumed, false otherwise
   */
  public boolean gridReleased(int row, int col) {
    return false;
  }
	
  /**
   * Invoked by engine when this pattern is focused an a midi note is received.  
   * 
   * @param note
   * @return True if the pattern has consumed this note, false if the top-level
   *         may handle it
   */
  public boolean noteOn(rwmidi.Note note) {
    return false;
  }
	
  /**
   * Invoked by engine when this pattern is focused an a midi note off is received.  
   * 
   * @param note
   * @return True if the pattern has consumed this note, false if the top-level
   *         may handle it
   */
  public boolean noteOff(rwmidi.Note note) {
    return false;
  }
	
  /**
   * Invoked by engine when this pattern is focused an a controller is received  
   * 
   * @param note
   * @return True if the pattern has consumed this controller, false if the top-level
   *         may handle it
   */
  public boolean controllerChange(rwmidi.Controller controller) {
    return false;
  }
}

long simulationNanos = 0;

/**
 * Core render loop and drawing functionality.
 */
void draw() {
  long drawStart = System.nanoTime();
  
  // Set background
  background(40);
  
  // Send colors
  color[] sendColors = lx.getColors();  
  long gammaStart = System.nanoTime();
  // Gamma correction here. Apply a cubic to the brightness
  // for better representation of dynamic range
  for (int i = 0; i < sendColors.length; ++i) {
    LXColor.RGBtoHSB(sendColors[i], hsb);
    float b = hsb[2];
    sendColors[i] = lx.hsb(360.*hsb[0], 100.*hsb[1], 100.*(b*b*b));
  }
  long gammaNanos = System.nanoTime() - gammaStart;

  // Always draw FPS meter
  drawFPS();

  // TODO(mcslee): fix
  long drawNanos = System.nanoTime() - drawStart;
  long uiNanos = 0;

  if (diagnosticsOn) {
    drawDiagnostics(drawNanos, simulationNanos, uiNanos, gammaNanos);
  }  
}

void drawDiagnostics(long drawNanos, long simulationNanos, long uiNanos, long gammaNanos) {
  float ws = 4 / 1000000.;
  int thirtyfps = 1000000000 / 30;
  int sixtyfps = 1000000000 / 60;
  int x = width - 138;
  int y = height - 14;
  int h = 10;
  noFill();
  stroke(#999999);
  rect(x, y, thirtyfps * ws, h);
  noStroke();
  int xp = x;
  float hv = 0;
  for (long val : new long[] {lx.timer.drawNanos, simulationNanos, uiNanos, gammaNanos, lx.engine.timer.outputNanos }) {
    fill(lx.hsb(hv % 360, 100, 80));
    rect(xp, y, val * ws, h-1);
    hv += 140;
    xp += val * ws;
  }
  noFill();
  stroke(#333333);
  line(x+sixtyfps*ws, y+1, x+sixtyfps*ws, y+h-1);
  
  y = y - 14;
  xp = x;
  float tw = thirtyfps * ws;
  noFill();
  stroke(#999999);
  rect(x, y, tw, h);
  h = 5;
  noStroke();
  for (long val : new long[] {
    lx.engine.timer.channelNanos,
    lx.engine.timer.copyNanos,
    lx.engine.timer.fxNanos}) {
    float amt = val / (float) lx.timer.drawNanos;
    fill(lx.hsb(hv % 360, 100, 80));
    rect(xp, y, amt * tw, h-1);
    hv += 140;
    xp += amt * tw;
  }
  
  xp = x;
  y += h;
  hv = 120;
  for (long val : new long[] {
    lx.engine.getChannel(0).timer.loopNanos,
    lx.engine.getChannel(1).timer.loopNanos,
    lx.engine.getChannel(1).getFaderTransition().timer.blendNanos}) {
    float amt = val / (float) lx.timer.drawNanos;
    fill(lx.hsb(hv % 360, 100, 80));
    rect(xp, y, amt * tw, h-1);
    hv += 140;
    xp += amt * tw;
  }
}

void drawFPS() {  
  // Always draw FPS meter
  fill(#555555);
  textSize(9);
  textAlign(LEFT, BASELINE);
  text("FPS: " + ((int) (frameRate*10)) / 10. + " / " + targetFramerate + " (-/+)", 4, height-4);
}


/**
 * Top-level keyboard event handling
 */
void keyPressed() {
  if (mappingMode) {
    mappingTool.keyPressed(uiMapping);
  }
  switch (key) {
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
      if (!midiEngine.isQwertyEnabled()) {
        presetManager.select(lx.engine.getFocusedChannel(), key - '1');
      }
      break;
    
    case '!':
      if (!midiEngine.isQwertyEnabled()) presetManager.store(lx.engine.getFocusedChannel(), 0);
      break;
    case '@':
      if (!midiEngine.isQwertyEnabled()) presetManager.store(lx.engine.getFocusedChannel(), 1);
      break;
    case '#':
      if (!midiEngine.isQwertyEnabled()) presetManager.store(lx.engine.getFocusedChannel(), 2);
      break;
    case '$':
      if (!midiEngine.isQwertyEnabled()) presetManager.store(lx.engine.getFocusedChannel(), 3);
      break;
    case '%':
      if (!midiEngine.isQwertyEnabled()) presetManager.store(lx.engine.getFocusedChannel(), 4);
      break;
    case '^':
      if (!midiEngine.isQwertyEnabled()) presetManager.store(lx.engine.getFocusedChannel(), 5);
      break;
    case '&':
      if (!midiEngine.isQwertyEnabled()) presetManager.store(lx.engine.getFocusedChannel(), 6);
      break;
    case '*':
      if (!midiEngine.isQwertyEnabled()) presetManager.store(lx.engine.getFocusedChannel(), 7);
      break;
      
    case '-':
    case '_':
      frameRate(--targetFramerate);
      break;
    case '=':
    case '+':
      frameRate(++targetFramerate);
      break; 
    case 'b':
      effects.boom.trigger();
      break;    
    case 'd':
      if (!midiEngine.isQwertyEnabled()) {
        debugMode = !debugMode;
        println("Debug output: " + (debugMode ? "ON" : "OFF"));
      }
      break;
    case 'm':
      if (!midiEngine.isQwertyEnabled()) {
        mappingMode = !mappingMode;
        uiPatternA.setVisible(!mappingMode);
        uiMapping.setVisible(mappingMode);
        if (mappingMode) {
          restoreToPattern = lx.getPattern();
          lx.setPatterns(new LXPattern[] { mappingTool });
        } else {
          lx.setPatterns(patterns);
          LXTransition pop = restoreToPattern.getTransition();
          restoreToPattern.setTransition(null);
          lx.goPattern(restoreToPattern);
          restoreToPattern.setTransition(pop);
        }
      }
      break;
    case 't':
      if (!midiEngine.isQwertyEnabled()) {
        lx.engine.setThreaded(!lx.engine.isThreaded());
      }
      break;
    case 'q':
      if (!midiEngine.isQwertyEnabled()) {
        diagnosticsOn = !diagnosticsOn;
      }
      break;
    case 's':
      if (!midiEngine.isQwertyEnabled()) {
        simulationOn = !simulationOn;
      }
      break;
    case 'S':
      if (!midiEngine.isQwertyEnabled()) {
        structureOn = !structureOn;
      }
      break;
  }
}

