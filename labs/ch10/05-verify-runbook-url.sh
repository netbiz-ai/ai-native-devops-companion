#!/usr/bin/env bash
# Chapter 10, Step 5 - Write the runbook before routing - confirm the runbook URL placeholder is gone and retest the rules
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The search returns no matches.
#   The rule test returns SUCCESS.
# --- command as printed, verbatim ---
if rg -n 'RUNBOOK_URL_VERIFIED_BY_DEPLOYMENT' \
  observability/alerts/reference-app.yaml \
  observability/alerts/reference-app.test.yaml; then
  echo "runbook URL placeholder is still present" >&2
  exit 1
fi
promtool test rules observability/alerts/reference-app.test.yaml
