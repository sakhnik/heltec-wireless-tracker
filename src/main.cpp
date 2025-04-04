#include <Arduino.h>
#include "tft.h"

Tft tft;

void setup()
{
    tft.Setup();
    //pinMode(18, OUTPUT);
}

void loop() {
    printf("loop\n");
    tft.Test();
    //digitalWrite(18, 1);
    //delay(500);
    //digitalWrite(18, 0);
    //delay(500);

}
