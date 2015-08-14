
import javax.sound.midi.MidiDevice;
import heronarts.lx.LX;
import heronarts.lx.LXChannel;
import heronarts.lx.LXEngine;
import heronarts.lx.midi.LXMidiDevice;
import heronarts.lx.midi.LXMidiInput;
import heronarts.lx.midi.LXMidiOutput;
import heronarts.lx.midi.LXMidiSystem;
import heronarts.lx.pattern.LXPattern;
import heronarts.lx.parameter.LXListenableNormalizedParameter;
import heronarts.lx.parameter.LXParameter;
import heronarts.lx.parameter.LXParameterListener;

public class EvolutionUC16 extends LXMidiDevice {

  public static final int BOTTOM_KNOB_1 = 16; // General Purpose 1 (coarse)
  public static final int BOTTOM_KNOB_2 = 17;
  public static final int BOTTOM_KNOB_3 = 18;
  public static final int BOTTOM_KNOB_4 = 19;
  public static final int BOTTOM_KNOB_5 = 20;
  public static final int BOTTOM_KNOB_6 = 21;
  public static final int BOTTOM_KNOB_7 = 22;
  public static final int BOTTOM_KNOB_8 = 23;

  public static final int TOP_KNOB_1 = 24;
  public static final int TOP_KNOB_2 = 25;
  public static final int TOP_KNOB_3 = 26;
  public static final int TOP_KNOB_4 = 27;
  public static final int TOP_KNOB_5 = 28;
  public static final int TOP_KNOB_6 = 28;
  public static final int TOP_KNOB_7 = 30;
  public static final int TOP_KNOB_8 = 31;

  public final static int DEVICE_CONTROL = 16;
  
  public final static int NUM_DEVICE_CONTROL_KNOBS = 16;

  public static final int[] KNOBS = { 
      BOTTOM_KNOB_1, BOTTOM_KNOB_2, BOTTOM_KNOB_3, BOTTOM_KNOB_4, 
      BOTTOM_KNOB_5, BOTTOM_KNOB_6, BOTTOM_KNOB_7, BOTTOM_KNOB_8,
      TOP_KNOB_1, TOP_KNOB_2, TOP_KNOB_3, TOP_KNOB_4, 
      TOP_KNOB_5, TOP_KNOB_6, TOP_KNOB_7, TOP_KNOB_8
  };




  public static final String[] DEVICE_NAMES = { "Evolution UC-16",
      "Evolution", "UC-16 USB MIDI Controller" };

  public static MidiDevice matchInputDevice() {
    return LXMidiSystem.matchInputDevice(DEVICE_NAMES);
  }

  public static EvolutionUC16 getEvolution(LX lx) {
    LXMidiInput input = LXMidiSystem.matchInput(lx, DEVICE_NAMES);
    if (input != null) {
      return new EvolutionUC16(input);
    }
    return null;
  }

  public EvolutionUC16(LXMidiInput input) {
    super(input);
  }

  
  public EvolutionUC16 bindKnob(LXParameter parameter, int knob) {
    bindController(parameter, 0, KNOBS[knob]);
    return this;
  }


  //=========== FROM APC40
  private LXChannel deviceControlChannel = null;
  public final LXChannel.AbstractListener deviceControlListener = new LXChannel.AbstractListener() {
    @Override
    public void patternDidChange(LXChannel channel, LXPattern pattern) {
      System.out.println("Detected pattern change");
      bindDeviceControlKnobs(pattern);
    }
  };

  public EvolutionUC16 bindDeviceControlKnobs(final LXEngine engine) {
    System.out.println("Binding knobs to engine");
    engine.focusedChannel.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter parameter) {
        bindDeviceControlKnobs(engine.getFocusedChannel());
      }
    });
    bindDeviceControlKnobs(engine.getFocusedChannel());
    return this;
  }

  public EvolutionUC16 bindDeviceControlKnobs(LXChannel channel) {
    System.out.println("Binding knobs to channel");
    if (this.deviceControlChannel != channel) {
      if (this.deviceControlChannel != null) {
        this.deviceControlChannel.removeListener(this.deviceControlListener);
      }
      this.deviceControlChannel = channel;
      this.deviceControlChannel.addListener(this.deviceControlListener);
    }
    bindDeviceControlKnobs(channel.getActivePattern());
    return this;
  }

  public EvolutionUC16 bindDeviceControlKnobs(LXPattern pattern) {
    int parameterIndex = 0;
    for (LXParameter parameter : pattern.getParameters()) {
      System.out.println("Binding knobs for pattern");
      if (parameter instanceof LXListenableNormalizedParameter) {
        //bindController(parameter, 0, DEVICE_CONTROL + parameterIndex);
        bindKnob(parameter, parameterIndex);
        System.out.println("Binding knob " + parameterIndex);
        if (++parameterIndex >= NUM_DEVICE_CONTROL_KNOBS) {
          break;
        }
      }
    }
    while (parameterIndex < NUM_DEVICE_CONTROL_KNOBS) {
      unbindController(0, DEVICE_CONTROL + parameterIndex);
      sendController(0, DEVICE_CONTROL + parameterIndex, 0);
      ++parameterIndex;
    }
    return this;
  }

}
