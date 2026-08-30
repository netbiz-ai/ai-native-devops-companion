#!/usr/bin/env bash
# Chapter 9, Cost and Cleanup - remove the AppProject once no application references it
#
# Label: Runnable
# Destructive: deletes the reference-app AppProject from the argocd namespace
# --- command as printed, verbatim ---
test -z "$(kubectl -n argocd get applications \
  -o jsonpath='{range .items[?(@.spec.project=="reference-app")]}{.metadata.name}{end}')" || {
    echo "AppProject is still referenced" >&2
    exit 1
  }
kubectl delete -f deployment/gitops/argocd/project.yaml
kubectl -n argocd get appproject reference-app
