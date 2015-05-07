/**
 * This is a very basic model OF A BRAIN!
 */
import java.io.*;
import java.nio.file.*;

static String lines[];

static class Model extends LXModel {
  public Model() {
    super(new Fixture());
  }
  
  private static class Fixture extends LXAbstractFixture {
    
    private static final int MATRIX_SIZE = 12;
    
    private Fixture() {
      BufferedReader br = null;
      String line = "";
      String cvsSplitBy = ",";

      try {
        for (int i=0; i<lines.length; i++) {
            // use comma as separator
          String[] floats = lines[i].split(cvsSplitBy);
          addPoint(new LXPoint(Double.parseDouble(floats[1]), Double.parseDouble(floats[2]), Double.parseDouble(floats[3])));
        }
      } finally {
        if (br != null) {
          try {
            br.close();
          } catch (IOException e) {
            e.printStackTrace();
          }
        }
      }

      System.out.println("Done");
    }
  }
}

