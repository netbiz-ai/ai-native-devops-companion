#!/usr/bin/env bash
# The observability lab - CH08, Break It Deliberately
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl -n reference-staging set env deployment/reference-app \
  OTEL_EXPORTER_OTLP_ENDPOINT=http://127.0.0.1:4318
kubectl -n reference-staging rollout status deployment/reference-app --timeout=90s
./labs/observability/validate.sh
kubectl -n reference-staging logs deployment/reference-app --since=5m | \
  grep -E 'export|connect|refused|retry' || true
kubectl -n observability logs deployment/otel-collector --since=5m
