/**
 * Here's a simple extension of a camera component. This will be
 * rendered inside the camera view context. We just override the
 * onDraw method and invoke Processing drawing methods directly.
 */

import java.nio.*;
import java.util.Arrays;


/** ********************************************************* UIBrainComponent
 * Selects colors for each point based on patterns/transitions/channels. 
 * Sends that data to the pointCloud to actually draw it.
 ************************************************************************** */
class UIBrainComponent extends UI3dComponent {
 
  final UIPointCloudVBO pointCloud = new UIPointCloudVBO();
  
  void onDraw(UI ui, PGraphics pg) {
    color[] simulationColors = lx.getColors();

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
  
  void drawSimulation(color[] simulationColors) {
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
    g_brightness = new BasicParameter("BRIGHTNESS", 1.0);
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
        museActivated = parameter.getValue() > 0.;
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
