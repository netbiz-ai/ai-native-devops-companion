#!/usr/bin/env bash
# The container lab - CH03, Step 1 - Control the Build Context
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The client reaches the container engine.
#   Buildx reports a ready builder.
#   Trivy is recorded.
# --- command as printed, verbatim ---
git status --short
docker version
docker buildx version
docker buildx inspect --bootstrap
trivy --version
