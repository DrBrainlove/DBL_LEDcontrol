/**
 * This file has a bunch of example patterns, each illustrating the key
 * concepts and tools of the LX framework.
 */



class LayerDemoPattern extends LXPattern {
  
  private final BasicParameter colorSpread = new BasicParameter("Clr", 0.5, 0, 3);
  private final BasicParameter stars = new BasicParameter("Stars", 100, 0, 100);
  
  public LayerDemoPattern(LX lx) {
    super(lx);
    addParameter(colorSpread);
    addParameter(stars);
    for (int i = 0; i < 200; ++i) {
      addLayer(new StarLayer(lx));
    }
    addLayer(new CircleLayer(lx));
    addLayer(new RodLayer(lx));
  }

  public void run(double deltaMs) {
    // The layers run automatically
  }

  private class CircleLayer extends LXLayer {

    private final SinLFO xPeriod = new SinLFO(3400, 7900, 11000); 
    private final SinLFO brightnessX = new SinLFO(model.xMin, model.xMax, xPeriod);

    private CircleLayer(LX lx) {
      super(lx);
      addModulator(xPeriod).start();
      addModulator(brightnessX).start();
    }

    public void run(double deltaMs) {
      // The layers run automatically
      float falloff = 100 / (4*FEET);
      for (LXPoint p : model.points) {
        float yWave = model.yRange/2 * sin(p.x / model.xRange * PI); 
        float distanceFromCenter = dist(p.x, p.y, model.cx, model.cy);
        float distanceFromBrightness = dist(p.x, abs(p.y - model.cy), brightnessX.getValuef(), yWave);
        colors[p.index] = LXColor.hsb(
          lx.getBaseHuef() + colorSpread.getValuef() * distanceFromCenter,
          100,
          max(0, 100 - falloff*distanceFromBrightness)
        );
      }
    }
  }

  private class RodLayer extends LXLayer {
    
    private final SinLFO zPeriod = new SinLFO(2000, 5000, 9000);
    private final SinLFO zPos = new SinLFO(model.zMin, model.zMax, zPeriod);
    
    private RodLayer(LX lx) {
      super(lx);
      addModulator(zPeriod).start();
      addModulator(zPos).start();
    }
    
    public void run(double deltaMs) {
      for (LXPoint p : model.points) {
        float b = 100 - dist(p.x, p.y, model.cx, model.cy) - abs(p.z - zPos.getValuef());
        if (b > 0) {
          addColor(p.index, LXColor.hsb(
            lx.getBaseHuef() + p.z,
            100,
            b
          ));
        }
      }
    }
  }
  
  private class StarLayer extends LXLayer {
    
    private final TriangleLFO maxBright = new TriangleLFO(0, stars, random(2000, 8000));
    private final SinLFO brightness = new SinLFO(-1, maxBright, random(3000, 9000)); 
    
    private int index = 0;
    
    private StarLayer(LX lx) { 
      super(lx);
      addModulator(maxBright).start();
      addModulator(brightness).start();
      pickStar();
    }
    
    private void pickStar() {
      index = (int) random(0, model.size-1);
    }
    
    public void run(double deltaMs) {
      if (brightness.getValuef() <= 0) {
        pickStar();
      } else {
        addColor(index, LXColor.hsb(lx.getBaseHuef(), 50, brightness.getValuef()));
      }
    }
  }
}


abstract class TestPattern extends LXPattern {
  public TestPattern(LX lx) {
    super(lx);
    setEligible(false);
  }
}


class TestPalette extends LXPalette {
  
  public TestPalette(LX lx, int basicColor) {
    super(lx);
   // LXColor culla = new LXColor(40,100,100);
    this.clr.setColor(basicColor);
    this.range.setValue(40);
   // hueMode.setValue(HUE_MODE_CYCLE);
   // period.setValue(10);
  }
}




/**
 * Simplest demonstration of using the rotating master hue.
 * All pixels are full-on the same color.
 */
