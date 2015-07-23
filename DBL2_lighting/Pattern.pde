/**
 * This file has a bunch of example patterns, each illustrating the key
 * concepts and tools of the LX framework.
 */


/**
 * Basic Hello World pattern
*/
class HelloWorldPattern extends BrainPattern{ 

  private final BasicParameter colorChangeSpeed = new BasicParameter("SPD",  5000, 0, 10000);
  private final SinLFO whatcolor = new SinLFO(0, 360, colorChangeSpeed);
  
  public HelloWorldPattern(LX lx){
    super(lx);
    addParameter(colorChangeSpeed);
    addModulator(whatcolor).trigger();
  }

  public void run(double deltaMs){
    for (LXPoint p : model.points) {
      float h=whatcolor.getValuef();
      int s=100;
      int b=100;
      colors[p.index]=lx.hsb(h,s,b);
    }
  }
}



/**
 * Creates a really basic thundercloud with lightning strikes pattern
 * Also an example of basic node traversal
 */
class Brainstorm extends BrainPattern {
  MentalImage mentalimage = new MentalImage("media/images/stormclouds_purple.jpg","xy",100);
  public BasicParameter xPer = new BasicParameter("XPD",6000.0,5000.0,20000.0);
  public BasicParameter yPer = new BasicParameter("YPD",6000,5000,20000);
  public BasicParameter lightningFreq = new BasicParameter("LFR",400,200,800);
  public BasicParameter lightningFreq2 = new BasicParameter("LFR",400,200,800);
  public SawLFO linenvx = new SawLFO(0.0,1.0,xPer);
  public SawLFO linenvy = new SawLFO(0.0,1.0,yPer);
  public Click lightningtrigger = new Click(lightningFreq);
  public Click lightningtrigger2 = new Click(lightningFreq2);
  public float add_to_xPer=0.0;
  public float add_to_yPer=0.0;
  public LightningBolt lb;
  public LightningBolt lb2;
  
  public Brainstorm(LX lx){
     super(lx);
     addModulator(linenvx).start();
     addModulator(linenvy).start();
     addModulator(lightningtrigger).start();
     addModulator(lightningtrigger2).start();
     addParameter(xPer);
     addParameter(yPer);
     addParameter(lightningFreq);
     addParameter(lightningFreq2);
     lb = new LightningBolt();
     lb2 = new LightningBolt();
  }
 
    
  class LightningBolt {
    public LinearEnvelope timeline = new LinearEnvelope(0,100,200);
    public List<LXPoint> boltpoints = new ArrayList<LXPoint>();
    public Node startNode;
    public Node endNode;
    public int boltlength;
    public Random randombool = new Random();
    public int bolthue = 65; //65 = yellow
    
    public LightningBolt(){
      addModulator(timeline).start();
      this.startNode = model.getRandomNode();
      while (this.startNode.ground) {
        this.startNode = model.getRandomNode();
      }
      Node prevNode = startNode.random_adjacent_node();
      Node currentNode = startNode;
      Node nextNode;
      while (!(currentNode.ground)) {
        nextNode=currentNode.random_adjacent_node();
        while (angleBetweenThreeNodes(prevNode,currentNode,nextNode)<(PI/4.0)){
          nextNode=currentNode.random_adjacent_node();
        }
        List<LXPoint> addpoints=nodeToNodePoints(currentNode,nextNode);
        for (LXPoint p : addpoints){
          this.boltpoints.add(p);
        }
        prevNode=currentNode;
        currentNode=nextNode;
      }
      this.boltlength=boltpoints.size();
      this.endNode=currentNode;
    }
    
