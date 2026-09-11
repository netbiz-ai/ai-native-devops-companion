#!/usr/bin/env bash
# The delivery lab - CH04, Step 2 - Confirm the Reviewed CI Gate
#
# Label: Runnable
# --- command as printed, verbatim ---
set -Eeuo pipefail
command -v rg >/dev/null
! rg -n 'pull_request_target|continue-on-error|secrets\.' \
  .github/workflows/ci.yml
rg -n 'permissions:|needs:|uses:|github\.sha|/health' \
  .github/workflows/ci.yml
