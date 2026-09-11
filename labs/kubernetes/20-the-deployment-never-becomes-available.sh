#!/usr/bin/env bash
# The kubernetes lab - CH06, Symptom: The Deployment Never Becomes Available
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl get pods \
  --namespace reference-dev \
  --selector app.kubernetes.io/name=reference-app
kubectl describe deployment reference-app \
  --namespace reference-dev
kubectl get events \
  --namespace reference-dev \
  --sort-by=.metadata.creationTimestamp
