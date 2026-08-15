#!/usr/bin/env bash
# Chapter 6, Step 2 - Assemble the controlled delivery workflow - require exactly one successful run per protected check name from the expected source app
#
# Label: Partial
# Substitute before running: "$all_check_runs" must hold the fully traversed check-run JSON for the checked-out commit, and confirm "expected_app" from a valid run - it is repository policy, not a constant.
# --- command as printed, verbatim ---
expected_app="github-actions"
for name in "quality" "image" "SAST" "Secrets" "IaC"; do
  jq -e --arg name "$name" --arg app "$expected_app" \
    '([.[] | select(.name == $name)] | length) == 1 and
     ([.[] | select(
       .name == $name and .app.slug == $app and
       .status == "completed" and .conclusion == "success"
     )] | length) == 1' \
    <<<"$all_check_runs" >/dev/null
done
