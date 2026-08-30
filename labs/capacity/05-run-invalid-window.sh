#!/usr/bin/env bash
# Chapter 13, Break It Deliberately - run a short-window candidate so the validator rejects the comparison
#
# Label: Runnable
# Destructive: runs candidate-a against the reference-optimization namespace
#
# Expected result, per the chapter:
#   FAIL: experiment duration does not match the approved comparison window
#   RESULT: invalid comparison
# --- command as printed, verbatim ---
labs/capacity/run-experiment.sh \
  --candidate candidate-a \
  --duration test-short-window \
  --namespace reference-optimization \
  --output evidence/ch13/invalid-window.json
labs/capacity/validate.sh \
  --baseline evidence/ch13/baseline.json \
  --candidate evidence/ch13/invalid-window.json
