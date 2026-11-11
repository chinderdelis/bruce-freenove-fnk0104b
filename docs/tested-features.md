# Tested features

Test environment:

- Date: 2026-11-11
- Base: Bruce `dev` @ `22e72a1ba812ab19c9e1fc63dd1cbf467780d576` + the patches in this repository
- Board: Freenove FNK0104B (ESP32-S3R8, 16 MB flash, 8 MB PSRAM)

## Working

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
