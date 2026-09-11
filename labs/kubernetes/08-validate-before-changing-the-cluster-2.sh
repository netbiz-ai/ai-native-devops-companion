#!/usr/bin/env bash
# The kubernetes lab - CH06, Step 3 - Validate Before Changing the Cluster
#
# Label: Runnable - creates a Namespace
# --- command as printed, verbatim ---
(
if kubectl get namespace reference-dev >/dev/null 2>&1; then
  echo 'STOP: reference-dev already exists; do not adopt or delete it' >&2
  exit 1
fi

set +e
kubectl diff -f deployment/kubernetes/base/namespace.yaml
namespace_diff_status=$?
set -e
test "$namespace_diff_status" -le 1 || exit "$namespace_diff_status"

# Stop here until a named reviewer approves this exact Namespace diff.
kubectl apply -f deployment/kubernetes/base/namespace.yaml
)
