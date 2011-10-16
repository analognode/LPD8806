/*****************************************************************************/
// Example to control LPD8806-based RGB LED Modules in a strip
// Original code by Adafruit https://github.com/adafruit/LPD8806
// SPI additions by cjbaar https://github.com/cjbaar/LPD8806
//
// Revised for netlogicdc project by Mike Ries http://singularitynode.com/
//
// This code randomly "wipes" diffent values of blue from one end
// of the strip to the other, from off, to light blue to dim blue. = 
// 
// Note: Yellow is MOSI: PIN 11
//       Yellow is SCK: PIN 13
/*****************************************************************************/

#include "LPD8806.h"
#include <SPI.h>

int cycleSpeed = 0; // Speed for colorChase. 10 is default

// Set the first variable to the NUMBER of pixels. 32 = 32 pixels in a row
// The LED strips are 32 LEDs per meter but you can extend/cut the strip
LPD8806 strip = LPD8806(160);

void setup() {
  randomSeed(analogRead(0));              // generate greater pseudorandomness
  Serial.begin(9600);

  // Start up the LED strip
  strip.begin();

  // Update the strip, to start they are all 'off'
  strip.show();
}

void loop () {
  int greenHigh = random(60,127);
  int greenLow = random(0,8);
  int timeHigh = random(0,100);
  int timeLow  = random(0,40);
  int dirHigh = random(0,50);
  int dirLow = random(0,50);
  if (dirHigh > 25 ) {
    colorWipe(strip.Color(0,0,greenHigh), timeHigh);
  } 
  else {
    colorUnWipe(strip.Color(0,0,greenHigh), timeHigh);
  }
    if (dirLow > 25 ) {
    colorWipe(strip.Color(0,0,greenLow), timeLow);
  } 
  else {
    colorUnWipe(strip.Color(0,0,greenLow), timeLow);
  }
}


// fill the dots one after the other with said color
// good for testing purposes
void colorWipe(uint32_t c, uint8_t wait) {
  int i;

  for (i=0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, c);
    strip.show();
    delay(wait);
  }
}

void colorUnWipe(uint32_t c, uint8_t wait) {
  int i;

  for (i=strip.numPixels(); i > 0; i--) {
    strip.setPixelColor(i, c);
    strip.show();
    delay(wait);
  }
}


