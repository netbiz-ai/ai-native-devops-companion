#!/usr/bin/env bash
# Chapter 8, Break It Deliberately - change only the readiness path and confirm the rollout stalls
#
# Label: Runnable
# Destructive: applies a deliberately broken workload manifest to the reference-dev namespace
#
# Expected result, per the chapter:
#   New Pods run but remain unready.
#   Old Ready Pods should remain, subject to capacity.
# --- command as printed, verbatim ---
cp deployment/kubernetes/base/workload.yaml \
  /tmp/ch08-workload.yaml

python3 - <<'PY'
from pathlib import Path

path = Path("deployment/kubernetes/base/workload.yaml")
text = path.read_text()
old = "path: /ready"
new = "path: /ready-missing"
if text.count(old) != 1:
    raise SystemExit("STOP: expected exactly one readiness path")
path.write_text(text.replace(old, new))
PY

kubectl apply -f deployment/kubernetes/base/workload.yaml
set +e
kubectl rollout status \
  deployment/reference-app \
  --namespace reference-dev \
  --timeout 40s
rollout_status=$?
set -e
test "$rollout_status" -ne 0
echo "Expected stalled rollout confirmed."
