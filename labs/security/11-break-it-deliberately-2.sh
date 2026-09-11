#!/usr/bin/env bash
# The security lab - CH09, Break It Deliberately
#
# Label: Runnable
# --- command as printed, verbatim ---
test "$(git branch --show-current)" = "ch09-secret-gate-test"
test -z "$(git status --porcelain)"
git reset --hard ch09-safe-base
git push --force-with-lease origin HEAD:ch09-secret-gate-test
git fetch origin ch09-secret-gate-test
test -z "$(git log --format='%H' \
  origin/ch09-secret-gate-test -- testdata/security/gitleaks-fixture.txt)"
gh pr checks --watch
