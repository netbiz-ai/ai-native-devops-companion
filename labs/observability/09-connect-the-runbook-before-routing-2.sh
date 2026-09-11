#!/usr/bin/env bash
# The observability lab - CH08, Step 5 - Connect the Runbook Before Routing
#
# Label: Runnable
# --- command as printed, verbatim ---
curl --fail --silent "$ALERTMANAGER_URL/api/v2/status" | \
  jq -e '.config.original | contains("ch10-alert-sink.observability.svc.cluster.local:9099")'
