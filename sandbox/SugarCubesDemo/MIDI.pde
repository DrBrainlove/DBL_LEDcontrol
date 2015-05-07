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
 * This file defines the MIDI mapping interfaces. This shouldn't
 * need editing unless you're adding top level support for a
 * specific MIDI device of some sort. Generally, all MIDI devices
 * will just work with the default configuration, and you can
 * set your SCPattern class to respond to the controllers that you
 * care about.
 */
import processing.event.*;

class MidiEngine {

  public final GridController grid;
  private final List<SCMidiInput> midiControllers = new ArrayList<SCMidiInput>();

  private SCMidiInput midiQwertyKeys;
  private SCMidiInput midiQwertyAPC;

  public MidiEngine() {
    grid = new GridController(this);
    midiControllers.add(midiQwertyKeys = new VirtualKeyMidiInput(this, VirtualKeyMidiInput.KEYS));
    midiControllers.add(midiQwertyAPC = new VirtualKeyMidiInput(this, VirtualKeyMidiInput.APC));
    int apcCount = 0;
    for (MidiInputDevice device : RWMidi.getInputDevices()) {
      if (device.getName().contains("APC")) {
        ++apcCount;
      }
    }    
    
    int apcIndex = 0;
    for (MidiInputDevice device : RWMidi.getInputDevices()) {
      if (device.getName().contains("APC")) {
        int apcChannel = -1;
        if (apcCount > 1 && apcIndex < 2) {
          apcChannel = apcIndex++;
        }
        midiControllers.add(new APC40MidiInput(this, device, apcChannel).setEnabled(true));
      } else if (device.getName().contains("SLIDER/KNOB KORG")) {
        midiControllers.add(new KorgNanoKontrolMidiInput(this, device).setEnabled(true));
      } else if (device.getName().contains("Arturia MINILAB")) {
        midiControllers.add(new ArturiaMinilabMidiInput(this, device).setEnabled(true));
      } else if (device.getName().contains("Twister")) {
        midiControllers.add(new MidiFighterTwisterInput(this, device).setEnabled(true));
      } else {
        boolean enabled =
          device.getName().contains("KEYBOARD KORG") ||
          device.getName().contains("Bus 1 Apple");
        midiControllers.add(new GenericDeviceMidiInput(this, device).setEnabled(enabled));
      }
    }
    
    apcIndex = 0;
    for (MidiOutputDevice device : RWMidi.getOutputDevices()) {
      if (device.getName().contains("APC")) {
        int apcChannel = -1;
        if (apcCount > 1 && apcIndex < 2) {
          apcChannel = apcIndex++;
        }
        new APC40MidiOutput(this, device, apcChannel);
      }
      else if (device.getName().contains("Twister") ) {
        new MidiFighterTwisterOutput(this, device); 
      }
    }
  }

  public List<SCMidiInput> getControllers() {
    return this.midiControllers;
  }

  public SCPattern getFocusedPattern() {
    return (SCPattern) lx.engine.getFocusedChannel().getActivePattern();
  }

  public MidiEngine setFocusedChannel(int channelIndex) {
    lx.engine.focusedChannel.setValue(channelIndex);
    return this;
  }

  public boolean isQwertyEnabled() {
    return midiQwertyKeys.isEnabled() || midiQwertyAPC.isEnabled();
  }
}

public interface SCMidiInputListener {
  public void onEnabled(SCMidiInput controller, boolean enabled);
}

public abstract class SCMidiInput extends UIItemList.AbstractItem {

  protected boolean enabled = false;
  private final String name;

  protected final MidiEngine midiEngine;

  final List<SCMidiInputListener> listeners = new ArrayList<SCMidiInputListener>();

  protected SCMidiInput(MidiEngine midiEngine, String name) {
    this.midiEngine = midiEngine;
    this.name = name;
  }

  public SCMidiInput addListener(SCMidiInputListener l) {
    listeners.add(l);
    return this;
  }

  public SCMidiInput removeListener(SCMidiInputListener l) {
    listeners.remove(l);
    return this;
  }

  public String getLabel() {
    return name;
  }

  public boolean isEnabled() {
    return enabled;
  }

  public boolean isSelected() {
    return enabled;
  }

  public void onMousePressed() {
    setEnabled(!enabled);
  }

  public SCMidiInput setEnabled(boolean enabled) {
    if (enabled != this.enabled) {
      this.enabled = enabled;
      for (SCMidiInputListener l : listeners) {
        l.onEnabled(this, enabled);
      }
    }
    return this;
  }

  private boolean logMidi() {
    return (uiMidi != null) && uiMidi.logMidi();
  }
  
  protected SCPattern getTargetPattern() {
    return midiEngine.getFocusedPattern();
  }

  final void programChangeReceived(ProgramChange pc) {
    if (!enabled) {
      return;
    }
    if (logMidi()) {
      println(getLabel() + " :: Program Change :: " + pc.getNumber());
    }
    handleProgramChange(pc);
  }

  final void controllerChangeReceived(rwmidi.Controller cc) {
    if (!enabled) {
      return;
    }
    if (logMidi()) {
      println(getLabel() + " :: Controller :: " + cc.getChannel() + " :: " + cc.getCC() + ":" + cc.getValue());
    }
    if (!handleControllerChange(cc)) {
      getTargetPattern().controllerChange(cc);
    }
  }

