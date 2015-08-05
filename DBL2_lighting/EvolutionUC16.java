/**
 * Copyright 2013- Mark C. Slee, Heron Arts LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @author Mark C. Slee <mark@heronarts.com>
 */

//package heronarts.lx.midi.device;

import javax.sound.midi.MidiDevice;

import heronarts.lx.LX;
import heronarts.lx.midi.LXMidiDevice;
import heronarts.lx.midi.LXMidiInput;
import heronarts.lx.midi.LXMidiSystem;
import heronarts.lx.parameter.LXParameter;

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
}
