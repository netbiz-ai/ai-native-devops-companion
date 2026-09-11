#!/usr/bin/env bash
# The kubernetes lab - CH06, Step 3 - Validate Before Changing the Cluster
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl kustomize deployment/kubernetes/base
kubectl apply --dry-run=client --validate=strict \
  -k deployment/kubernetes/base
kubectl apply --dry-run=server --validate=strict \
  -f deployment/kubernetes/base/namespace.yaml
