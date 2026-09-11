#!/usr/bin/env bash
# The observability lab - CH08, Test and Validate
#
# Label: Runnable, terminal two
# --- command as printed, verbatim ---
alert_state() {
  curl --fail --silent "$PROMETHEUS_URL/api/v1/rules?type=alert" | \
    jq -r '[.data.groups[].rules[]
      | select(.name == "ReferenceAppHighLatency")
      | .state][0] // "missing"'
}
test "$(alert_state)" = inactive
