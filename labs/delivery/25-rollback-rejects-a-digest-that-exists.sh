#!/usr/bin/env bash
# The delivery lab - CH04, Symptom: Rollback Rejects a Digest That Exists
#
# Label: Runnable
# --- command as printed, verbatim ---
gh release view ch04-bootstrap
gh run list --workflow .github/workflows/rollback.yml --limit 3
