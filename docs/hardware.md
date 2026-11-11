# Hardware

## Module

- **Freenove FNK0104B** (also labelled **FNK0104AB**): 2.8" IPS ESP32-S3 display
  module with capacitive touch.
- The board design is the same as the **ES3C28P**, which Bruce already supports.
  The Freenove variant differs in a few pin assignments (see below).

## SoC and memory

| Item | Value |
| --- | --- |
| SoC | ESP32-S3R8 (dual-core Xtensa LX7, WiFi 2.4 GHz, BLE 5) |
| Flash | 16 MB QSPI |
| PSRAM | 8 MB OPI |
| USB | native USB-CDC/JTAG (ESP32-S3 USB peripheral) |

## On-board peripherals

| Peripheral | Details |
| --- | --- |
| Display | ILI9341V, 240x320 IPS, 4-wire SPI, backlight on GPIO45 |
| Touch | FT6336G, I2C address `0x38`, INT 17, RST 18 |
| Audio | ES8311 codec + FM8002E amplifier; I2S MCLK 4, BCLK 5, LRC 7, DOUT 8, DIN 6; amp enable GPIO1 (active low) |
| Microphone | ES8311 ADC (shares the I2S bus) |
| Storage | microSD slot, SDMMC 4-bit |
| RGB LED | WS2812, GPIO42 |
| Battery | voltage divider x2 on GPIO9 (ADC) |
| Button | BOOT on GPIO0 (used as Select) |

## Power

- Powered over USB-C (5 V); onboard 3.3 V regulator.
- The expansion header exposes **3.3 V only**. CC1101 and nRF24 modules are 3.3 V;
  do not feed 5 V into the 3V3 rail.
- The battery connector has an onboard x2 divider on GPIO9. The ADC is only as
  accurate as the divider tolerance; treat the percentage as an estimate.

## Differences from the ES3C28P

| Function | ES3C28P | Freenove FNK0104B |
| --- | --- | --- |
| RGB LED | GPIO40 | **GPIO42** |
| Battery ADC | GPIO8 | **GPIO9** |
| SD bus | 1-bit | **4-bit** (D1=41, D2=48, D3=47) |

The upstream `Freenove-FNK0104AB` environment originally used the ES3C28P values;
the patches in this repository correct them.
