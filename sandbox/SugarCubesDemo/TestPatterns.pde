class BlankPattern extends SCPattern {
  BlankPattern(LX lx) {
    super(lx);
  }
  
  public void run(double deltaMs) {
    setColors(#000000);
  }
}

abstract class TestPattern extends SCPattern {
  public TestPattern(LX lx) {
    super(lx);
    setEligible(false);
  }
}

class TestStripPattern extends TestPattern {
  
  SinLFO d = new SinLFO(4, 40, 4000);
  
  public TestStripPattern(LX lx) {
    super(lx);
    addModulator(d).trigger();
  }
  
  public void run(double deltaMs) {
    for (Strip s : model.strips) {
      for (LXPoint p : s.points) {
        colors[p.index] = lx.hsb(
          lx.getBaseHuef(),
          100,
          max(0, 100 - d.getValuef()*dist(p.x, p.y, s.cx, s.cy))
        );
      }
    }
  }
}

/**
 * Simplest demonstration of using the rotating master hue.
 * All pixels are full-on the same color.
 */
class TestHuePattern extends TestPattern {
  public TestHuePattern(LX lx) {
    super(lx);
  }
  
  public void run(double deltaMs) {
    // Access the core master hue via this method call
    float hv = lx.getBaseHuef();
    for (int i = 0; i < colors.length; ++i) {
      colors[i] = lx.hsb(hv, 100, 100);
    }
  } 
}

/**
 * Test of a wave moving across the X axis.
 */
class TestXPattern extends TestPattern {
  private final SinLFO xPos = new SinLFO(0, model.xMax, 4000);
  public TestXPattern(LX lx) {
    super(lx);
    addModulator(xPos).trigger();
  }
  public void run(double deltaMs) {
    float hv = lx.getBaseHuef();
    for (LXPoint p : model.points) {
      // This is a common technique for modulating brightness.
      // You can use abs() to determine the distance between two
      // values. The further away this point is from an exact
      // point, the more we decrease its brightness
      float bv = max(0, 100 - abs(p.x - xPos.getValuef()));
      colors[p.index] = lx.hsb(hv, 100, bv);
    }
  }
}

/**
 * Test of a wave on the Y axis.
 */
class TestYPattern extends TestPattern {
  private final SinLFO yPos = new SinLFO(0, model.yMax, 4000);
  public TestYPattern(LX lx) {
    super(lx);
    addModulator(yPos).trigger();
  }
  public void run(double deltaMs) {
    float hv = lx.getBaseHuef();
    for (LXPoint p : model.points) {
      float bv = max(0, 100 - abs(p.y - yPos.getValuef()));
      colors[p.index] = lx.hsb(hv, 100, bv);
    }
  }
}

/**
 * Test of a wave on the Z axis.
 */
class TestZPattern extends TestPattern {
  private final SinLFO zPos = new SinLFO(0, model.zMax, 4000);
  public TestZPattern(LX lx) {
    super(lx);
    addModulator(zPos).trigger();
  }
  public void run(double deltaMs) {
    float hv = lx.getBaseHuef();
    for (LXPoint p : model.points) {
      float bv = max(0, 100 - abs(p.z - zPos.getValuef()));
      colors[p.index] = lx.hsb(hv, 100, bv);
    }
  }
}

/**
 * This shows how to iterate over towers, enumerated in the model.
 */
class TestTowerPattern extends TestPattern {
  private final SawLFO towerIndex = new SawLFO(0, model.towers.size(), 1000*model.towers.size());
  
  public TestTowerPattern(LX lx) {
    super(lx);
    addModulator(towerIndex).trigger();
  }

  public void run(double deltaMs) {
    int ti = 0;
    for (Tower t : model.towers) {
      for (LXPoint p : t.points) {
        colors[p.index] = lx.hsb(
          lx.getBaseHuef(),
          100,
          max(0, 100 - 80*LXUtils.wrapdistf(ti, towerIndex.getValuef(), model.towers.size()))
        );
      }
      ++ti;
    }
  }
  
}

/**
 * This is a demonstration of how to use the projection library. A projection
 * creates a mutation of the coordinates of all the points in the model, creating
 * virtual x,y,z coordinates. In effect, this is like virtually rotating the entire
 * art car. However, since in reality the car does not move, the result is that
 * it appears that the object we are drawing on the car is actually moving.
 *
 * Keep in mind that what we are creating a projection of is the view coordinates.
 * Depending on your intuition, some operations may feel backwards. For instance,
 * if you translate the view to the right, it will make it seem that the object
 * you are drawing has moved to the left. If you scale the view up 2x, objects
 * drawn with the same absolute values will seem to be half the size.
 *
 * If this feels counterintuitive at first, don't worry. Just remember that you
 * are moving the pixels, not the structure. We're dealing with a finite set
 * of sparse, non-uniformly spaced pixels. Mutating the structure would move
 * things to a space where there are no pixels in 99% of the cases.
 */
class TestProjectionPattern extends TestPattern {
  
  private final LXProjection projection;
  private final SawLFO angle = new SawLFO(0, TWO_PI, 9000);
  private final SinLFO yPos = new SinLFO(-20, 40, 5000);
  
  public TestProjectionPattern(LX lx) {
    super(lx);
    projection = new LXProjection(model);
    addModulator(angle).trigger();
    addModulator(yPos).trigger();
  }
  
  public void run(double deltaMs) {
    // For the same reasons described above, it may logically feel to you that
    // some of these operations are in reverse order. Again, just keep in mind that
    // the car itself is what's moving, not the object
    projection.reset()
    
      // Translate so the center of the car is the origin, offset by yPos
      .translateCenter(0, yPos.getValuef(), 0)

      // Rotate around the origin (now the center of the car) about an X-vector
      .rotate(angle.getValuef(), 1, 0, 0)

      // Scale up the Y axis (objects will look smaller in that access)
      .scale(1, 1.5, 1);

    float hv = lx.getBaseHuef();
    for (LXVector c : projection) {
      float d = sqrt(c.x*c.x + c.y*c.y + c.z*c.z); // distance from origin
      // d = abs(d-60) + max(0, abs(c.z) - 20); // life saver / ring thing
      d = max(0, abs(c.y) - 10 + .1*abs(c.z) + .02*abs(c.x)); // plane / spear thing
      colors[c.index] = lx.hsb(
        (hv + .6*abs(c.x) + abs(c.z)) % 360,
        100,
        constrain(140 - 40*d, 0, 100)
      );
    }
  } 
}

class TestCubePattern extends TestPattern {
  
  private SawLFO index = new SawLFO(0, Cube.POINTS_PER_CUBE, Cube.POINTS_PER_CUBE*60);
  
  TestCubePattern(LX lx) {
    super(lx);
    addModulator(index).start();
  }
  
  public void run(double deltaMs) {
    for (Cube c : model.cubes) {
      int i = 0;
      for (LXPoint p : c.points) {
        colors[p.index] = lx.hsb(
          lx.getBaseHuef(),
          100,
          max(0, 100 - 80.*abs(i - index.getValuef()))
        );
        ++i;
      }
    }
  }
}

class MappingTool extends TestPattern {
    
  private int cubeIndex = 0;
  private int stripIndex = 0;

  public final int MAPPING_MODE_ALL         = 0;
  public final int MAPPING_MODE_CHANNEL     = 1;
  public final int MAPPING_MODE_SINGLE_CUBE = 2;
  public final int MAPPING_MODE_DIGI        = 3;
  public final int MAPPING_MODE_FADE        = 4;

  public int mappingMode = MAPPING_MODE_ALL;

  public final int CUBE_MODE_ALL = 0;
  public final int CUBE_MODE_SINGLE_STRIP = 1;
  public final int CUBE_MODE_STRIP_PATTERN = 2;
  public int cubeMode = CUBE_MODE_ALL;

  public boolean channelModeRed = true;
  public boolean channelModeGreen = false;
  public boolean channelModeBlue = false;
      
  MappingTool(LX lx) {
    super(lx);
  }
  
  private int indexOfCubeInChannel(Cube c) {
    // TODO(mcslee): port to grizzly
    return -1;
  }
  
  private void printInfo() {
    println("Cube:" + cubeIndex + " Strip:" + (stripIndex+1));
  }
  
  public void cube(int delta) {
    int len = model.cubes.size();
    cubeIndex = (len + cubeIndex + delta) % len;
    printInfo();
  }
  
  public void strip(int delta) {
    int len = Cube.STRIPS_PER_CUBE;
    stripIndex = (len + stripIndex + delta) % len;
    printInfo();
  }
  
  public void run(double deltaMs) {
    color off = #000000;
    color c = off;
    color r = #FF0000;
    color g = #00FF00;
    color b = #0000FF;
    if (channelModeRed) c |= r;
    if (channelModeGreen) c |= g;
    if (channelModeBlue) c |= b;
    
    int ci = 0;
    for (Cube cube : model.cubes) {
      boolean cubeOn = false;
      int indexOfCubeInChannel = indexOfCubeInChannel(cube);
      switch (mappingMode) {
        case MAPPING_MODE_ALL: cubeOn = true; break;
        case MAPPING_MODE_SINGLE_CUBE: cubeOn = (cubeIndex == ci); break;
        case MAPPING_MODE_CHANNEL: cubeOn = (indexOfCubeInChannel > 0); break;
      }
      if (cubeOn) {
        if (mappingMode == MAPPING_MODE_CHANNEL) {
          color cc = off;
          switch (indexOfCubeInChannel) {
            case 1: cc = r; break;
            case 2: cc = r|g; break;
            case 3: cc = g; break;
            case 4: cc = b; break;
            case 5: cc = r|b; break;
          }
          setColor(cube, cc);
        } else if (cubeMode == CUBE_MODE_STRIP_PATTERN) {
          int si = 0;
          color sc = off;
          for (Strip strip : cube.strips) {
            int faceI = si / Face.STRIPS_PER_FACE;
            switch (faceI) {
              case 0: sc = r; break;
              case 1: sc = g; break;
              case 2: sc = b; break;
              case 3: sc = r|g|b; break;
            }
            if (si % Face.STRIPS_PER_FACE == 2) {
              sc = r|g;
            }
            setColor(strip, sc);
            ++si;
          }
        } else if (cubeMode == CUBE_MODE_SINGLE_STRIP) {
          setColor(cube, off);
          setColor(cube.strips.get(stripIndex), c);
        } else {
          setColor(cube, c);
        }
      } else {
        setColor(cube, off);
      }
      ++ci;
    }
  }
  
  public void setCube(int index) {
    cubeIndex = index % model.cubes.size();
  }
  
  public void incCube() {
    cubeIndex = (cubeIndex + 1) % model.cubes.size();
  }
  
  public void decCube() {
    --cubeIndex;
    if (cubeIndex < 0) {
      cubeIndex += model.cubes.size();
    }
  }
  
  public void setStrip(int index) {
    stripIndex = index % Cube.STRIPS_PER_CUBE;
  }
  
  public void incStrip() {
    stripIndex = (stripIndex + 1) % Cube.STRIPS_PER_CUBE;
  }
  
  public void decStrip() {
    stripIndex = (stripIndex + Cube.STRIPS_PER_CUBE - 1) % Cube.STRIPS_PER_CUBE;
  }
  
  public void keyPressed(UIMapping uiMapping) {
    switch (keyCode) {
      case UP: incCube(); break;
      case DOWN: decCube(); break;
      case LEFT: decStrip(); break;
      case RIGHT: incStrip(); break;
    }
    switch (key) {
      case 'r': channelModeRed = !channelModeRed; break;
      case 'g': channelModeGreen = !channelModeGreen; break;
      case 'b': channelModeBlue = !channelModeBlue; break;
    }
    uiMapping.setCubeID(cubeIndex+1);
    uiMapping.setStripID(stripIndex+1);
    uiMapping.redraw();
  }

}
