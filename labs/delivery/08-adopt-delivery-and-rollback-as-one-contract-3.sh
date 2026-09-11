#!/usr/bin/env bash
# The delivery lab - CH04, Step 3 - Adopt Delivery and Rollback as One Contract
#
# Label: Runnable
# --- command as printed, verbatim ---
rg -n 'outputs:|digest:|DIGEST|imagetools inspect|docker pull|release-evidence|MARKER_TAG' \
  .github/workflows/delivery.yml \
  .github/workflows/rollback.yml
