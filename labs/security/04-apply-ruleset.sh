#!/usr/bin/env bash
# Chapter 11, Step 4 - apply the security ruleset once and verify the effective rules
#
# Label: Runnable
# Destructive: creates an active ruleset on the GitHub repository via gh api POST, changing merge behavior
# --- command as printed, verbatim ---
repository="$(gh repo view --json nameWithOwner \
  --jq '.nameWithOwner')"
gh api --method POST "repos/${repository}/rulesets" \
  --input docs/security/security-ruleset.json \
  > evidence/security/applied-ruleset.json
gh ruleset check --default --repo "${repository}" \
  > evidence/security/effective-rules.txt
labs/security/verify-security-ruleset.sh \
  evidence/security/applied-ruleset.json \
  evidence/security/effective-rules.txt
