#!/usr/bin/env bash
# Chapter 4, Cost and Cleanup - confirm removals and print the retained image ID
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The first two commands should report missing images.
#   The final command should print the retained local image ID.
# --- command as printed, verbatim ---
docker image inspect ai-native-devops/reference-service:baseline
docker image inspect ai-native-devops/reference-service:broken
docker image inspect ai-native-devops/reference-service:chapter04 \
  --format '{{.Id}}'
