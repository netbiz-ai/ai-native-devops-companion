#!/usr/bin/env bash
# The delivery lab - CH04, Step 1 - Establish the Starting State and Read the Change
#
# Label: Runnable
# --- command as printed, verbatim ---
git diff delivery-start delivery-complete -- \
  .github/workflows/ci.yml \
  .github/workflows/delivery.yml \
  .github/workflows/rollback.yml
