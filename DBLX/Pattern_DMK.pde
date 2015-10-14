import oscP5.*;
import netP5.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.Rectangle;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.awt.image.BufferedImage.*;
import java.io.*;
import javax.imageio.ImageIO;



class Scraper extends BrainPattern{
  private final LXProjection projection;
  int[] pixels;
  boolean didset=false;
  int[][] pixelstack;
  int[] offset;
  int h,w,d;
  float count=0;
  
  public Scraper(LX lx) {
    super(lx);
    w=320;
    h=240;
    d=1;
    projection = new LXProjection(model);
    pixelstack = new int[d][h*w];
    offset = new int[1];
    ScraperRunnable sr = new ScraperRunnable(pixelstack, offset, w, h, d);
    Thread srThread = new Thread(sr, "ScraperRunnable");
    srThread.start();
   }
   
  void run(double deltaMs){
    /*if(ui!=null && !didset) {
       ui.setTheta(PI/2);
       didset=true;
    }*/


    float xr=0,xp=0,xt=0;
    int mode=1;
/*     projection.reset()
      // Swim around the world
     .rotate(2.0, 15.0, 15.0, 15.0)
     .translateCenter(0, 50, 0);*/
    for(LXVector p: projection){
      // should be optimized for normalized coords on point object
      float sx,sy,sz;
      sx=sy=sz=0;
      sx=p.x;
      sy=p.y;
      sz=p.z;
      sx-=model.xMin;
      sy-=model.yMin;
      sz-=model.zMin;
      sx/=(model.xMax-model.xMin);
      sy/=(model.yMax-model.yMin);
      sz/=(model.zMax-model.zMin);
      float tmp;
      switch(mode) {
        case 1:
          tmp=sx;
          sx=sy;
          sy=sz;
          sz=tmp;
          break;
        case 2:
          float dx = 0.5-sx;
          float dy = 0.5-sy;
          dx*=2;dy*=2;
          dx*=dx; 
          dy*=dy; 
          dx/=2;
          dy/=2;
          if(sx>0.5) { dx=-dx; }
          if(sy>0.5) { dy=-dy; }
          sx = 0.5+dx;
          sy = 0.5+dy;
          break;
      };
      /*xr = sqrt(sx*sx + sy*sy + sz*sz);
      xp = acos(sx/xr);
      xt = atan2(sx,sz);
      
      sx = xp/(PI/2);
      sy = xt/(PI/2);*/
      
      // CLAMP
      
      sx = max(sx, 0); sx=min(sx, 1);
      sy = max(sy, 0); sy=min(sy, 1);
      
      int ix = w-1-int(ceil(sx*(w-1)));
      int iy = h-1-int(ceil(sy*(h-1)));
      int iz = d-1-int(ceil(sz*(d-1)));
      synchronized(offset){
        iz+=offset[0];
        iz%=d;
        //iz=offset[0];
        colors[p.index] = pixelstack[iz][w*iy+ix];   
      }
    }    
  }
}    

class ScraperRunnable implements Runnable {
  int[][] pixelstack;
  int[] offset;
  float prev;
  DirectRobot dr;
  int w,h,d;
  public ScraperRunnable(int[][] p, int[] o, int xw, int xh, int xd){
    offset=o;
    w=xw;
    h=xh;
    d=xd;
    pixelstack=p;
    prev=0;
    try { dr = new DirectRobot(); } catch(Exception e) {}
  }
  public void run(){  
    while(true){
      float diff = millis()-prev;      
      if(diff>=1000/60){
        synchronized(offset){
         offset[0] = (offset[0]+1)%d;
         dr.getRGBPixels(20,20,w,h,pixelstack[offset[0]]);      
         prev=millis();
        }
      } else {
         delay(int(1000/60 - diff));
      }
    }
  }
}
  
class AutoOSC extends BrainPattern {
  OscP5 local_oscP5;
  public void oscEvent(OscMessage o){
    println(o);
  }
  public AutoOSC(LX lx) {
    super(lx);
    local_oscP5 = new OscP5(this,12000); 
  }
  public void run(double deltaMs){}
}