  final void noteOnReceived(Note note) {
    if (!enabled) {
      return;
    }
    if (note.getVelocity() == 0) {
      noteOffReceived(note);
      return;
    }
    if (logMidi()) {
      println(getLabel() + " :: Note On  :: " + note.getChannel() + ":" + note.getPitch() + ":" + note.getVelocity());
    }
    if (!handleNoteOn(note)) {
      getTargetPattern().noteOn(note);
    }
  }

  final void noteOffReceived(Note note) {
    if (!enabled) {
      return;
    }
    if (logMidi()) {
      println(getLabel() + " :: Note Off :: " + note.getChannel() + ":" + note.getPitch() + ":" + note.getVelocity());
    }
    if (!handleNoteOff(note)) {
      getTargetPattern().noteOff(note);
    }
  }
  
  protected void setNormalized(LXParameter parameter, float value) {
    if (parameter != null) {
      if (parameter instanceof BasicParameter) {
        ((BasicParameter)parameter).setNormalized(value);
      } else {
        parameter.setValue(value);
      }
    }
  }

  // Subclasses may implement these to map top-level functionality
  protected boolean handleProgramChange(ProgramChange pc) { return false; }
  protected boolean handleControllerChange(rwmidi.Controller cc) { return false; }
  protected boolean handleNoteOn(Note note) { return false; }
  protected boolean handleNoteOff(Note note) { return false; }
}

public class VirtualKeyMidiInput extends SCMidiInput {

  public static final int KEYS = 1;
  public static final int APC = 2;
  
  private final int mode;
  
  private int octaveShift = 0;

  class NoteMeta {
    int channel;
    int number;
    NoteMeta(int channel, int number) {
      this.channel = channel;
      this.number = number;
    }
  }

  final Map<Character, NoteMeta> keyToNote = new HashMap<Character, NoteMeta>();  
  
  VirtualKeyMidiInput(MidiEngine midiEngine, int mode) {
    super(midiEngine, "QWERTY (" + (mode == APC ? "APC" : "Key") + "  Mode)");
    this.mode = mode;
    if (mode == APC) {
      mapAPC();
    } else {
      mapKeys();
    }
    registerMethod("keyEvent", this);
  }

  private void mapAPC() {
    mapNote('1', 0, 53);
    mapNote('2', 1, 53);
    mapNote('3', 2, 53);
    mapNote('4', 3, 53);
    mapNote('5', 4, 53);
    mapNote('6', 5, 53);
    mapNote('q', 0, 54);
    mapNote('w', 1, 54);
    mapNote('e', 2, 54);
    mapNote('r', 3, 54);
    mapNote('t', 4, 54);
    mapNote('y', 5, 54);
    mapNote('a', 0, 55);
    mapNote('s', 1, 55);
    mapNote('d', 2, 55);
    mapNote('f', 3, 55);
    mapNote('g', 4, 55);
    mapNote('h', 5, 55);
    mapNote('z', 0, 56);
    mapNote('x', 1, 56);
    mapNote('c', 2, 56);
    mapNote('v', 3, 56);
    mapNote('b', 4, 56);
    mapNote('n', 5, 56);
  }

  private void mapKeys() {
    int note = 48;
    mapNote('a', 1, note++);
    mapNote('w', 1, note++);
    mapNote('s', 1, note++);
    mapNote('e', 1, note++);
    mapNote('d', 1, note++);
    mapNote('f', 1, note++);
    mapNote('t', 1, note++);
    mapNote('g', 1, note++);
    mapNote('y', 1, note++);
    mapNote('h', 1, note++);
    mapNote('u', 1, note++);
    mapNote('j', 1, note++);
    mapNote('k', 1, note++);
    mapNote('o', 1, note++);
    mapNote('l', 1, note++);
  }

  void mapNote(char ch, int channel, int number) {
    keyToNote.put(ch, new NoteMeta(channel, number));
  }
  
  public void keyEvent(KeyEvent e) {
    if (!enabled) {
      return;
    }
    char c = Character.toLowerCase(e.getKey());
    NoteMeta nm = keyToNote.get(c);
    if (nm != null) {
      switch (e.getAction()) {
      case KeyEvent.PRESS:
        noteOnReceived(new Note(Note.NOTE_ON, nm.channel, nm.number + octaveShift*12, 127));
        break;
      case KeyEvent.RELEASE:
        noteOffReceived(new Note(Note.NOTE_OFF, nm.channel, nm.number + octaveShift*12, 0));
        break;
      }
    }
    if ((mode == KEYS) && (e.getAction() == KeyEvent.PRESS)) {
      switch (c) {
      case 'z':
        octaveShift = constrain(octaveShift-1, -4, 4);
        break;
      case 'x':
        octaveShift = constrain(octaveShift+1, -4, 4);
        break;
      }
    }
  }
}

public class GenericDeviceMidiInput extends SCMidiInput {
  GenericDeviceMidiInput(MidiEngine midiEngine, MidiInputDevice d) {
    super(midiEngine, d.getName().replace("Unknown vendor",""));
    d.createInput(this);
  }
}

