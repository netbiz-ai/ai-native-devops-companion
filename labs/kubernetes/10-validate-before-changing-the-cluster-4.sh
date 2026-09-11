#!/usr/bin/env bash
# The kubernetes lab - CH06, Step 3 - Validate Before Changing the Cluster
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The rendered objects contain the reviewed registry and sha256 digest.
#   The API server reports the Namespace first, then reports the exact rendered workload objects without persisting them.
#   The diff status is 0 or 1, and a named reviewer inspects every difference.
# --- command as printed, verbatim ---
(
set +e
kubectl diff -k deployment/kubernetes/base
diff_status=$?
set -e

if [ "$diff_status" -gt 1 ]; then
  echo "STOP: kubectl diff failed with status $diff_status" >&2
  exit "$diff_status"
fi
echo "Diff review required; status=$diff_status"
)
