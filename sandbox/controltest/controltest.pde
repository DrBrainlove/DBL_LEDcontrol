import hypermedia.net.*;


UDP udp;
int UDP_PORT = 6038;
String controller_ip = "192.168.1.210";

class Particle {
  int i; //linear (global) index
  float x,y;
  int r,g,b;
}

// particle buffer
ArrayList<Particle> particles;

float master_gain = 0.2; //0.5;


                
//int TOTAL_NUMLED = 1500; //5 strips of 300 pixels each
int TOTAL_NUMLED = 900; //5 strips of 300 pixels each

int STRANDLEN = 300; // number of pixels in a strand

// container of byte arrays for each controller
ArrayList<byte[]> packet_list;


color white = color(255,255,0);

int[] ctrl_color = {color(255,0,0),
                  color(0,255,0),
                  color(0,0,255),
                  color(255,255,0),
                  color(255,0,255)
                };
                
/* 
 * convert int to byte
 */
byte int2byte(int x) {
  return byte(int(x) & 0xFF);
}
byte float2byte(float x) {
  return byte(int(x) & 0xFF);
}



/* 
* Given a max packet length of 1400 bytes (roughly), we can put about 450 LED into the packet
* The first 3 bytes will be empty header information, the 4th byte will be the offset multiplier
*/

int PKT_LEN = 3 + 200*3; // bytes, =  3 + 3*450
int PKT_HDRLEN = 3; // number of bytes in a packet header
int PKT_DATALEN = PKT_LEN - PKT_HDRLEN; // number of data bytes encoded
int PKT_PIXLEN = PKT_DATALEN/3; // number of pixels in packet
int PKT_OFFSETIX = 0; //index of the offset byte in a packet

int NPACKET = ceil( float( TOTAL_NUMLED) / float(PKT_DATALEN/3) );

void buildPacketHeader(byte[] packet) {
  packet[0] = 0; //offset multiplier
  packet[1] = 0; //empty
  packet[2] = 0; //empty
  //arrays are initialized to zero by default, so rest of packet buffer should be zero
}



/*
* copy the colors from the Particles array ointo the packet buffers and hit send
*/
void sendPackets() {
  int curstrand=0;
  byte[] packet = packet_list.get(0);
  int packetct = -1; //increments to 0 on first iteration
  int pixelix = 0; //for iterating through each packet
  for (int ii=0; ii< particles.size(); ii++) {
   
    if (ii % PKT_PIXLEN == 0){
      packetct++;
      //println("packetct " + str(packetct) + "  previous packetix " + str(pixelix));
      pixelix = 0; //reset to start of packet
      packet = packet_list.get(packetct); //update to next packet
      packet[PKT_OFFSETIX] = int2byte(packetct);
      //println("offset multiplier " + str(packet[PKT_OFFSETIX]));
      //println("loading packet " + str(packetct));
    }
    Particle cp = particles.get(ii);
    packet[PKT_HDRLEN+pixelix*3 +0] = float2byte(cp.r*master_gain); // R 
    //println(str(ii) + ": r=" + str( packet[PKT_HDRLEN+pixelix*3 +0]));
    packet[PKT_HDRLEN+pixelix*3 +1] = float2byte(cp.g*master_gain); // G
    packet[PKT_HDRLEN+pixelix*3 +2] = float2byte(cp.b*master_gain); // B   


    if (pixelix == PKT_PIXLEN-1 || ii == particles.size()-1) {
      //println("sending packet " + packetct);
      udp.send(packet, controller_ip); 
      delay(50);
    }
   
    
    /*if (ii==particles.size()-1)
      udp.send(packet, controller_ip); 
 */
    pixelix++;
  }
  //println("");
}


/*
* load the particle buffer with separate colors for each strip
*/
void loadPixelColorByStrip() {
  println("setting pixel colors");
  int strandix = -1;
  int r=0;
  int g=0;
  int b=0;
  int curcolor=0;
  //println("particle len: " + str(particles.size()));
  for (int ii=0; ii< particles.size(); ii++) {
    if (ii % STRANDLEN == 0) {
      strandix++;
    }
    Particle cp = particles.get(ii);
    curcolor = ctrl_color[strandix];
    
    cp.r = int(curcolor >> 16 & 0xFF);
    cp.g = int(curcolor >> 8 & 0xFF);
    cp.b = int(curcolor & 0xFF);
    //println("pixel " + str(ii) + " -> r: " + str(cp.r) + " g: " + str(cp.g) + " b: " + str(cp.b) );
  }
  
}