public class APC40MidiInput extends GenericDeviceMidiInput {

  private boolean shiftOn = false;
  private LXEffect releaseEffect = null;
  final private LXChannel targetChannel;
  
  APC40MidiInput(MidiEngine midiEngine, MidiInputDevice d) {
    this(midiEngine, d, -1);
  }
  
  APC40MidiInput(MidiEngine midiEngine, MidiInputDevice d, int channelIndex) {
    super(midiEngine, d);
    targetChannel = (channelIndex < 0) ? null : lx.engine.getChannels().get(channelIndex);
  }
  
  protected LXChannel getTargetChannel() {
    return (targetChannel != null) ? targetChannel : lx.engine.getFocusedChannel();
  }
  
  protected SCPattern getTargetPattern() {
    if (targetChannel != null) {
      return (SCPattern) (targetChannel.getActivePattern());
    }
    return super.getTargetPattern();
  }

  private class GridPosition {
    public final int row, col;
    GridPosition(int r, int c) {
      row = r;
      col = c;
    }
  }
  
  private GridPosition getGridPosition(Note note) {
    int channel = note.getChannel();
    int pitch = note.getPitch();
    if (channel < 8) {
      if (pitch >= APC40.CLIP_LAUNCH && pitch <= (APC40.CLIP_LAUNCH+4)) return new GridPosition(pitch-APC40.CLIP_LAUNCH, channel);
    }
    return null;
  }

  private boolean handleGridNoteOn(Note note) {
    GridPosition p = getGridPosition(note);
    if (p != null) {
      return midiEngine.grid.gridPressed(p.row, p.col);
    }
    return false;
  }

  private boolean handleGridNoteOff(Note note) {
    GridPosition p = getGridPosition(note);
    if (p != null) {
      return midiEngine.grid.gridReleased(p.row, p.col);
    }
    return false;
  }

  protected boolean handleControllerChange(rwmidi.Controller cc) {
    int channel = cc.getChannel();
    int number = cc.getCC();
    float value = cc.getValue() / 127.;
    float valuef = cc.getValue(); 
    switch (number) {
      
    case APC40.VOLUME:
     switch (channel) {
       case 0:
         uiSpeed.speed.setNormalized(0.5 - value*0.5);
         return true;
       case 1:
         effects.colorFucker.desat.setNormalized(value);
         return true;
       case 2:
         effects.colorFucker.desat.setNormalized(value);
         return true;
       case 3:
         effects.blur.amount.setNormalized(value);
         return true;
       case 4:
         effects.quantize.amount.setNormalized(value);
         return true;
     }
     break;
     
    // Master bright
    case APC40.MASTER_FADER:
      effects.colorFucker.level.setNormalized(value);
      return true;

    // Crossfader
    case APC40.CROSSFADER:
      lx.engine.getChannel(RIGHT_CHANNEL).getFader().setNormalized(value);
      return true;
      
    // Cue level
    case APC40.CUE_LEVEL:
      float val = effects.colorFucker.hueShift.getValuef();
      int cv = cc.getValue();
      if (cv < 64) {
        cv = 64 + cv;
      } else {
        cv = cv - 64;
      }
      val += (cv - 64) / 500.;
      effects.colorFucker.hueShift.setNormalized((val+1) % 1);
      return true;
    }
    
    int parameterIndex = -1;
    if (number >= APC40.TRACK_CONTROL && number <= (APC40.TRACK_CONTROL + 7)) {
      parameterIndex = number - APC40.TRACK_CONTROL;
    } else if (number >= APC40.DEVICE_CONTROL && number <= (APC40.DEVICE_CONTROL + 3)) {
      parameterIndex = 8 + (number - APC40.DEVICE_CONTROL);
    }
    if (parameterIndex >= 0) {
      List<LXParameter> parameters = getTargetPattern().getParameters();
      if (parameterIndex < parameters.size()) {
        setNormalized(parameters.get(parameterIndex), value);
        return true;
      }
    }
    
    if (number == (APC40.DEVICE_CONTROL + 4) || number == (APC40.DEVICE_CONTROL + 5)) { 
      int effectIndex = number - (APC40.DEVICE_CONTROL + 4);
      // TODO(mclsee): fix selected effect
      List<LXParameter> parameters = getSelectedEffect().getParameters();
      if (effectIndex < parameters.size()) {
        setNormalized(parameters.get(effectIndex), value);
        return true;
      }
    }
    if (number == (APC40.DEVICE_CONTROL + 6)) { 
      uiTempo.tempoAdjustFine.setNormalized(value);
      return true; 
    }

    if (number == (APC40.DEVICE_CONTROL + 7)) { 
      uiTempo.tempoAdjustCoarse.setNormalized(value);
      return true;   
    } 
    
    return false;
  }

  private long tap1 = 0;

  private boolean lbtwn(long a, long b, long c) {
    return a >= b && a <= c;
  }

