#!/usr/bin/env bash
# The gitops lab - CH07, Step 4 - Separate Staging Automation From Production Execution
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Staging shows automated reconciliation.
#   Production passes the check because it has no automated block.
# --- command as printed, verbatim ---
(
grep -A8 -n 'syncPolicy:' \
  deployment/gitops/argocd/staging-application.yaml
grep -A8 -n 'syncPolicy:' \
  deployment/gitops/argocd/production-application.yaml

if grep -A8 'syncPolicy:' \
  deployment/gitops/argocd/production-application.yaml \
  | grep -q 'automated:'; then
  echo 'STOP: production automation needs explicit review' >&2
  exit 1
fi
)
