#include "gps.h"
#include "board.h"
#include <Arduino.h>
#include <TinyGPS++.h>
#include <time.h>

namespace {

namespace P = Pins::GNSS;
TinyGPSPlus gps;
HardwareSerial ser(2);

// Flags for PPS handling and synchronization status
volatile bool ppsFlag = false;
volatile bool initialSyncDone = false;

// Timestamp for the last valid GNSS data received
unsigned long lastGNSSDataMillis = 0;

} //namespace;

// Interrupt handler for the PPS signal
void ppsInterrupt()
{
    ppsFlag = true;
}

void Gps::Setup()
{
    pinMode(P::VGNSS_CTRL, OUTPUT);
    digitalWrite(P::VGNSS_CTRL, HIGH);
    Serial1.begin(115200, SERIAL_8N1, 33, 34);

    // Start GNSS module communication
    ser.begin(115200, SERIAL_8N1, P::TX, P::RX);
    while(!ser);

    // Configure GNSS reset pin
    pinMode(P::RST, OUTPUT);
    digitalWrite(P::RST, HIGH);

    // Set up PPS pin and attach an interrupt handler
    pinMode(P::PPS, INPUT);
    attachInterrupt(digitalPinToInterrupt(P::PPS), ppsInterrupt, RISING);

    // Short delay for GNSS module initialization
    delay(1000);
}

// Debugging function to display GNSS data
void displayGNSSData() {
    if (gps.satellites.isValid()) {
        printf("sat=%d upd=%d age=%d\n", gps.satellites.value(), (int)gps.satellites.isUpdated(), gps.satellites.age());
    }
    //if (gps.location.isValid()) {
        printf("valid=%d lat=%lf lon=%lf alt=%lf spd=%lf\n", (int)gps.location.isValid(), gps.location.lat(), gps.location.lng(), gps.altitude.meters(), gps.speed.kmph());
    //}
}

// Function to set system time using GNSS data
void setSystemTime() {
    struct tm timeinfo;
    timeinfo.tm_year = gps.date.year() - 1900;
    timeinfo.tm_mon = gps.date.month() - 1;
    timeinfo.tm_mday = gps.date.day();
    timeinfo.tm_hour = gps.time.hour();
    timeinfo.tm_min = gps.time.minute();
    timeinfo.tm_sec = gps.time.second();
    time_t t = mktime(&timeinfo);

    timeval tv = { t, 0 };
    //settimeofday(&tv, NULL);  // Update system time
}

void Gps::Test() {
    // Process incoming GNSS data
    while (ser.available()) {
        if (gps.encode(ser.read())) {
            // Update the timestamp when valid GNSS data is received
            lastGNSSDataMillis = millis();
            displayGNSSData();  // Display GNSS data for debugging
        }
    }

    // Perform initial synchronization using NMEA time data
    if (!initialSyncDone && gps.date.isValid() && gps.time.isValid()) {
        setSystemTime();
        initialSyncDone = true;
        printf("Initial time synchronization done using NMEA data.\n");
    }

    // Disable interrupts to safely check and reset the PPS flag
    noInterrupts();
    if (ppsFlag) {
        //fineTuneSystemTime();  // Adjust system time based on the PPS pulse
        ppsFlag = false;
    }
    // Re-enable interrupts
    interrupts();

    // Check if GNSS data has been absent for more than a minute
    if (millis() - lastGNSSDataMillis > 60000) {
        printf("Warning: Haven't received GNSS data for more than 1 minute!");
        // Additional actions can be added here, like alerts or module resets.
    }
}

//// Function to fine-tune system time using the PPS pulse
//void fineTuneSystemTime() {
//  timeval tv;
//  gettimeofday(&tv, NULL);
//  tv.tv_usec = 0;  // Reset microseconds to zero
//  settimeofday(&tv, NULL); // Update system time
//  USBSerial.println("System time fine-tuned using PPS signal.");
//}
