#!/usr/bin/env bash
# The delivery lab - CH04, Step 5 - Configure Ownership Before Release
#
# Label: Runnable
# --- command as printed, verbatim ---
gh pr checks --watch
gh pr merge --merge --delete-branch
git switch main
git pull --ff-only
git status --short
