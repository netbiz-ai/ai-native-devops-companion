#!/usr/bin/env bash
# Chapter 5, Build It Step 3 - stage and statically review the CI workflow before pushing
#
# Label: Runnable
#
# Expected result, per the chapter:
#   No whitespace errors are reported.
#   actionlint reports no workflow syntax or expression error.
#   pull_request_target, secrets, and continue-on-error are absent.
#   Permissions are explicit.
#   Every uses reference contains a full 40-character commit SHA.
# --- command as printed, verbatim ---
git add requirements-dev.txt .github/workflows/ci.yml
git diff --cached --check
git diff --cached -- .github/workflows/ci.yml requirements-dev.txt
actionlint .github/workflows/ci.yml
rg -n 'pull_request_target|permissions:|secrets\.|continue-on-error|uses:' \
  .github/workflows/ci.yml
