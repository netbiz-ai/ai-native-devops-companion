#!/usr/bin/env bash
# Interlude, Step 3 - prove the cluster can pull the recorded digest
#
# Label: Runnable
# Destructive: runs and then deletes the digest-check Pod in the default
# namespace.
#
# Expected result, per the interlude:
#   pod/digest-check created
#   pod/digest-check condition met
#   pod "digest-check" deleted
# --- command as printed, verbatim ---
digest=$(grep -o 'sha256:[0-9a-f]\{64\}' \
  evidence/cluster/image-digest.txt | head -1)
test -n "$digest" || {
  echo "STOP: no digest was recorded in evidence/cluster/image-digest.txt" >&2
  exit 1
}

kubectl run digest-check --restart=Never \
  --image="localhost:5001/reference-app@${digest}"
kubectl wait --for=condition=Ready pod/digest-check --timeout=180s
kubectl delete pod digest-check --wait
