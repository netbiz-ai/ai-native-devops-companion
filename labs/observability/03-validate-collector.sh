#!/usr/bin/env bash
# observability lab, Step 3 - Configure and inspect telemetry flow - validate the Collector config and inspect its rollout and logs
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The configuration validates.
#   The Collector rollout completes.
#   No unexplained refusal, export failure, or drop appears.
# --- command as printed, verbatim ---
otelcol-contrib validate --config=observability/collector.yaml
kubectl -n observability rollout status deploy/otel-collector
kubectl -n observability logs deploy/otel-collector --since=5m |
  grep -E 'refused|failed|dropped' || true
