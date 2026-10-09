#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT="$SCRIPT_DIR/lessons"
mkdir -p "$LAB_ROOT"

for utility in curl jq grep sort uniq wc cut tr find zip unzip tar ss ip ping; do
    command -v "$utility" >/dev/null 2>&1 || {
        printf 'Required command is missing: %s\n' "$utility" >&2
        exit 1
    }
done

mkdir -p "$LAB_ROOT/lesson03/projects" "$LAB_ROOT/lesson03/docs" "$LAB_ROOT/lesson03/config"
touch "$LAB_ROOT/lesson03/projects/app.txt" "$LAB_ROOT/lesson03/docs/readme.txt" "$LAB_ROOT/lesson03/config/settings.conf"
{
    cd "$LAB_ROOT/lesson03"
    pwd
    ls
    cd projects
    pwd
    ls
    cd ../docs
    pwd
    ls
    cd ../config
    pwd
    ls
} > "$LAB_ROOT/lesson03/evidence.txt"

mkdir -p "$LAB_ROOT/lesson04/documents" "$LAB_ROOT/lesson04/scripts" "$LAB_ROOT/lesson04/logs"
touch "$LAB_ROOT/lesson04/README.md" "$LAB_ROOT/lesson04/notes.txt" "$LAB_ROOT/lesson04/config.conf" "$LAB_ROOT/lesson04/.env" "$LAB_ROOT/lesson04/.hidden"
{
    cd "$LAB_ROOT/lesson04"
    ls documents scripts logs
    ls -la
    cd ..
    pwd
    ls -la
} > "$LAB_ROOT/lesson04/evidence.txt"

mkdir -p "$LAB_ROOT/lesson05"
ls --help > "$LAB_ROOT/lesson05/ls-help.txt"
grep -E -- ' -a,| -l,' "$LAB_ROOT/lesson05/ls-help.txt" > "$LAB_ROOT/lesson05/options.txt" || true
if command -v man >/dev/null 2>&1; then
    MANPAGER=cat man ls 2>/dev/null | grep -i -m 8 hidden > "$LAB_ROOT/lesson05/man-search.txt" || true
else
    printf 'man is unavailable; ls --help was checked.\n' > "$LAB_ROOT/lesson05/man-search.txt"
fi

mkdir -p "$LAB_ROOT/lesson06"
cat /etc/os-release > "$LAB_ROOT/lesson06/os-release.txt"
grep -in ssh /etc/services > "$LAB_ROOT/lesson06/ssh-services.txt" || true
head -n 5 /etc/services > "$LAB_ROOT/lesson06/services-head.txt"
tail -n 5 /etc/services > "$LAB_ROOT/lesson06/services-tail.txt"

mkdir -p "$LAB_ROOT/lesson07"
curl -fsSL https://www.gnu.org -o "$LAB_ROOT/lesson07/gnu.html"
grep -oi -m 1 '<title[^>]*>[^<]*</title>' "$LAB_ROOT/lesson07/gnu.html" > "$LAB_ROOT/lesson07/title-tag.txt" || true
curl -fsSL https://example.com | head -n 15 > "$LAB_ROOT/lesson07/example-preview.html" || true
curl -fsSI https://www.gnu.org | head -n 12 > "$LAB_ROOT/lesson07/gnu-headers.txt"

mkdir -p "$LAB_ROOT/lesson08"
curl --version > "$LAB_ROOT/lesson08/curl-version.txt"
curl -fsSL https://example.com -o "$LAB_ROOT/lesson08/page.html"
test -s "$LAB_ROOT/lesson08/page.html"
head -n 3 "$LAB_ROOT/lesson08/page.html" > "$LAB_ROOT/lesson08/page-preview.txt"