  protected boolean handleNoteOn(Note note) {
    if (handleGridNoteOn(note)) {
      return true;
    }
    
    int nPitch = note.getPitch();
    int nChan = note.getChannel();
    switch (nPitch) {
    
    case APC40.SOLO_CUE: // SOLO/CUE
      switch (nChan) {
        case 4:
          effects.colorFucker.mono.setNormalized(1);
          return true;
        case 5:
          effects.colorFucker.invert.setNormalized(1);
          return true;
        case 6:
          lx.cycleBaseHue(60000);
          return true;
      }
      break;
            
    case APC40.SCENE_LAUNCH: // scene 1
      effects.boom.trigger();
      return true;
      
    case APC40.SCENE_LAUNCH+1: // scene 2
      //effects.flash.trigger();
      return true;
      
    case APC40.SCENE_LAUNCH+2: // scene 3
      getTargetPattern().reset();
      return true;
      
    case APC40.SEND_C:
      // dan's dirty tapping mechanism
      lx.tempo.trigger();
      tap1 = millis();
      return true;

    case APC40.PLAY: // play
      if (shiftOn) {
        midiEngine.setFocusedChannel(LEFT_CHANNEL);
      } else {
        uiCrossfader.setDisplayMode("A");
      }
      return true;
      
    case APC40.STOP: // stop
      uiCrossfader.setDisplayMode("COMP");
      return true;
      
    case APC40.REC: // rec
      if (shiftOn) {
        midiEngine.setFocusedChannel(RIGHT_CHANNEL);
      } else {
        uiCrossfader.setDisplayMode("B");
      }
      return true;

    case APC40.BANK_UP: // up bank
      if (shiftOn) {
        selectedEffect.setValue(selectedEffect.getValuei() - 1);
      } else {
        getTargetChannel().goPrev();
      }
      return true;
      
    case APC40.BANK_DOWN: // down bank
      if (shiftOn) {
        selectedEffect.setValue(selectedEffect.getValuei() + 1);
      } else {
        getTargetChannel().goNext();
      }
      return true;

    case APC40.SHIFT: // shift
      shiftOn = true;
      return true;

    case APC40.TAP_TEMPO: // tap tempo
      lx.tempo.tap();
      return true;
      
    case APC40.NUDGE_PLUS: // nudge+
      lx.tempo.setBpm(lx.tempo.bpm() + (shiftOn ? 1 : .1));
      return true;
      
    case APC40.NUDGE_MINUS: // nudge-
      lx.tempo.setBpm(lx.tempo.bpm() - (shiftOn ? 1 : .1));
      return true;

    case APC40.DETAIL_VIEW: // Detail View / red 5
      releaseEffect = getSelectedEffect(); 
      if (releaseEffect.isMomentary()) {
        releaseEffect.enable();
      } else {
        releaseEffect.toggle();
      }
      return true;

    case APC40.REC_QUANTIZATION: // rec quantize / red 6
      getSelectedEffect().disable();
      return true;
    }

    return false;
  }

  protected boolean handleNoteOff(Note note) {
    if (handleGridNoteOff(note)) {
      return true;
    }

    int nPitch = note.getPitch();
    int nChan = note.getChannel();

    switch (nPitch) {
      
    case APC40.SOLO_CUE: // SOLO/CUE
      switch (nChan) {
        case 4:
          effects.colorFucker.mono.setNormalized(0);
          return true;
        case 5:
          effects.colorFucker.invert.setNormalized(0);
          return true;
        case 6:
          lx.setBaseHue(lx.getBaseHue());
          return true;
      }
      break;

    case APC40.CLIP_STOP: // CLIP STOP
      if (nChan < PresetManager.NUM_PRESETS) {
        if (shiftOn) {
          presetManager.store(getTargetChannel(), nChan);
        } else {
          presetManager.select(getTargetChannel(), nChan);
        }
      }
      return true;

    case APC40.SEND_C: // SEND C
      long tapDelta = millis() - tap1;
      if (lbtwn(tapDelta,5000,300*1000)) {	// hackish tapping mechanism
        double bpm = 32.*60000./(tapDelta);
        while (bpm < 20) bpm*=2;
        while (bpm > 40) bpm/=2;
        lx.tempo.setBpm(bpm);
        lx.tempo.trigger();
        tap1 = 0;
        println("Tap Set - " + bpm + " bpm");
      }
      return true;

    case APC40.REC_QUANTIZATION: // rec quantize / RED 6
      if (releaseEffect != null) {
        if (releaseEffect.isMomentary()) {
          releaseEffect.disable();
        }
      }
      return true;

    case APC40.SHIFT: // shift
      shiftOn = false;
      return true;
    }
    
    return false;
  }
}

class KorgNanoKontrolMidiInput extends GenericDeviceMidiInput {
  
  KorgNanoKontrolMidiInput(MidiEngine midiEngine, MidiInputDevice d) {
    super(midiEngine, d);
  }
  
  protected boolean handleControllerChange(rwmidi.Controller cc) {
    int number = cc.getCC();
    if (number >= 16 && number <= 23) {
      int parameterIndex = number - 16;
      List<LXParameter> parameters = midiEngine.getFocusedPattern().getParameters();
      if (parameterIndex < parameters.size()) {
        setNormalized(parameters.get(parameterIndex), cc.getValue() / 127.);
        return true;
      }
    }
    
    if (cc.getValue() == 127) {
      switch (number) {
      
      case 58: // Left track
        midiEngine.setFocusedChannel(LEFT_CHANNEL);
        return true;
      
      case 59: // Right track
        midiEngine.setFocusedChannel(RIGHT_CHANNEL);
        return true;
      
      case 43: // Left chevron
        lx.engine.getFocusedChannel().goPrev();
        return true;
      
      case 44: // Right chevron
        lx.engine.getFocusedChannel().goNext();
        return true;
      }
    }
    
    return false;
  }
}