class TestHuePattern extends TestPattern {
  
  TestPalette palette = new TestPalette(lx, 100);
  
  public TestHuePattern(LX lx) {
    super(lx);
    //this.setPalette(palette);
  }
  
  public void run(double deltaMs) {
    // Access the core master hue via this method call
    //palette.clr.setColor(0xffff0220);
    ///palette.range.setValue(40);
    //palette.period.setValue(10);
    float hv = lx.getBaseHuef();
    for (int i = 0; i < colors.length; ++i) {
      colors[i] = lx.hsb(palette.getHuef(), 100, 100);
    }
  } 
}


/**
 * Test of a wave moving across the X axis.
 */
class TestXPattern extends TestPattern {
  private final SinLFO xPos = new SinLFO(0, model.xMax, 4000);
  public TestXPattern(LX lx) {
    super(lx);
    addModulator(xPos).trigger();
  }
  public void run(double deltaMs) {
    System.out.println("model points: " + model.points.size());
    System.out.println("colors length: " + colors.length);
    float hv = lx.getBaseHuef();
    int i = 0;
    int j = 0;
    for (LXPoint p : model.points) {
      j +=1;
      // This is a common technique for modulating brightness.
      // You can use abs() to determine the distance between two
      // values. The further away this point is from an exact
      // point, the more we decrease its brightness
      float bv = max(0, 100 - abs(p.x - xPos.getValuef()));
      if (i < 10) {
        i += 1;
        System.out.println("index: " + p.index);
        println(j);
      }
      colors[p.index] = lx.hsb(hv, 100, bv);
    }
  }
}

  
/**
 * Test of lighting up the bars one by one rapidly. 
 * Todo: Make this way less ugly and more importantly, write one that traverses the node graph
 * mjp 2015.06.28 currently gives a null pointer exception when run
 */
class TestBarPattern extends BrainPattern {
  public String current_bar="FOG-LAW-14";
  public String current_node="FOG";
  public TestBarPattern(LX lx) {
    super(lx);
  }
  public void run(double deltaMs) {
    Random random = new Random();
    List<String> bar_split=Arrays.asList(current_bar.split("-"));
    String next_node = ""; 
    for (String noooddee : bar_split){ 
      if (noooddee.length()==3 && !noooddee.equals(current_node)){ //is it a node name? is it not the same node name?
        next_node=noooddee;
    }
    }
    Node next_node_node = model.nodemap.get(next_node);
    List<String> possible_next_bars = next_node_node.adjacent_physical_bar_names;
    Random myRandomizer = new Random();
    String next_bar = possible_next_bars.get(myRandomizer.nextInt(possible_next_bars.size()));
    current_bar=next_bar;
    current_node=next_node;
    List<String> keys = new ArrayList<String>(model.physicalbarmap.keySet());
    String randomKey = keys.get( random.nextInt(keys.size()) );
    PhysicalBar b = model.physicalbarmap.get(next_bar);
    System.out.println("model points: " + model.points.size());
    System.out.println("colors length: " + colors.length);
    float hv = lx.getBaseHuef();
    int i = 0;
    int j = 0;
    for (LXPoint p: model.points) {
      colors[p.index]=lx.hsb(0,100,0);
    }
      for (LXPoint p: b.points) {
      j +=1;
      colors[p.index] = lx.hsb(100, 100, 100);
      }
    }
}

class ThunderClouds extends BrainPattern {
  public int current_color = 230; //230-260
  public int current_sat = 70; //70ish
  public int current_bri = 50; //0-50
  public ThunderClouds(LX lx){
     super(lx);
  }
  
  //WIP
  //class ThunderCloud {
  //  List<float> center
  //}
    
 public void run(double deltaMs) {
    for (LXPoint p: model.points) {
      colors[p.index]=lx.hsb(random(200,260),current_sat,random(0,50));
    }
 }
}



