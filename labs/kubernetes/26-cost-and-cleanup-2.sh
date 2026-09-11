#!/usr/bin/env bash
# The kubernetes lab - CH06, Cost and Cleanup
#
# Label: Runnable - destructive
# --- command as printed, verbatim ---
(
kubectl delete namespace reference-dev --wait=true

if kubectl get namespace reference-dev >/dev/null 2>&1; then
  echo 'STOP: reference-dev still exists' >&2
  exit 1
fi
echo 'Namespace cleanup confirmed.'
)
