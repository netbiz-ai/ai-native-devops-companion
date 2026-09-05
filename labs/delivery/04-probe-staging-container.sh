#!/usr/bin/env bash
# delivery lab, Step 2 - Assemble the controlled delivery workflow - pull the candidate digest, start a runner-local staging container, and probe /health
#
# Label: Partial
# Substitute before running: set "$IMAGE" and "$DIGEST" to the candidate published by the build step.
# --- command as printed, verbatim ---
docker pull "$IMAGE@$DIGEST"
docker run -d --name reference-service-staging \
  -p 127.0.0.1:8080:8080 "$IMAGE@$DIGEST"
trap 'docker rm -f reference-service-staging >/dev/null 2>&1 || true' EXIT
curl --fail --silent --show-error \
  --retry 5 --retry-all-errors --max-time 5 \
  http://127.0.0.1:8080/health
