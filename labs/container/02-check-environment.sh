#!/usr/bin/env bash
# The container lab, Prerequisites / Required publication environment - record tool versions and builder state
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The worktree contains only expected changes.
#   The client reaches the container engine.
#   Buildx reports a ready default BuildKit builder.
#   Trivy, the operating system, and the architecture are recorded.
# --- command as printed, verbatim ---
git status --short
docker version
docker buildx version
docker buildx inspect --bootstrap
trivy --version
uname -s
uname -m
