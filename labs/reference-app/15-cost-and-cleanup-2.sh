#!/usr/bin/env bash
# The reference-app lab - CH02, Cost and Cleanup
#
# Label: Runnable - removes generated caches under the two named directories
# --- command as printed, verbatim ---
find src tests -type d -name __pycache__ -print
find src tests -type d -name __pycache__ -prune -exec rm -r {} +
git status --short
