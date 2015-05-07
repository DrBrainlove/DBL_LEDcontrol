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

import java.nio.*;
import java.util.Arrays;

PFont labelFont = createFont("Arial", 12);

class UICubesComponent extends UI3dComponent {
 
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
    camera(); 
    strokeWeight(1);
  }
  
  void drawSimulation(color[] simulationColors) {
    translate(0, 30, 0);

    if (drawTrailer) {
      fill(#141414);
      drawBox(0, -TRAILER_HEIGHT, 0, 0, 0, 0, TRAILER_WIDTH, TRAILER_HEIGHT, TRAILER_DEPTH, TRAILER_HEIGHT/2.);
      fill(#070707);
      stroke(#222222);
      beginShape();
      vertex(0, 0, 0);
      vertex(TRAILER_WIDTH, 0, 0);
      vertex(TRAILER_WIDTH, 0, TRAILER_DEPTH);
      vertex(0, 0, TRAILER_DEPTH);
      endShape();
    
      // Draw the logo on the front of platform  
      pushMatrix();
      translate(0, 0, -1);
      float s = .07;
      scale(s, -s, s);
      image(logo, TRAILER_WIDTH/2/s-logo.width/2, TRAILER_HEIGHT/2/s-logo.height/2-2/s);
      popMatrix();
    }
    
    noStroke();
    for (Cube c : model.cubes) {
      if (structureOn) drawCube(c);
      if (mappingMode) drawLabel(c);
    }
      
    noFill();
    pointCloud.draw(simulationColors);
  }

  void drawLabel(Cube c) {
    textAlign   (CENTER, CENTER);
    textFont    (labelFont);
    fill        (0,0,100);
    pushMatrix  ();
    translate   (c.x+18,c.y+10,c.z);
    rotateZ     (PI);
    rotateY     (PI);
    text        (c.id, 0,0,0);
    popMatrix   ();
  }

  void drawCube(Cube c) {
    float in = .15;
    noStroke();
    fill(#393939);  
    drawBox(c.x+in, c.y+in, c.z+in, c.rx, c.ry, c.rz, Cube.EDGE_WIDTH-in*2, Cube.EDGE_HEIGHT-in*2, Cube.EDGE_WIDTH-in*2, Cube.CHANNEL_WIDTH-in);
  }
  
  void drawBox(float x, float y, float z, float rx, float ry, float rz, float xd, float yd, float zd, float sw) {
    pushMatrix();
    translate(x, y, z);
    rotate(rx / 180. * PI, -1, 0, 0);
    rotate(ry / 180. * PI, 0, -1, 0);
    rotate(rz / 180. * PI, 0, 0, -1);
    for (int i = 0; i < 4; ++i) {
      float wid = (i % 2 == 0) ? xd : zd;
      
      beginShape();
      vertex(0, 0);
      vertex(wid, 0);
      vertex(wid, yd);
      vertex(wid - sw, yd);
      vertex(wid - sw, sw);
      vertex(0, sw);
      endShape();
      beginShape();
      vertex(0, sw);
      vertex(0, yd);
      vertex(wid - sw, yd);
      vertex(wid - sw, yd - sw);
      vertex(sw, yd - sw);
      vertex(sw, sw);
      endShape();
  
      translate(wid, 0, 0);
      rotate(HALF_PI, 0, -1, 0);
    }
    popMatrix();
  }
}

class UIBlendMode extends UIWindow {
  public UIBlendMode(float x, float y, float w, float h) {
    super(lx.ui, "BLEND MODE", x, y, w, h);
    List<UIItemList.Item> items = new ArrayList<UIItemList.Item>();
    for (LXTransition t : transitions) {
      items.add(new TransitionItem(t));
    }
    final UIItemList tList;
    (tList = new UIItemList(1, UIWindow.TITLE_LABEL_HEIGHT, w-2, 60)).setItems(items).addToContainer(this);

    lx.engine.getChannel(RIGHT_CHANNEL).addListener(new LXChannel.AbstractListener() {
      public void faderTransitionDidChange(LXChannel channel, LXTransition transition) {
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
      return this.transition == lx.engine.getChannel(RIGHT_CHANNEL).getFaderTransition();
    }
    
    public boolean isPending() {
      return false;
    }
    
    public void onMousePressed() {
      lx.engine.getChannel(RIGHT_CHANNEL).setFaderTransition(this.transition);
    }
  }

}

class UICrossfader extends UIWindow {
  
  private final UIToggleSet displayMode;
  
  public UICrossfader(float x, float y, float w, float h) {
    super(lx.ui, "CROSSFADER", x, y, w, h);

    new UISlider(4, UIWindow.TITLE_LABEL_HEIGHT, w-9, 32).setParameter(lx.engine.getChannel(RIGHT_CHANNEL).getFader()).addToContainer(this);
    (displayMode = new UIToggleSet(4, UIWindow.TITLE_LABEL_HEIGHT + 36, w-9, 20)).setOptions(new String[] { "A", "COMP", "B" }).setValue("COMP").addToContainer(this);
  }
  
  public UICrossfader setDisplayMode(String value) {
    displayMode.setValue(value);
    return this;
  }
  
  public String getDisplayMode() {
    return displayMode.getValue();
  }
}

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
    
    void onDraw(UI ui, PGraphics pg) {
      tempoButton.setLabel("" + ((int)(lx.tempo.bpm() * 10)) / 10.);
    
      // Overlay tempo thing with openGL, redraw faster than button UI
      pg.fill(color(0, 0, 24 - 8*lx.tempo.rampf()));
      pg.noStroke();
      pg.rect(0, 0, width, height);
      
      redraw();
    }
  }
  
}

class UIMapping extends UIWindow {
  
  private static final String MAP_MODE_ALL      = "ALL";
  private static final String MAP_MODE_CHANNEL  = "CHNL";
  private static final String MAP_MODE_CUBE     = "CUBE";
  private static final String MAP_MODE_DIGI     = "DIGI";
  private static final String MAP_MODE_FADE     = "FADE";
  private static final String CUBE_MODE_ALL     = "ALL";
  private static final String CUBE_MODE_STRIP   = "SNGL";
  private static final String CUBE_MODE_PATTERN = "PTRN";
  
  private final MappingTool mappingTool;
  
  private final UILabel cubeLabel;
  private final UIIntegerBox cubeBox;
  private final UIIntegerBox stripBox;
  
  UIMapping(MappingTool tool, float x, float y, float w, float h) {
    super(lx.ui, "MAPPING", x, y, w, h);
    mappingTool = tool;
    
    int yp = UIWindow.TITLE_LABEL_HEIGHT;
    new UIToggleSet(4, yp, w-10, 20) {
      protected void onToggle(String value) {
        if      (value == MAP_MODE_ALL    ) mappingTool.mappingMode = mappingTool.MAPPING_MODE_ALL;
        else if (value == MAP_MODE_CHANNEL) mappingTool.mappingMode = mappingTool.MAPPING_MODE_CHANNEL;
        else if (value == MAP_MODE_CUBE   ) mappingTool.mappingMode = mappingTool.MAPPING_MODE_SINGLE_CUBE;
        else if (value == MAP_MODE_DIGI   ) mappingTool.mappingMode = mappingTool.MAPPING_MODE_DIGI;
        else if (value == MAP_MODE_FADE   ) mappingTool.mappingMode = mappingTool.MAPPING_MODE_FADE;
      }
    }.setOptions(new String[] { MAP_MODE_ALL, MAP_MODE_CUBE, MAP_MODE_DIGI, MAP_MODE_FADE }).addToContainer(this);
    yp += 24;
    new UILabel(4, yp+8, w-10, 20).setLabel("CUBE ID").addToContainer(this);
    yp += 24;
    (cubeLabel = new UILabel(4, yp, w-10, 20))
    .setAlignment(CENTER, CENTER)
    .setLabel(model.cubes.get(0).id)
    .setBackgroundColor(#222222)
    .setBorderColor(#666666)
    .addToContainer(this);
    yp += 24;
    
    new UILabel(4, yp+8, w-10, 20).setLabel("CUBE NUMBER").addToContainer(this);
    yp += 24;
    (cubeBox = new UIIntegerBox(4, yp, w-10, 20) {
      protected void onValueChange(int value) {
        mappingTool.setCube(value-1);
      }
    }).setRange(1, model.cubes.size()).addToContainer(this);
    yp += 24;
    
    yp += 10;
        
    new UIItemList(1, yp, w-2, 60).setItems(Arrays.asList(new UIItemList.Item[] {
      new ColorScrollItem(ColorScrollItem.COLOR_RED),
      new ColorScrollItem(ColorScrollItem.COLOR_GREEN),
      new ColorScrollItem(ColorScrollItem.COLOR_BLUE),
    })).addToContainer(this);
    yp += 64;

    new UILabel(4, yp+8, w-10, 20).setLabel("STRIP MODE").addToContainer(this);
    yp += 24;
    
    new UIToggleSet(4, yp, w-10, 20) {
      protected void onToggle(String value) {
        if      (value == CUBE_MODE_ALL) mappingTool.cubeMode = mappingTool.CUBE_MODE_ALL;
        else if (value == CUBE_MODE_STRIP) mappingTool.cubeMode = mappingTool.CUBE_MODE_SINGLE_STRIP;
        else if (value == CUBE_MODE_PATTERN) mappingTool.cubeMode = mappingTool.CUBE_MODE_STRIP_PATTERN;
      }
    }.setOptions(new String[] { CUBE_MODE_ALL, CUBE_MODE_STRIP, CUBE_MODE_PATTERN }).addToContainer(this);
    
    yp += 24;
    new UILabel(4, yp+8, w-10, 20).setLabel("STRIP ID").addToContainer(this);
    
    yp += 24;
    (stripBox = new UIIntegerBox(4, yp, w-10, 20) {
      protected void onValueChange(int value) {
        mappingTool.setStrip(value-1);
      }
    }).setRange(1, Cube.STRIPS_PER_CUBE).addToContainer(this);
    
  }
  
  public void setCubeID(int value) {
    cubeBox.setValue(value);
    cubeLabel.setLabel(model.getCubeByRawIndex(value).id);
  }

  public void setStripID(int value) {
    stripBox.setValue(value);
  }
  
  class ColorScrollItem extends UIItemList.AbstractItem {
    
    public static final int COLOR_RED = 1;
    public static final int COLOR_GREEN = 2;
    public static final int COLOR_BLUE = 3;
    
    private final int colorChannel;
    
    ColorScrollItem(int colorChannel) {
      this.colorChannel = colorChannel;
    }

    public String getLabel() {
      switch (colorChannel) {
        case COLOR_RED: return "Red";
        case COLOR_GREEN: return "Green";
        case COLOR_BLUE: return "Blue";
      }
      return "";
    }
    
    public boolean isSelected() {
      switch (colorChannel) {
        case COLOR_RED: return mappingTool.channelModeRed;
        case COLOR_GREEN: return mappingTool.channelModeGreen;
        case COLOR_BLUE: return mappingTool.channelModeBlue;
      }
      return false;
    }
    
    public void onMousePressed() {
      switch (colorChannel) {
        case COLOR_RED: mappingTool.channelModeRed = !mappingTool.channelModeRed; break;
        case COLOR_GREEN: mappingTool.channelModeGreen = !mappingTool.channelModeGreen; break;
        case COLOR_BLUE: mappingTool.channelModeBlue = !mappingTool.channelModeBlue; break;
      }
    }
  }
}

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
      pg.fill(#444444);
      pg.rect(0, 0, width, height);
      pg.textFont(ui.theme.getControlFont());
      pg.textSize(10);
      pg.textAlign(LEFT, TOP);
      pg.fill(#cccccc);
      pg.text(line1, 4, 4);
      pg.text(line2, 4, 24);
    }
  }
}

class UISpeed extends UIWindow {
  
  final BasicParameter speed;
  
  UISpeed(float x, float y, float w, float h) {
    super(lx.ui, "SPEED", x, y, w, h);
    speed = new BasicParameter("SPEED", 0.5);
    speed.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter parameter) {
        lx.setSpeed(parameter.getValuef() * 2);
      }
    });
    new UISlider(4, UIWindow.TITLE_LABEL_HEIGHT, w-10, 20).setParameter(speed).addToContainer(this);
  }
}

class UIMidi extends UIWindow {
  
  private final UIToggleSet channelMode;
  private final UIButton logMode;
  
  UIMidi(final MidiEngine midiEngine, float x, float y, float w, float h) {
    super(lx.ui, "MIDI", x, y, w, h);

    // Processing compiler doesn't seem to get that list of class objects also conform to interface
    List<UIItemList.Item> scrollItems = new ArrayList<UIItemList.Item>();
    for (SCMidiInput mc : midiEngine.getControllers()) {
      scrollItems.add(mc);
    }
    final UIItemList scrollList;
    (scrollList = new UIItemList(1, UIWindow.TITLE_LABEL_HEIGHT, w-2, 100)).setItems(scrollItems).addToContainer(this);
    (channelMode = new UIToggleSet(4, 130, 90, 20) {
      protected void onToggle(String value) {
        midiEngine.setFocusedChannel(value == "A" ? 0 : 1);
      }
    }).setOptions(new String[] { "A", "B" }).addToContainer(this);
    (logMode = new UIButton(98, 130, w-103, 20)).setLabel("LOG").addToContainer(this);
    
    SCMidiInputListener listener = new SCMidiInputListener() {
      public void onEnabled(SCMidiInput controller, boolean enabled) {
        scrollList.redraw();
      }
    };
    for (SCMidiInput mc : midiEngine.getControllers()) {
      mc.addListener(listener);
    }
    
    lx.engine.focusedChannel.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        channelMode.setValue(lx.engine.focusedChannel.getValuei() == 0 ? "A" : "B");
      }
    });

  }
  
  public boolean logMidi() {
    return logMode.isActive();
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

    //  color c = Color()    to-do (mark, alex, ben, micah):  Scale these colors somehow so that screen brightness more accurately represent the brightness of sculpture 
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

String className(Object p, String suffix) {
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
