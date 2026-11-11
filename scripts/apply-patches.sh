#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="${1:-$ROOT/bruce-firmware}"

shopt -s nullglob
patches=("$ROOT"/patches/*.patch)
if [ ${#patches[@]} -eq 0 ]; then
    echo "ERROR: no patches found in $ROOT/patches" >&2
    exit 1
fi

for p in "${patches[@]}"; do
    name="$(basename "$p")"
    if git -C "$REPO" apply --reverse --check "$p" >/dev/null 2>&1; then
        echo "already applied: $name"
    elif git -C "$REPO" apply --check "$p" >/dev/null 2>&1; then
        git -C "$REPO" apply "$p"
        echo "applied: $name"
    else
        echo "ERROR: cannot apply $name (tree modified?)" >&2
        exit 1
    fi
done
