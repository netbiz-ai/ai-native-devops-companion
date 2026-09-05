#!/usr/bin/env bash
# The container lab, Test and Validate - scan for HIGH and CRITICAL vulnerabilities under the learning policy
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The secret scan reports no detected secret.
#   The vulnerability command exits 0 when no HIGH or CRITICAL finding is reported.
#   It exits 1 when at least one policy-matching finding is reported.
# --- command as printed, verbatim ---
trivy image \
  --scanners vuln \
  --severity HIGH,CRITICAL \
  --exit-code 1 \
  ai-native-devops/reference-service:chapter04
