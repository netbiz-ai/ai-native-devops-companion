#!/usr/bin/env bash
# The security lab, Cost and Cleanup - delete the disposable test branch and local safety refs
#
# Label: Runnable
# Destructive: deletes the ch11-secret-gate-test branch on the origin remote and local test branches
# --- command as printed, verbatim ---
git switch lab/ch11
git push origin --delete ch11-secret-gate-test
git branch -D ch11-secret-gate-test
git branch -D ch11-safe-base
git ls-remote --exit-code --heads origin \
  ch11-secret-gate-test && exit 1 || true
