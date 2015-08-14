
class MusicResponse extends BrainPattern {
  private GraphicEQ eq = null;
  List<List<LXPoint>> strips_emanating_from_nodes = new ArrayList<List<LXPoint>>();

  double ms = 0.0;
  double offset = 0.0;
  private final BasicParameter colorScheme = new BasicParameter("SCM", 0, 3);
  private final BasicParameter cycleSpeed = new BasicParameter("SPD",  100, 0, 1000);
  private final BasicParameter colorSpread = new BasicParameter("LEN", 100, 0, 1000);
  private final BasicParameter colorHue = new BasicParameter("HUE",  0., 0., 359.);
  private final BasicParameter colorSat = new BasicParameter("SAT", 80., 0., 100.);
  private final BasicParameter colorBrt = new BasicParameter("BRT", 80., 0., 100.);
  private DecibelMeter dbMeter = new DecibelMeter(lx.audioInput());
  private GeneratorPalette gp = 
      new GeneratorPalette(
          new ColorOffset(0xDD0000).setHue(colorHue)
                                   .setSaturation(colorSat)
                                   .setBrightness(colorBrt),
          GeneratorPalette.ColorScheme.Monochromatic,
          40
      );
  private int scheme = 0;

  public MusicResponse(LX lx) {
    super(lx);
    addParameter(colorScheme);
    addParameter(cycleSpeed);
    addParameter(colorSpread);
    addParameter(colorHue);
    addParameter(colorSat);
    addParameter(colorBrt);
    
    /*if (eq == null) {
      eq = new GraphicEQ(lx.audioInput());
      eq.range.setValue(48);
      eq.release.setValue(800);
      eq.gain.setValue(-6);
      eq.slope.setValue(6);
      addParameter(eq.gain);
      addParameter(eq.range);
      addParameter(eq.attack);
      addParameter(eq.release);
      addParameter(eq.slope);
      addModulator(eq).start();
    }*/


    addModulator(dbMeter).start();
    for (String n : model.nodemap.keySet()) {
      List<LXPoint> out_from_node = new ArrayList<LXPoint>();
      Node node = model.nodemap.get(n);
      List<Node> neighbornodes = node.adjacent_nodes();
      for (Node nn : neighbornodes) {
        out_from_node = nodeToNodePoints(node,nn);
        strips_emanating_from_nodes.add(out_from_node);
      }
    }
  }
  
  public void run(double deltaMs) {
    int newScheme = (int)Math.floor(colorScheme.getValue());
    if ( newScheme != scheme) { 
      switch(newScheme) { 
        case 0: gp.setScheme(GeneratorPalette.ColorScheme.Analogous); break;
        case 1: gp.setScheme(GeneratorPalette.ColorScheme.Monochromatic); break;
        case 2: gp.setScheme(GeneratorPalette.ColorScheme.Triad); break;
        case 3: gp.setScheme(GeneratorPalette.ColorScheme.Complementary); break;
      }
      scheme = newScheme;
    }

    ms += deltaMs;
    offset += deltaMs*cycleSpeed.getValue()/1000.;
    //int steps = (int)colorSpread.getValue();
    //if (steps != gp.steps) { 
    //  gp.setSteps(steps);
    //}
    //gp.reset((int)offset);
    colorHue.setValue(offset%360.);
    double progress = lx.tempo.ramp();
    //float bassLevel = lx.audioInput.mix.level();//eq.getAveragef(0, 5) * 5000;
    float soundLevel = -dbMeter.getDecibelsf()*0.5;
    double adsr = Math.cos(progress)/2.0+0.5;
    //println(dbMeter.getDecibelsf() + "    " + soundLevel);
    for (LXPoint p: model.points) {
      colors[p.index] = 0;
      //colors[p.index] = gp.getColor();
      //colors[p.index] = lx.hsb(LXColor.h(gp.getColor()),40.,(float)(progress*100.));
    }
    for (List<LXPoint> strip : strips_emanating_from_nodes) {
      gp.reset();
      int distance_from_node=0;
      int striplength = strip.size();
      int steps = (int)Math.ceil(strip.size());
      //int steps = (int)Math.floor(strip.size()*adsr);
      gp.setSteps(steps);
      for (LXPoint p : strip) {
        distance_from_node+=1;
        //if (distance_from_node > steps) {
        //  break;
        //}
        /*
        float relative_distance = (float) distance_from_node / striplength;
        float hoo = 300- 5*relative_distance*2500/soundLevel;
        float saturat = 100;
        float britness = max(0, 100 - 3*relative_distance*2500/soundLevel);
        //addColor(p.index, lx.hsb(hoo, saturat, britness));
        */
        int clr = gp.getColor(adsr);
        colors[p.index] = lx.hsb(LXColor.h(clr),
                                 LXColor.s(clr),
                                 LXColor.b(clr));
                                 //LXColor.b(clr)*constrain(soundLevel/20., 0., 1.));
      }
    }
  }
}




