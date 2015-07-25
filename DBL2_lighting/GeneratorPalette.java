import heronarts.lx.color.*;

public class GeneratorPalette {

  //============== Enumerated Parameters

  // Color Scheme (for color scheme generation)
  public enum ColorScheme {
    Analogous, 
    Analogous45,
    Analogous60,
    Analogous90,
    Monochromatic, 
    Triad, 
    Complementary
  }

  // What to do when we get to the end of the color palette
  public enum RepeatPattern { Repeat, Reverse, Cycle }
  
  // Color Space flags that modulate certain algorithms
  public enum ColorSpace { RGB, HSB, CIE }



  // ============= Color Cycle Phases
  /**
   * The full color cycle is broken into phases of interpolation between
   * reference colors.
   */
  private class ColorCyclePhase {
    int index = 0; // which phase
    double progress_start = 0; // starting point for total progress
    double progress_end = 0; // stopping point for total progress
    int color_start = 0; // starting color index
    int color_end = 0; // target color index

    private ColorCyclePhase(int i, double ps, double pe, int cs, int ce) { 
      index = i;
      progress_start = ps;
      progress_end = pe;
      color_start = cs;
      color_end = ce;

      System.out.format("I: %d  %.2f-%.2f  %d-%d\n",
                        i, ps, pe, cs, ce); 
    }
  }

  // ============= Class Fields

  // reference color color palette
  public int       base_color = 0;
  public int[]     palette = {0};
  public int[][]   palette_rgb;
  public float[][] palette_hsb = null;

  // generator parameters
  public ColorSpace space = ColorSpace.RGB;
  public ColorScheme scheme = null;
  public RepeatPattern repeat = null;

  // steps in cycle and progress record
  public int steps;
  private double step_size = 0.0; 
  private double progress = 0.0;

  // phases of the color cycle
  private int phase = 0;
  private int phase_count = 0;
  private ColorCyclePhase[] phases = null;


  // ============= Constructors

  /**
   * A color palette that algorithmically generates a new color at each 
   * step based on the selected color scheme.
   *
   * @param scheme Analogous, Monochromatic, Triad, Complementary
   * @param base_color Color from which to generate the palette
   * @param repeat How to proceed once reaching the end of the palette
   * @param steps Number of pixels or timesteps in a comlpete cycle
   */

  public GeneratorPalette(
            ColorScheme scheme,
            int base_color,
            RepeatPattern repeat,
            int steps

          ) { 

    this.base_color = base_color;
    this.scheme = scheme;
    this.steps = steps;

    switch (scheme) {
      case Analogous:
        this.palette = new int[] {addDegrees(base_color, -30.f), 
                                  base_color, 
                                  addDegrees(base_color,  30.f)};
        this.space = ColorSpace.HSB;
        this.repeat = RepeatPattern.Reverse;
      case Analogous45:
        this.palette = new int[] {addDegrees(base_color, -45.f), 
                                  base_color, 
                                  addDegrees(base_color,  45.f)};
        this.space = ColorSpace.HSB;
        this.repeat = RepeatPattern.Reverse;
      case Analogous60:
        this.palette = new int[] {addDegrees(base_color, -60.f), 
                                  base_color, 
                                  addDegrees(base_color,  60.f)};
        this.space = ColorSpace.HSB;
        this.repeat = RepeatPattern.Reverse;
      case Analogous90:
        this.palette = new int[] {addDegrees(base_color, -90.f), 
                                  base_color, 
                                  addDegrees(base_color,  90.f)};
        this.space = ColorSpace.HSB;
        this.repeat = RepeatPattern.Reverse;
        break;
      case Monochromatic:
        float[] hsb = ColorToHSB(base_color);
        int c1 = LXColor.hsb(hsb[0], hsb[1],   0.f);
        int c2 = LXColor.hsb(hsb[0], hsb[1], 100.f);
        palette = new int[] {c1, c2};
        this.space = ColorSpace.RGB;
        this.repeat = RepeatPattern.Reverse;
        break;
      case Triad:
        //this.palette = new int[] {colors[0], base_color, colors[2]};
        this.space = ColorSpace.HSB;
        this.repeat = RepeatPattern.Cycle;
        break;
      case Complementary:
        this.palette = new int[] {base_color, addDegrees(base_color, 180.f)};
        this.space = ColorSpace.RGB;
        this.repeat = RepeatPattern.Reverse;
        break;

    }

    /*
    System.out.format("Base Color: %x\n", base_color);
    for (int i=0; i<colors.length; i++) {
      int c = colors[i];
      System.out.format("Colors [%d]: %x\n", i, c);
    }
    */
    for (int i=0; i<palette.length; i++) {
      int c = palette[i];
      System.out.format("Palette [%d]: %x\n", i, c);
    }

    initialize();
  }

  

