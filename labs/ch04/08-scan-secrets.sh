#!/usr/bin/env bash
# Chapter 4, Test and Validate - run Trivy secret scanners against image files and configuration
#
# Label: Runnable
#
# --- command as printed, verbatim ---
trivy image \
  --scanners secret \
  --image-config-scanners secret \
  ai-native-devops/reference-service:chapter04
