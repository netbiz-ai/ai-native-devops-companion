#!/usr/bin/env bash
# The reference-app lab - CH02, Step 5 - Stage the Working Deliverable
#
# Label: Runnable
# --- command as printed, verbatim ---
python3 -m compileall -q src tests
git add src/ tests/ .gitignore
git diff --cached --check
