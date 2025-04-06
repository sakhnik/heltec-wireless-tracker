#pragma once

#include <cstdint>

namespace Pins {

namespace TFT {

    constexpr const int8_t CS = 38;
    constexpr const int8_t REST = 39;
    constexpr const int8_t DC = 40;
    constexpr const int8_t SCLK = 41;
    constexpr const int8_t MOSI = 42;
    constexpr const int8_t LED_K = 21;
    constexpr const int8_t VTFT_CTRL = 3;

} //namespace TFT;

namespace GNSS {

    constexpr const int8_t VGNSS_CTRL = 3;
    constexpr const int8_t RX = 34;
    constexpr const int8_t TX = 33;
    constexpr const int8_t RST = 35; //There is a function built for this in the example below- currently it isn't used
    constexpr const int8_t PPS = 36;

} //namespace GNSS;

namespace LoRa {

    constexpr const int8_t DIO_1 = 14;
    constexpr const int8_t NSS = 8;
    constexpr const int8_t RESET = 12;
    constexpr const int8_t BUSY = 13;

    constexpr const int8_t CLK = 9;
    constexpr const int8_t MISO = 11;
    constexpr const int8_t MOSI = 10;

} //namespace LoRa;

} //namespace Pins;
