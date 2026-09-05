#!/usr/bin/env bash
# The security lab, Break It Deliberately - commit the harmless secret fixture on a disposable branch and push it
#
# Label: Runnable
# Destructive: pushes the new ch11-secret-gate-test branch, carrying the fake credential, to the origin remote
# --- command as printed, verbatim ---
test -z "$(git status --porcelain)"
git switch -c ch11-secret-gate-test
git branch ch11-safe-base
mkdir -p testdata/security
git show \
  ch11-complete:testdata/security/gitleaks-fixture.txt \
  > testdata/security/fake.env
git add testdata/security/fake.env
git commit -m "test: verify secret gate"
git push -u origin ch11-secret-gate-test
