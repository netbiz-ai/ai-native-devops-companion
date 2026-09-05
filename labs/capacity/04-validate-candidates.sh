#!/usr/bin/env bash
# The capacity lab, Test and Validate - validate both candidates against baseline and confirm restoration
#
# Label: Runnable
#
# Expected result, per the chapter:
#   CANDIDATE A: REVERT - dependency guardrail breached
#   CANDIDATE B: REVISE - repeatability rule not satisfied
#   FINAL STATE: PASS - accepted baseline restored
# --- command as printed, verbatim ---
labs/capacity/validate.sh \
  --baseline evidence/ch13/baseline.json \
  --candidate evidence/ch13/candidate-a.json \
  --cost-model evidence/ch13/cost-model.md
labs/capacity/validate.sh \
  --baseline evidence/ch13/baseline.json \
  --candidate evidence/ch13/candidate-b.json \
  --cost-model evidence/ch13/cost-model.md
labs/capacity/validate.sh --state baseline
