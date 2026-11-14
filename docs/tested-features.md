# Tested features

Board: Freenove FNK0104B (ESP32-S3R8, 16 MB flash, 8 MB PSRAM).

## v0.1.1 — Bruce `dev` @ `4f434aee` (2026-11-14)

Environment: `Freenove-FNK0104AB` built from a clean upstream checkout plus the
patches in this repository; binary flashed on hardware and checked over the
serial CLI. On 2026-11-14 the WiFi AP/WebUI and BLE iBeacon paths were also
executed on this build.

| Feature | What was checked |
| --- | --- |
| Display | Boots to the main menu; confirmed working on hardware |
| Touch | Taps/drags work; confirmed working on hardware |
| SD card | `ls` lists the card contents (4-bit SDMMC) |
| Audio output | `tone 440 500` reports `ES8311 speaker enabled`; sound confirmed |
| RGB LED | `led rgb 255 0 0` → `FF0000`, `led off` → `000000` |
| Battery ADC | `[BAT] 95% charging=1 adc=2066mV batt~4132mV` |
| I2C bus | `i2c` finds `0x18` (ES8311 codec) and `0x38` (FT6336G touch) |
| Serial CLI | `help`, `battery`, `ls`, `i2c`, `tone`, `led`, `settings` |
| Config save | `settings bright 100` produces no JSON dump (freeze fix) |
| WiFi AP | `wifi on` starts `BruceNet` (WPA2); host connects and pings `172.0.0.1` |
| WebUI | Login `admin`/`bruce`; `/systeminfo`, `/listfiles` (LittleFS + SD) and `/getscreen` answer over HTTP |
| BLE | iBeacon advertising verified on a BlueZ host via D-Bus `ManufacturerData`: UUID `e4c159a0-8c82-11e6-bdf4-0800200c9a66`, major 5, minor 88, company `0x004C` |

BLE note: iBeacon advertising works after a clean boot; starting it a second
time without resetting hit `[RAM] Low contiguous DMA memory for BLE` (`Still
only 31732 bytes DMA block, minimum 49152 needed`) and needs a reboot.

Not re-tested on this base (validated on v0.1.0): microphone, File Manager,
deep sleep, HID/BadUSB, BLE keyboard.

## v0.1.0 — Bruce `dev` @ `22e72a1b` (2026-11-11)

| Feature | What was checked |
| --- | --- |
| Display | Boots to the main menu, rotation correct |
| Touch | Dragging, taps, brightness menu |
| SD card | 4-bit SDMMC mounts; File Manager lists it |
| Audio output | `tone 880 900` produces a clear beep (ES8311 + FM8002E) |
| Microphone | Record/level path works (ES8311 ADC) |
| RGB LED | Red/green/blue/white/off on GPIO42 |
| Battery ADC | `battery` reports percentage, raw ADC and scaled voltage |
| WiFi AP | `wifi on` without known networks starts `BruceNet` (172.0.0.1) |
| WebUI | Login, `/systeminfo`, `/listfiles` on LittleFS and SD |
| File Manager | Browse/upload over WebUI |
| BLE | iBeacon advertising detected by a Linux/BlueZ host |
| Deep sleep | `poweroff` sleeps and wakes on BOOT |
| Serial CLI | `battery`, `settings`, `nav`, `led`, `screen`, `help` |
| Config save | Brightness menu and other config-saving menus no longer freeze |

## Not tested

| Feature | Why |
| --- | --- |
| HID / BadUSB | Needs USB re-enumeration; can drop the serial console |
| BLE keyboard | Needs pairing with a host |
| External CC1101 / nRF24 / RFID / IR / FM / GPS | Modules not available; pin conflicts documented |
| Real battery | No LiPo connected during bring-up; readings were from the USB rail |
| Deep-sleep current | Requires a multimeter measurement |

If you test any of the untested features, please open an issue with your results.
