#!/usr/bin/env bash
# The gitops lab, Cost and Cleanup - non-cascading application deletion, then delete the owned namespaces
#
# Label: Runnable
# Destructive: deletes both Application resources and the reference-staging and reference-production namespaces
# --- command as printed, verbatim ---
argocd app delete reference-app-staging --cascade=false
argocd app delete reference-app-production --cascade=false
kubectl delete namespace reference-staging reference-production \
  --wait=true
kubectl -n argocd get applications
kubectl get namespace reference-staging reference-production
kubectl get pv
kubectl get service --all-namespaces --field-selector spec.type=LoadBalancer
