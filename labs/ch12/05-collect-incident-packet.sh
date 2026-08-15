#!/usr/bin/env bash
# Chapter 12, Step 4 - Collect a bounded incident packet - capture incident-phase evidence and cluster state
#
# Label: Runnable
#
# --- command as printed, verbatim ---
labs/ch12/capture-evidence.sh \
  --phase incident \
  --output evidence/ch12/incident.txt

kubectl -n reference-incident get deployment,pods
kubectl -n reference-incident rollout history \
  deployment/reference-app
kubectl -n reference-incident get events \
  --sort-by=.metadata.creationTimestamp
