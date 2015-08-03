/*****************************************************************************
 *    PATTERNS THAT ARE NOT TO BE DISLPAYED FOR SOME REASON
 ****************************************************************************/


/** **************************************************************************
 * ported from sugarcubes by Jeanie 
 * Do not want to trample on sugarcubes IP though.
 ************************************************************************* **/ 
class Swim extends BrainPattern {

  // Projection stuff
  private final LXProjection projection;
  SawLFO rotation = new SawLFO(0, TWO_PI, 19000);
  SinLFO yPos = new SinLFO(-25, 25, 12323);
  final BasicParameter xAngle = new BasicParameter("XANG", 0.9);
  final BasicParameter yAngle = new BasicParameter("YANG", 0.3);
  final BasicParameter zAngle = new BasicParameter("ZANG", 0.3);

  final BasicParameter hueScale = new BasicParameter("HUE", 0.3);

  public Swim(LX lx) {
    super(lx);
    projection = new LXProjection(model);

    addParameter(xAngle);
    addParameter(yAngle);
    addParameter(zAngle);
    addParameter(hueScale);

    addModulator(rotation).trigger();
    addModulator(yPos).trigger();
  }


  int beat = 0;
  float prevRamp = 0;
  void run(double deltaMs) {

    // Sync to the beat
    float ramp = (float)lx.tempo.ramp();
    if (ramp < prevRamp) {
      beat = (beat + 1) % 4;
    }
    prevRamp = ramp;
    float phase = (beat+ramp) / 2.0 * 2 * PI;

    float denominator = max(xAngle.getValuef() + yAngle.getValuef() + zAngle.getValuef(), 1);

   projection.reset()
      // Swim around the world
     .rotate(rotation.getValuef(), xAngle.getValuef() / denominator, yAngle.getValuef() / denominator, zAngle.getValuef() / denominator)
      .translateCenter(0, 50 + yPos.getValuef(), 0);

    float model_height =  model.yMax - model.yMin;
    float model_width =  model.xMax - model.xMin;
    for (LXVector p : projection) {
      float x_percentage = (p.x - model.xMin)/model_width;

      // Multiply by 1.4 to shrink the size of the sin wave to be less than the height of the cubes.
      float y_in_range = 1.4 * (2*p.y - model.yMax - model.yMin) / model_height;
      float sin_x =  sin(phase + 2 * PI * x_percentage);       

      // Color fade near the top of the sin wave
      float v1 = sin_x > y_in_range  ? (100 + 100*(y_in_range - sin_x)) : 0;     

      float hue_color = (lx.getBaseHuef() + hueScale.getValuef() * (abs(p.x-model.xMax/2.)*.3 + abs(p.y-model.yMax/2)*.9 + abs(p.z - model.zMax/2.))) % 360;
      colors[p.index] = lx.hsb(hue_color, 70, v1);
    }
  }
}







/** **************************************************************************
 * Per Anna: Pattern is still WIP, this is its' current state.
 * Anna Leshinskaya
 ************************************************************************* **/ 

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
    //println(howFarFromGoal);
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





