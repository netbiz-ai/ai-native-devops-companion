#!/usr/bin/env bash
# Chapter 12, Step 7 - Verify recovery and complete the review - validate the three evidence files
#
# Label: Runnable
#
# Expected result, per the chapter:
#   PASS: controlled impact was detected
#   PASS: incident and deployment identities were recorded
#   PASS: recovery service checks meet the lab criteria
#   PASS: workload state is stable
#   PASS: evidence and decision records are complete
# --- command as printed, verbatim ---
labs/incident/validate.sh \
  --baseline evidence/ch12/baseline.txt \
  --incident evidence/ch12/incident.txt \
  --recovery evidence/ch12/recovery.txt
