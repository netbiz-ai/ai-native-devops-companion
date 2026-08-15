#!/usr/bin/env bash
# Chapter 13, Step 4 - Estimate cost and unit cost - build the dated cost model from the evidence files
#
# Label: Runnable
# --- command as printed, verbatim ---
labs/ch13/estimate-cost.sh \
  --baseline evidence/ch13/baseline.json \
  --candidate-a evidence/ch13/candidate-a.json \
  --candidate-b evidence/ch13/candidate-b.json \
  --output evidence/ch13/cost-model.md
