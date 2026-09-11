#!/usr/bin/env bash
# The observability lab - CH08, Step 3 - Configure and Inspect Telemetry Flow
#
# Label: Runnable
# --- command as printed, verbatim ---
: "${PROMETHEUS_URL:?set the Prometheus-compatible API root}"
: "${GRAFANA_URL:?set the Grafana-compatible API root}"
: "${ALERTMANAGER_URL:?set the Alertmanager-compatible API root}"
curl --fail --silent "$PROMETHEUS_URL/-/ready"
curl --fail --silent "$GRAFANA_URL/api/health" | jq -e '.database == "ok"'
curl --fail --silent "$ALERTMANAGER_URL/-/ready"
