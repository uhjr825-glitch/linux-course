#!/usr/bin/env bash
set -euo pipefail
input_dir="$1"
output_file="$input_dir/all_text.txt"
: > "$output_file"
shopt -s nullglob
for file in "$input_dir"/*.txt; do
    [[ "$file" == "$output_file" ]] && continue
    cat -- "$file" >> "$output_file"
done