mkdir -p "$LAB_ROOT/lesson09"
curl -fsSL https://jsonplaceholder.typicode.com/comments -o "$LAB_ROOT/lesson09/comments.json"
jq '.[2]' "$LAB_ROOT/lesson09/comments.json" > "$LAB_ROOT/lesson09/comment-3.json"
curl -fsS -X POST https://jsonplaceholder.typicode.com/posts -H 'Content-Type: application/json' \
    -d '{"title":"Linux practice","body":"Testing a POST request","userId":7}' \
    | jq . > "$LAB_ROOT/lesson09/post-response.json"
curl -fsSL https://jsonplaceholder.typicode.com/posts/1 | jq .title > "$LAB_ROOT/lesson09/post-title.json"
curl -fsSL https://jsonplaceholder.typicode.com/users/1 | jq .name > "$LAB_ROOT/lesson09/user-name.json"
curl -fsSL https://jsonplaceholder.typicode.com/todos/1 | jq .completed > "$LAB_ROOT/lesson09/todo-completed.json"

mkdir -p "$LAB_ROOT/lesson10"
hostname > "$LAB_ROOT/lesson10/hostname.txt"
ip a > "$LAB_ROOT/lesson10/interfaces.txt"
ping -c 2 -W 2 127.0.0.1 > "$LAB_ROOT/lesson10/localhost-ping.txt"

mkdir -p "$LAB_ROOT/lesson11"
ss -tn > "$LAB_ROOT/lesson11/tcp-numeric.txt"
ss -tl > "$LAB_ROOT/lesson11/tcp-listen.txt"
ss -tn state established > "$LAB_ROOT/lesson11/established.txt"

mkdir -p "$LAB_ROOT/lesson12"
apt-cache search htop | grep -i htop > "$LAB_ROOT/lesson12/search.txt" || true
apt show htop > "$LAB_ROOT/lesson12/package-info.txt" 2>&1
dpkg-query -W -f='${Status}\n${Version}\n' htop > "$LAB_ROOT/lesson12/installed-status.txt" 2>&1 || true
htop --version > "$LAB_ROOT/lesson12/htop-version.txt" 2>&1 || true
timeout 3s htop --batch --no-color -n 1 > "$LAB_ROOT/lesson12/htop-snapshot.txt" 2>&1 || true
printf 'htop is preinstalled in this Codespace; inspected, not removed.\n' > "$LAB_ROOT/lesson12/package-action.txt"

mkdir -p "$LAB_ROOT/lesson13"
cd "$LAB_ROOT/lesson13"
mkdir -p projects docs images backup project/website/css project/website/js reports
touch README.md project/website/index.html project/website/css/style.css project/website/js/script.js
touch reports/jan.txt reports/feb.txt reports/mar.txt
find . -maxdepth 4 -print | sort > evidence.txt

LESSON14_DIR="$(mktemp -d "$LAB_ROOT/lesson14-run.XXXXXX")"
mkdir -p "$LESSON14_DIR/docs" "$LESSON14_DIR/archive"
cd "$LESSON14_DIR"
printf 'Monthly report\n' > report.txt
printf 'Keep these notes\n' > notes.txt
printf 'Readme for docs\n' > docs/readme.txt
mkdir -p backup
cp report.txt backup/
cp report.txt report-old.txt
cp docs/readme.txt .
mv notes.txt backup/
mv report.txt report-final.txt
cp -r docs archive/
mv backup archive/
mv archive storage
find . -maxdepth 4 -type f | sort > evidence.txt

mkdir -p "$LAB_ROOT/lesson15/project/docs" "$LAB_ROOT/lesson15/project/tmp" "$LAB_ROOT/lesson15/backup"
cd "$LAB_ROOT/lesson15"
touch test.txt one.txt two.txt backup/first.txt backup/second.txt project/README.txt project/docs/guide.txt project/tmp/cache.txt
rm test.txt
rm one.txt two.txt
rm -r backup
rm -r project/tmp
find . -print | sort > evidence.txt

