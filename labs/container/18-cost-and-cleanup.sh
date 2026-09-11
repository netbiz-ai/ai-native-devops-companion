#!/usr/bin/env bash
# The container lab - CH03, Cost and Cleanup
#
# Label: Runnable
# --- command as printed, verbatim ---
docker rm --force reference-app-ch03 2>/dev/null || true
docker image rm ai-native-devops/reference-app:baseline
docker image rm ai-native-devops/reference-app:broken
rm -f Dockerfile.baseline Dockerfile.broken
git restore Dockerfile .dockerignore
