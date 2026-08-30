#!/usr/bin/env bash
# Chapter 4, Test and Validate - inspect the image user, command, and layer history
#
# Label: Runnable
#
# --- command as printed, verbatim ---
docker image inspect ai-native-devops/reference-service:chapter04 \
  --format 'user={{.Config.User}} cmd={{json .Config.Cmd}}'
docker history --no-trunc ai-native-devops/reference-service:chapter04
