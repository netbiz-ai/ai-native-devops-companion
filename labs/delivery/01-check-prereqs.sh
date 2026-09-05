#!/usr/bin/env bash
# The delivery lab, Required environment - verify the ci lab files, local tooling, and GitHub CLI authentication
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The the ci lab files exist.
#   Docker is reachable.
#   Every local validator reports a version.
#   GitHub CLI is authenticated to the intended training repository.
#   The worktree contains only expected changes.
# --- command as printed, verbatim ---
git switch main
git pull --ff-only
test -f .github/workflows/ci.yml
test -f Dockerfile
test -f src/app.py
test -f tests/test_app.py
docker version
docker buildx version
curl --version
jq --version
rg --version
actionlint --version
gh auth status
gh repo view --json nameWithOwner,visibility
git status --short
