#!/usr/bin/env bash
# The delivery lab - CH04, Symptom: Production Does Not Wait for Another Person
#
# Label: Runnable
# --- command as printed, verbatim ---
gh run list --workflow .github/workflows/delivery.yml --limit 3
rg -n 'environment: production' .github/workflows/delivery.yml
