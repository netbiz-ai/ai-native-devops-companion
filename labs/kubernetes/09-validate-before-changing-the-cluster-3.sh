#!/usr/bin/env bash
# The kubernetes lab - CH06, Step 3 - Validate Before Changing the Cluster
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl apply --dry-run=server --validate=strict \
  -k deployment/kubernetes/base
