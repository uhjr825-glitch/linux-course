#!/usr/bin/env bash
set -euo pipefail
for file in "$@"; do
    if [[ -f "$file" ]]; then printf '%s: found\n' "$file"; else printf '%s: missing\n' "$file"; fi
done
