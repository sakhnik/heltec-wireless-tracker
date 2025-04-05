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
    const int8_t RX = 34;
    const int8_t TX = 33;
    const int8_t RST = 35; //There is a function built for this in the example below- currently it isn't used
    const int8_t PPS = 36;

} //namespace GPS;

} //namespace Pins;
