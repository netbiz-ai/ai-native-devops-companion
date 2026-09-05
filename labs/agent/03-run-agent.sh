#!/usr/bin/env bash
# agent lab, Step 6 - Run the diagnostic agent - create a venv, install dependencies, and run one diagnosis
#
# Label: Runnable (unlabeled in the chapter)
#
# Expected result, per the chapter:
#   STATUS: REVIEW_REQUIRED
#   TARGET: reference-staging/reference-app
#   OBSERVATIONS: 4
#   TOP HYPOTHESIS: Container exits after missing configuration
#   PROPOSED ACTION: rollout_restart
#   POLICY: REVIEW
#   AUDIT: evidence/INC-204.jsonl
# --- command as printed, verbatim ---
cd agents/k8s-diagnostics
python3 -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt
python agent.py diagnose \
  --incident INC-204 \
  --namespace reference-staging \
  --workload reference-app
