#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TAG="${1:?usage: release-notes.sh <tag>}"
LOCK="$ROOT/upstream.lock"
CHANGELOG="$ROOT/CHANGELOG.md"

if [[ ! "$TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$ ]]; then
  echo "ERROR: invalid tag '$TAG'" >&2
  exit 1
fi

commit="$(sed -n 's/^commit=//p' "$LOCK")"
date="$(sed -n 's/^date=//p' "$LOCK")"
env="$(sed -n 's/^env=//p' "$LOCK")"
[ -n "$commit" ] || { echo "ERROR: missing commit in upstream.lock" >&2; exit 1; }

# Extract the changelog section for this tag.
# Supports both "## [vX.Y.Z] - date" and "## vX.Y.Z — date" headings.
extract_section() {
  local key="$1"
  awk -v key="$key" '
    BEGIN { insec=0 }
    /^## / {
      if (insec) exit
      h=$0
      sub(/^##[[:space:]]*/, "", h)
      gsub(/[][]/, "", h)
      if (h ~ "^" key "([[:space:]]|$)") { insec=1; next }
      next
    }
    insec { print }
  ' "$CHANGELOG"
}

section="$(extract_section "$TAG")"

# Prereleases fall back to the base version section, then to Unreleased.
if [ -z "$(printf '%s' "$section" | tr -d '[:space:]')" ] && [[ "$TAG" == *-* ]]; then
  base="${TAG%%-*}"
  section="$(extract_section "$base")"
fi
if [ -z "$(printf '%s' "$section" | tr -d '[:space:]')" ] && [[ "$TAG" == *-* ]]; then
  section="$(extract_section "Unreleased")"
fi

if [ -z "$(printf '%s' "$section" | tr -d '[:space:]')" ]; then
  if [ "${ALLOW_MISSING:-false}" = "true" ] || [ "${ALLOW_MISSING:-0}" = "1" ]; then
    section="No changelog entry for this tag yet."
  else
    echo "ERROR: no changelog section found for $TAG (or Unreleased) in $CHANGELOG" >&2
    exit 1
  fi
fi

cat <<NOTES
Community build of **Bruce** for the **Freenove FNK0104B (FNK0104AB)** 2.8" ESP32-S3 display module.

## Flash

\`\`\`bash
sha256sum -c SHA256SUMS
esptool.py --chip esp32s3 --port /dev/ttyACM0 --baud 921600 \\
  write_flash 0x0 Bruce-Freenove-FNK0104AB.bin
\`\`\`

Merged image, flash at offset \`0x0\`. If the port is missing, hold BOOT, tap RESET, release BOOT and retry.

## Base

- Upstream: Bruce \`dev\` @ \`${commit}\` (${date})
- Environment: \`${env}\`
- Built from a clean upstream checkout + the patches in this repository.

## Upstream pull requests

#3070, #3072, #3073 (and #3082, merged upstream, which includes the \`vprintf\` fix).

## What's in this release

$(printf '%s\n' "$section")

## Verification

\`\`\`bash
sha256sum -c SHA256SUMS
gh attestation verify Bruce-Freenove-FNK0104AB.bin --repo chinderdelis/bruce-freenove-fnk0104b
\`\`\`

## Tested on hardware

Display, touch, SD (4-bit), audio out, microphone, RGB LED, battery ADC, WiFi AP, WebUI/File Manager, BLE iBeacon, deep sleep/poweroff, serial CLI, config save.

**Not tested:** HID/BadUSB, BLE keyboard, external RF/RFID/IR/FM/GPS modules, real LiPo and sleep current.

See \`docs/tested-features.md\` and \`docs/known-issues.md\` in the repository.
NOTES
