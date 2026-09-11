#!/usr/bin/env bash
# The container lab - CH03, Test and Validate
#
# Label: Runnable
# --- command as printed, verbatim ---
label() {
  docker image inspect ai-native-devops/reference-app:chapter03 \
    --format "{{index .Config.Labels \"org.opencontainers.image.$1\"}}"
}
test "$(label title)" = reference-app
test "$(label revision)" = "$(git rev-parse --short HEAD)"
test "$(label source)" = "$source_url"
test "$(label base.name)" = "$python_base"
printf 'baseline_bytes=%s final_bytes=%s\n' "$baseline_bytes" "$final_bytes"
printf 'baseline_files=%s final_files=%s\n' "$baseline_files" "$final_files"
