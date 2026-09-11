#!/usr/bin/env bash
# The delivery lab - CH04, Step 6 - Dispatch and Review One Complete Release
#
# Label: Runnable
# --- command as printed, verbatim ---
set -Eeuo pipefail
select_new_run() {
  local workflow="$1" previous="$2" found=""
  for _ in $(seq 1 10); do
    found="$(gh run list \
      --workflow "$workflow" \
      --event workflow_dispatch \
      --limit 1 \
      --json databaseId \
      --jq '.[0].databaseId // empty')"
    [[ -n "$found" && "$found" != "$previous" ]] && break
    sleep 2
  done
  test -n "$found"
  test "$found" != "$previous"
  printf '%s\n' "$found"
}
run_id="$(select_new_run .github/workflows/delivery.yml "$previous_run_id")"
gh run watch "$run_id" --exit-status
gh run view "$run_id" --log
