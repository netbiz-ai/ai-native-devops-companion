#!/usr/bin/env bash
# Chapter 9, Build It, Step 2 - server dry-run the bounded AppProject
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl apply --dry-run=server \
  -f deployment/gitops/argocd/project.yaml
