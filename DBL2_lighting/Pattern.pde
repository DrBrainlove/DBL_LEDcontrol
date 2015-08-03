//**************************************************** COMMAND LINE PROCESSING
// To run Processing2 from the command line, install the CLI client:
//   Processing2 -> Tools -> Install "processing-java"
// Then go to your local DBL2_lighting directory in a terminal:
//   processing-java --run --sketch=`pwd` --output=/tmp/something --force
//****************************************************************************
 
  
/** ******************************************************************** VIDEO
 * Hackathon Entry
 * @author Tom Bishop
 * TODO: This pattern will prevent DBLX from launching if it cannot find a 
 * camera to connect to. Going to disable it by default for now, but we should
 * find a graceful way to handle it.
 ************************************************************************* **/
import processing.video.*;
PApplet parentApplet = this;
class VidPattern extends BrainPattern {
  MentalImage mentalimage = new MentalImage("media/images/stormclouds_purple.jpg","xy",110);  
  BasicParameter xPer = new BasicParameter("XPD",50000,5000,50000);
  BasicParameter yPer = new BasicParameter("YPD",50000,5000,50000);
  BasicParameter scl = new BasicParameter("Scale",100,10,400);
  SawLFO linenvx = new SawLFO(0.0,1.0,xPer);
  SawLFO linenvy = new SawLFO(0.0,1.0,yPer);
  float add_to_xPer=0.0;
  float add_to_yPer=0.0;
  Capture cam;
  
  public VidPattern(LX lx){
    super(lx);
    addModulator(linenvx).start();
    addModulator(linenvy).start();
    addParameter(xPer);
    addParameter(yPer);
    addParameter(scl);
    
    println("Available cameras: " + Capture.list()); 
    cam = new Capture(parentApplet,640,480);
    cam.start();  
  }
 public void run(double deltaMs) {                    
    if(linenvx.getValuef()<0.01){
      add_to_xPer=random(-1000,1000);
      xPer.setValue(xPer.getValuef()+add_to_xPer);
    }
    if(linenvy.getValuef()<0.01){
      add_to_yPer=random(-1000,1000);
      yPer.setValue(yPer.getValuef()+add_to_xPer);
    }
    
    if (cam.available() == true) {
      cam.read();
      PImage img = cam;
      mentalimage.updateImage(img,"xy",100);
    }
    
    colors=this.mentalimage.shiftedImageToPixels(colors,linenvx.getValuef(),linenvy.getValuef(),scl.getValuef()/100.0 );
  } 
}



/** *********************************************** POWER RANGERS MASK PATTERN
 * Hackathon Entry
 * @author Shruthi Kubatur
 * All 5 ranges in less than 4 minutes
 ************************************************************************* **/

class RangersPattern extends BrainPattern {
  public String current_bar_name="FOG-LAW"; //can be any 
  public String current_node_name="FOG";
  public Random randomness = new Random();
  
  private int j = 0, j_color = 0, color_step = 60, T = 700, persist = 10000;
  
  public List<Integer> painted = new ArrayList<Integer>();
  
  Node randomnode;
  Node nextrandomnode;
  List<Bar> barlist;
  
  private final BasicParameter colorChangeSpeed = new BasicParameter("SPD",  300000, 0, 1000000);
  private final SinLFO whatcolor = new SinLFO(0, 360, colorChangeSpeed);
  
  public RangersPattern(LX lx) {
    super(lx);
    randomnode = model.getRandomNode(); //SampleNodeTraversal
    addParameter(colorChangeSpeed);
    addModulator(whatcolor).trigger();
  }
  
  MentalImage mentalimage = new MentalImage("media/images/rangers_eyes_2.png", "yz", 250);
  int counter;
  float shift=0.0;
  