class APC40MidiOutput implements LXParameterListener, GridOutput {
  
  private final MidiEngine midiEngine;
  private final MidiOutput output;
  private LXPattern focusedPattern = null;
  private LXEffect focusedEffect = null;
  private final LXChannel targetChannel;
  
  APC40MidiOutput(MidiEngine midiEngine, MidiOutputDevice device) {
    this(midiEngine, device, -1);
  }
  
  APC40MidiOutput(MidiEngine midiEngine, MidiOutputDevice device, int channelIndex) {
    this.midiEngine = midiEngine;
    output = device.createOutput();
    targetChannel = (channelIndex < 0) ? null : lx.engine.getChannels().get(channelIndex);
    setDPatternOutputs();
    if (targetChannel != null) {
      lx.engine.focusedChannel.addListener(new LXParameterListener() {
        public void onParameterChanged(LXParameter p) {
          resetPatternParameters();
          for (int i = 0; i < 8; ++i) {
            output.sendNoteOn(i, APC40.CLIP_STOP, APC40.OFF);
          }
        }
      });
    }
    selectedEffect.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter parameter) {
        resetEffectParameters();
      }
    });
    LXChannel.Listener channelListener = new LXChannel.AbstractListener() {
      public void patternDidChange(LXChannel channel, LXPattern pattern) {
        if (channel == getTargetChannel()) {
          resetPatternParameters();
        }
      }
    };
    for (LXChannel d : lx.engine.getChannels()) {
      if (targetChannel == null || d == targetChannel) {
        d.addListener(channelListener);
      }
    }
    presetManager.addListener(new PresetListener() {
      public void onPresetSelected(LXChannel channel, Preset preset) {
        if (channel == getTargetChannel()) {
          for (int i = 0; i < 8; ++i) {
            output.sendNoteOn(i, APC40.CLIP_STOP, (preset.index == i) ? APC40.GREEN : APC40.OFF);
          }
        }
      }
      public void onPresetDirty(LXChannel channel, Preset preset) {
        if (channel == getTargetChannel()) {
          output.sendNoteOn(preset.index, APC40.CLIP_STOP, APC40.GREEN_BLINK);
        }
      }
      public void onPresetStored(LXChannel channel, Preset preset) {
        onPresetSelected(channel, preset);
      }
    });
    resetParameters();
    midiEngine.grid.addOutput(this);

    lx.cycleBaseHue(60000);
    output.sendNoteOn(6, APC40.SOLO_CUE, 127);
    
    // Turn off the track selection lights and preset selectors
    for (int i = 0; i < 8; ++i) {
      output.sendNoteOn(i, APC40.TRACK_SELECTION, APC40.OFF);
      output.sendNoteOn(i, APC40.CLIP_STOP, APC40.OFF);
    }
    
    // Turn off the MASTER selector
    output.sendNoteOn(0, APC40.MASTER_TRACK, APC40.OFF);
  }
  
  private void setDPatternOutputs() {
    for (LXChannel channel : lx.engine.getChannels()) {
      if (targetChannel == null || channel == targetChannel) {
        for (LXPattern pattern : channel.getPatterns()) {
//          if (pattern instanceof DPat) {
//            ((DPat)pattern).setAPCOutput(output);
//          }
        }
      }
    }
  }

   
  protected LXChannel getTargetChannel() {
    return (targetChannel != null) ? targetChannel : lx.engine.getFocusedChannel();
  }

  private void resetParameters() {
    resetPatternParameters();
    resetEffectParameters();
  }
  
  private void resetPatternParameters() {
    LXPattern newPattern = getTargetChannel().getActivePattern();
    if (newPattern == focusedPattern) {
      return;
    }
    if (focusedPattern != null) {
      for (LXParameter p : focusedPattern.getParameters()) {
        ((LXListenableParameter) p).removeListener(this);
      }
    }
    focusedPattern = newPattern;
    int i = 0;
    for (LXParameter p : focusedPattern.getParameters()) {
      ((LXListenableParameter) p).addListener(this);
      sendKnob(i++, p);
    }
    while (i < 12) {
      sendKnob(i++, 0);
    }
//    if (focusedPattern instanceof DPat) {
//      ((DPat)focusedPattern).updateLights();
//    } else {
      for (int j = 0; j < 8; ++j) {
        output.sendNoteOn(j, 48, 0);
      }
      for (int row = 0; row < 7; ++row) {
        for (int col = 0; col < 8; ++col) {
          setGridState(row, col, 0);
        }
      }
//    }
  }
  
  private void resetEffectParameters() {
    LXEffect newEffect = getSelectedEffect();
    if (newEffect == focusedEffect) {
      return;
    }
    if (focusedEffect != null) {
      for (LXParameter p : focusedPattern.getParameters()) {
        ((LXListenableParameter) p).removeListener(this);
      }
    }
    focusedEffect = newEffect;
    int i = 0;
    for (LXParameter p : focusedEffect.getParameters()) {
      ((LXListenableParameter) p).addListener(this);
      sendKnob(12 + i++, p);
    }
    while (i < 4) {
      sendKnob(12 + i++, 0);
    }
  }

  private void sendKnob(int i, LXParameter p) {
    float pv = constrain(p.getValuef(), 0, 1);
    if (p instanceof LXNormalizedParameter) {
      pv = ((LXNormalizedParameter)p).getNormalizedf();
    }
    sendKnob(i, (int) (pv * 127.));
  }
  
  private void sendKnob(int i, int value) {
    if (i < 8) {
      output.sendController(0, 48+i, value);
    } else if (i < 16) {
      output.sendController(0, 8+i, value);
    }
  }
  
  public void onParameterChanged(LXParameter parameter) {
    int i = 0;
    for (LXParameter p : focusedPattern.getParameters()) {
      if (p == parameter) {
        sendKnob(i, p);
        break;
      }
      ++i;
    }
    i = 12;
    for (LXParameter p : focusedEffect.getParameters()) {
      if (p == parameter) {
        sendKnob(i, p);
        break;
      }
      ++i;
    }
  }
  
  public void setGridState(int row, int col, int state) {
    if (col < 8 && row < 5) {
      output.sendNoteOn(col, 53+row, state);
    }
  }
}

