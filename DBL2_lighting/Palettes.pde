import java.awt.Color;
import org.jcolorbrewer.ColorBrewer;

class HueCyclePalette extends LXPalette {
  
  final BasicParameter zeriod = new BasicParameter("Period", 5000, 0, 30000);
  final BasicParameter spread = new BasicParameter("Spread", 2, 0, 8);
  final BasicParameter center = new BasicParameter("Center", model.cx - 10*INCHES, model.xMin, model.xMax);
  
  HueCyclePalette(LX lx) {
    super(lx);
    addParameter(zeriod);
    addParameter(spread);
    addParameter(center);
  
    zeriod.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        period.setValue(zeriod.getValue());
      }
    });
    
  }
  
  public double getHue(LXPoint p) {
    return super.getHue() + spread.getValue() * (abs(p.x - center.getValuef()) + abs(p.y - model.cy));
  }
}




/************** COLOR BREWER PALETTES *************/


public static class GradientCB {
  public static final int Sequential = 3;
  public static final int Diverging = 2;
  public static final int Qualitative = 1;
  
  public static Color[] getGradient(int paletteType, int paletteIndex, int colors) {
    boolean colorBlindSave = false;
    ColorBrewer[] palettes;
    if (paletteType == Sequential) { 
        palettes = ColorBrewer.getSequentialColorPalettes(colorBlindSave);
    } else if (paletteType == Diverging) { 
        palettes = ColorBrewer.getDivergingColorPalettes(colorBlindSave);
    } else { 
        palettes = ColorBrewer.getQualitativeColorPalettes(colorBlindSave);
    }
    Color[] gradient = palettes[paletteIndex].getColorPalette(colors);
    return gradient;
  }
}



public static class DBLPalette { 


  public static Color[] toColors(int[] ints) { 
    Color[] colors = new Color[ints.length];
    for (int i=0; i<ints.length; i++) {
      Color c = new Color(ints[i]);
      colors[i] = c;
    }
    return colors;
  }

  public static int[] toColorInts(Color[] colors) { 
    int[] ints = new int[colors.length];
    for (int i=0; i<colors.length; i++) {
      int c = colors[i].getRGB();
      ints[i] = c;
    }
    return ints;
  }

  public static Color[] interpolate(Color[] gradient, int colorCount) {
    Color[] colors = new Color[colorCount];
    float scale = (float)(gradient.length-1)/(float)(colorCount-1);

    for (int i = 0; i < colorCount; i++) {
      float value = scale * i;
      int index = (int)Math.floor(value);

      Color c1 = gradient[index];
      float remainder = 0.0f;
      Color c2 = null;
      if (index+1 < gradient.length) {
        c2 = gradient[index+1];
        remainder = value - index;
      } else {
        c2 = gradient[index];
      }
      //		 System.out.println("value: " + value + " index: " + index + " remainder: " + remainder);
      int red   = Math.round((1 - remainder) * c1.getRed()    + (remainder) * c2.getRed());
      int green = Math.round((1 - remainder) * c1.getGreen()  + (remainder) * c2.getGreen());
      int blue  = Math.round((1 - remainder) * c1.getBlue()   + (remainder) * c2.getBlue());

      colors[i] = new Color(red, green, blue);
    }
    return colors;
  }

  public static int[] interpolate(int[] gradient, int colorCount) { 
    Color[] gradientColor = toColors(gradient);
    int[] ints = toColorInts(interpolate(gradientColor, colorCount));   
    return ints;
  }

}
