#!/usr/bin/env bash
# The agent lab - CH12, Step 6 - Run the Control Harness
#
# Label: Runnable:
#
# Expected result, per the chapter:
#   "tool": "deployment-status"
#   "action": "review-deployment-readiness"
#   "executable": false
#   "requires_human_approval": true
#   "mutation_executed": false
# --- command as printed, verbatim ---
python3 operations-agent/src/agent.py deployment-status
