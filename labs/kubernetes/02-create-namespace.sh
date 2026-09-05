#!/usr/bin/env bash
# The kubernetes lab, Build It Step 1 - refuse an existing namespace, dry-run, diff, then apply namespace.yaml and record its UID
#
# Label: Runnable
# Destructive: creates the reference-dev Namespace on the target Kubernetes cluster
#
# --- command as printed, verbatim ---
if kubectl get namespace reference-dev >/dev/null 2>&1; then
  echo "STOP: reference-dev already exists; do not adopt or delete it" >&2
  exit 1
fi

if grep -En 'REPLACE_WITH|example\.invalid' \
  deployment/kubernetes/base/namespace.yaml; then
  echo "STOP: replace the namespace owner token" >&2
  exit 1
fi

kubectl apply --dry-run=client \
  --validate=strict \
  -f deployment/kubernetes/base/namespace.yaml
set +e
kubectl diff -f deployment/kubernetes/base/namespace.yaml
namespace_diff_status=$?
set -e
test "$namespace_diff_status" -le 1 || exit "$namespace_diff_status"

# Stop here until a named reviewer approves this exact Namespace diff.
kubectl apply -f deployment/kubernetes/base/namespace.yaml
kubectl get namespace reference-dev \
  -o jsonpath='{.metadata.uid}{"\n"}' \
  > evidence/ch08/namespace-uid.txt
