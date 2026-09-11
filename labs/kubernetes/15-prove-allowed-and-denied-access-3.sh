#!/usr/bin/env bash
# The kubernetes lab - CH06, Step 5 - Prove Allowed and Denied Access
#
# Label: Runnable
#
# Expected result, per the chapter:
#   EXPECTED_NETWORK_FAILURE: <service-address>:80: <refused, filtered, or timed out>
# --- command as printed, verbatim ---
(
kubectl label pod reference-client \
  --namespace reference-dev \
  app.kubernetes.io/name-

service_ip=$(kubectl get service reference-app \
  --namespace reference-dev \
  -o jsonpath='{.spec.clusterIP}')

denial_observed=0
for attempt in 1 2 3 4 5 6 7 8 9 10; do
  set +e
  kubectl exec reference-client \
    --namespace reference-dev \
    --stdin -- \
    python3 - "$service_ip" 80 \
    < deployment/kubernetes/tests/connect.py
  connect_status=$?
  set -e

  if [ "$connect_status" -eq 0 ]; then
    denial_observed=1
    break
  fi
  if [ "$connect_status" -ne 42 ]; then
    echo "STOP: unexpected test status $connect_status" >&2
    exit "$connect_status"
  fi
  sleep 3
done

test "$denial_observed" -eq 1 || {
  echo 'STOP: new connections were still allowed at the deadline' >&2
  exit 1
}
)
