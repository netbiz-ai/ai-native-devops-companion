#!/usr/bin/env bash
# The observability lab - CH08, Step 3 - Configure and Inspect Telemetry Flow
#
# Label: Runnable
# --- command as printed, verbatim ---
otelcol-contrib validate --config=observability/collector.yaml
kubectl apply -f observability/collector-deployment.yaml
kubectl -n observability create configmap otel-collector-config \
  --from-file=collector.yaml=observability/collector.yaml \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl -n observability rollout restart deployment/otel-collector
kubectl -n observability rollout status deployment/otel-collector --timeout=90s
kubectl -n observability logs deployment/otel-collector --since=5m | \
  grep -E 'refused|failed|dropped' || true
./labs/observability/validate.sh