public class MidiFighterTwisterInput extends GenericDeviceMidiInput {

  private boolean shiftOn = false;
  private LXEffect releaseEffect = null;
  final private LXChannel targetChannel;
  
  MidiFighterTwisterInput(MidiEngine midiEngine, MidiInputDevice d) {
    this(midiEngine, d, -1);
  }
  
  MidiFighterTwisterInput(MidiEngine midiEngine, MidiInputDevice d, int channelIndex) {
    super(midiEngine, d);
    targetChannel = (channelIndex < 0) ? null : lx.engine.getChannels().get(channelIndex);
  }
  
  protected LXChannel getTargetChannel() {
    return (targetChannel != null) ? targetChannel : lx.engine.getFocusedChannel();
  }
  
  protected SCPattern getTargetPattern() {
    if (targetChannel != null) {
      return (SCPattern) (targetChannel.getActivePattern());
    }
    return super.getTargetPattern();
  }

  private class GridPosition {
    public final int row, col;
    GridPosition(int r, int c) {
      row = r;
      col = c;
    }
  }
  
  private GridPosition getGridPosition(Note note) {
    int channel = note.getChannel();
    int pitch = note.getPitch();
    if (channel < 8) {
       return new GridPosition(pitch, channel);
    }
    return null;
  }

  private boolean handleGridNoteOn(Note note) {
    GridPosition p = getGridPosition(note);
    if (p != null) {
      return midiEngine.grid.gridPressed(p.row, p.col);
    }
    return false;
  }

  private boolean handleGridNoteOff(Note note) {
    GridPosition p = getGridPosition(note);
    if (p != null) {
      return midiEngine.grid.gridReleased(p.row, p.col);
    }
    return false;
  }

  protected boolean handleControllerChange(rwmidi.Controller cc) {
    int channel = cc.getChannel();
    int number = cc.getCC();
    float value = cc.getValue() / 127.;

    int parameterIndex = -1;
    if (number >= 0 && number <= 15) {
      parameterIndex = number ;
    } 
    if (parameterIndex >= 0) {
      List<LXParameter> parameters = getTargetPattern().getParameters();
      if (parameterIndex < parameters.size()) {
        setNormalized(parameters.get(parameterIndex), value);
        return true;
      }
    }
    
    return false;
  }

  private long tap1 = 0;

  private boolean lbtwn(long a, long b, long c) {
    return a >= b && a <= c;
  }

  protected boolean handleNoteOn(Note note) {
    if (handleGridNoteOn(note)) {
      return true;
    }
    
    int nPitch = note.getPitch();
    int nChan = note.getChannel();
    switch (nPitch) {
    
    case 20: // SOLO/CUE
      switch (nChan) {
        case 4:
          effects.colorFucker.mono.setNormalized(1);
          return true;
        case 5:
          effects.colorFucker.invert.setNormalized(1);
          return true;
        case 6:
          lx.cycleBaseHue(60000);
          return true;
      }
      break;
            
    case 82: // scene 1
      effects.boom.trigger();
      return true;
      
    case 83: // scene 2
      //effects.flash.trigger();
      return true;
      
    case 84: // scene 3
      getTargetPattern().reset();
      return true;
      
    case 90:
      // dan's dirty tapping mechanism
      lx.tempo.trigger();
      tap1 = millis();
      return true;

    case 91: // play
      if (shiftOn) {
        midiEngine.setFocusedChannel(LEFT_CHANNEL);
      } else {
        uiCrossfader.setDisplayMode("A");
      }
      return true;
      
    case 92: // stop
      uiCrossfader.setDisplayMode("COMP");
      return true;
      
    case 93: // rec
      if (shiftOn) {
        midiEngine.setFocusedChannel(RIGHT_CHANNEL);
      } else {
        uiCrossfader.setDisplayMode("B");
      }
      return true;

    case 94: // up bank
      if (shiftOn) {
        selectedEffect.setValue(selectedEffect.getValuei() - 1);
      } else {
        getTargetChannel().goPrev();
      }
      return true;
      
    case 95: // down bank
      if (shiftOn) {
        selectedEffect.setValue(selectedEffect.getValuei() + 1);
      } else {
        getTargetChannel().goNext();
      }
      return true;

    case 98: // shift
      shiftOn = true;
      return true;

    case 99: // tap tempo
      lx.tempo.tap();
      return true;
      
    case 100: // nudge+
      lx.tempo.setBpm(lx.tempo.bpm() + (shiftOn ? 1 : .1));
      return true;
      
    case 101: // nudge-
      lx.tempo.setBpm(lx.tempo.bpm() - (shiftOn ? 1 : .1));
      return true;

    case 62: // Detail View / red 5
      releaseEffect = getSelectedEffect(); 
      if (releaseEffect.isMomentary()) {
        releaseEffect.enable();
      } else {
        releaseEffect.toggle();
      }
      return true;

    case 63: // rec quantize / red 6
      getSelectedEffect().disable();
      return true;
    }

    return false;
  }

