#!/usr/bin/env bash
# The container lab - CH03, Cost and Cleanup
#
# Label: Runnable
# --- command as printed, verbatim ---
cleanup_ok=1
if docker image inspect ai-native-devops/reference-app:baseline >/dev/null 2>&1; then
  printf 'baseline still exists\n'
  cleanup_ok=0
fi
if docker image inspect ai-native-devops/reference-app:broken >/dev/null 2>&1; then
  printf 'broken image still exists\n'
  cleanup_ok=0
fi
if [ -n "$(git status --porcelain)" ]; then
  printf 'the checkout is not clean\n'
  cleanup_ok=0
fi
if [ "$cleanup_ok" -eq 1 ]; then
  docker image inspect ai-native-devops/reference-app:chapter03 \
    --format 'retained_id={{.Id}} size={{.Size}}'
fi
