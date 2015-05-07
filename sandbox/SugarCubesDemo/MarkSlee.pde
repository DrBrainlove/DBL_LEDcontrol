class Cathedrals extends SCPattern {
  
  private final BasicParameter xpos = new BasicParameter("XPOS", 0.5);
  private final BasicParameter wid = new BasicParameter("WID", 0.5);
  private final BasicParameter arms = new BasicParameter("ARMS", 0.5);
  private final BasicParameter sat = new BasicParameter("SAT", 0.5);
  private GraphicEQ eq;
  
  Cathedrals(LX lx) {
    super(lx);
    addParameter(xpos);
    addParameter(wid);
    addParameter(arms);
    addParameter(sat);
  }
 
  void onActive() {
    if (eq == null) {
      eq = new GraphicEQ(lx.audioInput());
      eq.slope.setValue(6);
      eq.range.setValue(36);
      eq.attack.setValue(10);
      eq.release.setValue(640);
      addParameter(eq.gain);
      addParameter(eq.range);
      addParameter(eq.attack);
      addParameter(eq.release);
      addParameter(eq.slope);
      addModulator(eq).start();
    }
  }

 
  public void run(double deltaMs) {
    float bassLevel = eq.getAveragef(0, 4);
    float trebleLevel = eq.getAveragef(8, 6);
    
    float falloff = 100 / (2 + 14*wid.getValuef());
    float cx = model.xMin + (model.xMax-model.xMin) * xpos.getValuef();
    float barm = 12 + 60*arms.getValuef()*max(0, 2*(bassLevel-0.1));
    float tarm = 12 + 60*arms.getValuef()*max(0, 2*(trebleLevel-0.1));
    
    float arm = 0;
    float middle = 0;
    
    float sf = 100. / (70 - 69.9*sat.getValuef());

    for (LXPoint p : model.points) {
      float d = MAX_FLOAT;
      if (p.y > model.cy) {
        arm = tarm;
        middle = model.yMax * 3/5.;
      } else {
        arm = barm;
        middle = model.yMax * 1/5.;
      }
      if (abs(p.x - cx) < arm) {
        d = min(abs(p.x - cx), abs(p.y - middle));
      }
      colors[p.index] = lx.hsb(
        (lx.getBaseHuef() + .2*abs(p.y - model.cy)) % 360,
        min(100, sf*dist(abs(p.x - cx), p.y, arm, middle)),
        constrain(120 - d*falloff, 0, 100));
    }
  } 
}
  
class MidiMusic extends SCPattern {
  
  private final Stack<LXLayer> newLayers = new Stack<LXLayer>();
  
  private final Map<Integer, LightUp> lightMap = new HashMap<Integer, LightUp>();
  private final List<LightUp> lights = new ArrayList<LightUp>();
  private final BasicParameter lightSize = new BasicParameter("SIZE", 0.5);

  private final List<Sweep> sweeps = new ArrayList<Sweep>();

  private final LinearEnvelope sparkle = new LinearEnvelope(0, 1, 500);
  private boolean sparkleDirection = true;
  private float sparkleBright = 100;
  
  private final BasicParameter wave = new BasicParameter("WAVE", 0);
  
  MidiMusic(LX lx) {
    super(lx);
    addParameter(lightSize);
    addParameter(wave);
    addModulator(sparkle).setValue(1);
  }
  
  void onReset() {
    for (LightUp light : lights) {
      light.noteOff(null);
    }
  }
  
  class Sweep extends LXLayer {
    
    final LinearEnvelope position = new LinearEnvelope(0, 1, 1000);
    float bright = 100;
    float falloff = 10;
    
    Sweep() {
      super(MidiMusic.this.lx, MidiMusic.this);
      addModulator(position);
    }
    
    public void run(double deltaMs) {
      if (!position.isRunning()) {
        return;
      }
      float posf = position.getValuef();
      for (LXPoint p : model.points) {
        blendColor(p.index, lx.hsb(
          (lx.getBaseHuef() + .2*abs(p.x - model.cx) + .2*abs(p.y - model.cy)) % 360,
          100,
          max(0, bright - posf*100 - falloff*abs(p.y - posf*model.yMax))
        ), LXColor.Blend.ADD);
      }
    }
  }
  
  class LightUp extends LXLayer {
    
    private final LinearEnvelope brt = new LinearEnvelope(0, 0, 0);
    private final Accelerator yPos = new Accelerator(0, 0, 0);
    private float xPos;
    
    LightUp() {
      super(MidiMusic.this.lx, MidiMusic.this);
      addModulator(brt);
      addModulator(yPos);
    }
    
    boolean isAvailable() {
      return brt.getValuef() <= 0;
    }
    
    void noteOn(Note note) {
      xPos = lerp(0, model.xMax, constrain(0.5 + (note.getPitch() - 60) / 28., 0, 1));
      yPos.setValue(lerp(20, model.yMax*.72, note.getVelocity() / 127.)).stop();
      brt.setRangeFromHereTo(lerp(40, 100, note.getVelocity() / 127.), 20).start();     
    }

    void noteOff(Note note) {
      yPos.setVelocity(0).setAcceleration(-380).start();
      brt.setRangeFromHereTo(0, 1000).start();
    }
    
    public void run(double deltaMs) {
      float bVal = brt.getValuef();
      if (bVal <= 0) {
        return;
      }
      float yVal = yPos.getValuef();
      for (LXPoint p : model.points) {
        float falloff = 6 - 5*lightSize.getValuef();
        float b = max(0, bVal - falloff*dist(p.x, p.y, xPos, yVal));
        if (b > 0) {
          blendColor(p.index, lx.hsb(
            (lx.getBaseHuef() + .2*abs(p.x - model.cx) + .2*abs(p.y - model.cy)) % 360,
            100,
            b
          ), LXColor.Blend.ADD);
        }
      }
    }
  }
  
  private LightUp getLight() {
    for (LightUp light : lights) {
      if (light.isAvailable()) {
        return light;
      }
    }
    LightUp newLight = new LightUp();
    lights.add(newLight);
    synchronized(newLayers) {
      newLayers.push(newLight);
    }
    return newLight;
  }
  
