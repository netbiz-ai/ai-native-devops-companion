#!/usr/bin/env bash
# The security lab - CH09, Break It Deliberately
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Secrets       fail   ...
# --- command as printed, verbatim ---
test -z "$(git status --porcelain)"
git switch -c ch09-secret-gate-test
git branch ch09-safe-base
git show security-complete:testdata/security/gitleaks-fixture.txt \
  >testdata/security/gitleaks-fixture.txt
git add testdata/security/gitleaks-fixture.txt
git commit -m "test: verify secret gate"
git push -u origin ch09-secret-gate-test
default_branch="$(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')"
gh pr create \
  --base "$default_branch" \
  --head ch09-secret-gate-test \
  --title "Test secret gate with invented fixture" \
  --body "Do not merge. This pull request tests the secret gate."
gh pr checks --watch || true