    public void run(double deltaMs){
      float phase=timeline.getValuef();
      if (phase<5){
        for (LXPoint p : model.points){
          addColor(p.index,lx.hsb(bolthue,20,20));
        }
      }
      if (phase<20){
        for (LXPoint p : startNode.adjacent_bar_points()){
          float point_radius = dist(p.x,p.y,p.z,startNode.x,startNode.y,startNode.z);
          addColor(p.index,lx.hsb(bolthue,70,90));
        }
      }
      if (phase>20 && phase <70){
        int ptcount=0;
        for (LXPoint p : boltpoints){
          float pctthru=float(ptcount)/float(boltlength);
          if (pctthru<((phase-20)/50)){
            addColor(p.index,lx.hsb(bolthue,70,90));
          }
          ptcount+=1;
        }
      }
      if (phase>70 && phase <100){
        int ptcount=0;
        for (LXPoint p : boltpoints){
          float pctthru=float(ptcount)/float(boltlength);
          if (pctthru>((phase-70)/30)){
            addColor(p.index,lx.hsb(bolthue,70,90));
          }
          ptcount+=1;
        }
      }
    }
  }
  
  public void run(double deltaMs) {
    if (lightningtrigger.getValuef()==1){
        lightningFreq.setValue(random(100,1000));
      lb=new LightningBolt();
    }
    if (lightningtrigger2.getValuef()==1){
        lightningFreq2.setValue(random(100,1000));
      lb2=new LightningBolt();
    }
    if(linenvx.getValuef()<0.01){
      add_to_xPer=random(-1000,1000);
      xPer.setValue(xPer.getValuef()+add_to_xPer);
    }
    if(linenvy.getValuef()<0.01){
      add_to_yPer=random(-1000,1000);
      yPer.setValue(yPer.getValuef()+add_to_xPer);
    }
    colors=this.mentalimage.shiftedImageToPixels(colors,linenvx.getValuef(),linenvy.getValuef());
    lb.run(deltaMs);
    lb2.run(deltaMs);
  } 
}



/** 
 * Demonstration of layering patterns
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





/**
 * Simplest demonstration of using the rotating master hue.
 * All pixels are full-on the same color.
 */
class TestHuePattern extends BrainPattern {
  
  public TestHuePattern(LX lx) {
    super(lx);
  }
  
  public void run(double deltaMs) {
    // Access the core master hue via this method call
    float hv = lx.getBaseHuef();
    for (int i = 0; i < colors.length; ++i) {
      colors[i] = lx.hsb(palette.getHuef(), 100, 100);
    }
  } 
}

class GradientPattern extends BrainPattern {
  GradientPattern(LX lx) {
    super(lx);
  }
  
  public void run(double deltaMs) {
    for (LXPoint p : model.points) {
      colors[p.index] = palette.getColor(p);
    }
  }
}




/**
 * Simple demonstration of using the MentalImage class
 * Chooses an image, and gradually rotates it across the brain.
 */
class TestImagePattern extends BrainPattern {

  MentalImage mentalimage = new MentalImage("media/images/starry_night.jpg","cylindrical_z",100);
  int counter;
  float shift=0.0;
  
  public TestImagePattern(LX lx) {
    super(lx);
  }
  
  public void run(double deltaMs) {
    shift+=0.0003;
    if(shift>1){
      shift=0.0;
    }
    colors=this.mentalimage.shiftedImageToPixels(colors,shift,0);
  } 
}






/**
 * Test of a wave moving across the X axis.
 */
class TestXPattern extends BrainPattern {

  private final SinLFO xPos = new SinLFO(model.xMin, model.xMax, 4000);
  
  public TestXPattern(LX lx) {
    super(lx);
    addModulator(xPos).trigger();
  }
  
