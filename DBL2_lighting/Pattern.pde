// processing-java --run --sketch=`pwd` --output=/tmp/something --force

/**
 * This file has a bunch of example patterns, each illustrating the key
 * concepts and tools of the LX framework.
 */




//Per Anna: Pattern is still WIP, this is its' current state.
class annaPattern extends BrainPattern { 
  
  Node firstNode;
  public final BasicParameter colorSpread = new BasicParameter("Clr", 0.5, 0, 3);
 BasicParameter xPer = new BasicParameter("XPD",6000,5000,20000);
   BasicParameter yPer = new BasicParameter("YPD",6000,5000,20000);
   SawLFO linenvx = new SawLFO(0.0,1.0,xPer);
   SawLFO linenvy = new SawLFO(0.0,1.0,yPer);
 
 public final SinLFO xPeriod = new SinLFO(3400, 7900, 11000); 
 public final SinLFO brightness = new SinLFO(model.xMin, model.xMax, xPeriod);

////  private final SinLFO brightnessX = new SinLFO(model.xMin, model.xMax, xPeriod);
  private final BasicParameter colorFade = new BasicParameter("Fade", 0.95, 0.9, 1.0);
  public PVector destination; 
  //define direction vector, i.e.  , destination
  public final ArrayList<Node> streamPath; 
  
    
 public annaPattern(LX lx){
   
   super(lx);
    addParameter(colorSpread);    
    addModulator(linenvx).start();
    addModulator(linenvy).start();
    addParameter(xPer);
    addParameter(yPer);
     addModulator(xPeriod).start();
     addModulator(brightness).start();
    firstNode = model.getFirstNodeAnnaPattern();
  //try the sawlfo modulator next
    destination = new PVector(-100,-100,-100);
  
  //makes a dark blue brain to start with
  for (LXPoint p : model.points) {
    float h=250; //hue
    int s=100; //saturation
    int b=100; // brightness
    colors[p.index]=lx.hsb(h,s,b); //sets colors of the node, point has attribute index
    }
  
  //defines the vector of nodes along path we want
   streamPath = new ArrayList();
  PVector whereamI;
  Node nextNode;
  float howFarFromGoal;
  howFarFromGoal = 100;
  
  while (howFarFromGoal>55 && firstNode.y != model.yMin && firstNode.y != model.xMin){
   
  //to demo it, colors each node light blue
   
  //start with first node
  List<Bar> barlist;
  barlist = firstNode.adjacent_bars();
  for (Bar b: barlist) {
        for (LXPoint p: b.points){
          colors[p.index]=lx.hsb(200,100,100);
        }
     }
    
   //pass to getNextNode
   //(ALEX MAKI-JOKELA) - I changed this line a little bit -your getNextNode function is super useful
   //so I renamed it and incorporated it into the Node class
    nextNode = firstNode.getNextNodeByVector(destination);
    whereamI = new PVector(nextNode.x,nextNode.y,nextNode.z);
     
   //ok now color the points to the next node
    List<LXPoint> bar_points = nodeToNodePoints(firstNode,nextNode);
    for (LXPoint p: bar_points) {
          colors[p.index]=lx.hsb(200,100,100);
        }
        
    howFarFromGoal = PVector.dist(whereamI,destination);
    println(howFarFromGoal);
    //nextNode now becomes First Node, until destination is reached.
      firstNode = nextNode;
   //add to array
   streamPath.add(nextNode);
  }//end while 
 }
 
public void run (double deltaMS) {
  //for the set of items:
  //modulate base hue from modulator
  //adjust by order to spread it, very incrementally
  List<Bar> barlist;
  int count = 1;
//  Collections.reverse(streamPath);

  for (Node n: streamPath){
      count++;
     barlist = n.adjacent_bars();
     for (Bar b: barlist) {
        for (LXPoint p: b.points){

          colors[p.index]=lx.hsb(
              100 - (linenvy.getValuef() * 100 * count ) ,
              100,100);
        }
     }
    
   
  }
}
} 





//************************* POWER RANGERS MASK PATTERN  **********************************
//******************** All 5 rangers in less than 4 minutes   ********************

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

//***********************************************************
//***********************************************************




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
        if (abs(site.yPos - p.y) < yMaxDist * calcRestraintConst &&
            abs(site.xPos - p.x) < xMaxDist * calcRestraintConst &&
            abs(site.zPos - p.z) < zMaxDist * calcRestraintConst) { //restraint on calculation
          float distSq = pow(site.xPos - p.x, 2) + pow(site.yPos - p.y, 2) + pow(site.zPos - p.z, 2);
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



/** 
 * Snake traces. I'm going to see if there's a good way to make this a class people can just call on to add snakes to their patterns tomorrow.
 * Feel free to adapt and work into your own patterns.
*/

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
 * Creates a thundercloud with lightning strikes pattern
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
  private final BasicParameter colorSpread = new BasicParameter("CLR", 0.0, 0.0, 360.0);
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


class PaletteDemo extends BrainPattern {
 
  double ms = 0;
  int offset = 0;
  private final BasicParameter cycleSpeed = new BasicParameter("SPD",  100, 0, 1000);
  private final BasicParameter colorSpread = new BasicParameter("LEN", 100, 0, 1000);
  private GeneratorPalette gp = 
      new GeneratorPalette(
          GeneratorPalette.ColorScheme.Analogous60,
          0xDD0000,
          GeneratorPalette.RepeatPattern.Reverse,
          100
      );
          
  public PaletteDemo(LX lx) {
    super(lx);
    addParameter(cycleSpeed);
    addParameter(colorSpread);
  }

  public void run(double deltaMs) {
    ms += deltaMs;
    int steps = (int)colorSpread.getValue();
    if (steps != gp.steps) { 
      gp.setSteps(steps);
    }
    offset += (int)deltaMs*(int)cycleSpeed.getValue()/1000;
    gp.reset(offset);
    for (LXPoint p : model.points) {
      colors[p.index] = gp.getColor();
    }
  }
}

/**
 * Points of light that chase along the edges.
 *
 * More ideas for later:
 * - Scatter/gather (they swarm around one point, then fly by
 *   divergent paths to another point)
 * - Fireworks (explosion of them coming out of one point)
 * - Multiple colors (maybe just a few in a different color)
 *
 * @author Geoff Schmiddt
 */
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

/**
 * Simple monochrome strobe light.
 *
 * @author Geoff Schmidt
 */

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


/**
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
 */

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

  class Generator {
    private LXPoint origin;
    double width;
    int[] distanceField;
    SemiRandomWalk walk;
    boolean smooth = false;

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

    if (generators.size() > 0) {
      generators.get(0).smooth = true;
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



/*
Idea: color based on total distance to generator points. 0 if less, white if more. increase the threshold. an interesting spider spread.
*/
class AHoleInMyBrain extends BrainPattern {
   int b = 0;
   int s=100;
   float h=100;
   float otherColor = 40;
   
   int i = 0;
   int xpos = 50;
   int ypos = 100;
   int zpos = 45;
   
   private final BasicParameter colorChangeSpeed = new BasicParameter("SPD",  7000, 0, 8000);
   private final SinLFO whatColor = new SinLFO(0, 360, colorChangeSpeed);
   
  public AHoleInMyBrain(LX lx){
     super(lx);
     addParameter(colorChangeSpeed);
     addModulator(whatColor).trigger();
  }
  
 public void run(double deltaMs) {
   i = i + 1;
   xpos = i % 220;
   ypos = (i % 220) + 50;
   
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
