#!/usr/bin/env bash
# observability lab, Step 4 - Provision the dashboard and alert - check and unit-test the Prometheus alert rules
#
# Label: Runnable
#
# Expected result, per the chapter:
#   SUCCESS
#   SUCCESS
# --- command as printed, verbatim ---
promtool check rules observability/alerts/reference-app.yaml
promtool test rules observability/alerts/reference-app.test.yaml