mkdir -p "$LAB_ROOT/lesson16"
cd "$LAB_ROOT/lesson16"
echo 'Linux terminal' > course.txt
echo 'GitHub Codespaces' >> course.txt
echo 'Bash shell' >> course.txt
for command_name in pwd cd ls whoami cat less head tail history man curl apt mkdir touch cp mv rm grep find chmod chown tar ps top kill env bash; do
    echo "$command_name" >> commands.txt
done
cat course.txt commands.txt > evidence.txt

mkdir -p "$LAB_ROOT/lesson17/demo"
cd "$LAB_ROOT/lesson17"
pwd | tee my_work_dir.txt > /dev/null
curl -fsSI https://example.com | head -n 8 > example-headers.txt
printf 'Linux terminal course\n' > demo/linux.txt
printf 'GitHub Codespaces training\n' > demo/github.txt
printf 'Bash command line\nSecond line\n' > demo/bash.txt
cat demo/linux.txt demo/github.txt demo/bash.txt | head > demo/combined-preview.txt
curl -fsSL https://example.com | head -n 20 | cat > response-preview.txt || true
LESS=-F less response-preview.txt > response-through-less.txt || cp response-preview.txt response-through-less.txt
cat response-through-less.txt > evidence.txt

mkdir -p "$LAB_ROOT/lesson18/subdir"
cd "$LAB_ROOT/lesson18"
cat > deploy.log <<'EOF'
2026-09-03 09:10 INFO Deployment started
2026-09-03 09:11 INFO Uploading application files
2026-09-03 09:12 INFO Database migration completed
2026-09-03 09:13 INFO Deployment completed successfully
2026-09-03 10:25 INFO Deployment started
2026-09-03 10:26 ERROR Failed to connect to server
2026-09-03 10:27 ERROR Deployment aborted
2026-09-03 11:40 INFO Deployment started
2026-09-03 11:42 INFO Deployment completed successfully
EOF
printf 'port=8080\ndebug=true\n' > config.txt
printf 'debug is enabled\n' > subdir/settings.txt
grep 'ERROR' deploy.log > error-lines.txt || true
grep 'INFO' deploy.log > info-lines.txt || true
grep -i 'info' deploy.log > info-ignore-case.txt || true
grep -n 'INFO' deploy.log > info-numbered.txt || true
grep -v 'INFO' deploy.log > non-info-lines.txt || true
grep 'port' config.txt > port-line.txt || true
grep -r --exclude='debug-search.txt' 'debug' . > debug-search.txt || true
history | grep 'cd' > history-cd.txt || true

mkdir -p "$LAB_ROOT/lesson19/practice/find" "$LAB_ROOT/lesson19/project/backend/logs" "$LAB_ROOT/lesson19/project/frontend"
cd "$LAB_ROOT/lesson19"
touch practice/find/app.log practice/find/error.log practice/find/config.json project/backend/config.json project/frontend/config.json
find . -type f -name config.json > configs-found.txt
find . -type d | sort > directories-found.txt
find . -type f -name '*.log' | sort > logs-found.txt
which curl > curl-path.txt

mkdir -p "$LAB_ROOT/lesson20"
cd "$LAB_ROOT/lesson20"
printf '%s\n' 'INFO: Application started' 'ERROR: Database connection failed' 'INFO: Request received' 'WARNING: Disk space low' 'ERROR: Database connection failed' 'INFO: Request received' 'ERROR: Authentication failed' > application.log
printf '%s\n' '2026-09-01;web-01;200;120' '2026-09-01;web-02;500;0' '2026-09-02;web-01;200;135' '2026-09-02;db-01;503;0' '2026-09-03;web-02;200;142' > requests.csv
grep 'INFO' application.log | wc -l > info-count.txt
cut -d: -f1 application.log | sort | uniq -c > level-counts.txt
cut -d ';' -f 3 requests.csv | sort | uniq -c > response-code-counts.txt
cut -d ';' -f 2 requests.csv | sort | uniq -c | awk '$1 > 1' > repeated-servers.txt
cut -d ';' -f 3 requests.csv | sort | uniq -d > repeated-codes.txt
cut -d ';' -f 2 requests.csv | tr '[:lower:]' '[:upper:]' | sort -u > uppercase-servers.txt
grep ';200;' requests.csv | cut -d ';' -f 2 | sort -u | wc -l > unique-successful-servers.txt