  private Sweep getSweep() {
    for (Sweep s : sweeps) {
      if (!s.position.isRunning()) {
        return s;
      }
    }
    Sweep newSweep = new Sweep();
    sweeps.add(newSweep);
    synchronized(newLayers) {
      newLayers.push(newSweep);
    }
    return newSweep;
  }
  
  public synchronized boolean noteOn(Note note) {
    if (note.getChannel() == 0) {
      LightUp light = getLight();
      lightMap.put(note.getPitch(), light);
      light.noteOn(note);
    } else if (note.getChannel() == 1) {
    } else if (note.getChannel() == 9) {
      if (note.getVelocity() > 0) {
        switch (note.getPitch()) {
          case 36:
            Sweep s = getSweep();
            s.bright = 50 + note.getVelocity() / 127. * 50;
            s.falloff = 20 - note.getVelocity() / 127. * 17;
            s.position.trigger();
            break;
          case 37:
            sparkleBright = note.getVelocity() / 127. * 100;
            sparkleDirection = true;
            sparkle.trigger();
            break;
          case 38:
            sparkleBright = note.getVelocity() / 127. * 100;
            sparkleDirection = false;
            sparkle.trigger();       
            break;
          case 39:
            effects.boom.trigger();
            break;
          case 40:
            //effects.flash.trigger();
            break;
        }
      }
    }
    return true;
  }
  
  public synchronized boolean noteOff(Note note) {
    if (note.getChannel() == 0) {
      LightUp light = lightMap.get(note.getPitch());
      if (light != null) {
        light.noteOff(note);
      }
    }
    return true;
  }
  
  final float[] wval = new float[16];
  float wavoff = 0;
  
  public synchronized void run(double deltaMs) {
    wavoff += deltaMs * .001;
    for (int i = 0; i < wval.length; ++i) {
      wval[i] = model.cy + 0.2 * model.yMax/2. * sin(wavoff + i / 1.9);
    }
    float sparklePos = (sparkleDirection ? sparkle.getValuef() : (1 - sparkle.getValuef())) * (Cube.POINTS_PER_STRIP)/2.;
    float maxBright = sparkleBright * (1 - sparkle.getValuef());
    for (Strip s : model.strips) {
      int i = 0;
      for (LXPoint p : s.points) {
        int wavi = (int) constrain(p.x / model.xMax * wval.length, 0, wval.length-1);
        float wavb = max(0, wave.getValuef()*100. - 8.*abs(p.y - wval[wavi]));
        colors[p.index] = lx.hsb(
          (lx.getBaseHuef() + .2*abs(p.x - model.cx) + .2*abs(p.y - model.cy)) % 360,
          100,
          constrain(wavb + max(0, maxBright - 40.*abs(sparklePos - abs(i - (Cube.POINTS_PER_STRIP-1)/2.))), 0, 100)
        );
        ++i;
      }
    }
        
    if (!newLayers.isEmpty()) {
      synchronized(newLayers) {
        while (!newLayers.isEmpty()) {
          addLayer(newLayers.pop());
        }
      }
    }
  }
}

class Pulley extends SCPattern {
  
  final int NUM_DIVISIONS = 16;
  private final Accelerator[] gravity = new Accelerator[NUM_DIVISIONS];
  private final Click[] delays = new Click[NUM_DIVISIONS];
  
  private final Click reset = new Click(9000);
  private boolean isRising = false;
  
  private BasicParameter sz = new BasicParameter("SIZE", 0.5);
  private BasicParameter beatAmount = new BasicParameter("BEAT", 0);
  
  Pulley(LX lx) {
    super(lx);
    for (int i = 0; i < NUM_DIVISIONS; ++i) {
      addModulator(gravity[i] = new Accelerator(0, 0, 0));
      addModulator(delays[i] = new Click(0));
    }
    addModulator(reset).start();
    addParameter(sz);
    addParameter(beatAmount);
    trigger();

  }
  
  private void trigger() {
    isRising = !isRising;
    int i = 0;
    for (Accelerator g : gravity) {
      if (isRising) {
        g.setSpeed(random(20, 33), 0).start();
      } else {
        g.setVelocity(0).setAcceleration(-420);
        delays[i].setDuration(random(0, 500)).trigger();
      }
      ++i;
    }
  }
  
  public void run(double deltaMs) {
    if (reset.click()) {
      trigger();
    }
        
    if (isRising) {
      // Fucking A, had to comment this all out because of that bizarre
      // Processing bug where some simple loop takes an absurd amount of
      // time, must be some pre-processor bug
//      for (Accelerator g : gravity) {
//        if (g.getValuef() > model.yMax) {
//          g.stop();
//        } else if (g.getValuef() > model.yMax*.55) {
//          if (g.getVelocityf() > 10) {
//            g.setAcceleration(-16);
//          } else {
//            g.setAcceleration(0);
//          }
//        }
//      }
    } else {
      int j = 0;
      for (Click d : delays) {
        if (d.click()) {
          gravity[j].start();
          d.stop();
        }
        ++j;
      }
      for (Accelerator g : gravity) {
        if (g.getValuef() < 0) {
          g.setValue(-g.getValuef());
          g.setVelocity(-g.getVelocityf() * random(0.74, 0.84));
        }
      }
    }

    // A little silliness to test the grid API    
    if (midiEngine != null && midiEngine.getFocusedPattern() == this) {
	    for (int i = 0; i < 5; ++i) {
        for (int j = 0; j < 8; ++j) {
          int gi = (int) constrain(j * NUM_DIVISIONS / 8, 0, NUM_DIVISIONS-1);
          float b = 1 - 4.*abs((6-i)/6. - gravity[gi].getValuef() / model.yMax);
          midiEngine.grid.setState(i, j, (b < 0) ? 0 : 3);
        }
      }
    }
    
    float fPos = 1 - lx.tempo.rampf();
    if (fPos < .2) {
      fPos = .2 + 4 * (.2 - fPos);
    }
    float falloff = 100. / (3 + sz.getValuef() * 36 + fPos * beatAmount.getValuef()*48);
    for (LXPoint p : model.points) {
      int gi = (int) constrain((p.x - model.xMin) * NUM_DIVISIONS / (model.xMax - model.xMin), 0, NUM_DIVISIONS-1);
      colors[p.index] = lx.hsb(
        (lx.getBaseHuef() + abs(p.x - model.cx)*.8 + p.y*.4) % 360,
        constrain(130 - p.y*.8, 0, 100),
        max(0, 100 - abs(p.y - gravity[gi].getValuef())*falloff)
      );
    }
  }
}

