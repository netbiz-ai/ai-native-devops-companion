#!/usr/bin/env bash
# The observability lab - CH08, Step 4 - Provision the Dashboard and Alert
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Checking observability/recording-rules.yaml
#     SUCCESS: ...
#   Checking observability/alerts/reference-app.yaml
#     SUCCESS: ...
#   Unit Testing: ...
#     SUCCESS
#   true
# --- command as printed, verbatim ---
promtool check rules observability/recording-rules.yaml
promtool check rules observability/alerts/reference-app.yaml
promtool test rules observability/alerts/reference-app.test.yaml
jq -e '.title and (.panels | length == 3)' observability/dashboard.json
