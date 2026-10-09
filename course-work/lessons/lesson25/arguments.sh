#!/usr/bin/env bash
set -euo pipefail
printf 'Argument count: %s\n' "$#"
for argument in "$@"; do printf 'Value: %s\n' "$argument"; done
