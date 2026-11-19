# Known issues

## Upstream patches pending

The config-dump and battery CLI fixes are merged upstream (#3070, #3072);
#3071 is closed. The remaining board fixes are proposed in #3073 (board-only)
and a separate touch/brightness PR. Until they are merged, use the patches or
a prebuilt release from this repository: building upstream `dev` alone will
not have the corrected pins, 4-bit SDMMC, FT6X36 read or brightness menu fixes.

## v0.1.2 hardware sanity: SD not re-tested

v0.1.2 was built locally (Freenove plus ES3C28P regression), flashed on the
Freenove board and sanity-checked (serial CLI, WiFi AP/WebUI, BLE iBeacon).
No microSD card was inserted during the run, so the SD mount was not
re-validated; `ls`/`storage list /` only showed LittleFS. The v0.1.1 SD result
remains the latest hardware validation. See
[`tested-features.md`](tested-features.md).

## HID/BadUSB and BLE keyboard are untested

Enabling USB HID re-enumerates the device and can drop the serial console;
BLE keyboard needs host pairing. Treat these as unverified.

## Battery reading not verified with a real cell

The ADC path on GPIO9 is configured and returns plausible values, but during
bring-up no battery was connected, so the readings came from the USB/charger
rail. The percentage is an estimate based on a 2.5–4.2 V range and a x2 divider.

## USB-CDC instability on some hosts/ports

On some USB ports/hubs the board disappears from the bus (`error -71` in
`dmesg`). Unplug and replug the cable. A powered hub or a direct motherboard
port is usually more stable.

## External module pin collisions

The suggested pins for CC1101/nRF24 overlap with the limited free GPIOs. See
[`external-modules.md`](external-modules.md) before wiring. In particular:

- CC1101 default `GDO0` collides with MISO (GPIO2): move it to GPIO43.
- nRF24 `CE` on GPIO3 collides with MOSI if you keep the default suggestion:
  tie CE to 3V3 or reassign pins.

## Brightness minimum is 1

The slider cannot be set to 0 anymore: a saved 0 left the screen almost dark
with no visible UI to raise it again. Values 1–100 are allowed.

## SD card is 4-bit

4-bit SDMMC is enabled for this board (`SD_MMC_4BIT`). Other boards keep 1-bit.
If you see SD mount failures with a particular card, try a different card first;
the 4-bit lines are D1=41, D2=48, D3=47.

## If you build without the patches

The board pins, 4-bit SDMMC, FT6X36 read and brightness menu fixes are only in
patch 0001. The config-dump and serial `vprintf` fixes are already upstream
(#3070 and #3082).
