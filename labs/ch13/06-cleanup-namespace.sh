#!/usr/bin/env bash
# Chapter 13, Cost and Cleanup - restore the baseline, then delete the disposable namespace
#
# Label: Runnable
# Destructive: restores the application configuration and deletes the reference-optimization namespace
# --- command as printed, verbatim ---
labs/ch13/restore.sh --namespace reference-optimization
labs/ch13/validate.sh --state baseline
kubectl delete namespace reference-optimization
kubectl get namespace reference-optimization
