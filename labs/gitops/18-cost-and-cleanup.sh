#!/usr/bin/env bash
# The gitops lab - CH07, Cost and Cleanup
#
# Label: Runnable
# --- command as printed, verbatim ---
rm -f /tmp/reference-staging.yaml \
  /tmp/reference-production.yaml \
  /tmp/reference-production-promoted.yaml \
  /tmp/reference-staging-final.yaml \
  /tmp/reference-production-final.yaml \
  /tmp/reference-staging-inventory.tsv \
  /tmp/reference-production-inventory.tsv \
  /tmp/gitops-preflight-before.txt \
  /tmp/gitops-preflight-after.txt
git status --short
