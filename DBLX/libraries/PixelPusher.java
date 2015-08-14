//Pixelpusher imports
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import com.heroicrobot.dropbit.devices.pixelpusher.PixelPusher;
import com.heroicrobot.dropbit.devices.pixelpusher.PusherCommand;


//Pixelpusher helper class
class PixelPusherObserver implements Observer {
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) {
    println("Registry changed!");
    if (updatedDevice != null) {
      println("Device change: " + updatedDevice);
    }
    this.hasStrips = true;
  }
}


//pixelpusher code
//Goes through the points in strips registered on the pixelpusher
//and sends the colors from sendColors to the appropriate strip/LED index
//We're going to have to make this much more robust if we use pixelPushers for the whole brain
//But for now it works well, don't mess with it unless there's a good reason to.

public void push_pixels(color[] sendColors) {
  if (ppObserver.hasStrips) {   
    registry.startPushing();
    registry.setExtraDelay(0);
    registry.setAutoThrottle(true);
    registry.setAntiLog(true);    
    int stripy = 0;
    List<Strip> strips = registry.getStrips();

    for (int i = 0; i < sendColors.length; ++i) {
      LXColor.RGBtoHSB(sendColors[i], hsb);
      float b = hsb[2];
      sendColors[i] = lx.hsb(360.*hsb[0], 100.*hsb[1], 100.*(b*b*b));
    }

    int numStrips = strips.size();
    if (numStrips == 0) return;
    int stripcounter=0;
    int striplength=0;
    int pixlcounter=0;
    color c;
    for (Strip strip : strips) {
      try{
        striplength=model.strip_lengths.get(stripcounter);
      }
      catch(Exception e){
         striplength=0;
      }
      stripcounter++;
      for (int stripx = 0; stripx < strip.getLength(); stripx++) { 
        
        if (stripx < striplength){
          c = sendColors[int(pixlcounter)];
        } else {
          //This else shouldn't have to be invoked, but it's here in case something in the hardware goes awry (we had to amputate a pixel etc). 
          //Better to have a pixel off than crash the whole thing.
          c = sendColors[0]; 
        }
        
        strip.setPixel(c, int(stripx));
        if (stripx < striplength){
          pixlcounter+=1;
        }
      }
    }
  }
}
