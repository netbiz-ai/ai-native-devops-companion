#!/usr/bin/env bash
# The observability lab - CH08, Cost and Cleanup
#
# Label: Runnable, destructive within the disposable lab
# --- command as printed, verbatim ---
kubectl apply -k deployment/gitops/overlays/staging/
kubectl -n observability delete deployment/otel-collector \
  service/otel-collector configmap/otel-collector-config \
  --ignore-not-found
kubectl -n observability delete deployment/ch10-alert-sink \
  service/ch10-alert-sink configmap/ch10-alertmanager-config \
  --ignore-not-found
kubectl -n reference-staging rollout status deployment/reference-app --timeout=90s
kubectl -n observability get deployment,service
./labs/observability/validate.sh
