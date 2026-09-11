#!/usr/bin/env bash
# The delivery lab - CH04, Step 7 - Exercise the Audited Rollback Path
#
# Label: Runnable
# --- command as printed, verbatim ---
set -Eeuo pipefail
previous_rollback_run_id="$(gh run list \
  --workflow .github/workflows/rollback.yml \
  --event workflow_dispatch \
  --limit 1 \
  --json databaseId \
  --jq '.[0].databaseId // empty')"
gh workflow run .github/workflows/rollback.yml \
  --ref main \
  -f approved_version=ch04-bootstrap \
  -f approved_digest="$bootstrap_digest" \
  -f incident_id=training/ch04-rollback
rollback_run_id="$(select_new_run .github/workflows/rollback.yml "$previous_rollback_run_id")"
gh run watch "$rollback_run_id" --exit-status
gh run view "$rollback_run_id" --log
