#!/usr/bin/env bash
# The gitops lab - CH07, Symptom: The Application Is Synced but Not Healthy
#
# Label: Runnable
# --- command as printed, verbatim ---
argocd app get reference-production --refresh
kubectl -n reference-production get deployment,pods,endpointslices
kubectl -n reference-production get events \
  --sort-by=.metadata.creationTimestamp
