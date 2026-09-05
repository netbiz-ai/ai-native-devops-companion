#!/usr/bin/env bash
# The capacity lab, Cost and Cleanup - restore the baseline, then delete the disposable namespace
#
# Label: Runnable
# Destructive: restores the application configuration and deletes the reference-optimization namespace
# --- command as printed, verbatim ---
labs/capacity/restore.sh --namespace reference-optimization
labs/capacity/validate.sh --state baseline
kubectl delete namespace reference-optimization
kubectl get namespace reference-optimization
