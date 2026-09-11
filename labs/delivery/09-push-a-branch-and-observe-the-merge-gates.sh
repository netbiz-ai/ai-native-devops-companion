#!/usr/bin/env bash
# The delivery lab - CH04, Step 4 - Push a Branch and Observe the Merge Gates
#
# Label: Runnable
# --- command as printed, verbatim ---
set -Eeuo pipefail
git add \
  .github/workflows/ci.yml \
  .github/workflows/delivery.yml \
  .github/workflows/rollback.yml
git diff --cached --check
git diff --cached --stat
git commit -m "Add guarded CI and delivery workflows"
git push -u origin HEAD
gh pr create --fill --base main
gh pr checks --watch