void loadParticles() {
  particles = new ArrayList<Particle>();
  
  int po = 4; //pixel offset
  int strandix = -1;
  int offset = 0;
  for (int ii=0; ii< TOTAL_NUMLED; ii++) {
    offset = ii % STRANDLEN;
    if (offset == 0) {
      strandix++;
    }
    //Particle p = particles.get(i);
    Particle p = new Particle();
    p.i = ii;
    if (strandix % 2 == 0) //even, go to right
      p.x = offset * po;
    else
      p.x = (STRANDLEN * po) - (offset+1) * po;
    p.y = strandix * 50;
    particles.add(p);
    //println(str(ii) + ": " +p.x + ", " + p.y);
  }
}


/**
* set the color of Particle p, scaled by value [0,1]
*/
void setParticleColor(Particle p, color c, float value) {
  if (value > 1) { value = 1; }
  else if (value < 0) {value = 0; }
  
  //print("p.r: " + p.r);
  p.r = int( (c >> 16 & 0xFF) * master_gain * value);
  p.g = int( (c >> 8 & 0xFF) * master_gain * value);
  p.b = int( (c & 0xFF) * master_gain * value);
  //println(" , " + p.r);
  return;
}

color getParticleColor(Particle p) {
  return color(p.r, p.g, p.b);
}

void drawPixels() {
  for (int ii =0 ; ii<particles.size(); ii++) {
    Particle p = particles.get(ii);
    strokeWeight(2); // how big we want the pixel to be
    stroke(color(p.r, p.g, p.b));
    point(p.x, p.y);
  }
}


//****************************************************************************
//  setup() and draw()

void setup() {
  size(1400,600);
  background(20);
  
  println("opening UDP socket: " + str(UDP_PORT));
  udp = new UDP(this, UDP_PORT);
  udp.listen( true );
      
  loadParticles();
  // set each strip to its own color
  loadPixelColorByStrip();    
  
  
  packet_list = new ArrayList<byte[]>();
  for( int i=0; i<NPACKET; i++) {
    println("building packet " + str(i));
    byte[] packet = new byte[PKT_LEN];
    buildPacketHeader(packet);
    packet_list.add(packet);
  }
  

}


void draw() {
  translate(20, 50);

  loopHSV(particles);
  
  
  //fixedHSVSweep();
  

  drawPixels();

  //delay(100);
  sendPackets();

}


//****************************************************************************
//****************************************************************************
// test patterns

void loopHSV(ArrayList<Particle> particles) {      
  colorMode(HSB, 360, 100, 100); //switch color mode to HSB, in degrees and percent
  //int offset = int(map(millis()%10000, 0, 10000, 0, 360)); 
  int offset = 360-int(((millis() / 5000.0) % 1.0) * 360.0);
  int h = 0;
  for (int i=0; i<particles.size(); i++) {
    Particle p = particles.get(i);
    colorMode(HSB, 360, 100, 100); //switch color mode to HSB, in degrees and percent
    h = (int(float(i) / float(particles.size()/7) * 360.0) + offset) % 360;
    color c = color(h, 100, 100);
    colorMode(RGB, 255);//switch back to RGB
    p.r = int(red(c));
    p.g = int(green(c));
    p.b = int(blue(c));
  }

  colorMode(RGB, 255);//switch back to RGB
}

void fixedHSVSweep() {
  float colorfreq = float(particles.size())/7;
  for (int i=0; i<particles.size(); i++) {
    Particle p = particles.get(i);
    color oldc = getParticleColor(p);
    colorMode(HSB, 360, 100, 100);
    int h = int(float(i) / colorfreq * 360.0) % 360;
    color c = color(h, 100, brightness(oldc)-5);
    colorMode(RGB, 255);//switch back to RGB
    p.r = int(red(c));
    p.g = int(green(c));
    p.b = int(blue(c));
    
  }
}

