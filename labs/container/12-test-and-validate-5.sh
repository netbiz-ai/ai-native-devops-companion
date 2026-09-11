#!/usr/bin/env bash
# The container lab - CH03, Test and Validate
#
# Label: Runnable
# --- command as printed, verbatim ---
trivy image \
  --scanners vuln \
  --severity HIGH,CRITICAL \
  --ignore-unfixed \
  --exit-code 1 \
  ai-native-devops/reference-app:chapter03
