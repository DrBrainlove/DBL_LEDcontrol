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

/** ****************************************************************** UISpeed
 *
 ************************************************************************** */
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
    new UISlider(4, UIWindow.TITLE_LABEL_HEIGHT, w-10, 20)
        .setParameter(speed)
        .addToContainer(this);
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
