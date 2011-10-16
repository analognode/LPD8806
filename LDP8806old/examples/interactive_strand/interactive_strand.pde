#include <LPD8806old.h>

/* Digital Addressable RGB LED with PWM waterproof flexible strip
 
 Based on example code from Adafruit Industries
 and Todd Kurt
 
 *
 * Adafruit, https://www.adafruit.com/products/306
 * 2008, Tod E. Kurt, ThingM, http://thingm.com/
 *
 * Updated by Mike Ries - http://analogNode.com
 *
 *
 
 Basic commands to test the strip using a serial connection
 
 r - (r)eset
 c - (c)olor chase
 w - (w)heel
 i - colorW(i)pe
 s - (s)et inidividual to R, G, B, LED
 f - set (f)ade speed
 
 */

/*****************************************************************************/

int dataPin = 2;   
int clockPin = 3; 

int cycleSpeed = 10; // Speed for colorChase. 10 is default

int incomingByte = 0;	// for incoming serial data

char serInStr[30];  // array that will hold the serial input string

// Set the first variable to the NUMBER of pixels. 32 = 32 pixels in a row
// The LED strips are 32 LEDs per meter but you can extend/cut the strip
LPD8806old strip = LPD8806old(32, dataPin, clockPin);

void setup() {
  // Start the serial stuff
  Serial.begin(9600);

  // Start up the LED strip
  strip.begin();

  // Update the strip, to start they are all 'off'
  strip.show();
  Serial.print("cmd>");
}

void loop () {
  int num;
  if( readSerialString() ) {
    Serial.println(serInStr);
    char cmd = serInStr[0];  // first char is command
    char* str = serInStr;
    while( *++str == ' ' );  // got past any intervening whitespace
    num = atoi(str);         // the rest is arguments (maybe)
    if( cmd == 'r' ) {
      Serial.println("Reset strip");
      colorWipe(strip.Color(0,0,0), cycleSpeed);
      strip.show();
    }
    else if( cmd == 'c' || cmd == 'w' || cmd == 'i' || cmd == 's' || cmd == 'f' ) {
      byte a = toHex( str[0],str[1] );
      byte b = toHex( str[2],str[3] );
      byte c = toHex( str[4],str[5] );
      byte d = toHex( str[6],str[7] );
      if( cmd == 's' ) {
        //fade individual LED to rgb address a, b, c at speed d
        Serial.println("set individual LED to "); 
        Serial.print(a,HEX); 
        Serial.print(",");
        Serial.print(b,HEX); 
        Serial.print(",");
        Serial.print(c,HEX); 
        Serial.print(",");
        Serial.print(d,HEX);          
        Serial.println("");
        pixelFade(d, a, b, c, cycleSpeed);
      }
      else if( cmd == 'w' ) {
        // initiate color wheel
        Serial.println("wheel to ");
        Serial.print(a,HEX); 
        Serial.print(",");
        Serial.print(b,HEX); 
        Serial.print(",");
        Serial.print(c,HEX); 
        Serial.print(",");
        Serial.print(d,HEX);          
        Serial.println("");
        rainbow(10);
      } 
      else if( cmd == 'i' ) {
        // initiate color wipe
        Serial.println("color wipe to ");
        Serial.print(a,HEX); 
        Serial.print(",");
        Serial.print(b,HEX); 
        Serial.print(",");
        Serial.print(c,HEX); 
        Serial.print(",");
        Serial.print(d,HEX);          
        Serial.println("");
        colorWipe(strip.Color(a,b,c), cycleSpeed);
      } 
      else if( cmd == 'c' ) {
        // color Chase
        Serial.println("color chase to ");
        Serial.print(a,HEX); 
        Serial.print(",");
        Serial.print(b,HEX); 
        Serial.print(",");
        Serial.print(c,HEX); 
        Serial.print(",");
        Serial.print(d,HEX);          
        Serial.println("");
        colorChase(strip.Color(a,b,c), cycleSpeed);	// orange
      }
      else if ( cmd == 'f' ) {
        Serial.print("set cycle speed to ");
        Serial.print(a,HEX); 
        Serial.print(",");
        Serial.print(b,HEX); 
        Serial.print(",");
        Serial.print(c,HEX); 
        Serial.print(",");
        Serial.print(d,HEX);
        Serial.println("");
        cycleSpeed = a;
      }
    }
    serInStr[0] = 0;  // say we've used the string
    Serial.print("cmd>");  
  }
}


