#!/usr/bin/env bash
# The container lab - CH03, Test and Validate
#
# Label: Runnable
# --- command as printed, verbatim ---
trivy image \
  --scanners secret \
  --image-config-scanners secret \
  ai-native-devops/reference-app:chapter03