  protected boolean handleNoteOff(Note note) {
    if (handleGridNoteOff(note)) {
      return true;
    }

    int nPitch = note.getPitch();
    int nChan = note.getChannel();

    switch (nPitch) {
      
    case 49: // SOLO/CUE
      switch (nChan) {
        case 4:
          effects.colorFucker.mono.setNormalized(0);
          return true;
        case 5:
          effects.colorFucker.invert.setNormalized(0);
          return true;
        case 6:
          lx.setBaseHue(lx.getBaseHue());
          return true;
      }
      break;

    case 52: // CLIP STOP
      if (nChan < PresetManager.NUM_PRESETS) {
        if (shiftOn) {
          presetManager.store(getTargetChannel(), nChan);
        } else {
          presetManager.select(getTargetChannel(), nChan);
        }
      }
      return true;

    case 90: // SEND C
      long tapDelta = millis() - tap1;
      if (lbtwn(tapDelta,5000,300*1000)) {  // hackish tapping mechanism
        double bpm = 32.*60000./(tapDelta);
        while (bpm < 20) bpm*=2;
        while (bpm > 40) bpm/=2;
        lx.tempo.setBpm(bpm);
        lx.tempo.trigger();
        tap1 = 0;
        println("Tap Set - " + bpm + " bpm");
      }
      return true;

    case 63: // rec quantize / RED 6
      if (releaseEffect != null) {
        if (releaseEffect.isMomentary()) {
          releaseEffect.disable();
        }
      }
      return true;

    case 98: // shift
      shiftOn = false;
      return true;
    }
    
    return false;
  }
}


class  MidiFighterTwisterOutput implements LXParameterListener, GridOutput {
  
  private final MidiEngine midiEngine;
  private final MidiOutput output;
  private LXPattern focusedPattern = null;
  private LXEffect focusedEffect = null;
  private final LXChannel targetChannel;
  
  MidiFighterTwisterOutput(MidiEngine midiEngine, MidiOutputDevice device) {
    this(midiEngine, device, -1);
  }
    
