#!/usr/bin/env bash
# incident lab, Step 1 - Establish the healthy baseline - deploy and label the in-namespace traffic client
#
# Label: Runnable
# Destructive: applies and labels the reference-client Pod in the reference-incident namespace
#
# --- command as printed, verbatim ---
kubectl apply \
  --namespace reference-incident \
  -f deployment/kubernetes/tests/client.yaml
kubectl label pod reference-client \
  --namespace reference-incident \
  app.kubernetes.io/environment=incident
kubectl wait pod/reference-client \
  --namespace reference-incident \
  --for=condition=Ready \
  --timeout=60s
