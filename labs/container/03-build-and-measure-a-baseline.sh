#!/usr/bin/env bash
# The container lab - CH03, Step 2 - Build and Measure a Baseline
#
# Label: Runnable
#
# Expected result, per the chapter:
#   baseline_seconds=<measured value> baseline_bytes=<measured value> baseline_files=<measured value>
# --- command as printed, verbatim ---
baseline_start=$(date +%s)
docker build --pull --no-cache \
  --file Dockerfile.baseline \
  --tag ai-native-devops/reference-app:baseline .
baseline_seconds=$(($(date +%s) - baseline_start))
baseline_bytes=$(docker image inspect \
  ai-native-devops/reference-app:baseline \
  --format '{{.Size}}')
baseline_files=$(docker run --rm \
  --entrypoint sh \
  ai-native-devops/reference-app:baseline \
  -c 'find /app -type f | wc -l')
printf 'baseline_seconds=%s baseline_bytes=%s baseline_files=%s\n' \
  "$baseline_seconds" "$baseline_bytes" "$baseline_files"
