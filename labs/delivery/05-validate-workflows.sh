#!/usr/bin/env bash
# Chapter 6, Step 3 - Validate before dispatch - stage both workflow files and inspect them locally
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The diff has no whitespace errors.
#   actionlint reports no syntax or expression error.
#   Every job has only its required permissions.
#   Only the built-in GITHUB_TOKEN is referenced.
#   External actions use reviewed full commit pins.
# --- command as printed, verbatim ---
git add .github/workflows/delivery.yml .github/workflows/rollback.yml
git diff --cached --check
actionlint .github/workflows/delivery.yml .github/workflows/rollback.yml
printf '%s\n' 'token: ${{ secrets.GITHUB_TOKEN }}' | rg 'secrets\.' >/dev/null
rg -n 'permissions:|environment:|concurrency:|uses:|secrets\.' \
  .github/workflows/delivery.yml .github/workflows/rollback.yml
git diff --cached -- .github/workflows