class ViolinWave extends SCPattern {
  
  BasicParameter level = new BasicParameter("LVL", 0.45);
  BasicParameter range = new BasicParameter("RNG", 0.5);
  BasicParameter edge = new BasicParameter("EDG", 0.5);
  BasicParameter release = new BasicParameter("RLS", 0.5);
  BasicParameter speed = new BasicParameter("SPD", 0.5);
  BasicParameter amp = new BasicParameter("AMP", 0.25);
  BasicParameter period = new BasicParameter("WAVE", 0.5);
  BasicParameter pSize = new BasicParameter("PSIZE", 0.5);
  BasicParameter pSpeed = new BasicParameter("PSPD", 0.5);
  BasicParameter pDensity = new BasicParameter("PDENS", 0.25);
  
  LinearEnvelope dbValue = new LinearEnvelope(0, 0, 10);
  
  ViolinWave(LX lx) {
    super(lx);
    addParameter(level);
    addParameter(edge);
    addParameter(range);
    addParameter(release);
    addParameter(speed);
    addParameter(amp);
    addParameter(period);
    addParameter(pSize);
    addParameter(pSpeed);
    addParameter(pDensity);

    addModulator(dbValue);
  }
  
  final List<Particle> particles = new ArrayList<Particle>();
  
  class Particle {
    
    LinearEnvelope x = new LinearEnvelope(0, 0, 0);
    LinearEnvelope y = new LinearEnvelope(0, 0, 0);
    
    Particle() {
      addModulator(x);
      addModulator(y);
    }
    
    Particle trigger(boolean direction) {
      float xInit = random(model.xMin, model.xMax);
      float time = 3000 - 2500*pSpeed.getValuef();
      x.setRange(xInit, xInit + random(-40, 40), time).trigger();
      y.setRange(model.cy + 10, direction ? model.yMax + 50 : model.yMin - 50, time).trigger();
      return this;
    }
    
    boolean isActive() {
      return x.isRunning() || y.isRunning();
    }
    
    public void run(double deltaMs) {
      if (!isActive()) {
        return;
      }
      
      float pFalloff = (30 - 27*pSize.getValuef());
      for (LXPoint p : model.points) {
        float b = 100 - pFalloff * (abs(p.x - x.getValuef()) + abs(p.y - y.getValuef()));
        if (b > 0) {
          blendColor(p.index, lx.hsb(
            lx.getBaseHuef(), 20, b
          ), LXColor.Blend.ADD);
        }
      }
    }
  }
  
  float[] centers = new float[30];
  double accum = 0;
  boolean rising = true;
  
  void fireParticle(boolean direction) {
    boolean gotOne = false;
    for (Particle p : particles) {
      if (!p.isActive()) {
       p.trigger(direction);
       return;
      }
    }
    particles.add(new Particle().trigger(direction));
  }
  
  final double LOG_10 = Math.log(10);
  
  public void run(double deltaMs) {
    accum += deltaMs / (1000. - 900.*speed.getValuef());
    for (int i = 0; i < centers.length; ++i) {
      centers[i] = model.cy + 30*amp.getValuef()*sin((float) (accum + (i-centers.length/2.)/(1. + 9.*period.getValuef())));
    }
    
    float zeroDBReference = pow(10, (50 - 190*level.getValuef())/20.);
    float dB = (float) (20*Math.log(lx.audioInput().mix.level() / zeroDBReference) / LOG_10);
    if (dB > dbValue.getValuef()) {
      rising = true;
      dbValue.setRangeFromHereTo(dB, 10).trigger();
    } else {
      if (rising) {
        for (int j = 0; j < pDensity.getValuef()*3; ++j) {
          fireParticle(true);
          fireParticle(false);
        }
      }
      rising = false;
      dbValue.setRangeFromHereTo(max(dB, -96), 50 + 1000*release.getValuef()).trigger();
    }
    float edg = 1 + edge.getValuef() * 40;
    float rng = (78 - 64 * range.getValuef()) / (model.yMax - model.cy);
    float val = max(2, dbValue.getValuef());
    
    for (LXPoint p : model.points) {
      int ci = (int) lerp(0, centers.length-1, (p.x - model.xMin) / (model.xMax - model.xMin));
      float rFactor = 1.0 -  0.9 * abs(p.x - model.cx) / (model.xMax - model.cx);
      colors[p.index] = lx.hsb(
        (lx.getBaseHuef() + abs(p.x - model.cx)) % 360,
        min(100, 20 + 8*abs(p.y - centers[ci])),
        constrain(edg*(val*rFactor - rng * abs(p.y-centers[ci])), 0, 100)
      );
    }
    
    for (Particle p : particles) {
      p.run(deltaMs);
    }
  }
}

class BouncyBalls extends SCPattern {
  
  static final int NUM_BALLS = 6;
  
  class BouncyBall {
       
    Accelerator yPos;
    TriangleLFO xPos = new TriangleLFO(0, model.xMax, random(8000, 19000));
    float zPos;
    
    BouncyBall(int i) {
      addModulator(xPos.setBasis(random(0, TWO_PI))).start();
      addModulator(yPos = new Accelerator(0, 0, 0));
      zPos = lerp(model.zMin, model.zMax, (i+2.) / (NUM_BALLS + 4.));
    }
    
    void bounce(float midiVel) {
      float v = 100 + 8*midiVel;
      yPos.setSpeed(v, getAccel(v, 60 / lx.tempo.bpmf())).start();
    }
    
    float getAccel(float v, float oneBeat) {
      return -2*v / oneBeat;
    }
    
