#!/usr/bin/env bash
# The capstone lab - CH13, Symptom: The Pre-Cleanup Gate Passes Cleanup You Never Ran
#
# Label: Runnable:
# --- command as printed, verbatim ---
bash labs/capstone/capstone-verify.sh all
head -4 evidence/capstone/summary/cleanup.txt
