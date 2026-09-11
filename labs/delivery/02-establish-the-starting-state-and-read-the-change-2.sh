#!/usr/bin/env bash
# The delivery lab - CH04, Step 1 - Establish the Starting State and Read the Change
#
# Label: Runnable
# --- command as printed, verbatim ---
set -Eeuo pipefail
git branch --show-current
git status --short
test -f .github/workflows/ci.yml
test -f .github/workflows/delivery.yml
test -f .github/workflows/rollback.yml
docker version
docker buildx version
curl --version
jq --version
rg --version
actionlint --version
gh --version
gh auth status
gh repo view --json nameWithOwner,visibility
