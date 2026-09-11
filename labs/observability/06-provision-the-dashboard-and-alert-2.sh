#!/usr/bin/env bash
# The observability lab - CH08, Step 4 - Provision the Dashboard and Alert
#
# Label: Runnable
# --- command as printed, verbatim ---
curl --fail --silent "$PROMETHEUS_URL/api/v1/rules" | jq -e '
  [.data.groups[].rules[].name] as $names
  | ["job:http_requests:rate5m",
     "job:http_errors:ratio5m",
     "job:http_request_duration_seconds:p95_5m",
     "ReferenceAppHighLatency"]
  | all(. as $name | $names | index($name))'

dashboard_uid="$(curl --fail --silent \
  "$GRAFANA_URL/api/search?query=Reference%20App%20-%20Staging" | \
  jq -r 'map(select(.title == "Reference App - Staging"))[0].uid // empty')"
test -n "$dashboard_uid"
curl --fail --silent "$GRAFANA_URL/api/dashboards/uid/$dashboard_uid" | \
  jq -e '[.dashboard.panels[].targets[0].expr] == [
    "job:http_requests:rate5m{environment=\"staging\"}",
    "job:http_errors:ratio5m{environment=\"staging\"}",
    "job:http_request_duration_seconds:p95_5m{environment=\"staging\"}"
  ]'
