#!/usr/bin/env bash
set -euo pipefail
file="${1:-}"
if [[ -f "$file" ]]; then printf 'Found: %s\n' "$file"; else printf 'Not found: %s\n' "$file"; fi
