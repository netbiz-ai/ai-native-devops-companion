#!/usr/bin/env bash
# Chapter 2, Step 8 - Commit the baseline - stage, inspect, and commit the initial library state
#
# Label: Runnable
#
# Expected result, per the chapter:
#   [main or master <commit-id>] Add evaluated deployment debugging prompt
# --- command as printed, verbatim ---
git add README.md prompts evals docs
git diff --cached --check
git diff --cached
test -s docs/ADR-001-prompt-evaluation.md
git commit -m "Add evaluated deployment debugging prompt"