    void run(double deltaMs) {
      float flrLevel = flr.getValuef() * model.xMax/2.;
      if (yPos.getValuef() < flrLevel) {
        if (yPos.getVelocity() < -50) {
          yPos.setValue(2*flrLevel-yPos.getValuef());
          float v = -yPos.getVelocityf() * bounce.getValuef();
          yPos.setSpeed(v, getAccel(v, 60 / lx.tempo.bpmf()));
        } else {
          yPos.setValue(flrLevel).stop();
        }
      }
      float falloff = 130.f / (12 + blobSize.getValuef() * 36);
      float xv = xPos.getValuef();
      float yv = yPos.getValuef();
      
      for (LXPoint p : model.points) {
        float d = sqrt((p.x-xv)*(p.x-xv) + (p.y-yv)*(p.y-yv) + .1*(p.z-zPos)*(p.z-zPos));
        float b = constrain(130 - falloff*d, 0, 100);
        if (b > 0) {
          blendColor(p.index, lx.hsb(
            (lx.getBaseHuef() + p.y*.5 + abs(model.cx - p.x) * .5) % 360,
            max(0, 100 - .45*(p.y - flrLevel)),
            b
          ), LXColor.Blend.ADD);
        }
      }
    }
  }
  
  final BouncyBall[] balls = new BouncyBall[NUM_BALLS];
  
  final BasicParameter bounce = new BasicParameter("BNC", .8);
  final BasicParameter flr = new BasicParameter("FLR", 0);
  final BasicParameter blobSize = new BasicParameter("SIZE", 0.5);
  
  BouncyBalls(LX lx) {
    super(lx);
    for (int i = 0; i < balls.length; ++i) {
      balls[i] = new BouncyBall(i);
    }
    addParameter(bounce);
    addParameter(flr);
    addParameter(blobSize);
  }
  
  public void run(double deltaMs) {
    setColors(#000000);
    for (BouncyBall b : balls) {
      b.run(deltaMs);
    }
  }
  
  public boolean noteOn(Note note) {
    int pitch = (note.getPitch() + note.getChannel()) % NUM_BALLS;
    balls[pitch].bounce(note.getVelocity());
    return true;
  }
}

class SpaceTime extends SCPattern {

  SinLFO pos = new SinLFO(0, 1, 3000);
  SinLFO rate = new SinLFO(1000, 9000, 13000);
  SinLFO falloff = new SinLFO(10, 70, 5000);
  float angle = 0;

  BasicParameter rateParameter = new BasicParameter("RATE", 0.5);
  BasicParameter sizeParameter = new BasicParameter("SIZE", 0.5);


  public SpaceTime(LX lx) {
    super(lx);
    
    addModulator(pos).trigger();
    addModulator(rate).trigger();
    addModulator(falloff).trigger();    
    pos.modulateDurationBy(rate);
    addParameter(rateParameter);
    addParameter(sizeParameter);
  }

  public void onParameterChanged(LXParameter parameter) {
    if (parameter == rateParameter) {
      rate.stop();
      rate.setValue(9000 - 8000*parameter.getValuef());
    }  else if (parameter == sizeParameter) {
      falloff.stop();
      falloff.setValue(70 - 60*parameter.getValuef());
    }
  }

  void run(double deltaMs) {    
    angle += deltaMs * 0.0007;
    float sVal1 = model.strips.size() * (0.5 + 0.5*sin(angle));
    float sVal2 = model.strips.size() * (0.5 + 0.5*cos(angle));

    float pVal = pos.getValuef();
    float fVal = falloff.getValuef();

    int s = 0;
    for (Strip strip : model.strips) {
      int i = 0;
      for (LXPoint p : strip.points) {
        colors[p.index] = lx.hsb(
          (lx.getBaseHuef() + 360 - p.x*.2 + p.y * .3) % 360, 
          constrain(.4 * min(abs(s - sVal1), abs(s - sVal2)), 20, 100),
          max(0, 100 - fVal*abs(i - pVal*(strip.metrics.numPoints - 1)))
        );
        ++i;
      }
      ++s;
    }
  }
}

class Swarm extends SCPattern {
  
  SawLFO offset = new SawLFO(0, 1, 1000);
  SinLFO rate = new SinLFO(350, 1200, 63000);
  SinLFO falloff = new SinLFO(15, 50, 17000);
  SinLFO fX = new SinLFO(model.xMin, model.xMax, 19000);
  SinLFO fY = new SinLFO(model.yMin, model.yMax, 11000);
  SinLFO hOffX = new SinLFO(model.xMin, model.xMax, 13000);

  public Swarm(LX lx) {
    super(lx);
    
    addModulator(offset).trigger();
    addModulator(rate).trigger();
    addModulator(falloff).trigger();
    addModulator(fX).trigger();
    addModulator(fY).trigger();
    addModulator(hOffX).trigger();
    offset.modulateDurationBy(rate);
  }

  float modDist(float v1, float v2, float mod) {
    v1 = v1 % mod;
    v2 = v2 % mod;
    if (v2 > v1) {
      return min(v2-v1, v1+mod-v2);
    } 
    else {
      return min(v1-v2, v2+mod-v1);
    }
  }

  void run(double deltaMs) {
    float s = 0;
    for (Strip strip : model.strips) {
      int i = 0;
      for (LXPoint p : strip.points) {
        float fV = max(-1, 1 - dist(p.x/2., p.y, fX.getValuef()/2., fY.getValuef()) / 64.);
        colors[p.index] = lx.hsb(
        (lx.getBaseHuef() + 0.3 * abs(p.x - hOffX.getValuef())) % 360, 
        constrain(80 + 40 * fV, 0, 100), 
        constrain(100 - 
          (30 - fV * falloff.getValuef()) * modDist(i + (s*63)%61, offset.getValuef() * strip.metrics.numPoints, strip.metrics.numPoints), 0, 100)
          );
        ++i;
      } 
      ++s;
    }
  }
}

class SwipeTransition extends LXTransition {
  
  final BasicParameter bleed = new BasicParameter("WIDTH", 0.5);
  
  SwipeTransition(LX lx) {
    super(lx);
    setDuration(5000);
    addParameter(bleed);
  }

