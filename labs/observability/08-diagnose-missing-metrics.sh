#!/usr/bin/env bash
# The observability lab, Troubleshooting - The metric query returns no data - inspect Collector logs and regenerate traffic
#
# Label: Runnable (unlabeled in the chapter)
# --- command as printed, verbatim ---
kubectl -n observability logs deploy/otel-collector --since=10m
./labs/observability/generate-traffic.sh http://127.0.0.1:8080/
