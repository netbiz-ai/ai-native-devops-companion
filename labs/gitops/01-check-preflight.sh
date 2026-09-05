#!/usr/bin/env bash
# The gitops lab, Prerequisites - stop-or-proceed preflight for cluster, Argo CD, and repository access
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The working tree and client versions are recorded.
#   The current context is the authorized lab cluster.
#   The Application CRD exists.
#   Argo CD reports a successful repository connection.
#   The approved bootstrap identity can create Application resources.
# --- command as printed, verbatim ---
git status --short
kubectl version --client
kubectl config current-context
argocd version --client
argocd context
kubectl get crd applications.argoproj.io
argocd repo get https://git.example/platform/ai-native-devops.git
kubectl auth can-i create applications.argoproj.io \
  --namespace argocd
