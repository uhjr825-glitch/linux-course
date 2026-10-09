#!/usr/bin/env bash
set -Eeuo pipefail
base="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$base/data" "$base/result"
curl -fsSL 'https://dummyjson.com/products?limit=0' -o "$base/data/products.json"
jq -e '.products | type == "array"' "$base/data/products.json" >/dev/null
jq -r '.products[] | select(.brand != null and .brand != "") | .brand' "$base/data/products.json" | sort | uniq -c | sort -nr > "$base/result/brand-statistics.txt"
jq -r '.products[].tags[]?' "$base/data/products.json" | sort | uniq -c | sort -nr > "$base/result/tag-statistics.txt"
jq -r '.products[] | select(.discountPercentage >= 10) | "\(.discountPercentage)|\(.title)"' "$base/data/products.json" | sort -t '|' -k1,1nr > "$base/result/discount-report.txt"
jq -r '.products[] | "\(.minimumOrderQuantity)|\(.title)"' "$base/data/products.json" | sort -t '|' -k1,1n > "$base/result/order-report.txt"
