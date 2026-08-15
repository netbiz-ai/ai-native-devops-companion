#!/usr/bin/env bash
# Chapter 9, Test and Validate - gather controller, scope, history, and runtime evidence
#
# Label: Runnable
# --- command as printed, verbatim ---
argocd app manifests reference-app-production \
  >/tmp/production-controller.yaml
argocd proj get reference-app
argocd app history reference-app-production
kubectl -n reference-production get deployment,service,pods
kubectl -n reference-production get endpointslices \
  -l kubernetes.io/service-name=reference-app
kubectl -n reference-production get networkpolicy
