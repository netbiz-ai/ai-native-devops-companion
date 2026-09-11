#!/usr/bin/env bash
# The container lab - CH03, Step 2 - Build and Measure a Baseline
#
# Label: Runnable
# --- command as printed, verbatim ---
trivy image \
  --scanners secret \
  --image-config-scanners secret \
  ai-native-devops/reference-app:baseline