  public void run(double deltaMs) {  
    
    randomnode = randomnode.random_adjacent_nodes(1).get(0);
    nextrandomnode = randomnode.random_adjacent_nodes(1).get(0);
    barlist = randomnode.adjacent_bars();

    float h = whatcolor.getValuef();
    colors = this.mentalimage.shiftedImageToPixels(colors, 0, 0);
    
    for (Integer z: painted){
       if (colors[z] == lx.hsb(0, 0, 0)){
       colors[z] = lx.hsb(j_color, 100, 90);
       }
    }
    
    for (Bar b: barlist) {
      for (LXPoint p: b.points){
        painted.add(p.index);
        colors[p.index] = lx.hsb(j_color, 100, 90);
      }
    }
    
    if ((j > 4) && ((j%T == 0) || (j%T == 1) || (j%T == 2) || (j%T == 3) || (j%T == 4)))
    {
    for (LXPoint z: model.points){
          if (colors[z.index] == lx.hsb(0, 0, 0))
             colors[z.index] = lx.hsb(65, 0, 5000); // flash
       }
    
    }
    
    if (j%T == 5)
       painted.clear();
    
    j_color = (color_step*(j-(j%T))/T)%301;
    j = j+1;
    
  } // End of "run" method
}




/** ****************************************************************** VORONOI
 * Hackathon Entry
 * @author Irene Zhou
 ************************************************************************* **/

class Voronoi extends BrainPattern {
  public BasicParameter speed = new BasicParameter("SPEED", 10, 0, 20);
  public BasicParameter width = new BasicParameter("WIDTH", 0.5, 0.2, 1);
  public BasicParameter hue = new BasicParameter("HUE", 0, 0, 360);
  public DiscreteParameter num = new DiscreteParameter("NUM", 14, 5, 28);
  private List<Site> sites = new ArrayList<Site>();
  public float xMaxDist = model.xMax - model.xMin;
  public float yMaxDist = model.yMax - model.yMin;
  public float zMaxDist = model.zMax - model.zMin;

  class Site {
    float xPos = 0;
    float yPos = 0;
    float zPos = 0;
    PVector velocity = new PVector(0,0,0);

    public Site() {
        xPos = random(model.xMin, model.xMax);
        yPos = random(model.yMin, model.yMax);
        zPos = random(model.zMin, model.zMax);
        velocity = new PVector(random(-1,1), random(-1,1), random(-1,1));
    }

    public void move(float speed) {
      xPos += speed * velocity.x;
      if ((xPos < model.xMin - 20) || (xPos > model.xMax + 20)) {
        velocity.x *= -1;
      }
      yPos += speed * velocity.y;
      if ((yPos < model.yMin - 20) || (yPos > model.yMax + 20)) {
        velocity.y *= -1;
      }
      zPos += speed * velocity.z;
      if ((zPos < model.zMin - 20) || (zPos > model.zMax + 20)) {
        velocity.z *= -1;
      }
    }
  }

  public Voronoi(LX lx) {
    super(lx);
    addParameter(speed);
    addParameter(width);
    addParameter(hue);
    addParameter(num);
  }

  public void run(double deltaMs) {
    for (LXPoint p: model.points) {
      float numSites = num.getValuef();
      float lineWidth = width.getValuef();

      while(sites.size()>numSites){
        sites.remove(0);
      }

      while(sites.size()<numSites){
        sites.add(new Site());
      }

      float minDistSq = 10000;
      float nextMinDistSq = 10000;
      float calcRestraintConst = 20 / (numSites + 15);
      lineWidth = lineWidth * 40 / (numSites + 20);

      for (Site site : sites) {
        float dx = site.xPos - p.x;
        float dy = site.yPos - p.y;
        float dz = site.zPos - p.z;

        if (abs(dy) < yMaxDist * calcRestraintConst &&
            abs(dx) < xMaxDist * calcRestraintConst &&
            abs(dz) < zMaxDist * calcRestraintConst) { //restraint on calculation
          float distSq = dx * dx + dy * dy + dz * dz;
          if (distSq < nextMinDistSq) {
            if (distSq < minDistSq) {
              nextMinDistSq = minDistSq;
              minDistSq = distSq;
            } else {
              nextMinDistSq = distSq;
            }
          }
        }
      }
      colors[p.index] = lx.hsb(
        (lx.getBaseHuef() + hue.getValuef()) % 360,
        100,
        max(0, min(100, 100 - sqrt(nextMinDistSq - minDistSq) / lineWidth))
      );
    }
    for (Site site: sites) {
      site.move(speed.getValuef());
    }
  }
}



/** ***************************************************************** SERPENTS
 * Snake traces. I'm going to see if there's a good way to make this a 
 * class people can just call on to add snakes to their patterns tomorrow.
 * Feel free to adapt and work into your own patterns.
 * @author Alex Maki-Jokela
 ************************************************************************* **/

