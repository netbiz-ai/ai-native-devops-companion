#!/usr/bin/env bash
# The capstone lab - CH13, Step 6 - Run the Pre-Cleanup Acceptance Gate
#
# Label: Runnable:
# --- command as printed, verbatim ---
(
set -Eeuo pipefail
published_result="$(bash labs/capstone/capstone-verify.sh all)"
identity="$(printf '%s\n' "$published_result" |
  sed -n 's/^release_identity=\([^ ]*\).*/\1/p')"

if [ "$identity" != consistent ]; then
  printf 'CAP-01=%s\n' "${identity:-unreported}"
  printf 'RESULT: NOT_READY\n'
  printf 'reason: the promoted digest is not tied to the running workload\n'
  exit 1
fi

printf '%s\n' "$published_result"
)
