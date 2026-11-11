# Pinout

## On-board (already configured)

| Function | Pins |
| --- | --- |
| Display (ILI9341, SPI) | SCLK 12, MOSI 11, MISO 13, CS 10, DC 46, RST board-reset, BL 45 |
| Touch (FT6336, I2C @0x38) | SDA 16, SCL 15, INT 17, RST 18 |
| SD card (SDMMC 4-bit) | CLK 38, CMD 40, D0 39, D1 41, D2 48, D3 47 |
| Audio (I2S) | MCLK 4, BCLK 5, LRC 7, DOUT 8, DIN 6 |
| Audio amplifier enable | GPIO1 (active low) |
| RGB LED (WS2812) | 42 |
| Button (Select) | 0 (BOOT) |
| Battery ADC | 9 (x2 divider) |

## Free GPIOs (broken-out headers)

| Header | Free GPIOs | Notes |
| --- | --- | --- |
| Expanded IO | 2, 3, 14, 21 | + 3V3 + GND |
| UART | 43 (TX0), 44 (RX0) | free if the serial console is unused |
| IIC | 16 (SDA), 15 (SCL) | shared touch/audio bus — for I2C add-ons |

Power modules from the header **3V3** pin — CC1101 and nRF24 are 3.3 V, not
5 V-tolerant.

> Match wiring by **GPIO number to the header silkscreen** (IO2/IO3/IO14/IO21,
> TX/RX), not by connector position.

## Notes

- GPIO40 is the SD card CMD line, **not** the RGB LED. The upstream board file
  originally had `RGB_LED=40`; this project fixes it to 42.
- The touch controller and the ES8311 codec share the I2C bus on 16/15. The board
  marks it as the system I2C bus so Bruce does not release/`Wire.end()` it.
- The display reset is tied to the board reset; `TFT_RST` is therefore `-1`.
- Backlight is active-high on GPIO45 and is driven with LEDC PWM.

For external modules see [`external-modules.md`](external-modules.md).
