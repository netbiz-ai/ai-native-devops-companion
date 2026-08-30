#!/usr/bin/env bash
# Chapter 11, Prerequisites - preflight check for required files and tools
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The required files exist.
#   Tool versions are recorded.
#   GitHub authentication is valid for the intended repository.
# --- command as printed, verbatim ---
test -f reference-app/Dockerfile
test -f rules/semgrep.yml
git cat-file -e \
  ch11-complete:testdata/security/gitleaks-fixture.txt
test -x labs/security/verify-security-ruleset.sh
test -n "$(find . -maxdepth 3 -type f \
  \( -name '*.lock' -o -name 'go.sum' \) -print -quit)"
actionlint --version
docker --version
gh auth status
jq --version
