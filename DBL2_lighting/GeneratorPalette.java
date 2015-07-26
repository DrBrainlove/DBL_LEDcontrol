import heronarts.lx.color.*;
import java.awt.Color;

public class GeneratorPalette {

  /////////////////////////////////////////////////////////////// ENUMERATIONS

  // Color Scheme (for color scheme generation)
  public enum ColorScheme {
    Analogous, 
    Analogous30,
    Analogous45,
    Analogous60,
    Analogous90,
    Monochromatic, 
    Triad, 
    Complementary,
    Custom
  }

  // What to do when we get to the end of the color palette
  public enum LoopPattern { Default, Repeat, Reverse, Cycle }
  
  // Color Space flags that modulate certain algorithms
  public enum ColorSpace { RGB, HSB, CIE }


  /////////////////////////////////////////////////// COLOR CYCLE PHASE STRUCT
  /**
   * The full color cycle is broken into phases of interpolation between
   * reference colors.
   */
  private class ColorCyclePhase {
    int index = 0; // which phase
    int color_start = 0; // starting color index
    int color_end = 0; // target color index
    double progress_start = 0; // starting point for total progress
    double progress_end = 0; // stopping point for total progress

    ColorCyclePhase(int i, int cs, int ce, double ps, double pe) { 
      index = i;
      color_start = cs;
      color_end = ce;
      progress_start = ps;
      progress_end = pe;

      //System.out.format("I: %d  %.2f-%.2f  %d-%d\n", i, ps, pe, cs, ce); 
    }
  }

  ////////////////////////////////////////////////////////// GENERATOR PALETTE
  
  //======================================================= INSTANCE VARIABLES

  // reference color color palette
  public ColorOffset   color;
  public ColorOffset[] palette;

  // generator parameters
  public ColorSpace space = ColorSpace.HSB;
  public ColorScheme scheme = null;
  public LoopPattern loop = null;
  public double AnalogSpin = 0;
  public double MonochromeLight =  40.;
  public double MonochromeDark  = -40.;

  // steps in cycle and progress record
  public int steps;
  private double step_size = 0.0; 
  private double progress = 0.0;

  // phases of the color cycle
  private int phase = 0;
  private int phase_count = 0;
  private ColorCyclePhase[] phases = null;

  private boolean internalValueUpdate = false;

  //============================================================= CONSTRUCTORS

  /**
   * A color palette that algorithmically generates a new color at each 
   * step based on the selected color scheme.
   *
   * @param scheme Analogous, Monochromatic, Triad, Complementary
   * @param base_color Color from which to generate the palette
   * @param loop How to loop once reaching the end of the palette
   * @param steps Number of pixels or timesteps in a comlpete cycle
   */

  public GeneratorPalette( int color, ColorScheme scheme, int steps ) { 
    this(new ColorOffset(String.format("GP-Base #%x", color), color), scheme, steps);
  }

  public GeneratorPalette( ColorOffset color, ColorScheme scheme, int steps ) { 

    this.color  = color;
    this.scheme = scheme;
    this.steps  = steps;
    this.loop   = getDefaultLoop();
    this.space  = getDefaultSpace();

    
    reset();
    updateSteps();
    updatePalette();
    updatePhases();
  }


  /*
  // Want to generate scheme based on a color
  GP(color, scheme, steps);
  GP(ColorParameter, schema, steps); 
  GP(ColorOffset, schema, steps);

  // Have palettes already, so don't have to generate secondary colors
  GP(color[], steps);
  GP(ColorParameter[], steps);
  GP(ColorOffset[], steps);
  // Complexest 
  */

  //================================================================== SETTERS

  /**
   * Set a new base color and regenerate the palette.
   */
  public GeneratorPalette setColor(int color) {
    this.color = new ColorOffset(color);
    updatePalette();
    return this;
  }

  public GeneratorPalette setColor(ColorOffset color) { 
    this.color = color;
    updatePalette();
    return this;
  }

  /**
   * Set a new color scheme and regenerate the palette.
   */
  public GeneratorPalette setScheme(ColorScheme scheme) {
    // TODO: wonder if this is a good idea
    this.scheme = scheme;
    updatePalette();
    return this;
  }

