# Bruce for Freenove FNK0104B (FNK0104AB)

Community board support for running [Bruce](https://github.com/BruceDevices/firmware)
on the **Freenove FNK0104B** 2.8" ESP32-S3 display module (also sold/labelled as
**FNK0104AB**).

This repository contains:

- board fixes and small upstream fixes as **patches** against Bruce `dev`;
- **documentation** (pinout, flashing, tested features, known issues);
- **build/flash scripts**;
- **prebuilt firmware** in the [Releases](../../releases) section.

Upstream base: Bruce `dev` @ `22e72a1ba812ab19c9e1fc63dd1cbf467780d576`
(2026-11-08), environment `Freenove-FNK0104AB`.

> This is an unofficial community project, not affiliated with Freenove.
> Bruce is licensed AGPL-3.0; see [`NOTICE.md`](NOTICE.md) and [`LICENSE`](LICENSE).

## Hardware

- ESP32-S3R8, 16 MB QSPI flash, 8 MB OPI PSRAM
- 2.8" 240x320 IPS TFT, ILI9341V over SPI
- FT6336G capacitive touch (I2C)
- ES8311 audio codec + FM8002E amplifier, onboard microphone
- microSD slot (SDMMC, 4-bit)
- WS2812 RGB LED
- Battery voltage divider (GPIO9, x2)
- BOOT button (GPIO0)

See [`docs/hardware.md`](docs/hardware.md) and [`docs/pinout.md`](docs/pinout.md).

## Status

This build was validated on real hardware. Details and test conditions are in
[`docs/tested-features.md`](docs/tested-features.md).

| Feature | Status |
| --- | --- |
| Display, touch, SD card (4-bit) | Working |
| Audio output + microphone | Working |
| RGB LED (GPIO42) | Working |
| Battery ADC (GPIO9) | Configured; not yet verified with a real LiPo |
| WiFi AP, WebUI, File Manager | Working |
| BLE advertising (iBeacon) | Working |
| Deep sleep / `poweroff` (BOOT wake) | Working |
| Serial CLI (`battery`, `nav`, `settings`, ...) | Working |
| HID/BadUSB, BLE keyboard | Not tested |
| External RF/RFID/IR/FM/GPS modules | Not tested |

The four fixes are proposed upstream as pull requests #3070–#3073. Until they
are merged, use the patches or the prebuilt release.

## Quick start (prebuilt firmware)

1. Download `Bruce-Freenove-FNK0104AB.bin` from [Releases](../../releases).
2. Verify the checksum with `SHA256SUMS`.
3. Flash the merged image at offset `0x0`:

```bash
esptool.py --chip esp32s3 --port /dev/ttyACM0 --baud 921600 \
  write_flash 0x0 Bruce-Freenove-FNK0104AB.bin
```

If the port is not detected, put the board in download mode: hold **BOOT**,
tap **RESET**, release **BOOT**. See [`docs/flashing.md`](docs/flashing.md).

## Build from source

Requirements: Linux/macOS, Python 3, [PlatformIO Core](https://platformio.org/),
`git`, and `esptool` for flashing.

```bash
./scripts/bootstrap.sh          # clone Bruce at the locked commit + apply patches
./scripts/build.sh              # build env Freenove-FNK0104AB
./scripts/flash.sh              # flash Bruce-Freenove-FNK0104AB.bin
```

`bootstrap.sh` clones Bruce into `bruce-firmware/` (git-ignored) at the commit
recorded in [`upstream.lock`](upstream.lock), then applies everything in
[`patches/`](patches).

Useful environment variables:

| Variable | Default | Meaning |
| --- | --- | --- |
| `ENV` | `Freenove-FNK0104AB` | PlatformIO environment |
| `PORT` | `/dev/ttyACM0` | Serial port for flashing |
| `BAUD` | `921600` | Flash baud rate |
| `PIO` | `pio` | PlatformIO executable |
| `ESPTOOL` | `esptool.py` | esptool executable |

## Pinout (summary)

| Function | Pins |
| --- | --- |
| Display (SPI) | SCLK 12, MOSI 11, MISO 13, CS 10, DC 46, BL 45 |
| Touch (I2C @0x38) | SDA 16, SCL 15, INT 17, RST 18 |
| SD card (SDMMC) | CLK 38, CMD 40, D0 39, D1 41, D2 48, D3 47 |
| Audio (I2S) | MCLK 4, BCLK 5, LRC 7, DOUT 8, DIN 6, amp-enable 1 |
| RGB LED | 42 |
| Battery ADC | 9 (x2 divider) |
| BOOT / Select | 0 |
| Free GPIOs | 2, 3, 14, 21, 43, 44 |

Full tables and external-module wiring: [`docs/pinout.md`](docs/pinout.md) and
[`docs/external-modules.md`](docs/external-modules.md).

## Known issues

See [`docs/known-issues.md`](docs/known-issues.md). Highlights:

- HID/BadUSB and BLE keyboard were not tested.
- The battery reading was not verified with a real cell (no battery attached
  during bring-up).
- External CC1101/NRF24 default pin suggestions collide with the free pins;
  check the documentation before wiring.

## Credits

- [Bruce](https://github.com/BruceDevices/firmware) and its contributors.
- Freenove for the hardware (unofficial support).

## License

AGPL-3.0. See [`LICENSE`](LICENSE) and [`NOTICE.md`](NOTICE.md).
