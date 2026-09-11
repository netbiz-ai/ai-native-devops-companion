#!/usr/bin/env bash
# The delivery lab - CH04, Break It Deliberately
#
# Label: Runnable
# --- command as printed, verbatim ---
set -Eeuo pipefail
actionlint .github/workflows/ci.yml
git add .github/workflows/ci.yml
git diff --cached --check
git commit -m "Test CI refusal with an invalid health path"
git push -u origin HEAD
failure_pr_url="$(gh pr create \
  --fill \
  --base main \
  --head lab/delivery-refusal)"
if gh pr checks "$failure_pr_url" --watch; then
  printf 'Expected the image gate to refuse this commit.\n' >&2
  exit 1
else
  printf 'Expected refusal observed for %s\n' "$failure_pr_url"
fi
