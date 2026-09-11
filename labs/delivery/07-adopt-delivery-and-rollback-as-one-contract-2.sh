#!/usr/bin/env bash
# The delivery lab - CH04, Step 3 - Adopt Delivery and Rollback as One Contract
#
# Label: Runnable
# --- command as printed, verbatim ---
set -Eeuo pipefail
git checkout delivery-complete -- \
  .github/workflows/delivery.yml \
  .github/workflows/rollback.yml
actionlint \
  .github/workflows/ci.yml \
  .github/workflows/delivery.yml \
  .github/workflows/rollback.yml
git diff --check
rg -n 'permissions:|environment:|concurrency:|uses:|github\.sha' \
  .github/workflows/delivery.yml \
  .github/workflows/rollback.yml
