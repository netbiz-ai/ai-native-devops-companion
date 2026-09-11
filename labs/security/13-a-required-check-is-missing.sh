#!/usr/bin/env bash
# The security lab - CH09, Symptom: A Required Check Is Missing
#
# Label: Runnable
# --- command as printed, verbatim ---
grep -E '^    name:' .github/workflows/security.yml
gh pr checks
gh ruleset check --default
