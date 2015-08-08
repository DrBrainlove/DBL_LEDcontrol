/*


AI will manage transitions

NerveBundle manages the mapping options between various sensors and senses and whatever.
The AI will actually control the mapping using NerveBundle container class

patterns etc register parameters with the NerveBundle
Sensors are hard coded into the NerveBundle



LXVirtualParameter
LXEffect
LXChannel - Has a lot of functionality we need to explore.



// Lame Ass transitions
  lx.enableAutoTransition(120000);
  
  for (LXPattern pattern : patterns) {
    pattern.setTransition(new MultiplyTransition(lx).setDuration(5000));
  }
  



// Steal pattern change detection and associated parameters for 
// Sensor-Sense mapping

  public UIChannelControl(UI ui, LXChannel channel, String label, int numKnobs, float x, float y) {
    super(ui, label, x, y, WIDTH, BASE_HEIGHT + KNOB_ROW_HEIGHT * (numKnobs / KNOBS_PER_ROW));

    this.channel = channel;
    int yp = TITLE_LABEL_HEIGHT;

    new UIButton(width-18, 4, 14, 14)
    .setParameter(channel.autoTransitionEnabled)
    .setLabel("A")
    .setActiveColor(ui.theme.getControlBackgroundColor())
    .addToContainer(this);

    List<UIItemList.Item> items = new ArrayList<UIItemList.Item>();
    for (LXPattern p : channel.getPatterns()) {
      items.add(new PatternScrollItem(p));
    }
    final UIItemList patternList =
      new UIItemList(1, yp, this.width - 2, 140)
      .setItems(items);
    patternList
    .setBackgroundColor(ui.theme.getWindowBackgroundColor())
    .addToContainer(this);
    yp += patternList.getHeight() + 10;

    final UIKnob[] knobs = new UIKnob[numKnobs];
    for (int ki = 0; ki < knobs.length; ++ki) {
      knobs[ki] = new UIKnob(5 + 34 * (ki % KNOBS_PER_ROW), yp
          + (ki / KNOBS_PER_ROW) * KNOB_ROW_HEIGHT);
      knobs[ki].addToContainer(this);
    }

    LXChannel.Listener lxListener = new LXChannel.AbstractListener() {
      @Override
      public void patternWillChange(LXChannel channel, LXPattern pattern, LXPattern nextPattern) {
        patternList.redraw();
      }

      @Override
      public void patternDidChange(LXChannel channel, LXPattern pattern) {
        patternList.redraw();
        int pi = 0;
        for (LXParameter parameter : pattern.getParameters()) {
          if (pi >= knobs.length) {
            break;
          }
          if (parameter instanceof LXListenableNormalizedParameter) {
            knobs[pi++].setParameter((LXListenableNormalizedParameter) parameter);
          }
        }
        while (pi < knobs.length) {
          knobs[pi++].setParameter(null);
        }
      }
    };

    channel.addListener(lxListener);
    lxListener.patternDidChange(channel, channel.getActivePattern());
  }



*/
