#!/usr/bin/env bash
# The delivery lab - CH04, Cost and Cleanup
#
# Label: Runnable
# --- command as printed, verbatim ---
gh repo view --json nameWithOwner,visibility
gh run list --limit 10
gh release list --limit 10
gh api 'repos/{owner}/{repo}/environments' --jq '.environments[].name'
