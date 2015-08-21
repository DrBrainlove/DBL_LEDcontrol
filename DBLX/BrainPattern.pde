/** ************************************************************ BRAIN PATTERN
 * Creates a custom pattern class for writing patterns onto the brain model 
 * Don't modify unless you know what you're doing.
 ************************************************************************* **/
//private static ArrayList<BrainPattern> patterns = new ArrayList<BrainPattern>();
public abstract class BrainPattern extends LXPattern {
  protected Model model;
  public boolean visible = true;
  
  protected BrainPattern(LX lx) {
    super(lx);
    logTime("-- Initialized BrainPalette: " + this.getClass().getName());
    this.model = (Model) lx.model;
    // auto-register visible patterns to the global list
    //if (visible) { patterns.add(this); }
  }
}
