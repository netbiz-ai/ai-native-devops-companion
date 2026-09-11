#!/usr/bin/env bash
# The delivery lab - CH04, Symptom: Delivery Reports a Missing or Duplicate Protected Check
#
# Label: Runnable
# --- command as printed, verbatim ---
gh run list --commit "$(git rev-parse HEAD)" --limit 20
gh pr checks
