#!/usr/bin/env bash
# The security lab - CH09, Cost and Cleanup
#
# Label: Runnable
# --- command as printed, verbatim ---
repository="$(gh repo view --json nameWithOwner --jq '.nameWithOwner')"
gh api "repos/${repository}/rulesets" \
  --jq '.[] | [.id, .name, .enforcement] | @tsv'
