#!/usr/bin/env bash
# Chapter 4, Build It Step 3 - build the final image with the recorded base identity and assert the label contract
#
# Label: Runnable
#
# --- command as printed, verbatim ---
final_start=$(date +%s)
source_url=$(git config --get remote.origin.url || printf 'unknown')
test "$source_url" != unknown
docker build --no-cache \
  --build-arg PYTHON_BASE="$python_base" \
  --build-arg VCS_REF="$(git rev-parse --short HEAD)" \
  --build-arg SOURCE_URL="$source_url" \
  --tag ai-native-devops/reference-service:chapter04 .
final_seconds=$(($(date +%s) - final_start))
final_bytes=$(docker image inspect \
  ai-native-devops/reference-service:chapter04 \
  --format '{{.Size}}')
final_files=$(docker run --rm \
  --entrypoint sh \
  ai-native-devops/reference-service:chapter04 \
  -c 'find /app -type f | wc -l')
printf 'final_seconds=%s final_bytes=%s final_files=%s\n' \
  "$final_seconds" "$final_bytes" "$final_files"
label() {
  docker image inspect ai-native-devops/reference-service:chapter04 \
    --format "{{index .Config.Labels \"org.opencontainers.image.$1\"}}"
}
test "$(label title)" = reference-service
test "$(label revision)" = "$(git rev-parse --short HEAD)"
test "$(label source)" = "$source_url"
printf 'labels title=%s revision=%s source=%s\n' \
  "$(label title)" "$(label revision)" "$(label source)"