  MidiFighterTwisterOutput(MidiEngine midiEngine, MidiOutputDevice device, int channelIndex) {
    this.midiEngine = midiEngine;
    output = device.createOutput();
    targetChannel = (channelIndex < 0) ? null : lx.engine.getChannels().get(channelIndex);
    //setDPatternOutputs();
   // setAPatternOutputs(); 
    setAPatternOutputs(); 
    if (targetChannel != null) {
      lx.engine.focusedChannel.addListener(new LXParameterListener() {
        public void onParameterChanged(LXParameter p) {
          resetPatternParameters();
        }
      });
    }
    selectedEffect.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter parameter) {
        resetEffectParameters();
      }
    });
    LXChannel.Listener channelListener = new LXChannel.AbstractListener() {
      public void patternDidChange(LXChannel channel, LXPattern pattern) {
        if (channel == getTargetChannel()) {
          resetPatternParameters();
        }
      }
    };
    for (LXChannel d : lx.engine.getChannels()) {
      if (targetChannel == null || d == targetChannel) {
        d.addListener(channelListener);
      }
    }
     
    resetParameters();
    midiEngine.grid.addOutput(this);

  }
  
  // private void setDPatternOutputs() {
  //   for (LXChannel channel : lx.engine.getChannels()) {
  //     if (targetChannel == null || channel == targetChannel) {
  //       for (LXPattern pattern : channel.getPatterns()) {
  //         if (pattern instanceof DPat) {
  //           ((DPat)pattern).setMidiFighterTwisterOutput(output);
  //         }
  //       }
  //     }
  //   }
  // }
  private void setAPatternOutputs() {
    for (LXChannel channel : lx.engine.getChannels()) {
      if (targetChannel == null || channel == targetChannel) {
        for (LXPattern pattern : channel.getPatterns()) {
//          if (pattern instanceof APat) {
//            ((APat)pattern).setMidiFighterTwisterOutput(output);
//          }
        }
      }
    }
  }
  
  
  protected LXChannel getTargetChannel() {
    return (targetChannel != null) ? targetChannel : lx.engine.getFocusedChannel();
  }

  private void resetParameters() {
    resetPatternParameters();
    resetEffectParameters();
  }
  
  private void resetPatternParameters() {
    LXPattern newPattern = getTargetChannel().getActivePattern();
    if (newPattern == focusedPattern) {
      return;
    }
    if (focusedPattern != null) {
      for (LXParameter p : focusedPattern.getParameters()) {
        ((LXListenableParameter) p).removeListener(this);
      }
    }
    focusedPattern = newPattern;
    int i = 0;
    for (LXParameter p : focusedPattern.getParameters()) {
      ((LXListenableParameter) p).addListener(this);
      sendKnob(i++, p);
    }
    while (i < 16) {
      sendKnob(i++, 0);
    }
//    if (focusedPattern instanceof DPat) {
//      ((DPat)focusedPattern).updateLights();
//    } else {
      for (int j = 0; j < 8; ++j) {
        output.sendNoteOn(j, 48, 0);
      }
      for (int row = 0; row < 7; ++row) {
        for (int col = 0; col < 8; ++col) {
          setGridState(row, col, 0);
        }
      }
//    }
  }
  
  private void resetEffectParameters() {
    LXEffect newEffect = getSelectedEffect();
    if (newEffect == focusedEffect) {
      return;
    }
    if (focusedEffect != null) {
      for (LXParameter p : focusedPattern.getParameters()) {
        ((LXListenableParameter) p).removeListener(this);
      }
    }
    focusedEffect = newEffect;
    int i = 0;
    for (LXParameter p : focusedEffect.getParameters()) {
      ((LXListenableParameter) p).addListener(this);
      sendKnob(16 + i++, p);
    }
    while (i < 4) {
      sendKnob(16 + i++, 0);
    }
  }

  private void sendKnob(int i, LXParameter p) {
    float pv = constrain(p.getValuef(), 0, 1);
    if (p instanceof LXNormalizedParameter) {
      pv = ((LXNormalizedParameter)p).getNormalizedf();
    }
    sendKnob(i, (int) (pv * 127.));
  }
  
  private void sendKnob(int i, int value) {
      output.sendController(0, i, value);
    } 
  
  public void onParameterChanged(LXParameter parameter) {
    int i = 0;
    for (LXParameter p : focusedPattern.getParameters()) {
      if (p == parameter) {
        sendKnob(i, p);
        break;
      }
      ++i;
    }
    i = 16;
    for (LXParameter p : focusedEffect.getParameters()) {
      if (p == parameter) {
        sendKnob(i, p);
        break;
      }
      ++i;
    }
  }
  
  public void setGridState(int row, int col, int state) {
    output.sendNoteOn(row, col, state); 
    // if (col < 8 && row < 5) {
    //   output.sendNoteOn(col, 53+row, state);
    //}
  }
}



class ArturiaMinilabMidiInput extends GenericDeviceMidiInput {
  ArturiaMinilabMidiInput(MidiEngine midiEngine, MidiInputDevice d) {
    super(midiEngine, d);
  }
  
  protected boolean handleControllerChange(rwmidi.Controller cc) {
    int parameterIndex = -1;
    switch (cc.getCC()) {
      case 7:   parameterIndex = 0; break;
      case 74:  parameterIndex = 1; break;
      case 71:  parameterIndex = 2; break;
      case 76:  parameterIndex = 3; break;
      case 114: parameterIndex = 4; break;
      case 18:  parameterIndex = 5; break;
      case 19:  parameterIndex = 6; break;
      case 16:  parameterIndex = 7; break;
      
      case 75:
        float val = effects.colorFucker.hueShift.getValuef();
        val += (cc.getValue() - 64) / 256.;
        effects.colorFucker.hueShift.setNormalized((val+1) % 1);
        break;
    }
    if (parameterIndex >= 0) {
      List<LXParameter> parameters = midiEngine.getFocusedPattern().getParameters();
      if (parameterIndex < parameters.size()) {
        LXParameter p = parameters.get(parameterIndex);
        float curVal = p.getValuef();
        curVal += (cc.getValue() - 64) / 127.;
        setNormalized(p, constrain(curVal, 0, 1));
      }
    }
    return false;
  }
}

interface GridOutput {
  public static final int OFF = 0;
  public static final int GREEN = 1;
  public static final int GREEN_BLINK = 2;
  public static final int RED = 3;
  public static final int RED_BLINK = 4;
  public static final int YELLOW = 5;
  public static final int YELLOW_BLINK = 6;
  public static final int ON = 127;
  
  public void setGridState(int row, int col, int state);
}

class GridController {
  private final List<GridOutput> goutputs = new ArrayList<GridOutput>();
  
  private final MidiEngine midiEngine;
  
  GridController(MidiEngine midiEngine) {
    this.midiEngine = midiEngine;
  }
  
  public void addOutput(GridOutput output) {
    goutputs.add(output);
  }
  
  public boolean gridPressed(int row, int col) {
    return midiEngine.getFocusedPattern().gridPressed(row, col);
  }
  
  public boolean gridReleased(int row, int col) {
    return midiEngine.getFocusedPattern().gridReleased(row, col);
  }
  
  public void setState(int row, int col, int state) {
    for (GridOutput g : goutputs) {
      g.setGridState(row, col, state);
    }
  }
}

