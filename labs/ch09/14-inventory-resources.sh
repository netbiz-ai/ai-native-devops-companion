#!/usr/bin/env bash
# Chapter 9, Cost and Cleanup - inventory application finalizers, namespaces, and external resources
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl -n argocd get application \
  reference-app-staging reference-app-production \
  -o custom-columns=NAME:.metadata.name,FINALIZERS:.metadata.finalizers
kubectl -n reference-staging get all,pvc
kubectl -n reference-production get all,pvc
kubectl get service --all-namespaces --field-selector spec.type=LoadBalancer
