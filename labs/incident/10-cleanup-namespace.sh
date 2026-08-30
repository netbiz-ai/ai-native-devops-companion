#!/usr/bin/env bash
# Chapter 12, Cost and Cleanup - restore, validate, then delete the disposable lab namespace
#
# Label: Runnable
# Destructive: deletes the reference-incident namespace from the cluster
#
# --- command as printed, verbatim ---
labs/incident/restore.sh
labs/incident/validate.sh \
  --baseline evidence/ch12/baseline.txt \
  --incident evidence/ch12/incident.txt \
  --recovery evidence/ch12/recovery.txt
kubectl delete namespace reference-incident
kubectl get namespace reference-incident
