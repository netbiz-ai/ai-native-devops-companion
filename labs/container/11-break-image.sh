#!/usr/bin/env bash
# Chapter 4, Break It Deliberately - build a Dockerfile without the application copy and confirm the startup failure
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The image builds, but Python cannot import `src.app` because `/app/src` is absent.
#
# The chapter prints the awk filter, the build, and the run. The two guards
# around them are added here because a script has no reader watching it: the
# filter matches an exact line, and a `docker run` of an image that still has
# its source starts a server that never exits.
# --- command as printed, verbatim, between the guards ---
if ! grep -q '/build/src' Dockerfile; then
  printf 'this Dockerfile has no builder-to-runtime source transfer to remove\n'
  printf 'see README.md: write config/03-dockerfile-final.dockerfile to reference-app/Dockerfile first\n'
  exit 1
fi

awk 'index($0, "/build/src") == 0' \
  Dockerfile > Dockerfile.broken

if grep -q '/build/src' Dockerfile.broken; then
  printf 'the source transfer was not removed: check the COPY line in Dockerfile\n'
  exit 1
fi

docker build \
  --file Dockerfile.broken \
  --tag ai-native-devops/reference-service:broken .

timeout 30 docker run --rm ai-native-devops/reference-service:broken
broken_status=$?
if [ "$broken_status" -eq 0 ]; then
  printf 'unexpected success: investigate before continuing\n'
  exit 1
elif [ "$broken_status" -eq 124 ]; then
  printf 'unexpected start: the container kept running, so source still reached it\n'
  exit 1
else
  printf 'expected failure: application module was not copied\n'
fi
