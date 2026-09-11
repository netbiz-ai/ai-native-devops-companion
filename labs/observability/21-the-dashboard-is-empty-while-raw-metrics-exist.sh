#!/usr/bin/env bash
# The observability lab - CH08, Symptom: The Dashboard Is Empty While Raw Metrics Exist
#
# Label: Runnable
# --- command as printed, verbatim ---
jq -r '.panels[] | [.title, .targets[0].expr] | @tsv' observability/dashboard.json
rg -n '^      - record:' observability/recording-rules.yaml
