//Ethernet to APA102 multi endpoint


#include "FastLED.h"
#include <SPI.h>         // needed for Arduino versions later than 0018
#include <Ethernet.h>
#include <EthernetUdp.h>         // UDP library from: bjoern@cs.stanford.edu 12/30/2008


#define NUM_LEDS 600 //(MAKI) changed 1010 to 1350
#define TOTAL_LEDS NUM_LEDS*2

char headerBL[3];



//Teensy 3.1
//#define DATA_PIN    7
//#define CLOCK_PIN   14

//megatemp
//#define DATA_PIN 4
//#define CLOCK_PIN 5


//teesny bitbang
#define DATA_PIN 20
#define CLOCK_PIN 21
#define DATA_PIN2 6
#define CLOCK_PIN2 5


#define COLOR_ORDER BGR
#define CHIPSET     APA102

#define UDP_TX_PACKET_MAX_SIZE 1450 //(MAKI) changed from 700 to 1400

CRGB leds[NUM_LEDS];
CRGB leds2[NUM_LEDS];


// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
//byte mac[] = {
//  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte mac[] = {
  0xA0, 0xAF, 0xB4, 0xAF, 0x0b, 0x03
};
//IPAddress ip(192, 168, 1, 210);

IPAddress ip(10, 4, 2, 11);

unsigned int localPort = 6038;      // local port to listen on


EthernetUDP Udp;

// buffers for receiving and sending data
//char packetBuffer[UDP_TX_PACKET_MAX_SIZE]; //buffer to hold incoming packet,
char packetBuffer[UDP_TX_PACKET_MAX_SIZE]; //buffer to hold incoming packet

float lasttime = millis();

void setup() {
  // start the Ethernet and UDP:


  Ethernet.begin(mac, ip);
  Udp.begin(localPort);


  FastLED.addLeds<CHIPSET, DATA_PIN, CLOCK_PIN, COLOR_ORDER, DATA_RATE_MHZ(1)>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);
  FastLED.addLeds<CHIPSET, DATA_PIN2, CLOCK_PIN2, COLOR_ORDER, DATA_RATE_MHZ(1)>(leds2, NUM_LEDS).setCorrection(TypicalLEDStrip);

  

  FastLED.setBrightness(16);

  for (int i = 0; i < NUM_LEDS; i++) {
    // Set the i'th led to red
    leds[i] = CRGB::Blue;
    // Show the leds
    FastLED.show();
    // now that we've shown the leds, reset the i'th led to black
    leds[i] = CRGB::Black;
    // Wait a little bit before we loop around and do it again
    
    // Set the i'th led to red
    leds2[i] = CRGB::Blue;
    // Show the leds
    FastLED.show();
    // now that we've shown the leds, reset the i'th led to black
    leds2[i] = CRGB::Black;
    // Wait a little bit before we loop around and do it again
  }

  for (int i=0; i<NUM_LEDS; i++) {
    leds[i]= CRGB::Blue;
    leds2[i]= CRGB::Blue;
  }
  FastLED.show();
  
  //
  Serial.begin(230000);
  Serial.println("enetAPA102 finished setup 210");
  //Serial.println(IPAddress);
  //Serial.println(char(mac));
  
}

void loop() {
  
  // if there's data available, read a packet
  int packetSize = Udp.parsePacket();
  //  if(Udp.parsePacket())
  if (packetSize)
  {
    //Serial.println(packetSize);
    //    Udp.read(headerBL, 3);
    //    int shift = int(headerBL[0]);
    //    Serial.println(shift);
    //   // headerBL[0]=uint8_t(headerBL[0]);
    //    Udp.read( (char*)(leds + shift * 200), 600);

    Udp.read(headerBL, 3);
    int shift = int(headerBL[0]);
    int LEDch = int(headerBL[1]);
    //Serial.print(shift); //(MAKI) seeing if this packet is getting messed up
    //Serial.print("   spaaaace   ");
    //Serial.println(LEDch); //(MAKI) seeing if this packet is getting messed up
    
    //Serial.println(headerBL);
    //  Serial.println(shift);
    // headerBL[0]=uint8_t(headerBL[0]);

    if (LEDch == 0) {
      Udp.read( (char*)(leds + shift * 450), 1350); //(MAKI) changed 600 to 1350
    }

    if (LEDch == 1) {
      Udp.read( (char*)(leds2 + shift * 450), 1350); //(MAKI) changed 600 to 1350
    }
    //int packetWaiting = Udp.parsePacket();
    //if(packetWaiting) Serial.println("waiting: " + packetWaiting);
    FastLED.show();
  }
  //FastLED.show();
  Serial.println(LEDS.getFPS());
  
}








