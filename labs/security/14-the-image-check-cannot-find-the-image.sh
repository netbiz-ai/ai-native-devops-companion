#!/usr/bin/env bash
# The security lab - CH09, Symptom: The Image Check Cannot Find the Image
#
# Label: Runnable
# --- command as printed, verbatim ---
run_id="$(gh run list --workflow security.yml \
  --branch "$(git branch --show-current)" --limit 1 \
  --json databaseId --jq '.[0].databaseId')"
image_job_id="$(gh run view "$run_id" --json jobs \
  --jq '.jobs[] | select(.name == "Image") | .databaseId')"
gh run view "$run_id" --job "$image_job_id" --log | grep -F 'reference-app:'
