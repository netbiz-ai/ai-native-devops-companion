#!/usr/bin/env bash
# The security lab - CH09, Step 4 - Run the Hosted Checks
#
# Label: Runnable
#
# Expected result, per the chapter:
#   SAST          pass   ...
#   Dependencies  pass   ...
#   Secrets       pass   ...
#   IaC           pass   ...
#   Image         pass   ...
# --- command as printed, verbatim ---
git status --short
repository="$(gh repo view --json nameWithOwner --jq '.nameWithOwner')"
default_branch="$(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')"
printf 'repository=%s default_branch=%s\n' "$repository" "$default_branch"
gh api "repos/${repository}/actions/permissions" \
  --jq '{enabled, allowed_actions}'
gh api "repos/${repository}" \
  --jq '{visibility, security_and_analysis}'
git push -u origin lab/security
gh pr create \
  --base "$default_branch" \
  --head lab/security \
  --title "Add evidence-producing security checks" \
  --body "Applies the reviewed Chapter 9 gate policy."
gh pr checks --watch
