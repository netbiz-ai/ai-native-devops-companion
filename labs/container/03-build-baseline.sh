#!/usr/bin/env bash
# Chapter 4, Build It Step 2 - build the baseline image and measure time, size, and file count
#
# Label: Runnable
#
# --- command as printed, verbatim ---
baseline_start=$(date +%s)
docker build --pull --no-cache \
  --file Dockerfile.baseline \
  --tag ai-native-devops/reference-service:baseline .
baseline_seconds=$(($(date +%s) - baseline_start))
baseline_bytes=$(docker image inspect \
  ai-native-devops/reference-service:baseline \
  --format '{{.Size}}')
baseline_files=$(docker run --rm \
  --entrypoint sh \
  ai-native-devops/reference-service:baseline \
  -c 'find /app -type f | wc -l')
printf 'baseline_seconds=%s baseline_bytes=%s baseline_files=%s\n' \
  "$baseline_seconds" "$baseline_bytes" "$baseline_files"