//read a string from the serial and store it in an array
//you must supply the array variable
uint8_t readSerialString()
{
  if(!Serial.available()) {
    return 0;
  }
  delay(10);  // wait a little for serial data

  memset( serInStr, 0, sizeof(serInStr) ); // set it all to zero
  int i = 0;
  while (Serial.available()) {
    serInStr[i] = Serial.read();   // FIXME: doesn't check buffer overrun
    i++;
  }
  //serInStr[i] = 0;  // indicate end of read string
  return i;  // return number of chars read
}


// -----------------------------------------------------
// a really cheap strtol(s,NULL,16)
#include <ctype.h>
uint8_t toHex(char hi, char lo)
{
  uint8_t b;
  hi = toupper(hi);
  if( isxdigit(hi) ) {
    if( hi > '9' ) hi -= 7;      // software offset for A-F
    hi -= 0x30;                  // subtract ASCII offset
    b = hi<<4;
    lo = toupper(lo);
    if( isxdigit(lo) ) {
      if( lo > '9' ) lo -= 7;  // software offset for A-F
      lo -= 0x30;              // subtract ASCII offset
      b = b + lo;
      return b;
    } // else error
  }  // else error
  return 0;
}

// Chase a dot down the strip
// good for testing purposes
void colorChase(uint32_t c, uint8_t wait) {
  int i;

  for (i=0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, 0);  // turn all pixels off
  } 

  for (i=0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, c);
    if (i == 0) { 
      strip.setPixelColor(strip.numPixels()-1, 0);
    } 
    else {
      strip.setPixelColor(i-1, 0);
    }
    strip.show();
    delay(wait);
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

// set individual pixel
void pixelFade (uint8_t pixel, uint8_t a, uint8_t b, uint8_t c, uint8_t wait) {
  int i;

  for (i=0; i < 51; i++) {
    int aTemp = a*i/50;
    int bTemp = b*i/50;
    int cTemp = c*i/50;
    strip.setPixelColor(pixel, strip.Color(aTemp,bTemp,cTemp));
    Serial.print(aTemp);
    Serial.print(", ");
    Serial.print(bTemp);
    Serial.print(", ");
    Serial.println(cTemp);
    //strip.setPixelColor(pixel, strip.Color(a,b,c));
    strip.show();
    delay(wait);
  }
}

/* Helper functions */

//Input a value 0 to 384 to get a color value.
//The colours are a transition r - g -b - back to r

uint32_t Wheel(uint16_t WheelPos)
{
  byte r, g, b;
  switch(WheelPos / 128)
  {
  case 0:
    r = 127 - WheelPos % 128;   //Red down
    g = WheelPos % 128;      // Green up
    b = 0;                  //blue off
    break; 
  case 1:
    g = 127 - WheelPos % 128;  //green down
    b = WheelPos % 128;      //blue up
    r = 0;                  //red off
    break; 
  case 2:
    b = 127 - WheelPos % 128;  //blue down 
    r = WheelPos % 128;      //red up
    g = 0;                  //green off
    break; 
  }
  return(strip.Color(r,g,b));
}


void rainbow(uint8_t wait) {
  int i, j;

  for (j=0; j < 384; j++) {     // 3 cycles of all 384 colors in the wheel
    for (i=0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, Wheel( (i + j) % 384));
    }  
    strip.show();   // write all the pixels out
    delay(wait);
  }
}






