#include <Arduino.h>
#include "tft.h"
#include "gps.h"
#include "lora.h"

Tft tft;
Gps gps;
LoRa lora;

void setup()
{
    printf("setup\n");
    //pinMode(18, OUTPUT);
    //tft.Setup();
    //gps.Setup();
    lora.Setup();
}

void loop() {
    printf("loop\n");
    //tft.Test();
    while (true) {
        //gps.Test();
        lora.Test();
    }
    //digitalWrite(18, HIGH);
    //delay(500);
    //digitalWrite(18, LOW);
    //delay(500);
}
