Full credit to Adafruit for these files. I'm just reaaranging and re-using parts to create new functions with arduino sketches. Thanks Adafruit!

This is an Arduino library for LPD8806 (and probably LPD8803/LPD8809) PWM LED driver chips, strips and pixels

Pick some up at http://www.adafruit.com/products/306

To download. click the DOWNLOADS button in the top right corner, rename the uncompressed folder LPD8806. Check that the LPD8806 folder contains LPD8806.cpp and LPD8806.h

Place the LPD8806 library folder your <arduinosketchfolder>/libraries/ folder. You may need to create the libraries subfolder if its your first library. Restart the IDE.

<<<<<<< HEAD
Use LDP8806 for the newer optimized SPI library, and LPD8806old for the original Digital Pin code.

Reworked sketches are in examples/

Note that I renamed the Adafruit libraries to "LDP8806old" - this includes the files and links.

This way I can use the original Adafruit libraries next to the new cjbaar fork.

I expect that eventually cjbaar's fork will be merged back to the adafruit branch, so this repo will eventually be unnecessary.

Note the new error requiring a change in LPD8806.h
https://elektrozwerge.wordpress.com/2013/03/17/arduino-ide-1-0-error-wprogram-h-no-such-file-or-directory/

=======
Reworked sketches are in examples/

Note that I updated the Adafruit libraries to "LDP8806old" - this includes the files and links.

This way I can use the original Adafruit libraries next to the new cjbaar fork.
>>>>>>> c66ef28bf988a84ad855090dbaa39259f7ea6a8e
