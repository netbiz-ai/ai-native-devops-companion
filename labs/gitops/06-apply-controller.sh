#!/usr/bin/env bash
# The gitops lab, Build It, Step 3 - create the AppProject and both Applications, then inspect them
#
# Label: Runnable
# Destructive: creates the AppProject and the staging and production Application resources in the argocd namespace
# --- command as printed, verbatim ---
git switch main
git pull --ff-only
kubectl apply -f deployment/gitops/argocd/project.yaml
kubectl apply --dry-run=server \
  -f deployment/gitops/argocd/staging-application.yaml
kubectl apply --dry-run=server \
  -f deployment/gitops/argocd/production-application.yaml
kubectl apply -f deployment/gitops/argocd/staging-application.yaml
kubectl apply -f deployment/gitops/argocd/production-application.yaml
argocd app manifests reference-app-staging >/tmp/staging-controller.yaml
argocd proj get reference-app
argocd app get reference-app-staging --refresh
argocd app get reference-app-production --refresh
