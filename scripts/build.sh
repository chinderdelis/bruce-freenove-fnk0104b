#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="${1:-$ROOT/bruce-firmware}"
ENV="${ENV:-Freenove-FNK0104AB}"
PIO="${PIO:-pio}"

"$PIO" run -d "$REPO" -e "$ENV"

BIN="$REPO/Bruce-$ENV.bin"
if [ -f "$BIN" ]; then
    mkdir -p "$ROOT/dist"
    cp "$BIN" "$ROOT/dist/"
    echo "artifact: $ROOT/dist/$(basename "$BIN")"
fi
