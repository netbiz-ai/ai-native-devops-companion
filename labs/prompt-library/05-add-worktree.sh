#!/usr/bin/env bash
# The prompt-library lab, Break It Deliberately - create an isolated disposable worktree for the safety experiment
#
# Label: Runnable
# --- command as printed, verbatim ---
git worktree add ../devops-prompt-library-safety-test -b experiment/remove-safety-boundary HEAD
cd ../devops-prompt-library-safety-test
