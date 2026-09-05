#!/usr/bin/env bash
# The container lab, Troubleshooting "The application package is missing" - list files under /app in the image
#
# Label: Runnable (unlabeled in the chapter)
#
# --- command as printed, verbatim ---
docker run --rm --entrypoint sh \
  ai-native-devops/reference-service:chapter04 \
  -c 'find /app -maxdepth 3 -type f -print'
