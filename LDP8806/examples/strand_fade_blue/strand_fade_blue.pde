/*****************************************************************************/
// Example to control LPD8806-based RGB LED Modules in a strip
// Original code by Adafruit https://github.com/adafruit/LPD8806
// SPI additions by cjbaar https://github.com/cjbaar/LPD8806
//
// Revised for netlogicdc project by Mike Ries http://singularitynode.com/
//
// New code randomly fades from blue to green.
// 
// Note: Yellow is MOSI: PIN 11
//       Yellow is SCK: PIN 13
/*****************************************************************************/

#include "LPD8806.h"
#include <SPI.h>

int cycleSpeed = 10; // Speed for colorChase. 10 is default

// Set the first variable to the NUMBER of pixels. 32 = 32 pixels in a row
// The LED strips are 32 LEDs per meter but you can extend/cut the strip
LPD8806 strip = LPD8806(160);

void setup() {
  randomSeed(analogRead(0));              // generate greater pseudorandomness

  // Start up the LED strip
  strip.begin();

  // Update the strip, to start they are all 'off'
  strip.show();
}

void loop () {
  blueRainbow(10);
}

void blueRainbow(uint8_t wait) {
  int i, j;

  for (j=0; j < 384; j++) {			// 3 cycles of all 384 colors in the wheel
    for (i=0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, blueWheel( (i + j) % 384));
    }	 
    strip.show();		        // write all the pixels out
    delay(wait);
  }
}

uint32_t blueWheel(uint16_t WheelPos)
{
  byte r, g, b;
  switch(WheelPos / 128)
  {
  case 0:
    r = 0;               		// Red down
    g = WheelPos % 128;			// Green up
    b = 0;				// blue off
    break; 
  case 1:
    g = 127 - WheelPos % 128;	        // green down
    b = WheelPos % 128;			// blue up
    r = 0;				// red off
    break; 
  case 2:
    b = 127 - WheelPos % 128;	        // blue down 
    r = 0;                              // red up
    g = WheelPos % 128;			// green up
    break; 
  }
  return(strip.Color(r,g,b));
}

