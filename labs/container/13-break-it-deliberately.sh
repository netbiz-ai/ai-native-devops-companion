#!/usr/bin/env bash
# The container lab - CH03, Break It Deliberately
#
# Label: Runnable
# --- command as printed, verbatim ---
awk 'index($0, "/build/src") == 0' \
  Dockerfile > Dockerfile.broken
if grep -q '/build/src' Dockerfile.broken; then
  printf 'the source transfer was not removed: check the COPY line in Dockerfile\n'
else
  docker build \
    --platform "$base_platform" \
    --build-arg PYTHON_BASE="$python_base" \
    --file Dockerfile.broken \
    --tag ai-native-devops/reference-app:broken .
  timeout 30 docker run --rm ai-native-devops/reference-app:broken
  broken_status=$?
  if [ "$broken_status" -eq 0 ]; then
    printf 'unexpected success: investigate before continuing\n'
  elif [ "$broken_status" -eq 124 ]; then
    printf 'unexpected start: the container kept running, so source still reached it\n'
  else
    printf 'expected failure: application source was not copied\n'
  fi
fi
