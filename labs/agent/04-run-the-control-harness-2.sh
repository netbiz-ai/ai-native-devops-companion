#!/usr/bin/env bash
# The agent lab - CH12, Step 6 - Run the Control Harness
#
# Label: Runnable:
#
# Expected result, per the chapter:
#   "action": "review-readiness-probe-configuration"
#   "target": "reference-staging/reference-app"
#   "executable": false
# --- command as printed, verbatim ---
python3 operations-agent/src/agent.py events
