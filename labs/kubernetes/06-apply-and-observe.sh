#!/usr/bin/env bash
# Chapter 8, Build It Step 4 - apply policy then workload, watch the rollout, and inspect endpoints
#
# Label: Runnable
# Destructive: applies the NetworkPolicy, Deployment, and Service to the reference-dev namespace
#
# Expected result, per the chapter:
#   deployment "reference-app" successfully rolled out
#   Confirm two replicas, two `ready=true` addresses, and Python 3.
#   This also proves the configured registry path pulled the digest.
# --- command as printed, verbatim ---
set -euo pipefail

test "$(kubectl get namespace reference-dev \
  -o jsonpath='{.metadata.uid}')" = \
  "$(cat evidence/ch08/namespace-uid.txt)" || {
  echo "STOP: namespace ownership cannot be proved" >&2
  exit 1
}

kubectl apply \
  -f deployment/kubernetes/base/network-policy.yaml \
  -f deployment/kubernetes/base/workload.yaml \
  -f deployment/kubernetes/base/service.yaml
kubectl rollout status \
  deployment/reference-app \
  --namespace reference-dev \
  --timeout 120s

kubectl get deployment,pods \
  --namespace reference-dev \
  --selector app.kubernetes.io/name=reference-app \
  --output wide

kubectl get service reference-app \
  --namespace reference-dev \
  --output wide

kubectl get endpointslice \
  --namespace reference-dev \
  --selector kubernetes.io/service-name=reference-app \
  -o jsonpath='{range .items[*].endpoints[*]}{.addresses[0]}{" ready="}{.conditions.ready}{"\n"}{end}'

app_pod=$(kubectl get pods \
  --namespace reference-dev \
  --selector app.kubernetes.io/name=reference-app \
  -o jsonpath='{.items[0].metadata.name}')
kubectl exec "$app_pod" \
  --namespace reference-dev -- \
  python3 --version
