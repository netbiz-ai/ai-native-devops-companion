#!/usr/bin/env bash
# Chapter 8, Break It Deliberately - restore the reviewed declaration and wait for recovery
#
# Label: Runnable
# Destructive: re-applies the reviewed workload manifest to the reference-dev namespace
#
# --- command as printed, verbatim ---
mv /tmp/ch08-workload.yaml \
  deployment/kubernetes/base/workload.yaml

kubectl apply -f deployment/kubernetes/base/workload.yaml
kubectl rollout status \
  deployment/reference-app \
  --namespace reference-dev \
  --timeout 120s