  void computeBlend(int[] c1, int[] c2, double progress) {
    float bleedf = 10 + bleed.getValuef() * 200.;
    float xPos = (float) (-bleedf + progress * (model.xMax + bleedf));
    for (LXPoint p : model.points) {
      float d = (p.x - xPos) / bleedf;
      if (d < 0) {
        colors[p.index] = c2[p.index];
      } else if (d > 1) {
        colors[p.index] = c1[p.index];
      } else {
        colors[p.index] = lerpColor(c2[p.index], c1[p.index], d, RGB);
      }
    }
  }
}

class BassPod extends SCPattern {

  private GraphicEQ eq = null;
  
  private final BasicParameter clr = new BasicParameter("CLR", 0.5);
  
  public BassPod(LX lx) {
    super(lx);
    addParameter(clr);
  }
  
  void onActive() {
    if (eq == null) {
      eq = new GraphicEQ(lx.audioInput());
      eq.range.setValue(36);
      eq.release.setValue(800);
      eq.gain.setValue(-6);
      eq.slope.setValue(6);
      addParameter(eq.gain);
      addParameter(eq.range);
      addParameter(eq.attack);
      addParameter(eq.release);
      addParameter(eq.slope);
      addModulator(eq).start();
    }
  }

  public void run(double deltaMs) {
    
    float bassLevel = eq.getAveragef(0, 5);
    
    float satBase = bassLevel*480*clr.getValuef();
    
    for (LXPoint p : model.points) {
      int avgIndex = (int) constrain(1 + abs(p.x-model.cx)/(model.cx)*(eq.numBands-5), 0, eq.numBands-5);
      float value = 0;
      for (int i = avgIndex; i < avgIndex + 5; ++i) {
        value += eq.getBandf(i);
      }
      value /= 5.;

      float b = constrain(8 * (value*model.yMax - abs(p.y-model.yMax/2.)), 0, 100);
      colors[p.index] = lx.hsb(
        (lx.getBaseHuef() + abs(p.y - model.cy) + abs(p.x - model.cx)) % 360,
        constrain(satBase - .6*dist(p.x, p.y, model.cx, model.cy), 0, 100),
        b
      );
    }
  }
}


class CubeEQ extends SCPattern {

  private GraphicEQ eq = null;

  private final BasicParameter edge = new BasicParameter("EDGE", 0.5);
  private final BasicParameter clr = new BasicParameter("CLR", 0.5);
  private final BasicParameter blockiness = new BasicParameter("BLK", 0.5);

  public CubeEQ(LX lx) {
    super(lx);
  }

  void onActive() {
    if (eq == null) {
      eq = new GraphicEQ(lx.audioInput());
      eq.range.setValue(48);
      eq.release.setValue(800);
      addParameter(eq.gain);
      addParameter(eq.range);
      addParameter(eq.attack);
      addParameter(eq.release);
      addParameter(eq.slope);
      addParameter(edge);
      addParameter(clr);
      addParameter(blockiness);
      addModulator(eq).start();
    }
  }

  public void run(double deltaMs) {

    float edgeConst = 2 + 30*edge.getValuef();
    float clrConst = 1.1 + clr.getValuef();

    for (LXPoint p : model.points) {
      float avgIndex = constrain(2 + p.x / model.xMax * (eq.numBands-4), 0, eq.numBands-4);
      int avgFloor = (int) avgIndex;

      float leftVal = eq.getBandf(avgFloor);
      float rightVal = eq.getBandf(avgFloor+1);
      float smoothValue = lerp(leftVal, rightVal, avgIndex-avgFloor);
      
      float chunkyValue = (
        eq.getBandf(avgFloor/4*4) +
        eq.getBandf(avgFloor/4*4 + 1) +
        eq.getBandf(avgFloor/4*4 + 2) +
        eq.getBandf(avgFloor/4*4 + 3)
      ) / 4.; 
      
      float value = lerp(smoothValue, chunkyValue, blockiness.getValuef());

      float b = constrain(edgeConst * (value*model.yMax - p.y), 0, 100);
      colors[p.index] = lx.hsb(
        (480 + lx.getBaseHuef() - min(clrConst*p.y, 120)) % 360, 
        100, 
        b
      );
    }
  }
}

class BoomEffect extends LXEffect {

  final BasicParameter falloff = new BasicParameter("WIDTH", 0.5);
  final BasicParameter speed = new BasicParameter("SPD", 0.5);
  final BasicParameter bright = new BasicParameter("BRT", 1.0);
  final BasicParameter sat = new BasicParameter("SAT", 0.2);
  List<Layer> layers = new ArrayList<Layer>();
  final float maxr = sqrt(model.xMax*model.xMax + model.yMax*model.yMax + model.zMax*model.zMax) + 10;

  class Layer {
    LinearEnvelope boom = new LinearEnvelope(-40, 500, 1300);

    Layer() {
      addModulator(boom);
      trigger();
    }

    void trigger() {
      float falloffv = falloffv();
      boom.setRange(-100 / falloffv, maxr + 100/falloffv, 4000 - speed.getValuef() * 3300);
      boom.trigger();
    }

    void run(double deltaMs) {
      float brightv = 100 * bright.getValuef();
      float falloffv = falloffv();
      float satv = sat.getValuef() * 100;
      float huev = lx.getBaseHuef();
      for (LXPoint p : model.points) {
        addColor(p.index, lx.hsb(
          huev,
          satv,
          constrain(brightv - falloffv*abs(boom.getValuef() - dist(p.x, 2*p.y, 3*p.z, model.xMax/2, model.yMax, model.zMax*1.5)), 0, 100)) 
        );
      }
    }
  }

  BoomEffect(LX lx) {
    super(lx, true);
    addParameter(falloff);
    addParameter(speed);
    addParameter(bright);
    addParameter(sat);
  }

  public void onEnable() {
    for (Layer l : layers) {
      if (!l.boom.isRunning()) {
        l.trigger();
        return;
      }
    }
    layers.add(new Layer());
  }

  private float falloffv() {
    return 20 - 19 * falloff.getValuef();
  }

  public void onTrigger() {
    onEnable();
  }

  public void run(double deltaMs) {
    for (Layer l : layers) {
      if (l.boom.isRunning()) {
        l.run(deltaMs);
      }
    }
  }
}

public class PianoKeyPattern extends SCPattern {
  
