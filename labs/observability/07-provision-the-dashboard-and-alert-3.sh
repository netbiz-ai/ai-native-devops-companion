#!/usr/bin/env bash
# The observability lab - CH08, Step 4 - Provision the Dashboard and Alert
#
# Label: Runnable
# --- command as printed, verbatim ---
jq -r '.panels[] | [.title, .targets[0].expr] | @tsv' \
  observability/dashboard.json
rg -n 'job:http_request_duration_seconds:p95_5m' \
  observability/recording-rules.yaml \
  observability/alerts/reference-app.yaml
