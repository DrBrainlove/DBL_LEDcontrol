//Ethernet to WS2811 bridge for max et


#include "FastLED.h"
#include <SPI.h>         // needed for Arduino versions later than 0018
#include <Ethernet.h>
#include <EthernetUdp.h>         // UDP library from: bjoern@cs.stanford.edu 12/30/2008
#define NUM_LEDS 930
//#define DATA_PIN 2
//#define CLOCK_PIN 3

char headerBL[3];
//char lt0[900] = {0}; //temp buffers for packets
//char lt1[900] = {0};
//char lt2[900] = {0};
//char lt3[900];





//Teensy 3.1
//#define DATA_PIN    7
//#define CLOCK_PIN   14

//megatemp
#define DATA_PIN 4
#define CLOCK_PIN 5



#define COLOR_ORDER GBR
#define CHIPSET     APA102



#define UDP_TX_PACKET_MAX_SIZE 1400

CRGB leds[NUM_LEDS];


// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
//byte mac[] = {
//  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte mac[] = {
  0xA0, 0xAF, 0xB4, 0xAF, 0x0b, 0x03
};
//IPAddress ip(192, 168, 1, 210);

IPAddress ip(10,4,2,11);

unsigned int localPort = 6038;      // local port to listen on

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


  Ethernet.begin(mac, ip);
  Udp.begin(localPort);

  // FastLED.addLeds<CHIPSET, DATA_PIN, COLOR_ORDER>(leds, NUM_LEDS);
  // FastLED.addLeds<CHIPSET, DATA_PIN,CLOCK_PIN, COLOR_ORDER>(leds, NUM_LEDS);
  // FastLED.addLeds<CHIPSET,DATA_PIN,CLOCK_PIN, COLOR_ORDER>(leds, NUM_LEDS);
  FastLED.addLeds<CHIPSET, DATA_PIN, CLOCK_PIN, COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);

  for (int i = 0; i < NUM_LEDS; i = i + 20) {
    // Set the i'th led to red
    leds[i] = CRGB::Red;
    // Show the leds
    FastLED.show();
    // now that we've shown the leds, reset the i'th led to black
    leds[i] = CRGB::Black;
    // Wait a little bit before we loop around and do it again
  }
  //
  Serial.begin(115200);
  Serial.println("enetNeoPixel finished setup 210");
  //Serial.println(IPAddress);
  //Serial.println(char(mac));
}

void loop() {
  // if there's data available, read a packet
  int packetSize = Udp.parsePacket();
  //  if(Udp.parsePacket())
  if (packetSize)
  {
    Udp.read((char*)headerBL, 3);
    int shift = uint32_t(headerBL[0]);

    Serial.println(shift + 100);


    Udp.read( (char*)(leds + shift * 300), 900);
    // Serial.println("0 p");

  }
  FastLED.show();
}








