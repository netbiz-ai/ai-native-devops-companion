#!/usr/bin/env bash
# The kubernetes lab - CH06, Symptom: The Service Has No Ready Endpoints
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl get pods \
  --namespace reference-dev \
  --show-labels
kubectl get service reference-app \
  --namespace reference-dev \
  -o yaml
kubectl get endpointslice \
  --namespace reference-dev \
  --selector kubernetes.io/service-name=reference-app \
  -o yaml
