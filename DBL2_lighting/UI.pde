/**
 * Here's a simple extension of a camera component. This will be
 * rendered inside the camera view context. We just override the
 * onDraw method and invoke Processing drawing methods directly.
 */

import java.nio.*;
import java.util.Arrays;


//Commented out - install Muse dependencies and uncomment to use Muse headset
//class MuseHUD {
  /*
  * Displays the connection quality and battery of a Muse headset.
  * Currently doesnt apppear on the screen, should eventually dynamically
  * adjust position to be in lower left corner
  * This is using Processing primitives, not the LX framework for a UI. 
  * Could definitely use a revamp
  */

/*Commented out - install Muse dependencies and uncomment to use Muse headset


  PGraphics museHUD;
  // colors for muse horseshoe HUD
  color morange = color(204,102,0);
  color mgreen = color(102, 204, 0);
  color mblue = color(0, 102, 204);
  color mred = color(204, 0, 102);
  color morangel = color(233, 187, 142);
  color mgreenl = color(187, 233, 142);
  color mbluel = color(142, 187, 233);
  color mredl = color(233, 142, 187);
  public MuseHUD() {
     museHUD = createGraphics(100, 100);
  }
  
  void drawHUD(MuseConnect muse) { //int head, int bl, int fl, int fr, int br, int battery ) {
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
    
    String battstr = "batt: " + str(muse.battery_level) + "%";
  
    museHUD.textSize(16);
    museHUD.text(battstr, 3, 96);
    museHUD.stroke(foreColor);
    museHUD.fill(foreColor);
    museHUD.endDraw();
    image(museHUD, 0, height-100); //should be robust to translation()?
  }
}

*/

class UIBrainComponent extends UI3dComponent {
 
  final UIPointCloudVBO pointCloud = new UIPointCloudVBO();
  
  void onDraw(UI ui, PGraphics pg) {
    color[] simulationColors = lx.getColors();
    simulationColors = lx.engine.getChannel(0).getColors();
    long simulationStart = System.nanoTime();
   // translate(0,50,-400); //remove this if we're using whole brain
    rotateX(PI*4.1);
    drawSimulation(simulationColors);
    camera(); 
    strokeWeight(1);
  }
  
  void drawSimulation(color[] simulationColors) {

    noStroke();
    noFill();
    pointCloud.draw(simulationColors);
  }
}




 
class UIWalls extends UI3dComponent {
  
  private final float WALL_MARGIN = 2*FEET;
  private final float WALL_SIZE = model.xRange + 2*WALL_MARGIN;
  private final float WALL_THICKNESS = 1*INCHES;
  
  protected void onDraw(UI ui, PGraphics pg) {
    fill(#666666);
    noStroke();
    pushMatrix();
    translate(model.cx, model.cy, model.zMax + WALL_MARGIN);
    box(WALL_SIZE, WALL_SIZE, WALL_THICKNESS);
    translate(-model.xRange/2 - WALL_MARGIN, 0, -model.zRange/2 - WALL_MARGIN);
    box(WALL_THICKNESS, WALL_SIZE, WALL_SIZE);
    translate(model.xRange + 2*WALL_MARGIN, 0, 0);
    box(WALL_THICKNESS, WALL_SIZE, WALL_SIZE);
    translate(-model.xRange/2 - WALL_MARGIN, model.yRange/2 + WALL_MARGIN, 0);
    box(WALL_SIZE, WALL_THICKNESS, WALL_SIZE);
    translate(0, -model.yRange - 2*WALL_MARGIN, 0);
    box(WALL_SIZE, WALL_THICKNESS, WALL_SIZE);
    popMatrix();
  }
}

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
  
  void draw(color[] colors) {
    // Put our new colors in the vertex data
    for (int i = 0; i < colors.length; ++i) {
      color c = colors[i];

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
