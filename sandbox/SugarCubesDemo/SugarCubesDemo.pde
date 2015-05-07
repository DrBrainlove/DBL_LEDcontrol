/**
 *           +-+-+-+-+-+               +-+-+-+-+-+
 *          /         /|               |\         \
 *         /         / +               + \         \
 *        +-+-+-+-+-+  |   +-+-+-+-+   |  +-+-+-+-+-+
 *        |         |  +  /         \  +  |         |
 *        +   THE   + /  /           \  \ +  CUBES  +
 *        |         |/  +-+-+-+-+-+-+-+  \|         |
 *        +-+-+-+-+-+   |             |   +-+-+-+-+-+
 *                      +             +
 *                      |    SUGAR    |
 *                      +             +
 *                      |             |
 *                      +-+-+-+-+-+-+-+
 *
 * Welcome to the Sugar Cubes! This Processing sketch is a fun place to build
 * animations, effects, and interactions for the platform. Most of the icky
 * code guts are embedded in the HeronLX library, or files prefixed with
 * an underscore. If you're an artist, you shouldn't need to worry about that.
 *
 * Below, you will find definitions of the Patterns, Effects, and Interactions.
 * If you're an artist, create a new tab in the Processing environment with
 * your name. Implement your classes there, and add them to the list below.
 */ 
 
LXPattern[] patterns(P2LX lx) {
  return new LXPattern[] {        
  
    new Swarm(lx),
    new SpaceTime(lx),
    new ViolinWave(lx),
    new Traktor(lx).setEligible(false),
    new BassPod(lx).setEligible(false),
    new CubeEQ(lx).setEligible(false),
   
    new Pulley(lx),
    new BouncyBalls(lx),
    new ShiftingPlane(lx),
    new AskewPlanes(lx),
    new Blinders(lx),
    new CrossSections(lx),
    new Psychedelia(lx),
    
    // Basic test patterns for reference, not art    
    new TestCubePattern(lx),
    new TestTowerPattern(lx),
    new TestProjectionPattern(lx),
    new TestStripPattern(lx),
    new TestHuePattern(lx),
    new TestXPattern(lx),
    new TestYPattern(lx),
    new TestZPattern(lx),

  };
}

LXTransition[] transitions(P2LX lx) {
  return new LXTransition[] {
    new DissolveTransition(lx),
    new AddTransition(lx),
    new MultiplyTransition(lx),
    // TODO(mcslee): restore these blend modes in P2LX
    // new OverlayTransition(lx),
    // new DodgeTransition(lx),
    new SwipeTransition(lx),
    new FadeTransition(lx),
  };
}

// Handles to globally triggerable effects 
class Effects {
  FlashEffect flash = new FlashEffect(lx);
  BoomEffect boom = new BoomEffect(lx);
  BlurEffect blur = new BlurEffect(lx);
  QuantizeEffect quantize = new QuantizeEffect(lx);
  ColorFuckerEffect colorFucker = new ColorFuckerEffect(lx);
  
  Effects() {
    blur.enable();
    quantize.enable();
    colorFucker.enable();
  }
}

