#!/usr/bin/env bash
# The observability lab - CH08, Symptom: The Metric Query Returns No Data
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl -n observability logs deployment/otel-collector --since=10m
for request_number in $(seq 1 20); do
  curl --fail --silent http://127.0.0.1:8080/ >/dev/null
done
rg -n 'http_server_request_duration_seconds' observability/recording-rules.yaml
