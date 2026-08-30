#!/usr/bin/env bash
# Chapter 1, Test and Validate / Validate syntax and the success path - run the gate against a present artifact
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The script should report that the artifact exists.
#   The variable captures the script's status before another command can overwrite `$?`.
#   The final command confirms the expected success status.
# --- command as printed, verbatim ---
bash samples/release-gate.sh artifacts/release.tar
success_status=$?
test "$success_status" -eq 0
