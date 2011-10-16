#include "LPD8806old.h"

// nldc blue test

/*****************************************************************************/

// Choose which 2 pins you will use for output.
// Can be any valid output pins.
int dataPin = 2;   
int clockPin = 3; 

int cycleSpeed = 1; // Speed for colorChase. 10 is default

// Set the first variable to the NUMBER of pixels. 32 = 32 pixels in a row
// The LED strips are 32 LEDs per meter but you can extend/cut the strip
LPD8806old strip = LPD8806old(32, dataPin, clockPin);

void setup() {
  Serial.begin(9600);

  // Start up the LED strip
  strip.begin();

  // Update the strip, to start they are all 'off'
  strip.show();
}

void loop () {
  int blueHigh = random(60,127);
  int blueLow = random(0,8);
  int timeHigh = random(0,40);
  int timeLow  = random(0,40);
  int dirHigh = random(0,50);
  int dirLow = random(0,50);
  if (dirHigh > 25 ) {
    colorWipe(strip.Color(0,0,blueHigh), timeHigh);
  } 
  else {
    colorUnWipe(strip.Color(0,0,blueHigh), timeHigh);
  }
    if (dirLow > 25 ) {
    colorWipe(strip.Color(0,0,blueLow), timeLow);
  } 
  else {
    colorUnWipe(strip.Color(0,0,blueLow), timeLow);
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


