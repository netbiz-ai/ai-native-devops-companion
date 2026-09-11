#!/usr/bin/env bash
# The delivery lab - CH04, Symptom: The Candidate Push Returns Permission Denied
#
# Label: Runnable
# --- command as printed, verbatim ---
rg -n 'packages:|GITHUB_TOKEN|ghcr.io' .github/workflows/delivery.yml
gh run list --workflow .github/workflows/delivery.yml --limit 3
