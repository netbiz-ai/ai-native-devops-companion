#!/usr/bin/env bash
# The container lab - CH03, Symptom: The Application Source Is Missing
#
# Label: Runnable
# --- command as printed, verbatim ---
docker run --rm --entrypoint sh \
  ai-native-devops/reference-app:chapter03 \
  -c 'find /app -maxdepth 3 -type f -print'