  public void run(double deltaMs) {
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
 * Test of hemispheres functionality
 */
class TestHemispheres extends BrainPattern {
  private final SinLFO xPos = new SinLFO(0, model.xMax, 4000);
  public TestHemispheres(LX lx) {
    super(lx);
    addModulator(xPos).trigger();
  }
  public void run(double deltaMs) {
    float hv = lx.getBaseHuef();
    int i = 0;
    int j = 0;
    Bar bar = model.barmap.get("FOG-LAW");
    Bar otherbar = model.barmap.get("LAW-OLD");;
    float x = bar.angle_with_bar(otherbar);
    //println(otherbar.id);
    //println(x);
    for (String bb : model.barmap.keySet()){
      Bar b = model.barmap.get(bb);
      hv=200;
      if (b.left_right_mid.equals("left")){
        hv=100;
      }
      if (b.left_right_mid.equals("right")){
        hv=200;
      }
      if (b.left_right_mid.equals("mid")){
        hv=300;
      }
      
      for (LXPoint p : b.points) {
        colors[p.index] = lx.hsb(hv, 100, 100);
      }
  }
}
}




  
/**
 * Test of lighting up the bars one by one rapidly. 
 * Todo: Make this way less ugly and more importantly, write one that traverses the node graph
 */
class TestBarPattern extends BrainPattern {
  public String current_bar_name="FOG-LAW"; //can be any 
  public String current_node_name="FOG";
  public Random randomness = new Random();
  public TestBarPattern(LX lx) {
    super(lx);
  }
  public void run(double deltaMs) {
    Random random = new Random();
    List<String> bar_node_names=Arrays.asList(current_bar_name.split("-"));
    String next_node_name = ""; 
    for (String node_name_i : bar_node_names){ 
      if (node_name_i.length()==3 && !node_name_i.equals(current_node_name)){ //is it a node name? is it not the same node name?
        next_node_name=node_name_i;
    }
    }
    Node next_node_node = model.nodemap.get(next_node_name);
    List<String> possible_next_bars = next_node_node.adjacent_bar_names;
    String next_bar_name = possible_next_bars.get(randomness.nextInt(possible_next_bars.size()));
    current_bar_name=next_bar_name;
    current_node_name=next_node_name;
    List<String> keys = new ArrayList<String>(model.barmap.keySet());
    String randomKey = keys.get( random.nextInt(keys.size()) );
    Bar b = model.barmap.get(next_bar_name);
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

/**
 * Selects random sets of bars and sets them to random colors fading in and out
 */
class RandomBarFades extends BrainPattern {
   
  SortedMap<String, Bar> active_bars = new TreeMap<String, Bar>();
  SortedMap<String, String> random_bar_colors = new TreeMap<String, String>();
  List<String> all_bar_names= new ArrayList<String>(model.barmap.keySet());;
  Random randomness = new Random();
  Bar b;
  String randomKey;
  int phase = -1;
  String random_color_str;
    
  public RandomBarFades(LX lx){
    super(lx);
  }


  public void run(double deltaMs) {
    if (phase < 0){  
      for (int i = 0; i < 400; i=i+1) {
        String stringi = str(i);
        randomKey = all_bar_names.get( randomness.nextInt(all_bar_names.size()) );
        b = model.barmap.get(randomKey);
        active_bars.put(stringi,b);
        random_color_str = str(int(random(360)));
        random_bar_colors.put(stringi,random_color_str);
        phase=1;
      }
    }
    phase=phase+3;
    if (phase < 100){
      for (String j : active_bars.keySet()){
        Bar bb = active_bars.get(j);
        random_color_str = random_bar_colors.get(j);
        for (LXPoint p : bb.points) {
          colors[p.index]=lx.hsb(int(random_color_str),100,phase);
        }
      }
    }
    else{
      for (String j : active_bars.keySet()){
        Bar bb = active_bars.get(j);
        random_color_str = random_bar_colors.get(j);
        for (LXPoint p : bb.points) {
          colors[p.index]=lx.hsb(int(random_color_str),100,200-phase);
        }
      }
    }
    if (phase>200){
      phase=phase % 200;
      for (LXPoint p: model.points) {
        colors[p.index]=lx.hsb(0,0,0);
      }
      active_bars = new TreeMap<String, Bar>();
      random_bar_colors = new TreeMap<String, String>();
      for (int i = 0; i < 400; i++) {
        String stringi = str(i);
        String randomKey = all_bar_names.get( randomness.nextInt(all_bar_names.size()) );
        b = model.barmap.get(randomKey);
        active_bars.put(stringi,b);
        random_color_str = str(int(random(360)));
        random_bar_colors.put(stringi,random_color_str);
      }
   }  
  }
}



 
 
 

class RainbowBarrelRoll extends BrainPattern {
   float hoo;
   float anglemod = 0;
    
  public RainbowBarrelRoll(LX lx){
     super(lx);
  }
  
 public void run(double deltaMs) {
     anglemod=anglemod+1;
     if (anglemod > 360){
       anglemod = anglemod % 360;
     }
     
    for (LXPoint p: model.points) {
      //conveniently, hue is on a scale of 0-360
      hoo=((atan(p.x/p.z))*360/PI+anglemod);
      colors[p.index]=lx.hsb(hoo,80,100);
    }
  }
}


class SampleNodeTraversal extends BrainPattern{
  Node randomnode;
  Node nextrandomnode;
  List<Bar> barlist;
  
  
  public SampleNodeTraversal(LX lx){
    super(lx);
    randomnode = model.getRandomNode();
  }

  public void run(double deltaMS) {
    randomnode = randomnode.random_adjacent_nodes(1).get(0);
    nextrandomnode = randomnode.random_adjacent_nodes(1).get(0);
    barlist = randomnode.adjacent_bars();
    List<LXPoint> bar_points = nodeToNodePoints(randomnode,nextrandomnode);
    for (LXPoint p: model.points) {
      colors[p.index]=lx.hsb(30,55,100);
    }

    for (Bar b: barlist) {
      for (LXPoint p: b.points){
        colors[p.index]=lx.hsb(200,256,100);
      }
    }

    int counta=0;
    for (LXPoint p:bar_points){
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
    List<LXPoint> bar_poince = nodeToNodePoints(randnod,randnod2);
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
  private final BasicParameter colorSpread = new BasicParameter("CLR", 0.5, 0.0, 360.0);
  private final BasicParameter colorFade   = new BasicParameter("FADE", 1, 0.0, 10.0);
  private SinLFO colorPeriod = new SinLFO(0, 1000, bounceSpeed);
  //private Color[] gradient = GradientCB.getGradient(3, 1, 20);
  private int[] baseGradient = 
      Colour.colorSchemeOfType(
          Colour.Colours.successColor(), 
          Colour.ColorScheme.ColorSchemeMonochromatic
      );

  private int[] gradient = DBLPalette.interpolate(baseGradient, 100);

  public CirclesBounce(LX lx) {
    super(lx);
    addParameter(bounceSpeed);
    addParameter(colorSpread);
    addParameter(colorFade);
    addLayer(new CirclesLayer(lx, 0));
    addLayer(new CirclesLayer(lx, 1));
    addLayer(new CirclesLayer(lx, 2));
    //println(gradient);
  }

  public void run(double deltaMs) {
    // The layers run automatically
  }

  private class CirclesLayer extends LXLayer {
    private SinLFO xPeriod = new SinLFO(model.xMin, model.xMax, bounceSpeed);
    private SinLFO yPeriod = new SinLFO(model.yMin, model.yMax, bounceSpeed);
    private SinLFO zPeriod = new SinLFO(model.zMin, model.zMax, bounceSpeed);
    private int xyz;
    //private final SinLFO brightnessX = new SinLFO(model.xMin, model.xMax, xPeriod);

    private CirclesLayer(LX lx, int _xyz) {
      super(lx);
      xyz = _xyz;
      addModulator(colorPeriod).start();
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
        /*
        colors[p.index] = LXColor.hsb(
          lx.getBaseHuef() + colorSpread.getValuef(),
          100.0,
          max(0.0, 100.0 - falloff*distanceFromBrightness)
        );
        int increment = (int)(deltaMs / (colorSpread.getValuef()+1.0));
        println("Indrement: ", increment);
        */
        //Color clr = gradient[(p.index+(int)colorPeriod.getValue()) % gradient.length];
        //colors[p.index] = clr.getRGB();
        /*
        int rgb = clr.getRGB();
        colors[p.index] = LXColor.hsb(
          hue(rgb),
          saturation(rgb),
          brightness(rgb) * max(0.0, 100.0 - falloff*distanceFromBrightness) * 0.01
        );
        */
        colors[p.index] = gradient[p.index % gradient.length];
        //colors[p.index] = gradient[(p.index+(int)colorPeriod.getValue()) % gradient.length];
      }
    }
  }
}