class Serpents extends BrainPattern{
  
  public DiscreteParameter howmanysnakes = new DiscreteParameter("NUM",3,100);
  public DiscreteParameter serperiod = new DiscreteParameter("PER",200,10,200);
  public DiscreteParameter serlength = new DiscreteParameter("LEN",10,1,20);
  public List<Serpent> serpence = new ArrayList<Serpent>();
  
  class Serpent {
    
    float slength;
    float speriod;
    float prevphase=0.0;
    int hoo;
    SawLFO wormthroughbar;
    List<Node> snakeNodes = new ArrayList<Node>();
    List<LXPoint> snakeDots = new ArrayList<LXPoint>();
    
    public Serpent(float period, float slength, int hoo){
      this.speriod = constrain(period,10,20000);
      this.wormthroughbar = new SawLFO(0,100,this.speriod);
      this.slength=slength;
      this.hoo=hoo;
      
      addModulator(this.wormthroughbar).start();
      Node previternode;
      Node iternode=model.getRandomNode();
      snakeNodes.add(iternode);
      while (snakeNodes.size()<(slength+2)){
        previternode=iternode;
        iternode=iternode.random_adjacent_node();
        List<LXPoint> dotsBetween = nodeToNodePoints(previternode,iternode);
        for (LXPoint p : dotsBetween){
          snakeDots.add(p);
        }
        snakeNodes.add(iternode);
      }
    }
    
    public void run(double deltaMs) {
      float phase=wormthroughbar.getValuef();
      
      //handle disposing/adding new nodes    
      if(phase<prevphase){ //aka if the saw lfo looped back around again
        snakeNodes.remove(0);
        Node lastnode=snakeNodes.get(snakeNodes.size() - 1);
        Node prevlastnode=snakeNodes.get(snakeNodes.size() - 2);
        Node nextnode=lastnode.random_adjacent_node();
        while (nextnode.id==prevlastnode.id){
          nextnode=lastnode.random_adjacent_node();
        }
        snakeNodes.add(nextnode);
      }
      
      Node prevnode=snakeNodes.get(0);
      boolean firstnode=true;
      Node sn=snakeNodes.get(0);
      for(int i=0;i<snakeNodes.size()-1;i++){
        sn=snakeNodes.get(i+1);
        prevnode=snakeNodes.get(i);
          List<LXPoint> the_bar= nodeToNodePoints(prevnode,sn);
          float barlen = the_bar.size();
          if (i==0){
            float pointcounter=0;
            for (LXPoint p : the_bar){
              if (pointcounter/barlen*100>phase){
                addColor(p.index,lx.hsb(hoo,100,100));
              }
              pointcounter+=1;
            }
          } else {
            if (i==snakeNodes.size()-2){
              int pointcounter=0;
              for (LXPoint p : the_bar){
                if (pointcounter/barlen*100<phase){
                   addColor(p.index,lx.hsb(hoo,100,100));
                 }
                 pointcounter++;
              }
            } else {
            for (LXPoint p : the_bar){
              addColor(p.index,lx.hsb(hoo,100,100));
            }
          }
          }
        prevnode=sn;
        }
          
      prevphase=phase;
      }
  }

  public Serpents(LX lx){
    super(lx);
    addParameter(howmanysnakes);
    addParameter(serperiod);
    addParameter(serlength);
  }  
  
  public void run(double deltaMs){
    for (LXPoint p : model.points) {
      colors[p.index]=0;
    }
    while(serpence.size()>howmanysnakes.getValuef()){
      serpence.remove(0);
    }
    while(serpence.size()<howmanysnakes.getValuef()){
      int hoo = int(random(360));
      serpence.add(new Serpent(serperiod.getValuef(),serlength.getValuef(),hoo));
    }
    for (Serpent serpent : serpence){
      serpent.run(deltaMs);
    }  
  }
    
}
      
  



/** ************************************************************** BRAIN STORM
 * Creates a thundercloud with lightning strikes pattern
 * Also an example of basic node traversal
 * @author: Alex Maki-Jokela
 ************************************************************************* **/
 
 
