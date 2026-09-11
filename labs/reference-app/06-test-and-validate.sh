#!/usr/bin/env bash
# The reference-app lab - CH02, Test and Validate
#
# Label: Runnable
# --- command as printed, verbatim ---
set -e
python3 -m unittest discover -v
python3 -m compileall -q src tests
git diff --cached --check
