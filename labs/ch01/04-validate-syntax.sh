#!/usr/bin/env bash
# Chapter 1, Test and Validate / Validate syntax and the success path - syntax-check the release gate
#
# Label: Runnable
#
# Expected result, per the chapter:
#   No output and exit status 0 mean Bash parsed the file.
#   This does not prove correct release behavior.
# --- command as printed, verbatim ---
bash -n samples/release-gate.sh
