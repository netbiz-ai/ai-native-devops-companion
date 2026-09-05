#!/usr/bin/env bash
# The ci lab, Cost and Cleanup - remove the labeled lab container, image, and virtualenv session
#
# Label: Runnable
# --- command as printed, verbatim ---
if [ "$(docker inspect --format \
  '{{ index .Config.Labels "ai-native-devops.lab" }}' \
  reference-service-ch05 2>/dev/null)" = "ch05" ]; then
  docker rm -f reference-service-ch05
fi
docker image rm ai-native-devops/reference-service:chapter05 2>/dev/null || true
deactivate 2>/dev/null || true
