#!/usr/bin/env bash
# The container lab - CH03, Symptom: The Container Exits With a Permission Error
#
# Label: Runnable
# --- command as printed, verbatim ---
docker run --rm --entrypoint sh \
  ai-native-devops/reference-app:chapter03 \
  -c 'id; ls -ld /app /app/src /tmp'
docker logs reference-app-ch03
