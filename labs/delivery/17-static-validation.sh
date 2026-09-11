#!/usr/bin/env bash
# The delivery lab - CH04, Static Validation
#
# Label: Runnable
# --- command as printed, verbatim ---
set -Eeuo pipefail
actionlint \
  .github/workflows/ci.yml \
  .github/workflows/delivery.yml \
  .github/workflows/rollback.yml
git diff --check
rg -n 'permissions:|needs:|environment:|concurrency:|uses:' \
  .github/workflows/ci.yml \
  .github/workflows/delivery.yml \
  .github/workflows/rollback.yml