  final LinearEnvelope[] cubeBrt;
  final SinLFO base[];  
  final BasicParameter attack = new BasicParameter("ATK", 0.1);
  final BasicParameter release = new BasicParameter("REL", 0.5);
  final BasicParameter level = new BasicParameter("AMB", 0.6);
  
  PianoKeyPattern(LX lx) {
    super(lx);
        
    addParameter(attack);
    addParameter(release);
    addParameter(level);
    cubeBrt = new LinearEnvelope[model.cubes.size() / 4];
    for (int i = 0; i < cubeBrt.length; ++i) {
      addModulator(cubeBrt[i] = new LinearEnvelope(0, 0, 100));
    }
    base = new SinLFO[model.cubes.size() / 12];
    for (int i = 0; i < base.length; ++i) {
      addModulator(base[i] = new SinLFO(0, 1, 7000 + 1000*i)).trigger();
    }
  }
  
  private float getAttackTime() {
    return 15 + attack.getValuef()*attack.getValuef() * 2000;
  }
  
  private float getReleaseTime() {
    return 15 + release.getValuef() * 3000;
  }
  
  private LinearEnvelope getEnvelope(int index) {
    return cubeBrt[index % cubeBrt.length];
  }
  
  private SinLFO getBase(int index) {
    return base[index % base.length];
  }
    
  public boolean noteOn(Note note) {
    LinearEnvelope env = getEnvelope(note.getPitch());
    env.setEndVal(min(1, env.getValuef() + (note.getVelocity() / 127.)), getAttackTime()).start();
    return true;
  }
  
  public boolean noteOff(Note note) {
    getEnvelope(note.getPitch()).setEndVal(0, getReleaseTime()).start();
    return true;
  }
  
  public void run(double deltaMs) {
    int i = 0;
    float huef = lx.getBaseHuef();
    float levelf = level.getValuef();
    for (Cube c : model.cubes) {
      float v = max(getBase(i).getValuef() * levelf/4., getEnvelope(i++).getValuef());
      setColor(c, lx.hsb(
        (huef + 20*v + abs(c.cx-model.xMax/2.)*.3 + c.cy) % 360,
        min(100, 120*v),
        100*v
      ));
    }
  }
}

class CrossSections extends SCPattern {
  
  final SinLFO x = new SinLFO(0, model.xMax, 5000);
  final SinLFO y = new SinLFO(0, model.yMax, 6000);
  final SinLFO z = new SinLFO(0, model.zMax, 7000);
  
  final BasicParameter xw = new BasicParameter("XWID", 0.3);
  final BasicParameter yw = new BasicParameter("YWID", 0.3);
  final BasicParameter zw = new BasicParameter("ZWID", 0.3);  
  final BasicParameter xr = new BasicParameter("XRAT", 0.7);
  final BasicParameter yr = new BasicParameter("YRAT", 0.6);
  final BasicParameter zr = new BasicParameter("ZRAT", 0.5);
  final BasicParameter xl = new BasicParameter("XLEV", 1);
  final BasicParameter yl = new BasicParameter("YLEV", 1);
  final BasicParameter zl = new BasicParameter("ZLEV", 0.5);

  
  CrossSections(LX lx) {
    super(lx);
    addModulator(x).trigger();
    addModulator(y).trigger();
    addModulator(z).trigger();
    addParams();
  }
  
  protected void addParams() {
    addParameter(xr);
    addParameter(yr);
    addParameter(zr);    
    addParameter(xw);
    addParameter(xl);
    addParameter(yl);
    addParameter(zl);
    addParameter(yw);    
    addParameter(zw);
  }
  
  void onParameterChanged(LXParameter p) {
    if (p == xr) {
      x.setDuration(10000 - 8800*p.getValuef());
    } else if (p == yr) {
      y.setDuration(10000 - 9000*p.getValuef());
    } else if (p == zr) {
      z.setDuration(10000 - 9000*p.getValuef());
    }
  }
  
  float xv, yv, zv;
  
  protected void updateXYZVals() {
    xv = x.getValuef();
    yv = y.getValuef();
    zv = z.getValuef();    
  }

  public void run(double deltaMs) {
    updateXYZVals();
    
    float xlv = 100*xl.getValuef();
    float ylv = 100*yl.getValuef();
    float zlv = 100*zl.getValuef();
    
    float xwv = 100. / (10 + 40*xw.getValuef());
    float ywv = 100. / (10 + 40*yw.getValuef());
    float zwv = 100. / (10 + 40*zw.getValuef());
    
    for (LXPoint p : model.points) {
      color c = 0;
      c = PImage.blendColor(c, lx.hsb(
      (lx.getBaseHuef() + p.x/10 + p.y/3) % 360, 
      constrain(140 - 1.1*abs(p.x - model.xMax/2.), 0, 100), 
      max(0, xlv - xwv*abs(p.x - xv))
        ), ADD);
      c = PImage.blendColor(c, lx.hsb(
      (lx.getBaseHuef() + 80 + p.y/10) % 360, 
      constrain(140 - 2.2*abs(p.y - model.yMax/2.), 0, 100), 
      max(0, ylv - ywv*abs(p.y - yv))
        ), ADD); 
      c = PImage.blendColor(c, lx.hsb(
      (lx.getBaseHuef() + 160 + p.z / 10 + p.y/2) % 360, 
      constrain(140 - 2.2*abs(p.z - model.zMax/2.), 0, 100), 
      max(0, zlv - zwv*abs(p.z - zv))
        ), ADD); 
      colors[p.index] = c;
    }
  }
}

class Blinders extends SCPattern {
    
  final SinLFO[] m;
  final TriangleLFO r;
  final SinLFO s;
  final TriangleLFO hs;

  public Blinders(LX lx) {
    super(lx);
    m = new SinLFO[12];
    for (int i = 0; i < m.length; ++i) {  
      addModulator(m[i] = new SinLFO(0.5, 120, (120000. / (3+i)))).trigger();
    }
    addModulator(r = new TriangleLFO(9000, 15000, 29000)).trigger();
    addModulator(s = new SinLFO(-20, 275, 11000)).trigger();
    addModulator(hs = new TriangleLFO(0.1, 0.5, 15000)).trigger();
    s.modulateDurationBy(r);
  }

