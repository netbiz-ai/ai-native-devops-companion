#!/usr/bin/env bash
# The security lab, Break It Deliberately - remove the unsafe commit by resetting and force-pushing the disposable branch
#
# Label: Runnable
# Destructive: discards every change after ch11-safe-base and force-pushes rewritten history to origin
# --- command as printed, verbatim ---
test "$(git branch --show-current)" = "ch11-secret-gate-test"
test -z "$(git status --porcelain)"
git reset --hard ch11-safe-base
git push --force-with-lease origin \
  HEAD:ch11-secret-gate-test
git fetch origin ch11-secret-gate-test
test -z "$(git log --format='%H' \
  origin/ch11-secret-gate-test -- testdata/security/fake.env)"
