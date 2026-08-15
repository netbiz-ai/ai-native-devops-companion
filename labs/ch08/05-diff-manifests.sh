#!/usr/bin/env bash
# Chapter 8, Build It Step 3 - run kubectl diff on the policy and workload manifests before approval
#
# Label: Runnable
#
# --- command as printed, verbatim ---
set +e
kubectl diff \
  -f deployment/kubernetes/base/network-policy.yaml \
  -f deployment/kubernetes/base/workload.yaml
diff_status=$?
set -e

if [ "$diff_status" -gt 1 ]; then
  echo "STOP: kubectl diff failed" >&2
  exit "$diff_status"
fi
echo "Diff completed with status $diff_status."
