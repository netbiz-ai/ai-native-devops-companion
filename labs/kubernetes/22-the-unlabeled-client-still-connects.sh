#!/usr/bin/env bash
# The kubernetes lab - CH06, Symptom: The Unlabeled Client Still Connects
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl get networkpolicy reference-app-default-deny \
  --namespace reference-dev \
  -o yaml
kubectl get pod reference-client \
  --namespace reference-dev \
  --show-labels
