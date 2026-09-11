#!/usr/bin/env bash
# The capstone lab - CH13, Step 1 - Establish One Acceptance Run
#
# Label: Runnable:
# --- command as printed, verbatim ---
CAPSTONE_RUN_ID=some-other-run bash labs/capstone/capstone-verify.sh identity \
  || echo 'refused, as it should be'
