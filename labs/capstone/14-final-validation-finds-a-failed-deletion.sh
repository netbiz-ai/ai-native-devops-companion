#!/usr/bin/env bash
# The capstone lab - CH13, Symptom: Final Validation Finds a Failed Deletion
#
# Label: Runnable:
# --- command as printed, verbatim ---
kubectl get namespaces
kubectl get events --all-namespaces --sort-by=.lastTimestamp
bash labs/capstone/capstone-verify.sh cleanup
