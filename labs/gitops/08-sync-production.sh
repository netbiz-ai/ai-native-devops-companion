#!/usr/bin/env bash
# Chapter 9, Build It, Step 4 - pin the approved revision, sync production, and verify rollout and image
#
# Label: Runnable
# Destructive: synchronizes the production Application, changing the reference-production workload
#
# Expected result, per the chapter:
#   Argo CD reports the merged revision as Synced.
#   The application becomes Healthy.
#   The Deployment reports the approved digest.
# --- command as printed, verbatim ---
git switch main
git pull --ff-only
APPROVED_REVISION="$(git rev-parse HEAD)"
test "$(git ls-remote origin refs/heads/main | awk '{print $1}')" \
  = "$APPROVED_REVISION" || {
    echo "Remote main changed; review the new revision" >&2
    exit 1
  }
argocd app get reference-app-production --refresh
argocd app diff reference-app-production \
  --revision "$APPROVED_REVISION"
argocd app sync reference-app-production \
  --revision "$APPROVED_REVISION"
argocd app wait reference-app-production \
  --sync --health --timeout 300
argocd app history reference-app-production
kubectl -n reference-production rollout status \
  deployment/reference-app --timeout=300s
kubectl -n reference-production get deployment reference-app \
  -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