mkdir -p "$LAB_ROOT/lesson21/permissions-practice/project/config" "$LAB_ROOT/lesson21/permissions-practice/project/logs"
cd "$LAB_ROOT/lesson21/permissions-practice"
printf 'PORT=8080\n' > project/config/settings.conf
printf '#!/bin/bash\necho backup\n' > project/backup.sh
printf 'restricted\n' > project/restricted.log
printf 'private notes\n' > notes.txt
chmod 644 notes.txt
chmod 744 project/backup.sh
chmod 600 project/restricted.log
if [[ ! -e config && ! -L config ]]; then
    ln -s project/config config
fi
[[ -L config && "$(readlink config)" == 'project/config' ]]
if [[ ! -e project/current-restricted.log && ! -L project/current-restricted.log ]]; then
    ln -s restricted.log project/current-restricted.log
fi
[[ -L project/current-restricted.log && "$(readlink project/current-restricted.log)" == 'restricted.log' ]]
cat config/settings.conf > config-via-link.txt
cat project/current-restricted.log > restricted-via-link.txt
ls -l notes.txt project/backup.sh project/restricted.log config project/current-restricted.log > permissions.txt

mkdir -p "$LAB_ROOT/lesson22/project/config" "$LAB_ROOT/lesson22/project/logs" "$LAB_ROOT/lesson22/project/data" "$LAB_ROOT/lesson22/logs-copy"
cd "$LAB_ROOT/lesson22"
printf 'port=8080\n' > project/config/app.conf
printf 'database=staging\n' > project/config/db.conf
printf 'server started\n' > project/logs/app.log
printf 'server stopped\n' > project/logs/app-old.log
printf '100,200,300\n' > project/data/numbers.txt
tar -cf config-backup.tar project/config
tar -tf config-backup.tar > config-archive-contents.txt
zip -q config-data.zip project/data/numbers.txt project/config/app.conf
unzip -l config-data.zip > zip-contents.txt
gzip -kf project/logs/app.log
tar -czf logs.tar.gz project/logs
tar -xzf logs.tar.gz -C logs-copy
tar -czf config-data.tar.gz project/config project/data
tar -tzf config-data.tar.gz > config-data-contents.txt
find logs-copy -type f > extracted-logs.txt

mkdir -p "$LAB_ROOT/lesson23"
cd "$LAB_ROOT/lesson23"
sleep 180 & sleep_one=$!
sleep 240 & sleep_two=$!
sleep 300 & sleep_three=$!
printf 'sleep PIDs: %s %s %s\n' "$sleep_one" "$sleep_two" "$sleep_three" > process-evidence.txt
ps -p "$sleep_one","$sleep_two","$sleep_three" -o pid=,comm= >> process-evidence.txt
top -b -n 1 -p "$sleep_one,$sleep_two,$sleep_three" >> process-evidence.txt 2>&1 || true
kill "$sleep_one"
kill "$sleep_two" "$sleep_three"
wait "$sleep_one" 2>/dev/null || true
wait "$sleep_two" 2>/dev/null || true
wait "$sleep_three" 2>/dev/null || true
if ps -p "$sleep_one","$sleep_two","$sleep_three" -o pid= | grep -q '[0-9]'; then
    printf 'A practice sleep process is still running\n' >> process-evidence.txt
    exit 1
fi
printf 'All three recorded practice processes have exited.\n' >> process-evidence.txt

