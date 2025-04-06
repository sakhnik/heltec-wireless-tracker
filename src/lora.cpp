#include "lora.h"
#include "board.h"
#include <SPI.h>
#include <RadioLib.h>

#define PA_OUTPUT_PA_BOOST_PIN  1
#define PA_OUTPUT_RFO_PIN       0

namespace {

namespace P = Pins::LoRa;

SPIClass spi(FSPI);
SX1262 radio = new Module(P::NSS, P::DIO_1, P::RESET, RADIOLIB_NC, spi);

volatile bool operationDone = false;
bool transmissionInProgress = false;
int transmissionState = RADIOLIB_ERR_NONE;

} //namespace;

// this function is called when a complete packet
// is received by the module
// IMPORTANT: this function MUST be 'void' type
//            and MUST NOT have any arguments!
#if defined(ESP8266) || defined(ESP32)
  ICACHE_RAM_ATTR
#endif
void setOperationDone(void) {
    operationDone = true;
}

void LoRa::Setup()
{
    for (int i = 5; i > 0; --i) {
        printf("%d\n", i);
        delay(1000);
    }
    printf("begin\n");
    spi.begin(P::CLK, P::MISO, P::MOSI);

    int state = radio.begin(/*freq=*/433.5, /*bw=*/125.0, /*sf=*/10);
    if (state == RADIOLIB_ERR_NONE) {
        printf("success!\n");
    } else {
        while (true) {
            printf("begin failed, code %d\n", state);
            delay(500);
        }
    }

    radio.setDio1Action(setOperationDone);

    printf("startReceive ");
    state = radio.startReceive();
    if (state == RADIOLIB_ERR_NONE) {
        printf("success!\n");
    } else {
        printf("failed, code %d\n", state);
        while (true) {
            delay(50);
        }
    }

    // if needed, 'listen' mode can be disabled by calling
    // any of the following methods:
    //
    // radio.standby()
    // radio.sleep()
    // radio.transmit();
    // radio.receive();
    // radio.scanChannel();
}

// counter to keep track of transmitted packets
int count = 0;

void LoRa::Test()
{
    if (operationDone) {
        operationDone = false;

        if (!transmissionInProgress) {
            // you can read received data as an Arduino String
            String str;
            int state = radio.readData(str);

            if (state == RADIOLIB_ERR_NONE) {
                // packet was successfully received
                printf("[SX1262] Received packet!\n");
                printf("[SX1262] Data:\t\t%s\n", str.c_str());
                printf("[SX1262] RSSI:\t\t%f dBm\n", radio.getRSSI());
                printf("[SX1262] SNR:\t\t%f dB\n", radio.getSNR());
                printf("[SX1262] Frequency error:\t%f Hz\n", radio.getFrequencyError());
            } else if (state == RADIOLIB_ERR_CRC_MISMATCH) {
                // packet was received, but is malformed
                printf("CRC error!\n");
            } else {
                // some other error occurred
                printf("failed, code %d\n", state);
            }
        } else {
            if (transmissionState == RADIOLIB_ERR_NONE) {
                // packet was successfully sent
                printf("transmission finished!\n");
            } else {
                printf("failed, code %d\n", transmissionState);
            }

            transmissionInProgress = false;
            //radio.finishTransmit();
            auto s = radio.startReceive();
            if (s == RADIOLIB_ERR_NONE) {
                // packet was successfully sent
                printf("startReceive finished!\n");
            } else {
                printf("startReceive failed, code %d\n", s);
            }
        }
    }

    static auto prevTx = 0;
    auto now = millis();
    if (now - prevTx > 5000 && !transmissionInProgress) {
        prevTx = now;

        // send another one
        printf("[SX1262] Sending another packet ... \n");

        // you can transmit C-string or Arduino string up to
        // 256 characters long
        String str = "Hello World! #" + String(count++);
        transmissionState = radio.startTransmit(str);
        transmissionInProgress = true;
    }
}
