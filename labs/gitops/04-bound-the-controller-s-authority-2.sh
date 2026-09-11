#!/usr/bin/env bash
# The gitops lab - CH07, Step 3 - Bound the Controller's Authority
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The project shows Namespace as an allowed cluster-scoped kind.
#   The destination entries name the two Application targets but do not constrain Namespace object names.
# --- command as printed, verbatim ---
grep -A4 -n 'clusterResourceWhitelist:' \
  deployment/gitops/argocd/project.yaml
grep -A6 -n 'destinations:' \
  deployment/gitops/argocd/project.yaml
