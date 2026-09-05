#!/usr/bin/env bash
# The kubernetes lab, Cost and Cleanup - delete the reference-dev Namespace after explicit confirmation
#
# Label: Runnable
# Destructive: deletes the reference-dev Namespace and every object it contains
#
# --- command as printed, verbatim ---
test "${CH08_DELETE_CONFIRMED:-}" = "reference-dev" || {
  echo "STOP: set CH08_DELETE_CONFIRMED=reference-dev after inventory review" >&2
  exit 1
}
kubectl delete namespace reference-dev --wait=true

if kubectl get namespace reference-dev >/dev/null 2>&1; then
  echo "STOP: namespace still exists" >&2
  exit 1
fi
echo "Namespace cleanup confirmed."
