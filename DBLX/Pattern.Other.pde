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







