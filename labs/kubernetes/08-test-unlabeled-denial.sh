#!/usr/bin/env bash
# The kubernetes lab, Build It Step 5 - remove the client label and prove the unlabeled client is denied
#
# Label: Runnable
# Destructive: removes the app.kubernetes.io/name label from the reference-client Pod
#
# --- command as printed, verbatim ---
kubectl label pod reference-client \
  --namespace reference-dev \
  app.kubernetes.io/name-

service_ip=$(kubectl get service reference-app \
  --namespace reference-dev \
  -o jsonpath='{.spec.clusterIP}')

denial_observed=false
for attempt in 1 2 3 4 5; do
  set +e
  denied_output=$(kubectl exec reference-client \
    --namespace reference-dev \
    --stdin -- \
    python3 - "$service_ip" 80 \
    < deployment/kubernetes/tests/connect.py 2>&1)
  denied_status=$?
  set -e

  if [ "$denied_status" -eq 0 ] &&
     printf '%s\n' "$denied_output" |
       grep -q '^EXPECTED_NETWORK_FAILURE:'; then
    denial_observed=true
    break
  fi
  if [ "$denied_status" -ne 42 ]; then
    printf '%s\n' "$denied_output" >&2
    echo "STOP: the negative test failed ambiguously" >&2
    exit 1
  fi
  sleep 2
done
test "$denial_observed" = true || {
  echo "STOP: an unlabeled client still reached the application" >&2
  exit 1
}
echo "Unlabeled-client denial confirmed."
