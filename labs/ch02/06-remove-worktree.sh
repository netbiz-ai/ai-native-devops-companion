#!/usr/bin/env bash
# Chapter 2, Break It Deliberately - inspect the change, then remove the disposable worktree and branch
#
# Label: Runnable
# --- command as printed, verbatim ---
git diff
cd ../devops-prompt-library
git worktree remove --force ../devops-prompt-library-safety-test
git branch -D experiment/remove-safety-boundary
git status --short
