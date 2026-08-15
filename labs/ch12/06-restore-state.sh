#!/usr/bin/env bash
# Chapter 12, Step 6 - Restore the accepted state - run the reviewed restoration and capture recovery evidence
#
# Label: Runnable
# Destructive: restores the accepted deployment state of reference-app in the reference-incident namespace
#
# --- command as printed, verbatim ---
labs/ch12/restore.sh
kubectl -n reference-incident rollout status \
  deployment/reference-app --timeout=180s
labs/ch12/generate-traffic.sh --duration 180
labs/ch12/capture-evidence.sh \
  --phase recovery \
  --output evidence/ch12/recovery.txt
