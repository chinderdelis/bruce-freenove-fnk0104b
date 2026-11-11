#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${PORT:-/dev/ttyACM0}"
BAUD="${BAUD:-921600}"
ESPTOOL="${ESPTOOL:-esptool.py}"
BIN="${1:-$ROOT/dist/Bruce-Freenove-FNK0104AB.bin}"

if [ ! -f "$BIN" ]; then
    echo "ERROR: binary not found: $BIN" >&2
    echo "Build it first with ./scripts/build.sh or download a release." >&2
    exit 1
fi

"$ESPTOOL" --chip esp32s3 --port "$PORT" --baud "$BAUD" write_flash 0x0 "$BIN"
