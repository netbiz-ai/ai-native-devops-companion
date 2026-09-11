#!/usr/bin/env bash
# The security lab - CH09, Step 5 - Require the Exact Names
#
# Label: Runnable
# --- command as printed, verbatim ---
ruleset_file="$(git rev-parse --git-path ch09-security-ruleset.json)"
repository="$(gh repo view --json nameWithOwner --jq '.nameWithOwner')"
default_branch="$(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')"
printf 'repository=%s\n' "$repository"
ruleset_response="$(gh api --method POST \
  "repos/${repository}/rulesets" \
  --input "$ruleset_file")"
printf '%s\n' "$ruleset_response" | jq -r '.id, .name, .enforcement'
gh ruleset check --default --repo "$repository"
test "$(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')" = "$default_branch"
