#!/usr/bin/env bash
# The delivery lab - CH04, Break It Deliberately
#
# Label: Runnable
# --- command as printed, verbatim ---
git revert --no-edit HEAD
git push
gh pr checks "$failure_pr_url" --watch
