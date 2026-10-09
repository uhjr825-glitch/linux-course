#!/usr/bin/env bash
set -euo pipefail
case "${1:-}" in
    start) echo 'Start requested' ;;
    stop) echo 'Stop requested' ;;
    status) echo 'Status requested' ;;
    *) echo 'Unknown mode' ;;
esac