  public void run(double deltaMs) {
    float hv = lx.getBaseHuef();
    int si = 0;
    for (Strip strip : model.strips) {
      int i = 0;
      float mv = m[si % m.length].getValuef();
      for (LXPoint p : strip.points) {
        colors[p.index] = lx.hsb(
          (hv + p.z + p.y*hs.getValuef()) % 360, 
          min(100, abs(p.x - s.getValuef())/2.), 
          max(0, 100 - mv/2. - mv * abs(i - (strip.metrics.length-1)/2.))
        );
        ++i;
      }
      ++si;
    }
  }
}

class Psychedelia extends SCPattern {
  
  final int NUM = 3;
  SinLFO m = new SinLFO(-0.5, NUM-0.5, 9000);
  SinLFO s = new SinLFO(-20, 147, 11000);
  TriangleLFO h = new TriangleLFO(0, 240, 19000);
  SinLFO c = new SinLFO(-.2, .8, 31000);

  Psychedelia(LX lx) {
    super(lx);
    addModulator(m).trigger();
    addModulator(s).trigger();
    addModulator(h).trigger();
    addModulator(c).trigger();
  }

  void run(double deltaMs) {
    float huev = h.getValuef();
    float cv = c.getValuef();
    float sv = s.getValuef();
    float mv = m.getValuef();
    int i = 0;
    for (Strip strip : model.strips) {
      for (LXPoint p : strip.points) {
        colors[p.index] = lx.hsb(
          (huev + i*constrain(cv, 0, 2) + p.z/2. + p.x/4.) % 360, 
          min(100, abs(p.y-sv)), 
          max(0, 100 - 50*abs((i%NUM) - mv))
        );
      }
      ++i;
    }
  }
}

class AskewPlanes extends SCPattern {
  
  class Plane {
    private final SinLFO a;
    private final SinLFO b;
    private final SinLFO c;
    float av = 1;
    float bv = 1;
    float cv = 1;
    float denom = 0.1;
    
    Plane(int i) {
      addModulator(a = new SinLFO(-1, 1, 4000 + 1029*i)).trigger();
      addModulator(b = new SinLFO(-1, 1, 11000 - 1104*i)).trigger();
      addModulator(c = new SinLFO(-50, 50, 4000 + 1000*i * ((i % 2 == 0) ? 1 : -1))).trigger();      
    }
    
    void run(double deltaMs) {
      av = a.getValuef();
      bv = b.getValuef();
      cv = c.getValuef();
      denom = sqrt(av*av + bv*bv);
    }
  }
    
  final Plane[] planes;
  final int NUM_PLANES = 3;
  
  AskewPlanes(LX lx) {
    super(lx);
    planes = new Plane[NUM_PLANES];
    for (int i = 0; i < planes.length; ++i) {
      planes[i] = new Plane(i);
    }
  }
  
  public void run(double deltaMs) {
    float huev = lx.getBaseHuef();
    
    // This is super fucking bizarre. But if this is a for loop, the framerate
    // tanks to like 30FPS, instead of 60. Call them manually and it works fine.
    // Doesn't make ANY sense... there must be some weird side effect going on
    // with the Processing internals perhaps?
//    for (Plane plane : planes) {
//      plane.run(deltaMs);
//    }
    planes[0].run(deltaMs);
    planes[1].run(deltaMs);
    planes[2].run(deltaMs);    
    
    for (LXPoint p : model.points) {
      float d = MAX_FLOAT;
      for (Plane plane : planes) {
        if (plane.denom != 0) {
          d = min(d, abs(plane.av*(p.x-model.cx) + plane.bv*(p.y-model.cy) + plane.cv) / plane.denom);
        }
      }
      colors[p.index] = lx.hsb(
        (huev + abs(p.x-model.cx)*.3 + p.y*.8) % 360,
        max(0, 100 - .8*abs(p.x - model.cx)),
        constrain(140 - 10.*d, 0, 100)
      );
    }
  }
}

class ShiftingPlane extends SCPattern {

  final SinLFO a = new SinLFO(-.2, .2, 5300);
  final SinLFO b = new SinLFO(1, -1, 13300);
  final SinLFO c = new SinLFO(-1.4, 1.4, 5700);
  final SinLFO d = new SinLFO(-10, 10, 9500);

  ShiftingPlane(LX lx) {
    super(lx);
    addModulator(a).trigger();
    addModulator(b).trigger();
    addModulator(c).trigger();
    addModulator(d).trigger();    
  }
  
  public void run(double deltaMs) {
    float hv = lx.getBaseHuef();
    float av = a.getValuef();
    float bv = b.getValuef();
    float cv = c.getValuef();
    float dv = d.getValuef();    
    float denom = sqrt(av*av + bv*bv + cv*cv);
    for (LXPoint p : model.points) {
      float d = abs(av*(p.x-model.cx) + bv*(p.y-model.cy) + cv*(p.z-model.cz) + dv) / denom;
      colors[p.index] = lx.hsb(
        (hv + abs(p.x-model.cx)*.6 + abs(p.y-model.cy)*.9 + abs(p.z - model.cz)) % 360,
        constrain(110 - d*6, 0, 100),
        constrain(130 - 7*d, 0, 100)
      );
    }
  }
}

class Traktor extends SCPattern {

  final int FRAME_WIDTH = 60;
  
  final BasicParameter speed = new BasicParameter("SPD", 0.5);
  
  private float[] bass = new float[FRAME_WIDTH];
  private float[] treble = new float[FRAME_WIDTH];
    
  private int index = 0;
  private GraphicEQ eq = null;

  public Traktor(LX lx) {
    super(lx);
    for (int i = 0; i < FRAME_WIDTH; ++i) {
      bass[i] = 0;
      treble[i] = 0;
    }
    addParameter(speed);
  }

  public void onActive() {
    if (eq == null) {
      eq = new GraphicEQ(lx.audioInput());
      eq.slope.setValue(6);
      eq.gain.setValue(12);
      eq.range.setValue(36);
      eq.release.setValue(500);
      addParameter(eq.gain);
      addParameter(eq.range);
      addParameter(eq.attack);
      addParameter(eq.release);
      addParameter(eq.slope);
      addModulator(eq).start();
    }
  }

