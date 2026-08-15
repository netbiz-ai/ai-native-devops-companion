#!/usr/bin/env bash
# Chapter 9, Build It, Step 1 - render both overlays, check digests, and server dry-run the output
#
# Label: Runnable
# --- command as printed, verbatim ---
: "${STAGING_DIGEST:?set the verified staging digest}"
: "${PRODUCTION_DIGEST:?set the previous production digest}"
! grep -R -E 'REPLACE_ME|REPLACE_WITH' \
  deployment/gitops/overlays || exit 1
kubectl kustomize deployment/gitops/overlays/staging \
  > /tmp/reference-staging.yaml
kubectl kustomize deployment/gitops/overlays/production \
  > /tmp/reference-production.yaml
grep -F "registry.example.invalid/reference-app@${STAGING_DIGEST}" \
  /tmp/reference-staging.yaml || exit 1
grep -F "registry.example.invalid/reference-app@${PRODUCTION_DIGEST}" \
  /tmp/reference-production.yaml || exit 1
kubectl apply --dry-run=server -f /tmp/reference-staging.yaml
kubectl apply --dry-run=server -f /tmp/reference-production.yaml
