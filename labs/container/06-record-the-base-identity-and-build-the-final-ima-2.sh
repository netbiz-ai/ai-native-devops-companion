#!/usr/bin/env bash
# The container lab - CH03, Step 3 - Record the Base Identity and Build the Final Image
#
# Label: Runnable
# --- command as printed, verbatim ---
final_start=$(date +%s)
source_url=https://github.com/netbiz-ai/ai-native-devops-companion
docker build --no-cache \
  --platform "$base_platform" \
  --build-arg PYTHON_BASE="$python_base" \
  --build-arg VCS_REF="$(git rev-parse --short HEAD)" \
  --build-arg SOURCE_URL="$source_url" \
  --tag ai-native-devops/reference-app:chapter03 .
final_seconds=$(($(date +%s) - final_start))
final_bytes=$(docker image inspect \
  ai-native-devops/reference-app:chapter03 \
  --format '{{.Size}}')
final_files=$(docker run --rm \
  --entrypoint sh \
  ai-native-devops/reference-app:chapter03 \
  -c 'find /app -type f | wc -l')
printf 'final_seconds=%s final_bytes=%s final_files=%s\n' \
  "$final_seconds" "$final_bytes" "$final_files"
