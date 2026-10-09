#!/usr/bin/env bash
set -euo pipefail
count=1
while (( count <= 3 )); do
    printf 'Check %s\n' "$count"
    ((count += 1))
done
