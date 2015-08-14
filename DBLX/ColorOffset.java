import java.awt.Color;
import heronarts.lx.LX;
import heronarts.lx.color.*;
import heronarts.lx.LXComponent;
import heronarts.lx.LXUtils;
import heronarts.lx.parameter.BasicParameter;
import heronarts.lx.parameter.FixedParameter;
import heronarts.lx.parameter.LXListenableParameter;
import heronarts.lx.parameter.LXParameter;
import heronarts.lx.parameter.LXParameterListener;

/**
 * Stores LXParameter HSB color offsets to a generatlized ColorParameter. 
 */
public class ColorOffset extends ColorParameter {
  // implements LXParameterListener {

  public String label;
  public LXParameter hue;
  public LXParameter saturation;
  public LXParameter brightness;

  public LXParameter hueOffset = new FixedParameter(0.0);
  public LXParameter saturationOffset = new FixedParameter(0.0);
  public LXParameter brightnessOffset = new FixedParameter(0.0);

  //============== CONSTRUCTORS
  public ColorOffset(int color) { 
    this(String.format("ColorOffset: #%x", color), color); 
  }
  public ColorOffset(String label, int color) { 
    super(label, color); 
    this.label = label;
    this.hue = super.hue;
    this.saturation = super.saturation;
    this.brightness = super.brightness;
  }

  public ColorOffset(LXParameter hue, 
                     LXParameter saturation, 
                     LXParameter brightness) { 
    this(String.format("ColorOffset H: %.2f S: %.2f B: %.2f", 
              hue.getValue(), saturation.getValue(), brightness.getValue()), 
        hue, saturation, brightness);
  }

  public ColorOffset(String label,
                     LXParameter hue, 
                     LXParameter saturation, 
                     LXParameter brightness) { 
    super(label);
    this.label = label;
    this.hue = hue;
    this.saturation = saturation;
    this.brightness = brightness;
    //hue.addListener(this);
    //saturation.addListener(this);
    //brightness.addListener(this);
    //System.out.println("GP - " + label);
  }

  
  //============== ALTERNATE CONSTRUCTORS
  public ColorOffset(ColorParameter color) {
    super("CP");
    this.hue = color.hue;
    this.saturation = color.saturation;
    this.brightness = color.brightness;
  }

  public ColorOffset clone() { 
    return new ColorOffset(this.label+"-clone", this.hue, this.saturation, this.brightness);
  }

  //============== SETTERS
  public ColorOffset setHue(double hue) { 
    return this.setHue(new FixedParameter(hue));
  }
  public ColorOffset setHue(LXParameter hue) { 
    this.hue = hue;
    return this;
  }
  public ColorOffset setSaturation(double saturation) { 
    return this.setSaturation(new FixedParameter(saturation));
  }
  public ColorOffset setSaturation(LXParameter saturation) { 
    this.saturation = saturation;
    return this;
  }
  public ColorOffset setBrightness(double brightness) { 
    return this.setBrightness(new FixedParameter(brightness));
  }
  public ColorOffset setBrightness(LXParameter brightness) { 
    this.brightness = brightness;
    return this;
  }

  //============== GETTERS
  public double getHue() { 
    return (hue.getValue() + hueOffset.getValue())%360.;
  }
  public double getSaturation() { 
    return LXUtils.constrain(saturation.getValue() + saturationOffset.getValue(), 0., 100.);
  }
  public double getBrightness() { 
    return LXUtils.constrain(brightness.getValue() + brightnessOffset.getValue(), 0., 100.);
  }
  public double[] getHSB() { 
    //System.out.println("Getting HSB for " + label);
    return new double[] {getHue(), getSaturation(), getBrightness()};
  }
  public int getColor() {
    //System.out.println("Getting color for " + label);
    double[] hsb = getHSB();
    return LXColor.hsb(hsb[0], hsb[1], hsb[2]);
  }
  public int[] getRGB() { 
    //System.out.println("Getting RGB for " + label);
    int color = getColor();
    return new int[] {LXColor.red(color), 
                      LXColor.green(color), 
                      LXColor.blue(color)};
  }

  public String getLabel() { 
    return this.label;
  }


  public ColorOffset spin(double spin) { 
    this.label += String.format("-spin(%.2f)", spin);
    return this.spin(new FixedParameter(spin));
  }
  public ColorOffset spin(LXParameter spin) { 
    this.hueOffset = spin;
    return this;
  }
  
  public ColorOffset saturate(double saturate) { 
    this.label += String.format("-sat(%.2f)", saturate);
    return this.saturate(new FixedParameter(saturate));
  }
  public ColorOffset saturate(LXParameter saturate) { 
    this.saturationOffset = saturate;
    return this;
  }
 
  public ColorOffset brighten(double brighten) { 
    this.label += String.format("-brgt(%.2f)", brighten);
    return this.brighten(new FixedParameter(brighten));
  }
  public ColorOffset brighten(LXParameter brighten) { 
    this.brightnessOffset = brighten;
    return this;
  }

}




