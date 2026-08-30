#!/usr/bin/env bash
set -euo pipefail

target="${1:-http://127.0.0.1:8080}"
requests="${REQUESTS:-20}"

case "$requests" in
  ''|*[!0-9]*) echo "REQUESTS must be a positive integer" >&2; exit 2 ;;
esac

for ((i = 1; i <= requests; i++)); do
  curl --fail --silent --show-error "${target}/health" >/dev/null
done

echo "generated ${requests} successful health requests against ${target}"