class ShittyLightningStrikes extends BrainPattern {
  public String next_node;
  public List<Bar> bars_tried = new ArrayList<Bar>();
  public List<String> nodes_hit = new ArrayList<String>();
  public String point_node="ERA";
  public Bar b;
  public Node next_node_node;
   int stage = 0; //0 = hasn't struck ground yet, 1-10 = has struck ground, 11+ = has struck ground and is expired
  public ShittyLightningStrikes(LX lx){
     super(lx);
  }
 
    
  public void run(double deltaMs) {
    for (LXPoint p: model.points) {
      if (p.z< 15){
        colors[p.index]=lx.hsb(random(200,260),70,random(0,50));
      }
      else {
        colors[p.index]=lx.hsb(random(200,260),20*(p.z/model.zMax),random(0,50));
      }
      
    }
    Node next_node_node = model.nodemap.get(point_node); 
    if (!(next_node_node.ground) && bars_tried.size()<15){
      List<String> possible_next_bars = next_node_node.adjacent_bar_names;
      float x= random(10);
      Random myRandomizer = new Random();
      String next_bar = possible_next_bars.get(myRandomizer.nextInt(possible_next_bars.size()));
      b = model.barmap.get(next_bar);
      bars_tried.add(b);
      
      List<String> bar_split=Arrays.asList(next_bar.split("-"));
      for (String noooddee : bar_split){ 
        if (noooddee.length()==3 && !noooddee.equals(point_node)){ //is it a node name? is it not the same node name?
          next_node=noooddee;
        }
      }
      point_node=next_node;
      
      for (Bar barrr : bars_tried) {
        for (LXPoint p: barrr.points) {
          colors[p.index]=lx.hsb(70,100,100);
        }
      }
    }
    else{
      
      bars_tried = new ArrayList<Bar>();
      nodes_hit = new ArrayList<String>();
      Random myRandomizer = new Random();
      List<String> possible_nodes = new ArrayList<String>(model.nodemap.keySet());
      point_node = possible_nodes.get(myRandomizer.nextInt(possible_nodes.size()));
    }
   // if (x>5) {
   //   String next_bar_2 = possible_next_bars.get(myRandomizer.nextInt(possible_next_bars.size()));
   //   PhysicalBar b = model.physicalbarmap.get(next_bar);
   //   bars_tried.add(b);
   // }
  } 
}


class RandomBarFades extends BrainPattern {
   
  public SortedMap<String, Bar> active_bars = new TreeMap<String, Bar>();
  public SortedMap<String, String> cullas = new TreeMap<String, String>();
  List<String> keys;
  Bar b;
  public int phase = -1;
  String culla;
    
  public RandomBarFades(LX lx){
    super(lx);
  }


  public void run(double deltaMs) {
    if (phase < 0){  
      for (int i = 0; i < 400; i=i+1) {
        String stringi = str(i);
        Random myRandom = new Random();
        keys = new ArrayList<String>(model.barmap.keySet());
        String randomKey = keys.get( myRandom.nextInt(keys.size()) );
        b = model.barmap.get(randomKey);
        active_bars.put(stringi,b);
        culla = str(int(random(360)));
        cullas.put(stringi,culla);
        phase=1;
      }
    }
    phase=phase+3;
    if (phase < 100){
      for (String j : active_bars.keySet()){
        Bar bb = active_bars.get(j);
        culla = cullas.get(j);
        for (LXPoint p : bb.points) {
          colors[p.index]=lx.hsb(int(culla),100,phase);
        }
      }
    }
    else{
      for (String j : active_bars.keySet()){
        Bar bb = active_bars.get(j);
        culla = cullas.get(j);
        for (LXPoint p : bb.points) {
          colors[p.index]=lx.hsb(int(culla),100,200-phase);
        }
      }
    }
    if (phase>200){
      phase=phase % 200;
      for (LXPoint p: model.points) {
        colors[p.index]=lx.hsb(0,0,0);
      }
      active_bars = new TreeMap<String, Bar>();
      cullas = new TreeMap<String, String>();
      for (int i = 0; i < 400; i++) {
        String stringi = str(i);
        Random myRandomizer = new Random();
        String randomKey = keys.get( myRandomizer.nextInt(keys.size()) );
        b = model.barmap.get(randomKey);
        active_bars.put(stringi,b);
        culla = str(int(random(360)));
        cullas.put(stringi,culla);
      }
   }  
  }
}
 
 
 
 
 
 class RainbowBarrelRoll extends BrainPattern {
   
   float amod = 0;
   float smod = 0;
   float sval = 0;
    
  public RainbowBarrelRoll(LX lx){
     super(lx);
  }
  
 public void run(double deltaMs) {
     amod=amod+1;
     smod=smod+1;
     if (amod > 100){
       amod = amod % 100;
     }
     
    for (LXPoint p: model.points) {
      float angl=((atan(p.z/p.x))*180/3.14159265+amod);
      float sval=smod;
      colors[p.index]=lx.hsb(angl,100,100);
    }
 }

 }