class BrainStorm extends BrainPattern {
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
  
  public BrainStorm(LX lx){
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


/** ************************************************************** HEMISPHERES
 * Test of hemispheres functionality
 ************************************************************************* **/
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

 
 
/** ****************************************************** RAINBOW BARREL ROLL
 * A colored plane of light rotates around an axis
 ************************************************************************* **/
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

 
/** ************************************************************ CIRCLE BOUNCE
 * A plane bounces up and down the brain, making a circle of color.
 ************************************************************************** */
class CircleBounce extends LXPattern {
  
  private final BasicParameter bounceSpeed 
      = new BasicParameter("BNC",  1000, 0, 10000);
  private final BasicParameter colorSpread 
      = new BasicParameter("CLR", 0.0, 0.0, 360.0);
  private final BasicParameter colorFade   
      = new BasicParameter("FADE", 1, 0.0, 10.0);

  public CircleBounce(LX lx) {
    super(lx);
    addParameter(bounceSpeed);
    addParameter(colorSpread);
    addParameter(colorFade);
    addLayer(new CircleLayer(lx));
  }

  public void run(double deltaMs) {}

  private class CircleLayer extends LXLayer {
    private final SinLFO xPeriod = new SinLFO(model.zMin, model.zMax, bounceSpeed);

    private CircleLayer(LX lx) {
      super(lx);
      addModulator(xPeriod).start();
    }

    public void run(double deltaMs) {
      float falloff = 5.0 / colorFade.getValuef();
      for (LXPoint p : model.points) {
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

    
/** ************************************************************** PSYCHEDELIC
 * Colors entire brain in modulatable psychadelic color palettes
 * Demo pattern for GeneratorPalette.
 * @author scouras
 ************************************************************************** */
class Psychedelic extends BrainPattern {
 
  double ms = 0.0;
  double offset = 0.0;
  private final BasicParameter colorScheme = new BasicParameter("SCM", 0, 3);
  private final BasicParameter cycleSpeed = new BasicParameter("SPD",  100, 0, 1000);
  private final BasicParameter colorSpread = new BasicParameter("LEN", 100, 0, 1000);
  private final BasicParameter colorHue = new BasicParameter("HUE",  0., 0., 359.);
  private final BasicParameter colorSat = new BasicParameter("SAT", 80., 0., 100.);
  private final BasicParameter colorBrt = new BasicParameter("BRT", 80., 0., 100.);
  private GeneratorPalette gp = 
      new GeneratorPalette(
          new ColorOffset(0xDD0000).setHue(colorHue)
                                   .setSaturation(colorSat)
                                   .setBrightness(colorBrt),
          //GeneratorPalette.ColorScheme.Complementary,
          GeneratorPalette.ColorScheme.Monochromatic,
          //GeneratorPalette.ColorScheme.Triad,
          //GeneratorPalette.ColorScheme.Analogous,
          100
      );
  private int scheme = 0;
    
  public Psychedelic(LX lx) {
      super(lx);
    addParameter(colorScheme);
    addParameter(cycleSpeed);
    addParameter(colorSpread);
    addParameter(colorHue);
    addParameter(colorSat);
    addParameter(colorBrt);
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
    int steps = (int)colorSpread.getValue();
    if (steps != gp.steps) { 
      gp.setSteps(steps);
    }
    gp.reset((int)offset);
    for (LXPoint p : model.points) {
      colors[p.index] = gp.getColor();
    }
  }
}
  
    
/** ******************************************************* A HOLE IN MY BRAIN
 * Hackathon Entry
 * @author Codey Christensen
 ************************************************************************* **/
    
class AHoleInMyBrain extends BrainPattern {
   int b = 0;
   int s=100;
   float h=100;
   float otherColor = 40;
    
   int i = 0;
   int xpos = 50;
   int ypos = 100;
   int zpos = 45;
   
   private final BasicParameter colorChangeSpeed = new BasicParameter("CLR",  7000, 0, 8000);
   private final BasicParameter len = new BasicParameter("LEN",  220, 10, 225);
   private final BasicParameter changeSpeed = new BasicParameter("SPD",  1, 1, 10);
   private final BasicParameter holeSize = new BasicParameter("HOL",  50, 1, 1000);
    
   private final SinLFO whatColor = new SinLFO(0, 360, colorChangeSpeed);
   private final SinLFO sizeChange = new SinLFO(30, 600, 500);
   
  public AHoleInMyBrain(LX lx){
     super(lx);
     addParameter(colorChangeSpeed);
     addParameter(len);
     addParameter(changeSpeed);
     addParameter(holeSize);
     addModulator(whatColor).trigger();
     addModulator(sizeChange).trigger();
    }
    
    public void run(double deltaMs) {
   i = i + int(changeSpeed.getValuef());
   xpos = i % int(len.getValuef());
   ypos = (i % int(len.getValuef())) + int(holeSize.getValuef());
   
   //complimentary color
   otherColor = (whatColor.getValuef() + 180) % 360;
   
   for (LXPoint p : model.points) {
      if (p.x-model.xMin < xpos || p.x-model.xMin  > ypos) {
        b = 100;
      } else if (p.y-model.yMin < xpos || p.y-model.yMin  > ypos) {
        h = otherColor;
        b = 100;
      } else {
        b = 0;
        h = whatColor.getValuef();
      }
      colors[p.index]=lx.hsb(h,s,b);
    }
  }
}

/** ************************************************************ PIXIE PATTERN
 * Points of light that chase along the edges.
 *
 * More ideas for later:
 * - Scatter/gather (they swarm around one point, then fly by
 *   divergent paths to another point)
 * - Fireworks (explosion of them coming out of one point)
 * - Multiple colors (maybe just a few in a different color)
 *
 * @author Geoff Schmiddt
 ************************************************************************* **/
class PixiePattern extends BrainPattern {
  // How many pixies are zipping around.
  private final BasicParameter numPixies =
      new BasicParameter("NUM", 100, 0, 1000);
  // How fast each pixie moves, in pixels per second.
  private final BasicParameter speed =
      new BasicParameter("SPD", 60.0, 10.0, 1000.0);
  // How long the trails persist. (Decay factor for the trails, each frame.)
  // XXX really should be scaled by frame time
  private final BasicParameter fade =
      new BasicParameter("FADE", 0.9, 0.8, .99);
  // Brightness adjustment factor.
  private final BasicParameter brightness =
      new BasicParameter("BRIGHT", 1.0, .25, 2.0);

  class Pixie {
    public Node fromNode, toNode;
    public double offset;
    public int kolor;

    public Pixie() {
    }
  }
  private ArrayList<Pixie> pixies = new ArrayList<Pixie>();

  public PixiePattern(LX lx) {
    super(lx);
    addParameter(numPixies);
    addParameter(fade);
    addParameter(speed);
    addParameter(brightness);
  }

  public void setPixieCount(int count) {
    while (this.pixies.size() < count) {
      Pixie p = new Pixie();
      p.fromNode = model.getRandomNode();
      p.toNode = p.fromNode.random_adjacent_node();
      p.kolor = lx.hsb(0, 0, 100);
      this.pixies.add(p);
  }
    if (this.pixies.size() > count) {
      this.pixies.subList(count, this.pixies.size()).clear();
    }
  } 

  public void run(double deltaMs) {
    this.setPixieCount(Math.round(numPixies.getValuef()));
    //    System.out.format("FRAME %.2f\n", deltaMs);

    for (LXPoint p : model.points) {
     colors[p.index] =
         LXColor.scaleBrightness(colors[p.index], fade.getValuef());
    }

    for (Pixie p : this.pixies) {
      double drawOffset = p.offset;
      p.offset += (deltaMs / 1000.0) * speed.getValuef();
      //      System.out.format("from %.2f to %.2f\n", drawOffset, p.offset);

      while (drawOffset < p.offset) {
          //        System.out.format("at %.2f, going to %.2f\n", drawOffset, p.offset);
        List<LXPoint> points = nodeToNodePoints(p.fromNode, p.toNode);

        int index = (int)Math.floor(drawOffset);
        if (index >= points.size()) {
          Node oldFromNode = p.fromNode;
          p.fromNode = p.toNode;
          do {
            p.toNode = p.fromNode.random_adjacent_node();
          } while (angleBetweenThreeNodes(oldFromNode, p.fromNode, p.toNode)
                   < 4*PI/360*3); // don't go back the way we came
          drawOffset -= points.size();
          p.offset -= points.size();
          //          System.out.format("next edge\n");
          continue;
        }

        // How long, notionally, was the pixie at this pixel during
        // this frame? If we are moving at 100 pixels per second, say,
        // then timeHereMs will add up to 1/100th of a second for each
        // pixel in the pixie's path, possibly accumulated over
        // multiple frames.
        double end = Math.min(p.offset, Math.ceil(drawOffset + .000000001));
        double timeHereMs = (end - drawOffset) /
            speed.getValuef() * 1000.0;

        LXPoint here = points.get((int)Math.floor(drawOffset));
        //        System.out.format("%.2fms at offset %d\n", timeHereMs, (int)Math.floor(drawOffset));

        addColor(here.index,
                 LXColor.scaleBrightness(p.kolor,
                                         (float)timeHereMs / 1000.0
                                         * speed.getValuef()
                                         * brightness.getValuef()));
        drawOffset = end;
      }
    }
  }
}

/** ******************************************************************* STROBE
 * Simple monochrome strobe light.
 * @author Geoff Schmidt
 ************************************************************************* **/

class StrobePattern extends BrainPattern {
  private final BasicParameter speed = new BasicParameter("SPD",  5000, 0, 10000);
  private final BasicParameter min = new BasicParameter("MIN",  60, 10, 500);
  private final BasicParameter max = new BasicParameter("MAX",  500, 0, 2000);
  private final SinLFO rate = new SinLFO(min, max, speed);
  private final SquareLFO strobe = new SquareLFO(0, 100, rate);

  private final BasicParameter saturation =
      new BasicParameter("SAT", 100, 0, 100);
  // hue rotation in cycles per minute
  private final BasicParameter hueSpeed = new BasicParameter("HUE", 15, 0, 120);
  private final LinearEnvelope hue = new LinearEnvelope(0, 360, 0);

  private boolean wasOn = false;
  private int latchedColor = 0;

  public StrobePattern(LX lx) {
    super(lx);
    addParameter(speed);
    addParameter(min);
    addParameter(max);
    addModulator(rate).start();
    addModulator(strobe).start();
    addParameter(saturation);
    addParameter(hueSpeed);
    hue.setLooping(true);
    addModulator(hue).start();
  }

  public void run(double deltaMs) {
    hue.setPeriod(60 * 1000 / (hueSpeed.getValuef() + .00000001));

    boolean isOn = strobe.getValuef() > .5;
    if (isOn && ! wasOn) {
      latchedColor =
        lx.hsb(hue.getValuef(), saturation.getValuef(), 100);
  }
  
    wasOn = isOn;
    int kolor = isOn? latchedColor : LXColor.BLACK;
    for (LXPoint p : model.points) {
      colors[p.index] = kolor;
    }
 }
}


/** ******************************************************************** MOIRE
 * Moire patterns, computed across the actual topology of the brain.
 *
 * Basically this is the classic demoscene Moire effect:
 * http://www.youtube.com/watch?v=XtCW-axRJV8&t=2m54s
 *
 * but distance is defined as the actual shortest path along the bars,
 * so the effect happens across the actual brain structure (rather
 * than a 2D plane).
 *
 * Potential improvements:
 * - Map to a nice color gradient, then run several of these in parallel
 *   (eg, 2 sets of 2 generators, each with a different palette)
 *   and mix the colors
 * - Make it more efficient so you can sustain full framerate even with
 *   higher numbers of generators
 *
 * @author Geoff Schmidt
 ************************************************************************* **/

class MovableDistanceField {
  private LXPoint origin;
  double width;
  int[] distanceField;
  SemiRandomWalk walk;

  LXPoint getOrigin() {
    return origin;
  }

  void setOrigin(LXPoint newOrigin) {
    origin = newOrigin;
    distanceField = distanceFieldFromPoint(origin);
    walk = new SemiRandomWalk(origin);
  }

  void advanceOnWalk(double howFar) {
    origin = walk.step(howFar);
    distanceField = distanceFieldFromPoint(origin);
  }
};

class MoireManifoldPattern extends BrainPattern {
  // Stripe width (generator field periodicity), in pixels
  private final BasicParameter width = new BasicParameter("WID", 65, 500);
  // Rate of movement of generator centers, in pixels per second
  private final BasicParameter walkSpeed = new BasicParameter("SPD", 100, 1000);
  // Number of generators
  private final DiscreteParameter numGenerators =
      new DiscreteParameter("GEN", 2, 1, 8 + 1);
  // Number of generators that are smooth
  private final DiscreteParameter numSmooth =
      new DiscreteParameter("SMOOTH", 2, 0, 8 + 1);

  ArrayList<Generator> generators = new ArrayList<Generator>();

  class Generator extends MovableDistanceField {
    boolean smooth = false;

    double contributionAtPoint(LXPoint where) {
      int dist = distanceField[where.index];
      double ramp = ((float)dist % (float)width) / (float)width;
      if (smooth) {
        return ramp;
      } else {
        return ramp < .5 ? 0.5 : 0.0;
  }
      }
      }
      
  public MoireManifoldPattern(LX lx) {
    super(lx);
    addParameter(width);
    addParameter(walkSpeed);
    addParameter(numGenerators);
    addParameter(numSmooth);
    }
      
  public void setGeneratorCount(int count) {
    while (generators.size() < count) {
      Generator g = new Generator();
      g.setOrigin(model.getRandomPoint());
      generators.add(g);
    }
    if (generators.size() > count) {
      generators.subList(count, generators.size()).clear();
        }
      }
      
  public void run(double deltaMs) {
    setGeneratorCount(numGenerators.getValuei());
    numSmooth.setRange(0, numGenerators.getValuei() + 1);

    int i = 0;
    for (Generator g : generators) {
      g.width = width.getValuef();
      g.advanceOnWalk(deltaMs / 1000.0 * walkSpeed.getValuef());
      g.smooth = i < numSmooth.getValuei();
      i ++;
        }

    for (LXPoint p : model.points) {
      float sumField = 0;
      for (Generator g : generators) {
        sumField += g.contributionAtPoint(p);
      }

      sumField = (cos(sumField * 2 * PI) + 1)/2;
      colors[p.index] = lx.hsb(0.0, 0.0, sumField * 100);
    }
      
    /*
    for (Generator g : generators) {
      colors[g.getOrigin().index] = LXColor.RED;
    }
    */
  } 
}


/** *************************************************************** WAVE FRONT
 * Colorful splats that spread out across the topology of the brain
 * and wobble a bit as they go.
 *
 * Simple application of MovableDistanceField.
 *
 * Potential improvements:
 * - Nicer set of color gradients. Maybe 1D textures?
 *
 * Some nice settings (NUM/WSPD/GSPD/WID):
 * - 6, 170, 285, 190
 * - 1, 0, 85, 162.5
 * - 5, 110, 85, 7.5
 *
 * @author Geoff Schmidt
 ************************************************************************* **/

class WaveFrontPattern extends BrainPattern {
  // Number of splats
  private final DiscreteParameter numSplats =
      new DiscreteParameter("NUM", 4, 1, 10 + 1);
  // Rate at which splat center moves (pixels / sec)
  private final BasicParameter walkSpeed =
      new BasicParameter("WSPD", 70, 0, 1000);
  // Rate at which splats grow (pixels / sec)
  private final BasicParameter growSpeed =
      new BasicParameter("GSPD", 125, 0, 500);
  // Width of splat band (pixels)
  private final BasicParameter width =
      new BasicParameter("WID", 30, 0, 250);

  class Splat extends MovableDistanceField {
    double age; // seconds
    double size; // pixels
    double walkSpeed;
    double growSpeed;
    double width = 50;
    double baseHue;
    double hueWidth = 90; // degrees of hue covered by the band
    double timeSinceAnyUnreached = 0;
    double timeToReset = -1;

    Splat() {
      this.reset();
    }

    void reset() {
      age = 0;
      size = 0;
      baseHue = (new Random()).nextDouble() * 360;
      timeSinceAnyUnreached = 0;
      timeToReset = -1;
      this.setOrigin(model.getRandomPoint());
    }

    void advanceTime(double deltaMs) {
      age += deltaMs / 1000;
      timeSinceAnyUnreached += deltaMs / 1000;
      size += deltaMs / 1000 * growSpeed;
      this.advanceOnWalk(deltaMs / 1000.0 * walkSpeed);

      if (timeSinceAnyUnreached > .5 && timeToReset < 0) {
        // For the last half a second, we've been big enough to cover
        // the whole brain. Time to think about resetting. Do it at a
        // random point in the future such that we're active about 80%
        // of the time. This will help the resets of different splats
        // to stay spaced out rather than getting bunched up.
        timeToReset = age + age * (new Random()).nextDouble() * .25;
      }

      if (timeToReset > 0 && age > timeToReset)
        // The planned reset time has come.
        reset();
    }

    int colorAtPoint(LXPoint p) {
      double pixelsBehindFrontier = size - (double)distanceField[p.index];
      if (pixelsBehindFrontier < 0) {
        timeSinceAnyUnreached = 0;
        return LXColor.hsba(0, 0, 0, 0);
      } else {
        double positionInBand = 1.0 - pixelsBehindFrontier / width;
        if (positionInBand < 0.0) {
          return LXColor.hsba(0, 0, 0, 0);
        } else {
            double hoo = baseHue + positionInBand * hueWidth;
    
            // return LXColor.hsba(hoo, Math.min((1 - positionInBand) * 250, 100), Math.min(100, 500 + positionInBand * 100), 1.0);
            return LXColor.hsba(hoo, 100, 100, 1.0);
  }
      }
    }
      }

  ArrayList<Splat> splats = new ArrayList<Splat>();

  public WaveFrontPattern(LX lx) {
    super(lx);
    addParameter(numSplats);
    addParameter(walkSpeed);
    addParameter(growSpeed);
    addParameter(width);
    }

  public void setSplatCount(int count) {
    while (splats.size() < count) {
      splats.add(new Splat());
        }
    if (splats.size() > count) {
      splats.subList(count, splats.size()).clear();
      }
    }

  public void run(double deltaMs) {
    setSplatCount(numSplats.getValuei());
    for (Splat s : splats) {
      s.advanceTime(deltaMs);
      s.walkSpeed = walkSpeed.getValuef();
      s.growSpeed = growSpeed.getValuef();
      s.width = width.getValuef();
      }

    Random rand = new Random();
    for (LXPoint p : model.points) {
      int kolor = LXColor.BLACK;
      for (Splat s : splats) {
        kolor = LXColor.blend(kolor, s.colorAtPoint(p), LXColor.Blend.ADD);
      }
      colors[p.index] = kolor;
   }  
  }
}
 
/** *********************************************************** COLORED STATIC
 * MultiColored static, with black and white mode
 * @author: Codey Christensen
 ************************************************************************* **/
 
class ColorStatic extends BrainPattern {
 
  ArrayList<LXPoint> current_points = new ArrayList<LXPoint>();
  ArrayList<LXPoint> random_points = new ArrayList<LXPoint>();
 
  int i;
  int h;
  int s;
  int b;
 
  private final BasicParameter number_of_points = new BasicParameter("PIX",  340, 50, 1000);
  private final BasicParameter decay = new BasicParameter("DEC",  0, 5, 100);
  private final BasicParameter black_and_white = new BasicParameter("BNW",  0, 0, 1);
   
  private final BasicParameter color_change_speed = new BasicParameter("SPD",  205, 0, 360);
  private final SinLFO whatColor = new SinLFO(0, 360, color_change_speed);
    
  public ColorStatic(LX lx){
     super(lx);
     addParameter(number_of_points);
     addParameter(decay);
     addParameter(color_change_speed);
     addParameter(black_and_white);
     addModulator(whatColor).trigger();
  }
  
 public void run(double deltaMs) {
   i = i + 1;
     
   random_points = model.getRandomPoints(int(number_of_points.getValuef()));

   for (LXPoint p : random_points) {
      h = int(whatColor.getValuef());
      if(int(black_and_white.getValuef()) == 1) {
        s = 0;
      } else {
        s = 100;
 }
      b = 100;

      colors[p.index]=lx.hsb(h,s,b);
      current_points.add(p);
  }

   if(i % int(decay.getValuef()) == 0) {
     for (LXPoint p : current_points) {
        h = 0;
        s = 0;
        b = 0;

        colors[p.index]=lx.hsb(h,s,b);
    }
     current_points.clear();
    }
  }
}
