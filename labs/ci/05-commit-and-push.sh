#!/usr/bin/env bash
# The ci lab, Build It Step 4 - commit the workflow and push the branch to observe the gates
#
# Label: Runnable
# Destructive: pushes a commit to the origin remote on GitHub
#
# Expected result, per the chapter:
#   Quality and Source security start in parallel.
#   Image gate waits for both jobs.
#   Image gate builds, scans, starts, and probes the commit-specific image.
#   All three named checks pass for the tested revision.
# --- command as printed, verbatim ---
git diff --cached --check
git status --short
git commit -m "Add gated CI workflow"
git push -u origin HEAD
