#!/usr/bin/env bash
# The security lab - CH09, Cost and Cleanup
#
# Label: Runnable
# --- command as printed, verbatim ---
gh pr close ch09-secret-gate-test --delete-branch || true
git switch lab/security
git branch -D ch09-secret-gate-test 2>/dev/null || true
git branch -D ch09-safe-base 2>/dev/null || true
ruleset_file="$(git rev-parse --git-path ch09-security-ruleset.json)"
rm -f -- "$ruleset_file"
if git ls-remote --exit-code --heads origin ch09-secret-gate-test \
  >/dev/null 2>&1; then
  echo 'remote test branch still exists'
  false
fi
