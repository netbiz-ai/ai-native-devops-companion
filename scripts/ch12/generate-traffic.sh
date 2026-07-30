#!/usr/bin/env bash
set -euo pipefail

target="${1:-http://127.0.0.1:8000}"
requests="${REQUESTS:-30}"

case "$requests" in
  ''|*[!0-9]*) echo "REQUESTS must be a positive integer" >&2; exit 2 ;;
esac

for ((i = 1; i <= requests; i++)); do
  curl --silent --show-error --output /dev/null \
    --write-out '%{http_code}\n' "${target}/ready"
done
