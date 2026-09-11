#!/usr/bin/env bash
# The delivery lab - CH04, Step 6 - Dispatch and Review One Complete Release
#
# Label: Runnable
# --- command as printed, verbatim ---
set -Eeuo pipefail
previous_run_id="$run_id"
gh workflow run .github/workflows/delivery.yml \
  --ref main \
  -f release_id=ch04-release-001 \
  -f bootstrap=false
run_id="$(select_new_run .github/workflows/delivery.yml "$previous_run_id")"
gh run watch "$run_id" --exit-status
gh run view "$run_id" --log
