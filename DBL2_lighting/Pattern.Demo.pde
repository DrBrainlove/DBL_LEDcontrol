/*****************************************************************************
 *    PATTERNS PRIMARILY INTENDED TO DEMO CONCEPTS, BUT NOT BE DISPLAYED
 ****************************************************************************/


/** ************************************************************** HELLO WORLD
 * Basic Hello World pattern
 * @author Alex Maki-Jokela
 ************************************************************************* **/
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


/** ************************************************************** HELLO WORLD
 * Basic Hello World pattern
 * @author Alex Maki-Jokela
 ************************************************************************* **/
class BarLengthTestPattern extends BrainPattern{ 


  private final Click whatcolor = new Click(5000); //rotate the colors erry 30 seconds in case there are two close colors next to each other
  private IntList hoos = new IntList();
  
  public BarLengthTestPattern(LX lx){
    super(lx);
    addModulator(whatcolor).start();
    for (String s : model.barmap.keySet()){
      hoos.append(int(random(360)));
    }
  }

  public void run(double deltaMs){
    if (whatcolor.getValuef()==1){
      hoos = new IntList();
      for (String s : model.barmap.keySet()){
        hoos.append(int(random(360)));
      }
    }
    int countr=0;
    int hoo_culla;
    for (String s:model.barmap.keySet()) {
      Bar b = model.barmap.get(s);
      hoo_culla=hoos.get(countr);
      countr+=1;
      for (LXPoint p : b.points) {
        colors[p.index]=lx.hsb(hoo_culla,100,100);
      }
    }
  }
}



/** ************************************************* NODE TRAVERSAL WITH FADE
 * Basic path traversal with global fading. 
 ************************************************************************** */
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


/** *********************************************************** DISPLAY IMAGES
 * Simple demonstration of using the MentalImage class
 * Chooses an image, and gradually rotates it across the brain.
 ************************************************************************* **/
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


/** ********************************************************** LX PALETTE DEMO
 * Simplest demonstration of using the rotating master hue.
 * All pixels are full-on the same color.
 ************************************************************************* **/
class LXPaletteDemo extends BrainPattern {
  
  public LXPaletteDemo(LX lx) {
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


/** ***************************************************************** GRADIENT
 * Example class making use of LXPalette's X/Y/Z interpolation to set
 * the color of each point in the model
 * @author Scouras
 ************************************************************************* **/

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





/** ********************************************************* RANDOM BAR FADES
 * Selects random sets of bars and sets them to random colors fading in and out
 * @author Alex Maki-Jokela
 ************************************************************************* **/
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


  
/** **************************************************************** TEST BARS
 * Test of lighting up the bars one by one rapidly. 
 * Todo: Make this way less ugly and more importantly, write one that 
 * traverses the node graph
 ************************************************************************* **/
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





/** *************************************************************** LAYER DEMO
 * Demonstration of layering patterns
 ************************************************************************* **/
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