  /**
   * Set a new color space (RGB/HSV) for color interpolation.
   */
  public GeneratorPalette setSpace(ColorSpace space) {
    this.space = space;
    return this;
  }

  /**
   * Set steps in color cycle.
   */
  public GeneratorPalette setSteps(int steps) {
    this.steps=steps;
    updateSteps();
    return this;
  }
  private void updateSteps() {
    this.step_size = 1.0/(double)steps;
  }

  //=========================================================== INITIALIZATION

  /**
   * Get the default interpolation space for each color scheme.
   */
  private ColorSpace getDefaultSpace() {
    switch(scheme) {
      case Analogous:     return ColorSpace.HSB;
      case Monochromatic: return ColorSpace.HSB;
      case Triad:         return ColorSpace.HSB;
      case Complementary: return ColorSpace.RGB;
      case Custom:        return ColorSpace.HSB;
      default:            return ColorSpace.HSB;
    }
  }

  /**
   * Get the default looping pattern for each color scheme.
   */
  private LoopPattern getDefaultLoop() {
    switch(scheme) {
      case Analogous:     return LoopPattern.Reverse;
      case Monochromatic: return LoopPattern.Reverse;
      case Triad:         return LoopPattern.Cycle;
      case Complementary: return LoopPattern.Reverse;
      case Custom:        return LoopPattern.Reverse;
      default:            return LoopPattern.Repeat;
    }
  }

  /**
   * Initialize color palettes from the base color.
   */
  private void updatePalette() {

    switch (scheme) { 
      case Analogous:   AnalogSpin =  30.; scheme=ColorScheme.Analogous; break;
      case Analogous30: AnalogSpin =  30.; scheme=ColorScheme.Analogous; break;
      case Analogous45: AnalogSpin =  45.; scheme=ColorScheme.Analogous; break;
      case Analogous60: AnalogSpin =  60.; scheme=ColorScheme.Analogous; break;
      case Analogous90: AnalogSpin =  90.; scheme=ColorScheme.Analogous; break;
      //case Triad:       AnalogSpin = 120; scheme=Analogous; break;
    }

    switch (scheme) {
      case Analogous:
        palette = new ColorOffset[] {color.clone().spin(-AnalogSpin),
                                     color,
                                     color.clone().spin( AnalogSpin)};
        break;
      case Monochromatic:
        palette = new ColorOffset[] {color.clone().setBrightness(MonochromeLight),
                                     color,
                                     color.clone().setBrightness(MonochromeDark)};
        break;
      case Triad:
        palette = new ColorOffset[] {color.clone().spin(-120.),
                                     color,
                                     color.clone().spin( 120.)};
        break;
      case Complementary:
        palette = new ColorOffset[] { color,
                                     color.clone().spin( 180.)};
        break;
      case Custom:
        break;
      default:
        throw new RuntimeException(
            "Don't know how to interpret color scheme " + scheme);
    }

    updatePhases();
  }

  /**
   * Initialize color cycle looping into phases.
   */

  private void updatePhases() {
    
    if (loop == LoopPattern.Repeat) { 
      phase_count = palette.length-1;
      phases = new ColorCyclePhase[phase_count];
      int p = 0;
      for (int i=0; i<palette.length-1; i++) { 
        phases[p] = new ColorCyclePhase(p, i, i+1,
                                        (double)(p  )/(double)phase_count,
                                        (double)(p+1)/(double)phase_count);
        p++;
      }
    } else if (loop == LoopPattern.Reverse) { 
      phase_count = (palette.length-1) * 2;
      phases = new ColorCyclePhase[phase_count];
      int p = 0;
      for (int i=0; i<palette.length-1; i++) { 
        phases[p] = new ColorCyclePhase(p, i, i+1,
                                        (double)(p  )/(double)phase_count,
                                        (double)(p+1)/(double)phase_count);
        p++;
      }
      for (int i=0; i<palette.length-1; i++) { 
        phases[p] = new ColorCyclePhase(p, palette.length-i-1, palette.length-i-2,
                                        (double)(p  )/(double)phase_count,
                                        (double)(p+1)/(double)phase_count);
        p++;
      }
    } else if (loop == LoopPattern.Cycle) { 
      phase_count = palette.length;
      phases = new ColorCyclePhase[phase_count];
      int p = 0;
      for (int i=0; i<palette.length; i++) { 
        phases[p] = new ColorCyclePhase(p, i, (i+1)%phase_count,
                                        (double)(p  )/(double)phase_count,
                                        (double)(p+1)/(double)phase_count);
        p++;
      }
    }
  }


