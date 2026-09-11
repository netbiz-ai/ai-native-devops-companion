#!/usr/bin/env bash
# The kubernetes lab - CH06, Symptom: Cleanup Would Delete an Unknown Namespace
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl apply -k deployment/kubernetes/base
kubectl rollout status deployment/reference-app \
  --namespace reference-dev \
  --timeout=120s
