#!/usr/bin/env bash
# Chapter 4, Cost and Cleanup - remove the lab container, baseline and broken images, and temporary Dockerfiles
#
# Label: Runnable
#
# --- command as printed, verbatim ---
docker rm --force reference-service-ch04 2>/dev/null || true
docker image rm ai-native-devops/reference-service:baseline
docker image rm ai-native-devops/reference-service:broken
rm Dockerfile.baseline Dockerfile.broken
