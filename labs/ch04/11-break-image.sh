#!/usr/bin/env bash
# Chapter 4, Break It Deliberately - build a Dockerfile without the application copy and confirm the startup failure
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The image builds, but Python cannot import `src.app` because `/app/src` is absent.
# --- command as printed, verbatim ---
awk 'index($0, "COPY --from=builder --chown=10001:10001 /build/src ./src") == 0' \
  Dockerfile > Dockerfile.broken
docker build \
  --file Dockerfile.broken \
  --tag ai-native-devops/reference-service:broken .
if docker run --rm ai-native-devops/reference-service:broken; then
  printf 'unexpected success: investigate before continuing\n'
  exit 1
else
  printf 'expected failure: application module was not copied\n'
fi
