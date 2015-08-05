//Ethernet to WS2811 bridge for max et


#include <FastLED.h>
#include <SPI.h>         // needed for Arduino versions later than 0018
#include <Ethernet.h>
#include <EthernetUdp.h>         // UDP library from: bjoern@cs.stanford.edu 12/30/2008
#define NUM_LEDS 300
#define DATA_PIN 3
#define CLOCK_PIN 2

#define COLOR_ORDER BGR //GBR on #15, BGR for all else?
#define CHIPSET     APA102

#define UDP_TX_PACKET_MAX_SIZE 1400

// we assume 60/m. comment this in if we're driving a 30/m strip
#define HALF_DENSITY

struct {
  byte header[21];
  CRGB leds[NUM_LEDS];
} incoming;    //packet[21-offset*3 +(ii*3)+0] = byte(cp.r & 0xFF); // R 
    //packet[21-offset*3 +(ii*3)+1] = byte(cp.g & 0xFF); // G
    //packet[21-offset*3 +(ii*3)+2] = byte(cp.b & 0xFF); // B   


CRGB *leds = (CRGB*)&incoming.leds;

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
//byte mac[] = {  
//  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte mac[] = {  
  0xDE, 0xAF, 0xB4, 0x4F, 0xE4, 0x16 };
//IPAddress ip(192, 168, 1, 77);

IPAddress ip(10,4,2,16);

unsigned int localPort = 6038;      // local port to listen on

const int num_channels = 1320;
const int ck_header = 8;

EthernetUDP Udp;

// buffers for receiving and sending data
//char packetBuffer[UDP_TX_PACKET_MAX_SIZE]; //buffer to hold incoming packet,
char packetBuffer[UDP_TX_PACKET_MAX_SIZE]; //buffer to hold incoming packet
//har vals_tmp[ck_header + num_channels]; //buffer to hold incoming packet
//char vals[num_channels]; //buffer to hold incoming packet
//char vals[ck_header + num_channels]; //buffer to hold incoming packet

//int dataPin = 2;
//int clockPin = 3;
//Adafruit_WS2801 strip = Adafruit_WS2801(num_channels/3, dataPin, clockPin);

//WS2801 strip = WS2801(160);

void setup() {
  // start the Ethernet and UDP:
 
   
  Ethernet.begin(mac,ip);
  Udp.begin(localPort);
  
  FastLED.addLeds<CHIPSET, DATA_PIN,CLOCK_PIN, COLOR_ORDER>(leds, NUM_LEDS);
   for(int i = 0; i < NUM_LEDS; i++) {
		// Set the i'th led to yellow: this will teset byte order as well 
		leds[i] = CRGB::Yellow;
		// Show the leds
		FastLED.show();
		// now that we've shown the leds, reset the i'th led to black
		leds[i] = CRGB::Black;
		// Wait a little bit before we loop around and do it again
		delay(5);
	}
   FastLED.show();
//
//  Serial.begin(57600);
//Serial.println("enetNeoPixel finished setup");
}

void loop() {
  // if there's data available, read a packet
  int packetSize = Udp.parsePacket();
  if(packetSize)
  {
 
    Udp.read( (char*)&incoming, sizeof(incoming));
    //delay(1);
    //Serial.println("enetNeoPixel packet ");
    
    #ifdef HALF_DENSITY
      //for (int i=0)
    #endif
   
  }
 
    FastLED.show();
}




