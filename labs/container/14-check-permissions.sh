#!/usr/bin/env bash
# Chapter 4, Troubleshooting "The container exits with a permission error" - show identity and path ownership
#
# Label: Runnable (unlabeled in the chapter)
#
# --- command as printed, verbatim ---
docker run --rm --entrypoint sh \
  ai-native-devops/reference-service:chapter04 \
  -c 'id; ls -ld /app /tmp'
