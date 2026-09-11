#!/usr/bin/env bash
# The gitops lab - CH07, Step 3 - Bound the Controller's Authority
#
# Label: Runnable
# --- command as printed, verbatim ---
(
grep -nE 'sourceRepos:|destinations:|ResourceWhitelist:|ResourceBlacklist:' \
  deployment/gitops/argocd/project.yaml
grep -nE 'repoURL:|path:|namespace:' \
  deployment/gitops/argocd/staging-application.yaml \
  deployment/gitops/argocd/production-application.yaml

for kind in Namespace Deployment Service NetworkPolicy; do
  grep -q "kind: ${kind}" /tmp/reference-staging.yaml || {
    echo "STOP: expected rendered kind missing: ${kind}" >&2
    exit 1
  }
done
)