class SampleNodeTraversal extends BrainPattern{
  Node randnod = model.getRandomNode();
  Node randnod2 = model.getRandomNode();
  List<Bar> barlist;
  
  
  public SampleNodeTraversal(LX lx){
    super(lx);
  }

  public void run(double deltaMS) {
    randnod = randnod.random_adjacent_nodes(1).get(0);
    randnod2 = randnod.random_adjacent_nodes(1).get(0);
    barlist = randnod.adjacent_bars();
    List<LXPoint> bar_poince = model.getOrderedLXPointsBetweenTwoAdjacentNodes(randnod,randnod2);
    for (LXPoint p: model.points) {
      colors[p.index]=lx.hsb(30,55,100);
    }

    for (Bar b: barlist) {
      for (LXPoint p: b.points){
        colors[p.index]=lx.hsb(200,256,100);
      }
    }

    int counta=0;
    for (LXPoint p:bar_poince){
      counta+=10;
      colors[p.index]=lx.hsb(counta,counta/2,100);
    }
  }
}

class SampleNodeTraversalWithFade extends BrainPattern{
  Node randnod = model.getRandomNode();
  Node randnod2 = model.getRandomNode();
  private final BasicParameter colorFade = new BasicParameter("Fade", 0.95, 0.9, 1.0);
  List<Bar> barlist;

  public SampleNodeTraversalWithFade(LX lx){
    super(lx);
    addParameter(colorFade);
    for (LXPoint p: model.points) {
      colors[p.index]=lx.hsb(0,0,0);
    }
  }

  public void run(double deltaMS) {
    randnod = randnod.random_adjacent_nodes(1).get(0);
    randnod2 = randnod.random_adjacent_nodes(1).get(0);
    barlist = randnod.adjacent_bars();
    List<LXPoint> bar_poince = model.getOrderedLXPointsBetweenTwoAdjacentNodes(randnod,randnod2);
    for (LXPoint p: model.points) {
      colors[p.index] = LXColor.scaleBrightness(colors[p.index], colorFade.getValuef());
    }

    for (Bar b: barlist) {
      for (LXPoint p: b.points){
        colors[p.index]=lx.hsb(200,100,100);
      }
    }
    int counta=0;
    for (LXPoint p:bar_poince){
      counta+=10;
      colors[p.index]=lx.hsb(counta,counta/2,100);
    }
  }
}

 
class CircleBounce extends LXPattern {
  
  private final BasicParameter bounceSpeed = new BasicParameter("BNC",  1000, 0, 10000);
  private final BasicParameter colorSpread = new BasicParameter("CLR", 0.5, 0.0, 3.0);
  private final BasicParameter colorFade   = new BasicParameter("FADE", 1, 0.0, 10.0);

