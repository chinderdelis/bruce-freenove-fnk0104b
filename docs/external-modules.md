# External modules

The on-board peripherals use most pins. The broken-out headers leave these
GPIOs free:

| Header | Free GPIOs | Notes |
| --- | --- | --- |
| Expanded IO | 2, 3, 14, 21 | + 3V3 + GND |
| UART | 43 (TX0), 44 (RX0) | free if the serial console is unused |
| IIC | 16 (SDA), 15 (SCL) | shared touch/audio bus |

## Sub-GHz / 2.4 GHz radios (SPI, shared bus)

| Device | SCK | MOSI | MISO | CS | GDO0/CE |
| --- | :---: | :---: | :---: | :---: | :---: |
| CC1101 | 14 | 3 | 2 | 21 | 43 (GDO0) |
| nRF24 | 14 | 3 | 2 | 44 | 3V3 * (CE) |

- CC1101 and nRF24 share SCK/MOSI/MISO. Set the pins in Bruce → Settings →
  Hardware/Pins.
- **CC1101 GDO0** default collides with MISO (GPIO2) — set GDO0 to **43** in the UI.
- Both radios at once need 7 GPIOs but only 6 are free (4 Expanded IO + 2 UART).
  Either tie nRF24 **CE to 3V3** ( * ) so Bruce drives it over SPI only, or use one
  radio at a time and swap CS in the UI.
- nRF24: add a decoupling capacitor across the module VCC/GND (10 µF; 100 µF for
  PA+LNA modules).

## I2C add-ons

PN532 (NFC), DS3231 (RTC) and other I2C devices join the IIC header
(SDA 16 / SCL 15) at their own addresses. The touch controller (0x38) and the
ES8311 codec (0x18) already live on this bus.

## IR / RF

The board exposes IR/RF TX/RX pin choices for the free GPIOs
(2, 3, 14, 21). Use a transistor/driver for IR LEDs; do not drive a high-power
IR LED directly from a GPIO.

## Power

- Power external modules from the header **3V3** pin. CC1101 and nRF24 are
  3.3 V devices, not 5 V-tolerant.
- Check current budget: the display backlight, audio amplifier and WiFi bursts
  draw significant current. Use a short, thick 3V3/GND pair for radio modules.
