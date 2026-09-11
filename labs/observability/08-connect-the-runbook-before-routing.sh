#!/usr/bin/env bash
# The observability lab - CH08, Step 5 - Connect the Runbook Before Routing
#
# Label: Runnable
# --- command as printed, verbatim ---
sed -n '1,180p' observability/runbooks/high-latency.md
rg -n 'owner|runbook_url' observability/alerts/reference-app.yaml
promtool test rules observability/alerts/reference-app.test.yaml
kubectl apply -f observability/test-receiver.yaml
kubectl -n observability rollout status deployment/ch10-alert-sink --timeout=90s
kubectl -n observability get configmap/ch10-alertmanager-config \
  service/ch10-alert-sink