mkdir -p "$LAB_ROOT/lesson24/project/config"
cd "$LAB_ROOT/lesson24"
touch project/config/app.conf project/config/database.conf
export PROJECT_NAME='linux-course-practice'
export APP_MODE='testing'
export CONFIG_DIR="$PWD/project/config"
printf 'PROJECT_NAME=%s\nAPP_MODE=%s\nCONFIG_DIR=%s\n' "$PROJECT_NAME" "$APP_MODE" "$CONFIG_DIR" > variables.txt
env | grep -E '^(APP_MODE|CONFIG_DIR|PROJECT_NAME)=' | sort >> variables.txt
ls "$CONFIG_DIR" | sort > project/config-files.txt

mkdir -p "$LAB_ROOT/lesson25/project"
cd "$LAB_ROOT/lesson25"
printf 'application started\n' > project/application.log
printf 'backup completed\n' > project/backup.log
printf 'deployment completed\n' > project/deployment.log
cat > project-check.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo 'Project check started'
ls -la "$1"
EOF
cat > file-info.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
[[ $# -eq 1 ]] || { echo 'Usage: file-info.sh FILE' >&2; exit 2; }
head -n 3 -- "$1"
EOF
cat > enter-directory.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
directory="$1"
cd -- "$directory"
pwd
EOF
cat > arguments.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'Argument count: %s\n' "$#"
for argument in "$@"; do printf 'Value: %s\n' "$argument"; done
EOF
chmod +x project-check.sh file-info.sh enter-directory.sh arguments.sh
./project-check.sh project > project-check-output.txt
./file-info.sh project/application.log > file-info-output.txt
./enter-directory.sh project > directory-output.txt
./arguments.sh one two three > arguments-output.txt

mkdir -p "$LAB_ROOT/lesson26"
cd "$LAB_ROOT/lesson26"
touch report.txt server.txt backup.txt
printf 'READY\n' > report.txt
printf 'web-01\n' > server.txt
printf 'backup-01\n' > backup.txt
cat > check-files.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
for file in "$@"; do
    if [[ -f "$file" ]]; then printf '%s: found\n' "$file"; else printf '%s: missing\n' "$file"; fi
done
EOF
cat > check-argument.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
file="${1:-}"
if [[ -f "$file" ]]; then printf 'Found: %s\n' "$file"; else printf 'Not found: %s\n' "$file"; fi
EOF
cat > mode.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
case "${1:-}" in
    start) echo 'Start requested' ;;
    stop) echo 'Stop requested' ;;
    status) echo 'Status requested' ;;
    *) echo 'Unknown mode' ;;
esac
EOF
cat > counter.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
count=1
while (( count <= 3 )); do
    printf 'Check %s\n' "$count"
    ((count += 1))
done
EOF
chmod +x check-files.sh check-argument.sh mode.sh counter.sh
./check-files.sh report.txt server.txt backup.txt missing.txt > files-check.txt
./check-argument.sh report.txt > argument-check.txt
./mode.sh status > case-output.txt
./counter.sh > counter-output.txt

