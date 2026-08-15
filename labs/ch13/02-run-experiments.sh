#!/usr/bin/env bash
# Chapter 13, Step 3 - Compare two changes within one cost boundary - run both candidates with a baseline restore between them
#
# Label: Runnable
# Destructive: applies candidate scaling changes to and restores the reference-optimization namespace
# --- command as printed, verbatim ---
labs/ch13/run-experiment.sh \
  --candidate candidate-a \
  --namespace reference-optimization \
  --output evidence/ch13/candidate-a.json
labs/ch13/restore.sh --namespace reference-optimization
labs/ch13/validate.sh --state baseline
labs/ch13/run-experiment.sh \
  --candidate candidate-b \
  --namespace reference-optimization \
  --output evidence/ch13/candidate-b.json
