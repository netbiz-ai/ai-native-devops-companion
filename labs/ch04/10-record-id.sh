#!/usr/bin/env bash
# Chapter 4, Test and Validate - record the local immutable image ID
#
# Label: Runnable
#
# --- command as printed, verbatim ---
docker image inspect ai-native-devops/reference-service:chapter04 \
  --format '{{.Id}}'
