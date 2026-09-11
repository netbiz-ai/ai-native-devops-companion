#!/usr/bin/env bash
# The capstone lab - CH13, Step 1 - Establish One Acceptance Run
#
# Label: Runnable:
# --- command as printed, verbatim ---
cat docs/capstone/architecture.md
export CAPSTONE_RUN_ID="capstone-acceptance-001"
printf 'run_id=%s\n' "$CAPSTONE_RUN_ID"
