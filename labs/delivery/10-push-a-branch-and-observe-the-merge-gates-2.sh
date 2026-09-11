#!/usr/bin/env bash
# The delivery lab - CH04, Step 4 - Push a Branch and Observe the Merge Gates
#
# Label: Runnable
# --- command as printed, verbatim ---
gh api 'repos/{owner}/{repo}/branches/main/protection/required_status_checks' \
  --jq '{strict: .strict, checks: .checks}'
