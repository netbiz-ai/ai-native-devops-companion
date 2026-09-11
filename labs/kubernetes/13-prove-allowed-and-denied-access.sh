#!/usr/bin/env bash
# The kubernetes lab - CH06, Step 5 - Prove Allowed and Denied Access
#
# Label: Runnable
# --- command as printed, verbatim ---
sed -n '1,240p' deployment/kubernetes/tests/client.yaml
kubectl apply --dry-run=server --validate=strict \
  --namespace reference-dev \
  -f deployment/kubernetes/tests/client.yaml
kubectl apply --namespace reference-dev \
  -f deployment/kubernetes/tests/client.yaml
kubectl wait pod/reference-client \
  --namespace reference-dev \
  --for=condition=Ready \
  --timeout=60s