  /**
   * Initialize phases, deltas, etc when creating object or modifying parameters
   */

  private void initialize() {
 
    this.step_size = 1.0/(double)steps;
    
    // Phases
    if (repeat == RepeatPattern.Repeat) { 
      phase_count = palette.length-1;
      phases = new ColorCyclePhase[phase_count];
      int p = 0;
      for (int i=0; i<palette.length-1; i++) { 
        phases[p] = new ColorCyclePhase(p,
                                        (double)(p  )/(double)phase_count,
                                        (double)(p+1)/(double)phase_count,
                                        i,
                                        i+1
        );
        p++;
      }
    } else if (repeat == RepeatPattern.Reverse) { 
      phase_count = (palette.length-1) * 2;
      phases = new ColorCyclePhase[phase_count];
      int p = 0;
      for (int i=0; i<palette.length-1; i++) { 
        phases[p] = new ColorCyclePhase(p,
                                        (double)(p  )/(double)phase_count,
                                        (double)(p+1)/(double)phase_count,
                                        i,
                                        i+1
        );
        p++;
      }
      for (int i=0; i<palette.length-1; i++) { 
        phases[p] = new ColorCyclePhase(p,
                                        (double)(p  )/(double)phase_count,
                                        (double)(p+1)/(double)phase_count,
                                        palette.length-i-1,
                                        palette.length-i-2
        );
        p++;
      }
    } else if (repeat == RepeatPattern.Cycle) { 
      phase_count = palette.length;
      phases = new ColorCyclePhase[phase_count];
      int p = 0;
      for (int i=0; i<palette.length; i++) { 
        phases[p] = new ColorCyclePhase(p,
                                        (double)(p  )/(double)phase_count,
                                        (double)(p+1)/(double)phase_count,
                                        i,
                                        (i+1)%phase_count
        );
        p++;
      }
    }

    


  }


  /**
   * Generate the next color in the sequence.
   */
  public int getColor() {
   
    this.progress %= 1.0;
    this.phase = (int)Math.floor(this.progress*this.phase_count);

    ColorCyclePhase p = this.phases[this.phase];
    double pp = (this.progress-p.progress_start)*(double)this.phase_count;
    int color;
    if (space == ColorSpace.RGB) { 
      color = LXColor.lerp(this.palette[p.color_start], 
                           this.palette[p.color_end], 
                           pp);
    } else { 
      color = LXColor.lerp(this.palette[p.color_start], 
                           this.palette[p.color_end], 
                           pp);
    }
    this.progress += this.step_size;

    /*
    System.out.println("Progress: " + this.progress
                     + "  SubProgress: " + pp
                     + "  Phase: " + this.phase
                     + "  Start: " + p.color_start 
                     + "  End: " + p.color_end
                     + "  Color: " + color);
    System.out.format("Pro: %5.2f Sub: %5.2f Phase: %1d "
                    + "Start: %1d End: %1d Color %x\n",
                      this.progress,
                      pp,
                      this.phase,
                      p.color_start,
                      p.color_end,
                      color
                    );
    */ 
    //                 */
    return color;
  }



  /**
   * Restart the palette at the beginning of the cycle. Allows the same
   * generator to be used for multiple objects with consistent results.
   */

  public void reset() { 
    this.progress = 0.0;
  }
  public void reset(int step) {
    step %= this.steps;
    this.progress = (double)step/(double)this.steps;
  }




  /**
   * Linear interpolation for color triples, either RGB or HSV.
   */
  public double[] lerp(double[] c1, double[] c2, double amount) {
    double[] c3 = new double[3];
    for (int i=0; i<3; i++) { 
      c3[i] = (1.0-amount)*c1[i] + amount*c2[i];
    }
    return c3;
  }


  /**
   * Set steps in color cycle.
   */
  public void setSteps(int steps) {
    this.steps=steps;
    initialize();
  }







  /*
   * Standardized convenience HSB/RGB converters
   */
  public float[] ColorToHSB(int color) {
    float h = LXColor.h(color);
    float s = LXColor.s(color);
    float b = LXColor.b(color);
    return new float[] {h, s, b};
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
    float[] hsb = ColorToHSB(color);
    hsb[0] += degrees;
    hsb[0] %= 360.f;
    return LXColor.hsb(hsb[0], hsb[1], hsb[2]);
  }
    



}








