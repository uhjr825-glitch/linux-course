#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/data"
OUTPUT_DIR="$SCRIPT_DIR/output"
ARCHIVE_DIR="$SCRIPT_DIR/archive"
LOG_DIR="$SCRIPT_DIR/logs"
API_BASE="${GITHUB_API_BASE_URL:-https://api.github.com}"
REPOSITORY="${REPORT_REPOSITORY:-cli/cli}"
API_BASE="${API_BASE%/}"
LOG_FILE="$LOG_DIR/run.log"
STAGING_DIR=""

mkdir -p "$DATA_DIR" "$OUTPUT_DIR" "$ARCHIVE_DIR" "$LOG_DIR"

log() {
    printf '[%s] %s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$*" | tee -a "$LOG_FILE"
}

fail() {
    log "ERROR: $*"
    exit 1
}

cleanup() {
    if [[ -n "$STAGING_DIR" && -d "$STAGING_DIR" ]]; then
        rm -rf -- "$STAGING_DIR"
    fi
}
trap cleanup EXIT

command -v curl >/dev/null 2>&1 || fail "curl is not installed"
command -v jq >/dev/null 2>&1 || fail "jq is not installed"
command -v tar >/dev/null 2>&1 || fail "tar is not installed"

if [[ ! "$REPOSITORY" =~ ^[[:alnum:]._-]+/[[:alnum:]._-]+$ ]]; then
    fail "invalid repository name: $REPOSITORY"
fi

STAGING_DIR="$(mktemp -d "$SCRIPT_DIR/.github-report.XXXXXX")" || fail "cannot create staging directory"
REPOSITORY_JSON="$STAGING_DIR/repository.json"
ISSUES_JSON="$STAGING_DIR/issues.json"
TITLES_FILE="$STAGING_DIR/titles.txt"
LABELS_FILE="$STAGING_DIR/labels.txt"
REPORT_FILE="$STAGING_DIR/report.txt"
ARCHIVE_FILE="$STAGING_DIR/report.tar.gz"

log "Starting report for $REPOSITORY"
log "Downloading repository metadata"
if ! curl --fail --silent --show-error --location --retry 2 --connect-timeout 10 --max-time 60 \
    "$API_BASE/repos/$REPOSITORY" -o "$REPOSITORY_JSON"; then
    fail "could not download repository metadata"
fi
jq -e 'type == "object" and (.full_name | type == "string") and (.stargazers_count | type == "number")' \
    "$REPOSITORY_JSON" >/dev/null || fail "repository response is not valid GitHub repository JSON"

log "Downloading the first 30 open issues (GitHub also includes pull requests in this endpoint)"
if ! curl --fail --silent --show-error --location --retry 2 --connect-timeout 10 --max-time 60 \
    "$API_BASE/repos/$REPOSITORY/issues?state=open&per_page=30" -o "$ISSUES_JSON"; then
    fail "could not download open issues"
fi
jq -e 'type == "array"' "$ISSUES_JSON" >/dev/null || fail "issues response is not a JSON array"

jq -r '.[] | select(has("pull_request") | not) | .title' "$ISSUES_JSON" > "$TITLES_FILE"
jq -r '.[] | select(has("pull_request") | not) | .labels[]?.name' "$ISSUES_JSON" \
    | sort | uniq -c | sort -nr > "$LABELS_FILE"

API_RECORD_COUNT="$(jq 'length' "$ISSUES_JSON")"
ISSUE_COUNT="$(jq '[.[] | select(has("pull_request") | not)] | length' "$ISSUES_JSON")"
TITLE_COUNT="$(wc -l < "$TITLES_FILE" | tr -d '[:space:]')"
BUG_TITLE_COUNT="$(grep -ic 'bug' "$TITLES_FILE" || true)"
REPOSITORY_NAME="$(jq -r '.name' "$REPOSITORY_JSON")"
FULL_NAME="$(jq -r '.full_name' "$REPOSITORY_JSON")"
OPEN_ISSUES="$(jq -r '.open_issues_count' "$REPOSITORY_JSON")"
STARS="$(jq -r '.stargazers_count' "$REPOSITORY_JSON")"
RUN_TIME="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

{
    printf 'GitHub open-issues report\n'
    printf '=========================\n\n'
    printf 'Repository: %s (%s)\n' "$REPOSITORY_NAME" "$FULL_NAME"
    printf 'Repository open issues (API metadata): %s\n' "$OPEN_ISSUES"
    printf 'Stars: %s\n' "$STARS"
    printf 'Generated: %s\n\n' "$RUN_TIME"
    printf 'API records fetched: %s\n' "$API_RECORD_COUNT"
    printf 'Issue records (pull requests excluded): %s\n' "$ISSUE_COUNT"
    printf 'Issue titles listed: %s\n' "$TITLE_COUNT"
    printf 'Titles containing "bug" (case-insensitive): %s\n\n' "$BUG_TITLE_COUNT"
    printf 'Issue titles\n-------------\n'
    if [[ -s "$TITLES_FILE" ]]; then
        cat "$TITLES_FILE"
    else
        printf 'No issues in this API page.\n'
    fi
    printf '\nLabel frequency\n----------------\n'
    if [[ -s "$LABELS_FILE" ]]; then
        cat "$LABELS_FILE"
    else
        printf 'No labels in this API page.\n'
    fi
} > "$REPORT_FILE"

[[ -s "$REPORT_FILE" ]] || fail "report was not created"
tar -czf "$ARCHIVE_FILE" -C "$STAGING_DIR" report.txt || fail "could not create report archive"
tar -tzf "$ARCHIVE_FILE" | grep -Fxq 'report.txt' || fail "report archive does not contain report.txt"

mv -f -- "$REPOSITORY_JSON" "$DATA_DIR/repository.json"
mv -f -- "$ISSUES_JSON" "$DATA_DIR/issues.json"
mv -f -- "$TITLES_FILE" "$OUTPUT_DIR/issue-titles.txt"
mv -f -- "$LABELS_FILE" "$OUTPUT_DIR/label-statistics.txt"
mv -f -- "$REPORT_FILE" "$OUTPUT_DIR/report.txt"
mv -f -- "$ARCHIVE_FILE" "$ARCHIVE_DIR/report.tar.gz"

[[ -s "$DATA_DIR/repository.json" ]] || fail "repository JSON is missing"
[[ -s "$DATA_DIR/issues.json" ]] || fail "issues JSON is missing"
[[ -s "$OUTPUT_DIR/report.txt" ]] || fail "report is missing"
[[ -s "$ARCHIVE_DIR/report.tar.gz" ]] || fail "archive is missing"

log "Saved $API_RECORD_COUNT API records and analyzed $ISSUE_COUNT issues"
log "Report: output/report.txt"
log "Archive: archive/report.tar.gz"
log "Run completed successfully"