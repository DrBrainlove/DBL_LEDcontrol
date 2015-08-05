#include <FastLED.h>
#include <SPI.h>

#define DATA_PIN   11 // SPI MOSI pin
#define CLOCK_PIN  13 //13 //SPI  SCK
#define COLOR_ORDER BGR // BGR //GBR
#define CHIPSET     APA102
#define NUM_LEDS    300

#define BRIGHTNESS  255
#define FRAMES_PER_SECOND 60

CRGB leds[NUM_LEDS];

CRGBPalette16 currentPalette;
TBlendType    currentBlending;

void setup() {
  delay(3000); // sanity delay
  FastLED.addLeds<CHIPSET, DATA_PIN, CLOCK_PIN, COLOR_ORDER, DATA_RATE_MHZ(8)>(leds, NUM_LEDS).setCorrection( TypicalLEDStrip );
  FastLED.setBrightness( BRIGHTNESS );

  //currentBlending = BLEND;

}

void loop() {

  static int startix =0;
  startix++;

  //fill_solid(leds, NUM_LEDS, CRGB::Blue);
  //red_whitebar();
  rainbowBlend(startix);
  
  FastLED.show();
  FastLED.delay(1000 / FRAMES_PER_SECOND);
}


void rainbowBlend(int colorix) {
  //currentBlending = BLEND;
  int brightness = 255;
  for(int i=0; i<NUM_LEDS; i++) {
    leds[i] = ColorFromPalette(RainbowStripeColors_p, colorix, brightness);
    colorix += 3;
  }
  
}


int curbarix=0;

void red_whitebar() {
  fill_solid(leds, NUM_LEDS, CRGB::Red);
  for(int i=0; i<NUM_LEDS; i++) {
    if (i>=curbarix && i < curbarix+3) {
      leds[i] = CRGB::White;
    }
  }
  curbarix++;
  if (curbarix > NUM_LEDS)
    curbarix =0;
}