  int counter = 0;
  
  public void run(double deltaMs) {
    
    int stepThresh = (int) (40 - 39*speed.getValuef());
    counter += deltaMs;
    if (counter < stepThresh) {
      return;
    }
    counter = counter % stepThresh;

    index = (index + 1) % FRAME_WIDTH;
    
    float rawBass = eq.getAveragef(0, 4);
    float rawTreble = eq.getAveragef(eq.numBands-7, 7);
    
    bass[index] = rawBass * rawBass * rawBass * rawBass;
    treble[index] = rawTreble * rawTreble;

    for (LXPoint p : model.points) {
      int i = (int) constrain((model.xMax - p.x) / model.xMax * FRAME_WIDTH, 0, FRAME_WIDTH-1);
      int pos = (index + FRAME_WIDTH - i) % FRAME_WIDTH;
      
      colors[p.index] = lx.hsb(
        (360 + lx.getBaseHuef() + .8*abs(p.x-model.cx)) % 360,
        100,
        constrain(9 * (bass[pos]*model.cy - abs(p.y - model.cy + 5)), 0, 100)
      );
      blendColor(p.index, lx.hsb(
        (400 + lx.getBaseHuef() + .5*abs(p.x-model.cx)) % 360,
        60,
        constrain(5 * (treble[pos]*.6*model.cy - abs(p.y - model.cy)), 0, 100)

      ), LXColor.Blend.ADD);
    }
  }
}

class ColorFuckerEffect extends LXEffect {
  
  final BasicParameter level = new BasicParameter("BRT", 1);
  final BasicParameter desat = new BasicParameter("DSAT", 0);
  final BasicParameter hueShift = new BasicParameter("HSHFT", 0);
  final BasicParameter sharp = new BasicParameter("SHARP", 0);
  final BasicParameter soft = new BasicParameter("SOFT", 0);
  final BasicParameter mono = new BasicParameter("MONO", 0);
  final BasicParameter invert = new BasicParameter("INVERT", 0);

  
  float[] hsb = new float[3];
  
  ColorFuckerEffect(LX lx) {
    super(lx);
    addParameter(level);
    addParameter(desat);
    addParameter(sharp);
    addParameter(hueShift);
    addParameter(soft);
    addParameter(mono);
    addParameter(invert);
  }
  
  public void run(double deltaMs) {
    if (!isEnabled()) {
      return;
    }
    float bMod = level.getValuef();
    float sMod = 1 - desat.getValuef();
    float hMod = hueShift.getValuef();
    float fSharp = sharp.getValuef();
    float fSoft = soft.getValuef();
    boolean mon = mono.getValuef() > 0.5;
    boolean ivt = invert.getValuef() > 0.5;
    if (bMod < 1 || sMod < 1 || hMod > 0 || fSharp > 0 || ivt || mon || fSoft > 0) {
      for (int i = 0; i < colors.length; ++i) {
        LXColor.RGBtoHSB(colors[i], hsb);
        if (mon) {
          hsb[0] = lx.getBaseHuef() / 360.;
        }
        if (ivt) {
          hsb[2] = 1 - hsb[2];
        }
        if (fSharp > 0) {
          fSharp = 1/(1-fSharp);
          if (hsb[2] < .5) {
            hsb[2] = pow(hsb[2],fSharp);
          } else {
            hsb[2] = 1-pow(1-hsb[2],fSharp);
          }
        }
        if (fSoft > 0) {
          if (hsb[2] > 0.5) {
            hsb[2] = lerp(hsb[2], 0.5 + 2 * (hsb[2]-0.5)*(hsb[2]-0.5), fSoft);
          } else {
            hsb[2] = lerp(hsb[2], 0.5 * sqrt(2*hsb[2]), fSoft);
          }
        }
        colors[i] = lx.hsb(
          (360. * hsb[0] + hMod*360.) % 360,
          100. * hsb[1] * sMod,
          100. * hsb[2] * bMod
        );
      }
    }
  }
}

class QuantizeEffect extends LXEffect {
  
  color[] quantizedFrame;
  float lastQuant;
  final BasicParameter amount = new BasicParameter("AMT", 0);
  
  QuantizeEffect(LX lx) {
    super(lx);
    quantizedFrame = new color[lx.total];
    lastQuant = 0;
  } 
  
  public void run(double deltaMs) {
    float fQuant = amount.getValuef();
    if (fQuant > 0) {
      float tRamp = (lx.tempo.rampf() % (1./pow(2,floor((1-fQuant) * 4))));
      float f = lastQuant;
      lastQuant = tRamp;
      if (tRamp > f) {
        for (int i = 0; i < colors.length; ++i) {
          colors[i] = quantizedFrame[i];
        }
        return;
      }
    }
    for (int i = 0; i < colors.length; ++i) {
      quantizedFrame[i] = colors[i];
    }
  }
}

class BlurEffect extends LXEffect {
  
  final BasicParameter amount = new BasicParameter("AMT", 0);
  final int[] frame;
  final LinearEnvelope env = new LinearEnvelope(0, 1, 100);
  
  BlurEffect(LX lx) {
    super(lx);
    addParameter(amount);
    addModulator(env);
    frame = new int[lx.total];
    for (int i = 0; i < frame.length; ++i) {
      frame[i] = #000000;
    }
  }
  
  public void onEnable() {
    env.setRangeFromHereTo(1, 400).start();
    for (int i = 0; i < frame.length; ++i) {
      frame[i] = #000000;
    }
  }
  
  public void onDisable() {
    env.setRangeFromHereTo(0, 1000).start();
  }
  
  public void run(double deltaMs) {
    float amt = env.getValuef() * amount.getValuef();
    if (amt > 0) {    
      amt = (1 - amt);
      amt = 1 - (amt*amt*amt);
      for (int i = 0; i < colors.length; ++i) {
        // frame[i] = colors[i] = PApplet.blendColor(colors[i], lerpColor(#000000, frame[i], amt, RGB), SCREEN);
        frame[i] = colors[i] = lerpColor(colors[i], LXColor.screen(colors[i], frame[i]), amt, RGB);
      }
    }
      
  }  
}

