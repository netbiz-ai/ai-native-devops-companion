#!/usr/bin/env bash
# The container lab, Test and Validate - run Trivy secret scanners against image files and configuration
#
# Label: Runnable
#
# --- command as printed, verbatim ---
trivy image \
  --scanners secret \
  --image-config-scanners secret \
  ai-native-devops/reference-service:chapter04
