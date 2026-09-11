#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

python3 -m json.tool "${repo_root}/observability/dashboard.json" >/dev/null

for required in \
  "${repo_root}/observability/collector.yaml" \
  "${repo_root}/observability/recording-rules.yaml" \
  "${repo_root}/observability/alerts/reference-app.yaml" \
  "${repo_root}/observability/runbooks/high-latency.md"; do
  test -s "$required"
done

echo "observability assets validated"
