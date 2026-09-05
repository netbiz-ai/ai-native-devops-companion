#!/usr/bin/env bash
# The gitops lab, Build It, Step 4 - stage and push the production digest promotion for review
#
# Label: Runnable
# --- command as printed, verbatim ---
git switch -c promote/reference-app
grep -F "digest: ${STAGING_DIGEST}" \
  deployment/gitops/overlays/production/kustomization.yaml
git diff -- deployment/gitops/overlays/production/kustomization.yaml
kubectl kustomize deployment/gitops/overlays/production \
  > /tmp/reference-production-candidate.yaml
kubectl apply --dry-run=server \
  -f /tmp/reference-production-candidate.yaml
git add deployment/gitops/overlays/production/kustomization.yaml \
  docs/promotions/reference-app-production.md
git diff --cached --check
git commit -m "Promote reference-app digest"
git push -u origin promote/reference-app