/*class PixelOSCListener extends BrainPattern {
  public PixelOSCListener(LX lx) {    
    super(lx);
  }
  public void run(double deltaMs){
    for(int i=0; i<colors.length; i++){
      colors[i] = oscColors[i];
    }  
  }
}*/

  

class DMK1 extends BrainPattern {
 
  OscP5 local_oscP5;  
  private final LXProjection projection;
  public void oscEvent(OscMessage o){
    if(o.checkAddrPattern("/multi/1")) {
      ox[0] = o.get(0).floatValue();
      oy[0] = o.get(1).floatValue();
    }      
    if(o.checkAddrPattern("/multi/2")) {
      ox[1] = o.get(0).floatValue();
      oy[1] = o.get(1).floatValue();
    }      
    if(o.checkAddrPattern("/multi/3")) {
      ox[2] = o.get(0).floatValue();
      oy[2] = o.get(1).floatValue();
    }      
    if(o.checkAddrPattern("/multi/4")) {
      ox[3] = o.get(0).floatValue();
      oy[3] = o.get(1).floatValue();
    }      
    if(o.checkAddrPattern("/multi/5")) {
      ox[4] = o.get(0).floatValue();
      oy[4] = o.get(1).floatValue();
    }      
    if(o.checkAddrPattern("/accelerometer")) {
      avgx=avgy=avgz=0;
      for(int i=1; i<30; i++){
        accx[i] = accx[i-1];
        accy[i] = accy[i-1];        
      }      
      accx[0] = o.get(0).floatValue();
      accy[0] = o.get(1).floatValue();
      maxx=maxy=-9999;
      minx=miny=9999;
      for(int i=0; i<30; i++){
        if(accx[i]<minx) { minx=accx[i]; }
        if(accy[i]<miny) { miny=accy[i]; }
        if(accx[i]>maxx) { maxx=accx[i]; }
        if(accx[i]>maxy) { maxy=accy[i]; }
        avgx+=accx[i];
        avgy+=accy[i];
      }
      avgx/=30;
      avgy/=30;
      float sx, sy;
      sx = accx[0];
      sy = accy[0];
      sx-=minx;
      sy-=miny;
      sx/=maxx-minx;
      sy/=maxy-miny;            
      ox[0] = sx;
      oy[0] = sy;
    }
    println("--");
    
  }
  float[] ox,oy,oz;
  float[] accx,accy,accz;
  float   avgx, avgy, avgz;
  float   minx, maxx, miny, maxy;
  
  float xFactor, yFactor, zFactor;

  public DMK1(LX lx) {
    super(lx);
    projection = new LXProjection(model);
    // OSC
    local_oscP5 = new OscP5(this,12000); 
    ox= new float[5];
    oy= new float[5];
    
    accx = new float[30];
    accy = new float[30];
    for(int i=0; i<30; i++){ accx[i]=0; accy[i]=0; }
    for(int i=0; i<5; i++){ ox[i]=0; oy[i]=0; }
  }
  void run(double deltaMs){   
    float ax,ay;
    ax=ay=0;
    for (LXPoint p : model.points) {
      float sx=p.x;
      float sy=p.y;
      sx-=model.xMin;
      sy-=model.yMin;
      sx/=(model.xMax-model.xMin);
      sy/=(model.yMax-model.yMin);
      
      colors[p.index] = lx.hsb(0,0,0);
      if(abs(sx-ox[0])<0.1 && abs(sy-oy[0])<0.1) { colors[p.index] = lx.hsb(0,100,100); }
      if(abs(sx-ox[1])<0.1 && abs(sy-oy[1])<0.1) { colors[p.index] = lx.hsb(40,100,100); }
      if(abs(sx-ox[2])<0.1 && abs(sy-oy[2])<0.1) { colors[p.index] = lx.hsb(80,100,100); }
      if(abs(sx-ox[3])<0.1 && abs(sy-oy[3])<0.1) { colors[p.index] = lx.hsb(120,100,100); }
      if(abs(sx-ox[4])<0.1 && abs(sy-oy[4])<0.1) { colors[p.index] = lx.hsb(160,100,100); }
      ax=p.x;
      ay=p.y;
    }    
  }
}