  public CircleBounce(LX lx) {
    super(lx);
    addParameter(bounceSpeed);
    addParameter(colorSpread);
    addParameter(colorFade);
    addLayer(new CircleLayer(lx));
  }

  public void run(double deltaMs) {
    // The layers run automatically
  }

  private class CircleLayer extends LXLayer {
    private final SinLFO xPeriod = new SinLFO(model.zMin, model.zMax, bounceSpeed); 
    //private final SinLFO brightnessX = new SinLFO(model.xMin, model.xMax, xPeriod);

    private CircleLayer(LX lx) {
      super(lx);
      addModulator(xPeriod).start();
      //addModulator(brightnessX).start();
    }

    public void run(double deltaMs) {
      // The layers run automatically
      float falloff = 5.0 / colorFade.getValuef();
      //println("Height: ", xPeriod.getValuef());
      for (LXPoint p : model.points) {
        //float yWave = model.yRange/2 * sin(p.x / model.xRange * PI); 
        //float distanceFromCenter = dist(p.x, p.y, model.cx, model.cy);
        float distanceFromBrightness = abs(xPeriod.getValuef() - p.z);
        colors[p.index] = LXColor.hsb(
          lx.getBaseHuef() + colorSpread.getValuef(),
          100.0,
          max(0.0, 100.0 - falloff*distanceFromBrightness)
        );
      }
    }
  }
}

class CirclesBounce extends LXPattern {
  
  private final BasicParameter bounceSpeed = new BasicParameter("BNC",  1000, 0, 10000);
  private final BasicParameter colorSpread = new BasicParameter("CLR", 0.5, 0.0, 3.0);
  private final BasicParameter colorFade   = new BasicParameter("FADE", 1, 0.0, 10.0);

  public CirclesBounce(LX lx) {
    super(lx);
    addParameter(bounceSpeed);
    addParameter(colorSpread);
    addParameter(colorFade);
    addLayer(new CirclesLayer(lx, 0));
    addLayer(new CirclesLayer(lx, 1));
    addLayer(new CirclesLayer(lx, 2));
  }

  public void run(double deltaMs) {
    // The layers run automatically
  }



  //choco2 better than 3
 //JgraphT

  private class CirclesLayer extends LXLayer {
    private SinLFO xPeriod = new SinLFO(model.xMin, model.xMax, bounceSpeed);
    private SinLFO yPeriod = new SinLFO(model.yMin, model.yMax, bounceSpeed);
    private SinLFO zPeriod = new SinLFO(model.zMin, model.zMax, bounceSpeed);
    private int xyz;
    //private final SinLFO brightnessX = new SinLFO(model.xMin, model.xMax, xPeriod);

    private CirclesLayer(LX lx, int _xyz) {
      super(lx);
      xyz = _xyz;
      addModulator(xPeriod).start();
      addModulator(yPeriod).start();
      addModulator(zPeriod).start();
      //addModulator(brightnessX).start();
    }

    public void run(double deltaMs) {
      // The layers run automatically
      float falloff = 5.0 / colorFade.getValuef();
      //println("Height: ", xPeriod.getValuef());
      for (LXPoint p : model.points) {
        //float yWave = model.yRange/2 * sin(p.x / model.xRange * PI); 
        //float distanceFromCenter = dist(p.x, p.y, model.cx, model.cy);
        float distanceFromBrightness = 0.0;
        if (xyz==0) { distanceFromBrightness = abs(xPeriod.getValuef() - p.x); }
        if (xyz==1) { distanceFromBrightness = abs(yPeriod.getValuef() - p.y); }
        if (xyz==2) { distanceFromBrightness = abs(zPeriod.getValuef() - p.z); }
        colors[p.index] = LXColor.hsb(
          lx.getBaseHuef() + colorSpread.getValuef(),
          100.0,
          max(0.0, 100.0 - falloff*distanceFromBrightness)
        );
      }
    }
  }
}



