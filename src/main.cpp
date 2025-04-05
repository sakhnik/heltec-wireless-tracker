#include <Arduino.h>
#include "tft.h"
#include "gps.h"

Tft tft;
Gps gps;

void setup()
{
    printf("setup\n");
    //tft.Setup();
    gps.Setup();
    //pinMode(18, OUTPUT);
}

void loop() {
    printf("loop\n");
    //tft.Test();
    while (true) {
        gps.Test();
    }
    //digitalWrite(18, HIGH);
    //delay(500);
    //digitalWrite(18, LOW);
    //delay(500);
}
