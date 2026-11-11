# Flashing

## Prebuilt release (recommended)

Download `Bruce-Freenove-FNK0104AB.bin` and `SHA256SUMS` from the Releases page,
verify the checksum, then flash the merged image at offset `0x0`:

```bash
sha256sum -c SHA256SUMS
esptool.py --chip esp32s3 --port /dev/ttyACM0 --baud 921600 \
  write_flash 0x0 Bruce-Freenove-FNK0104AB.bin
```

Wait ~10 seconds after the reset before opening the serial monitor; the first
boot can take a little longer.

## Build from source

```bash
./scripts/bootstrap.sh   # clone Bruce at upstream.lock + apply patches
./scripts/build.sh       # produces dist/Bruce-Freenove-FNK0104AB.bin
./scripts/flash.sh       # flashes it at 0x0
```

Or with PlatformIO directly:

```bash
pio run -e Freenove-FNK0104AB -t upload --upload-port /dev/ttyACM0
```

## Download mode

If `/dev/ttyACM0` is not present or flashing fails:

1. Hold **BOOT**.
2. Tap **RESET**.
3. Release **BOOT**.
4. Flash again.

To leave download mode and boot the firmware:

```bash
esptool.py --chip esp32s3 --port /dev/ttyACM0 --after hard_reset run
```

## Backup the original flash

Before the first flash you can save the factory image (16 MB flash):

```bash
esptool.py --chip esp32s3 --port /dev/ttyACM0 --baud 921600 \
  read_flash 0 0x1000000 freenove-factory-backup.bin
```

## Troubleshooting

- **Permission denied on the port**: add your user to the `dialout` group and
  log in again: `sudo usermod -aG dialout "$USER"`.
- **Port disappears during use** (`error -71` in `dmesg`): unplug and replug the
  USB cable. Some USB hubs/ports are unstable with this board.
- **Serial output looks garbled**: the native USB-CDC console runs at 115200;
  open the monitor only after boot, or reset while the monitor is open.
- **Board boots to a menu but does not respond**: make sure you flashed the
  **merged** image at `0x0`, not a raw `firmware.bin` at another offset.
