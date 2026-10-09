#!/usr/bin/env bash
set -euo pipefail
input_dir="$1"
output_file="$2"
: > "$output_file"
shopt -s nullglob
files=("$input_dir"/*.log)
if (( ${#files[@]} == 0 )); then echo 'No .log files found'; exit 0; fi
for file in "${files[@]}"; do
    count="$(grep -c 'ERROR' "$file" || true)"
    printf '%s %s\n' "$(basename "$file")" "$count" >> "$output_file"
done
