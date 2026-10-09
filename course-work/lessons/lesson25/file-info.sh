#!/usr/bin/env bash
set -euo pipefail
[[ $# -eq 1 ]] || { echo 'Usage: file-info.sh FILE' >&2; exit 2; }
head -n 3 -- "$1"
