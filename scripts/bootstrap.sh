#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_URL="${REPO_URL:-https://github.com/BruceDevices/firmware.git}"
WORKDIR="${1:-$ROOT/bruce-firmware}"
LOCK="$ROOT/upstream.lock"
COMMIT="$(sed -n 's/^commit=//p' "$LOCK")"

if [ -z "$COMMIT" ]; then
    echo "ERROR: no commit= entry in $LOCK" >&2
    exit 1
fi

if [ -e "$WORKDIR" ] && [ ! -d "$WORKDIR/.git" ]; then
    echo "ERROR: $WORKDIR exists but is not a git repository." >&2
    echo "Remove it or pass a different work directory." >&2
    exit 1
fi

if [ ! -d "$WORKDIR/.git" ]; then
    git clone --recursive "$REPO_URL" "$WORKDIR"
fi

git -C "$WORKDIR" fetch --all --tags --prune
git -C "$WORKDIR" checkout --detach "$COMMIT"
git -C "$WORKDIR" submodule update --init --recursive

"$ROOT/scripts/apply-patches.sh" "$WORKDIR"

echo "Ready: $WORKDIR @ $COMMIT + patches"
