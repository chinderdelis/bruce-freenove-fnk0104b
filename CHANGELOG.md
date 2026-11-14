# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
versions follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v0.1.1] - 2026-11-14

### Changed
- Updated upstream base to Bruce `dev` @ `4f434aee38cbc90c022eaac376c4bf286a2e6be2` (1.17, includes #3082).
- Dropped patch 0004 (USBSerial `vprintf` fix): already merged upstream.

### Fixed
- Patch 0001 verified against the new upstream base.

## [v0.1.0] - 2026-11-11

Initial community build for the Freenove FNK0104B (FNK0104AB), based on Bruce
`dev` @ `22e72a1ba812ab19c9e1fc63dd1cbf467780d576`.

### Included patches

- `0001-board-freenove-fnk0104b.patch` — board fixes (RGB LED GPIO42, battery
  ADC GPIO9, 4-bit SDMMC, shared touch/codec I2C, backlight/PWM and poweroff,
  FT6X36 read, brightness menu, PR CI entry).
- `0002-config-no-serial-dump.patch` — stop dumping the config JSON to USB-CDC
  on every save (fixes UI freezes when no serial monitor is attached).
- `0003-cli-battery-command.patch` — new `battery` / `bat` serial command.
- `0004-usbserial-vprintf-fix.patch` — forward `va_list` to
  `Print::vprintf()` so formatted CLI output prints values instead of addresses.

Upstream pull requests: #3070, #3071, #3072, #3073.

[Unreleased]: https://github.com/chinderdelis/bruce-freenove-fnk0104b/compare/v0.1.1...HEAD
[v0.1.1]: https://github.com/chinderdelis/bruce-freenove-fnk0104b/releases/tag/v0.1.1
[v0.1.0]: https://github.com/chinderdelis/bruce-freenove-fnk0104b/releases/tag/v0.1.0
