#!/usr/bin/env bash
# Chapter 8, Break It Deliberately - inspect deployment state, events, and logs before restoring the file
#
# Label: Runnable
#
# --- command as printed, verbatim ---
kubectl get deployment,replicasets,pods \
  --namespace reference-dev \
  --selector app.kubernetes.io/name=reference-app

kubectl describe deployment reference-app \
  --namespace reference-dev

kubectl get events \
  --namespace reference-dev \
  --sort-by=.metadata.creationTimestamp

kubectl logs \
  --namespace reference-dev \
  --selector app.kubernetes.io/name=reference-app \
  --all-containers=true \
  --prefix=true \
  --tail=30
