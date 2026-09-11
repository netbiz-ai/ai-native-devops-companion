#!/usr/bin/env bash
# The gitops lab - CH07, Step 6 - Run Optional Server-Side Preflight
#
# Label: Runnable
# --- command as printed, verbatim ---
preflight_inventory() {
  for object in application/reference-staging \
    application/reference-production appproject/ai-native-devops; do
    if kubectl -n argocd get "$object" \
      -o 'jsonpath={.kind}{"\t"}{.metadata.name}{"\t"}{.metadata.uid}' \
      2>/dev/null; then
      printf '\n'
    else
      printf '%s\tABSENT\n' "$object"
    fi
  done
}

preflight_inventory > /tmp/gitops-preflight-before.txt

kubectl apply --dry-run=server \
  -f deployment/gitops/argocd/project.yaml
kubectl apply --dry-run=server \
  -f deployment/gitops/argocd/staging-application.yaml
kubectl apply --dry-run=server \
  -f deployment/gitops/argocd/production-application.yaml

preflight_inventory > /tmp/gitops-preflight-after.txt
cmp /tmp/gitops-preflight-before.txt /tmp/gitops-preflight-after.txt
