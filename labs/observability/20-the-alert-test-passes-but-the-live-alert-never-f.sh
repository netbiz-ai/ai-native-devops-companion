#!/usr/bin/env bash
# The observability lab - CH08, Symptom: The Alert Test Passes but the Live Alert Never Fires
#
# Label: Runnable
# --- command as printed, verbatim ---
promtool test rules observability/alerts/reference-app.test.yaml
rg -n 'environment|for:|job:http_requests' observability/alerts/reference-app.yaml
