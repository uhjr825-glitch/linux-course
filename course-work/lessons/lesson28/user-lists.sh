#!/usr/bin/env bash
set -Eeuo pipefail
base="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
curl -fsSL https://jsonplaceholder.typicode.com/users -o "$base/data/users.json"
jq -r '.[].name' "$base/data/users.json" > "$base/result/user_names.txt"
jq -r '.[].address.city' "$base/data/users.json" > "$base/result/cities.txt"
tar -czf "$base/result/user-lists.tar.gz" -C "$base" result/user_names.txt result/cities.txt