mkdir -p "$LAB_ROOT/lesson27/inbox" "$LAB_ROOT/lesson27/archive" "$LAB_ROOT/lesson27/processed"
cd "$LAB_ROOT/lesson27"
printf 'First text file\n' > inbox/first.txt
printf 'Second text file\n' > inbox/second.txt
printf 'INFO started\nERROR failed\nINFO retry\n' > inbox/app.log
printf 'ERROR database\nINFO ready\n' > inbox/database.log
printf 'server01 OK\nserver02 ERROR\nserver03 OK\n' > inbox/status.log
cat > collect-text.sh <<'EOF'
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
EOF
cat > log-errors.sh <<'EOF'
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
EOF
chmod +x collect-text.sh log-errors.sh
./collect-text.sh inbox
./log-errors.sh inbox error_report.txt
cat inbox/all_text.txt > text-aggregation.txt
cat error_report.txt >> text-aggregation.txt
grep 'ERROR' inbox/*.log | wc -l > error-line-count.txt

mkdir -p "$LAB_ROOT/lesson28/data" "$LAB_ROOT/lesson28/result"
cd "$LAB_ROOT/lesson28"
curl -fsSL https://jsonplaceholder.typicode.com/users -o data/users.json
test -s data/users.json
jq -r '.[].name' data/users.json > result/user_names.txt
curl -fsSL https://jsonplaceholder.typicode.com/todos -o data/todos.json
jq -r '.[0:10][].title' data/todos.json > result/todo_titles.txt
cat > users-report.sh <<'EOF'
#!/usr/bin/env bash
set -Eeuo pipefail
base="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
curl -fsSL https://jsonplaceholder.typicode.com/users -o "$base/data/users.json"
jq -r '.[] | "\(.name)|\(.email)"' "$base/data/users.json" > "$base/result/user-emails.txt"
EOF
cat > todo-count.sh <<'EOF'
#!/usr/bin/env bash
set -Eeuo pipefail
base="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
curl -fsSL https://jsonplaceholder.typicode.com/todos -o "$base/data/todos.json"
count="$(jq 'length' "$base/data/todos.json")"
printf 'Dataset: JSONPlaceholder todos\nCount: %s\n' "$count" > "$base/result/todo-count.txt"
EOF
cat > user-lists.sh <<'EOF'
#!/usr/bin/env bash
set -Eeuo pipefail
base="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
curl -fsSL https://jsonplaceholder.typicode.com/users -o "$base/data/users.json"
jq -r '.[].name' "$base/data/users.json" > "$base/result/user_names.txt"
jq -r '.[].address.city' "$base/data/users.json" > "$base/result/cities.txt"
tar -czf "$base/result/user-lists.tar.gz" -C "$base" result/user_names.txt result/cities.txt
EOF
chmod +x users-report.sh todo-count.sh user-lists.sh
./users-report.sh
./todo-count.sh
./user-lists.sh
tar -tzf result/user-lists.tar.gz > result/archive-contents.txt

mkdir -p "$LAB_ROOT/lesson29/data" "$LAB_ROOT/lesson29/result"
cd "$LAB_ROOT/lesson29"
curl -fsSL 'https://dummyjson.com/products?limit=0' -o data/products.json
jq -e '.products | type == "array"' data/products.json >/dev/null
jq -r '.products[] | select(.brand != null and .brand != "") | .brand' data/products.json | sort > result/brands.txt
jq -r '.products[].availabilityStatus' data/products.json | sort | uniq -c | sort -nr > result/availability.txt
jq -r '.products[].minimumOrderQuantity' data/products.json | sort -n | uniq -c | sort -nr | head -n 3 > result/order-quantities.txt
jq -r '.products[] | select(.discountPercentage >= 10) | "\(.discountPercentage)|\(.title)"' data/products.json \
    | sort -t '|' -k1,1nr > result/discounts.txt
jq -r '.products[] | select(.category == "beauty" and .discountPercentage > 15) | "\(.discountPercentage)|\(.category)|\(.title)"' data/products.json \
    | sort -t '|' -k1,1nr > result/category-discounts.txt
cat > category-report.sh <<'EOF'
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
EOF
cat > full-catalog-report.sh <<'EOF'
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
EOF
chmod +x category-report.sh full-catalog-report.sh
./category-report.sh beauty > result/beauty-report.txt
./full-catalog-report.sh
test -f result/brands.txt
test -f result/availability.txt
test -f result/order-quantities.txt
test -f result/discounts.txt
test -f result/category-discounts.txt
test -f result/brand-statistics.txt
test -f result/tag-statistics.txt
test -f result/discount-report.txt
test -f result/order-report.txt

printf 'Completed practical exercises for lessons 3-29.\n'