#!/usr/bin/env bash
set -Eeuo pipefail
base="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
category="${1:-}"
[[ -n "$category" ]] || { echo 'Usage: category-report.sh CATEGORY' >&2; exit 2; }
matches="$(jq -r --arg category "$category" '.products[] | select(.category == $category) | "\(.title)|\(.price)|\(.discountPercentage)"' "$base/data/products.json" | sort -t '|' -k2,2n)"
if [[ -z "$matches" ]]; then
    printf 'No products found in category %s\n' "$category"
    exit 0
fi
printf '%s\n' "$matches"
printf 'Count: %s\n' "$(printf '%s\n' "$matches" | wc -l | tr -d '[:space:]')"