  //=============================================================== GET COLORS

  /**
   * Generate the next color in the sequence.
   */
  public int getColor() {
   
    this.progress %= 1.0;
    this.phase = (int)Math.floor(this.progress*this.phase_count);
    int color = getColor(this.progress);
    this.progress += this.step_size;
    return color;
  }

  /**
   * Generate color from a given step in the sequence.
   */
  public int getColor(int step) {
    return getColor((double)step/(double)steps);
  }

  /**
   * Generate color from a given progress point.
   */
  public int getColor(double progress) { 

    ColorCyclePhase p = this.phases[this.phase];
    double pp = (this.progress-p.progress_start)*(double)this.phase_count;
    int color;
    if (space == ColorSpace.RGB) {
      color = LXColor.lerp(this.palette[p.color_start].getColor(),
                          this.palette[p.color_end].getColor(),
                           pp);
    } else { 
      double[] c = lerpHSB(palette[p.color_start].getHSB(), 
                           palette[p.color_end].getHSB(), 
                           pp);
      color = HSBtoColor(c);
    }
    return color;
  }



  //=========================================================== RESET PROGRESS

  /**
   * Restart the palette at the beginning of the cycle. Allows the same
   * generator to be used for multiple objects with consistent results.
   */
  public void reset() {
    reset(0.f);
  }
  /**
   * Reset the palette to a given step [0-steps].
   */
  public void reset(int step) {
    reset((double)step/(double)this.steps);
  }
  /**
   * Reset the palette to a given progress [0.0-1.0].
   */
  public void reset(double progress) {
    this.progress %= 1.f;
    this.progress = progress;
  }




  /**
   * Linear interpolation for color triples, either RGB or HSV.
   */
  public int[] lerpRGB(int[] c1, int[] c2, double amount) {
    return ColorToRGB(LXColor.lerp(RGBtoColor(c1), RGBtoColor(c2), amount));
    /*
    int[] c3 = new int[3];
    for (int i=0; i<3; i++) { 
      c3[i] = (int)Math.floor(((1.0-amount)*(double)c1[i] 
                                   + amount*(double)c2[i]));
    }
    return c3;
    */
  }

  public double[] lerpHSB(double[] c1, double[] c2, double amount) {
    double[] c3 = new double[3];
    for (int i=0; i<3; i++) { 
      c3[i] = (1.0-amount)*c1[i] + amount*c2[i];
    }
    return c3;
  }






  //============================================= CONVENIENCE COLOR OPERATIONS

  /**
   * Standardized convenience HSB/RGB converters
   */
  public double[] ColorToHSB(int color) {
    return new double[] {LXColor.h(color), LXColor.s(color), LXColor.b(color)};
  }
  public int[] ColorToRGB(int color) {
    return new int[] {LXColor.red(color), 
                      LXColor.green(color), 
                      LXColor.blue(color)};
  }

  public int RGBtoColor(int[] rgb) { 
    System.out.format("R: %d  G: %d  B: %d\n", rgb[0], rgb[1], rgb[2]);
    return new Color((float)rgb[0]/256.f, 
                     (float)rgb[1]/256.f, 
                     (float)rgb[2]/256.f).getRGB();
  }
  public int HSBtoColor(double[] hsb) {
    return LXColor.hsb(hsb[0], hsb[1], hsb[2]);
  }
  public int HSBtoColor(float[] hsb) {
    return LXColor.hsb(hsb[0], hsb[1], hsb[2]);
  }

  public int complementary(int color) { 
   return addDegrees(color, 180.0f);
  } 

  public int addDegrees(int color, float degrees) { 
    double[] hsb = ColorToHSB(color);
    hsb[0] += degrees;
    hsb[0] %= 360.f;
    return LXColor.hsb(hsb[0], hsb[1], hsb[2]);
  }
    



}








