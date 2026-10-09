#!/usr/bin/env bash
set -Eeuo pipefail
base="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
curl -fsSL https://jsonplaceholder.typicode.com/todos -o "$base/data/todos.json"
count="$(jq 'length' "$base/data/todos.json")"
printf 'Dataset: JSONPlaceholder todos\nCount: %s\n' "$count" > "$base/result/todo-count.txt"
