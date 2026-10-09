#!/usr/bin/env bash
set -Eeuo pipefail
base="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
curl -fsSL https://jsonplaceholder.typicode.com/users -o "$base/data/users.json"
jq -r '.[] | "\(.name)|\(.email)"' "$base/data/users.json" > "$base/result/user-emails.txt"
