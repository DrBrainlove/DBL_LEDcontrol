/**
 *     DOUBLE BLACK DIAMOND        DOUBLE BLACK DIAMOND
 *
 *         //\\   //\\                 //\\   //\\  
 *        ///\\\ ///\\\               ///\\\ ///\\\
 *        \\\/// \\\///               \\\/// \\\///
 *         \\//   \\//                 \\//   \\//
 *
 *        EXPERTS ONLY!!              EXPERTS ONLY!!
 *
 * This file implements the mapping functions needed to lay out the physical
 * cubes and the output ports on the panda board. It should only be modified
 * when physical changes or tuning is being done to the structure.
 */

static final float SPACING = 27;
static final float RISER = 13.5;
static final float FLOOR = 0;

/**
 * Definitions of tower positions. This is all that should need
 * to be modified. Distances are measured from the left-most cube.
 * The first value is the offset moving NE (towards back-right).
 * The second value is the offset moving NW (negative comes forward-right).
 */

static final TowerConfig[] TOWER_CONFIG = {
  new TowerConfig("A", 0    ,     0, RISER, 5,   new int[]{   1,0,    1,1,    1,13,   1,12,   2,22           }), // most left
  new TowerConfig("B", 25   ,  12.5, FLOOR, 6,   new int[]{   1,5,    1,4,    1,15,   1,14,   1,17,   1,16   }),
  new TowerConfig("C", 37.5 , -12.5, RISER, 6,   new int[]{   2,10,   1,3,    2,9,    2,0,    2,1,    2,8    }), 
  new TowerConfig("D", 62.5 ,   -25, FLOOR, 6,   new int[]{   0,0,    2,20,   1,18,   1,8,    1,20,   1,7    }),
  new TowerConfig("E", 50   ,   -50, RISER, 6,   new int[]{   1,11,   1,23,   1,22,   1,21,   1,10,   1,9    }), 
  new TowerConfig("F", 75   , -62.5, FLOOR, 6,   new int[]{   2,17,   2,13,   2,19,   2,14,   2,18,   2,15   }), 
  new TowerConfig("G", 87.5 , -87.5, RISER, 5,   new int[]{   3,2,    2,12,   3,14,   3,11,   2,16,          }),
  new TowerConfig("H", 112.5,   -75, FLOOR, 5,   new int[]{   3,10,   3,15,   3,17,   3,20,   3,18,          }), 

  new TowerConfig("I",  12.5,   -25, FLOOR, 5,   new int[]{   2,11,   2,4,    2,2,    1,6,    2,3            }), // off "A"
  new TowerConfig("J",     0,   -50, RISER, 4,   new int[]{   3,1,    3,5,    3,12,   3,0                    }),
  new TowerConfig("K",    25, -62.5, FLOOR, 5,   new int[]{   2,5,    1,2,    2,6,    2,7,    2,21           }), 
  new TowerConfig("L",  37.5, -87.5, RISER, 4,   new int[]{   3,3,    3,7,    3,13,   3,6,                   }),
  new TowerConfig("M",  62.5, -99.5, FLOOR, 5,   new int[]{   3,23,   3,9,    3,8,    3,21,   2,23           }),

  new TowerConfig("N",   125,  -100, RISER, 4,   new int[]{   4,14,   4,13,   4,12,   4,7                    }), // off "H"
  new TowerConfig("O",   100,-112.5, FLOOR, 5,   new int[]{   4,15,   4,6,    4,5,    4,4,    4,11           }),
  new TowerConfig("P",    75,  -125, RISER, 4,   new int[]{   4,10,   4,9,    3,16,   4,8,                   }),
};

static class TowerConfig {
  public final String id;
  public final float  x;
  public final float  z;
  public final float  base;
  public final int    numCubes;
  public final int[]  pins;
  
  public TowerConfig(String id, float z, float x, float base, int numCubes, int[] pins) {
	this.id 		= id;
	this.x 			= x;
	this.z 			= z;
	this.base 		= base;
	this.numCubes 	= numCubes;
	this.pins 		= pins;
  }
} 

public Model buildModel() {

  List<Tower> towers = new ArrayList<Tower>();
  Cube[] cubes = new Cube[200];
  int cubeIndex = 1;

  float rt2 = sqrt(2);
  float x, y, z, xd, zd, num;
  for (TowerConfig tc : TOWER_CONFIG) {
	x = -tc.x;
	z = tc.z; 
	y = tc.base;
	num = tc.numCubes;
	if (z < x) {
	  zd = -(x-z)/rt2;
	  xd = z*rt2 - zd;
	} else {
	  zd = (z-x)/rt2;
	  xd = z*rt2 - zd;
	}
	List<Cube> tower = new ArrayList<Cube>();
	for (int n = 0; n < num; ++n) {
	  Cube cube = new Cube(tc.id + (n+1), tc.pins[n*2], tc.pins[n*2+1], xd + 24, y, zd + 84, 0, -45, 0);
	  tower.add(cube);
	  cubes[cubeIndex++] = cube;
	  y += SPACING;
	}
	towers.add(new Tower(tc.id, tower));
  }

  return new Model(towers, cubes);
}
