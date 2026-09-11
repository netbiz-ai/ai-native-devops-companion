#!/usr/bin/env bash
# The security lab - CH09, Step 5 - Require the Exact Names
#
# Label: Runnable
#
# Expected result, per the chapter:
#     ok    parses as JSON
#     ok    enforcement is active
#     ok    targets branches
#     ok    requires 5 check(s): Dependencies, IaC, Image, SAST, Secrets
#     ok    checks must pass on the latest commit
#     ok    no bypass actors
#     ok    ruleset verified: .git/ch09-security-ruleset.json
# --- command as printed, verbatim ---
ruleset_file="$(git rev-parse --git-path ch09-security-ruleset.json)"
repository="$(gh repo view --json nameWithOwner --jq '.nameWithOwner')"
head_sha="$(gh pr view --json headRefOid --jq '.headRefOid')"
actions_app_id="$(gh api \
  "repos/${repository}/commits/${head_sha}/check-runs" \
  --jq '[.check_runs[] | select(.name == "SAST" or .name == "Dependencies" or .name == "Secrets" or .name == "IaC" or .name == "Image") | .app | select(.slug == "github-actions") | .id] | unique | if length == 1 then .[0] else empty end')"
test -n "$actions_app_id"
ruleset_tmp="$(mktemp)"
jq --argjson app_id "$actions_app_id" \
  '(.rules[] | select(.type == "required_status_checks") | .parameters.required_status_checks[]) += {integration_id: $app_id}' \
  "$ruleset_file" >"$ruleset_tmp"
mv "$ruleset_tmp" "$ruleset_file"
jq -e . "$ruleset_file" >/dev/null
labs/security/verify-security-ruleset.sh "$ruleset_file"
gh pr checks --watch
