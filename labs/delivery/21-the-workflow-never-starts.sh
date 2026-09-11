#!/usr/bin/env bash
# The delivery lab - CH04, Symptom: The Workflow Never Starts
#
# Label: Runnable
# --- command as printed, verbatim ---
gh workflow list
gh run list --limit 10
actionlint .github/workflows/ci.yml
