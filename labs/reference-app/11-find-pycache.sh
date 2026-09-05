#!/usr/bin/env bash
# The reference-app lab, Cost and Cleanup - list project-local __pycache__ directories
#
# Label: Runnable
#
# --- command as printed, verbatim ---
find src tests -type d -name __pycache__ -print
