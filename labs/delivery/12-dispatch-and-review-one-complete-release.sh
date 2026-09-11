#!/usr/bin/env bash
# The delivery lab - CH04, Step 6 - Dispatch and Review One Complete Release
#
# Label: Runnable
# --- command as printed, verbatim ---
previous_run_id="$(gh run list \
  --workflow .github/workflows/delivery.yml \
  --event workflow_dispatch \
  --limit 1 \
  --json databaseId \
  --jq '.[0].databaseId // empty')"
gh workflow run .github/workflows/delivery.yml \
  --ref main \
  -f release_id=ch04-bootstrap \
  -f bootstrap=true
