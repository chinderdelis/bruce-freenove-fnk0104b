# Known issues

## Upstream patches pending

The board and the three fixes are proposed upstream as pull requests #3070,
#3071, #3072 and #3073. Until they are merged, you must use the patches or a
prebuilt release from this repository. Building upstream `dev` alone will not
have the corrected pins or the fixes.

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

Two upstream issues are fixed only by these patches:

- `fix(config)` — saving the config dumps ~1.7 KB of JSON to USB-CDC; with no
  monitor draining the endpoint the UI can freeze.
- `fix(serial)` — formatted CLI output can print memory addresses instead of
  values (e.g. `LED color set to 3FCD8C30`).
