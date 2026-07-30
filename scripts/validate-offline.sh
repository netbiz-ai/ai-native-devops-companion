#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

while IFS= read -r script; do
  bash -n "$script"
done < <(find scripts workspace -type f -name '*.sh' -print | sort)

python3 -m compileall -q \
  reference-app/src \
  operations-assistant/src \
  operations-agent/src \
  scripts/validate_repo.py

python3 -m unittest discover -s reference-app/tests -p 'test_*.py'
python3 -m unittest discover -s operations-assistant/tests -p 'test_*.py'
python3 -m unittest discover -s operations-agent/tests -p 'test_*.py'
python3 scripts/validate_repo.py

workspace/samples/release-gate.sh pass
if workspace/samples/release-gate.sh fail >/dev/null 2>&1; then
  printf 'FAIL: release gate failure path returned success\n' >&2
  exit 1
fi

printf 'offline_validation=pass\n'
printf 'live_cloud_cluster_delivery_cleanup=not_evaluated\n'
