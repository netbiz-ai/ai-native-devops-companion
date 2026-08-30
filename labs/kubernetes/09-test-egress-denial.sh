#!/usr/bin/env bash
# Chapter 8, Build It Step 5 - prove the application Pod cannot open unapproved egress to the API Service
#
# Label: Runnable
#
# --- command as printed, verbatim ---
api_service_ip=$(kubectl get service kubernetes \
  --namespace default \
  --output jsonpath='{.spec.clusterIP}')

kubectl exec reference-client \
  --namespace reference-dev -- \
  python3 -c \
  'import socket, sys
with socket.create_connection((sys.argv[1], 443), 3):
    print("CONTROL_CONNECTION_SUCCEEDED")' \
  "$api_service_ip"

app_pod=$(kubectl get pods \
  --namespace reference-dev \
  --selector app.kubernetes.io/name=reference-app \
  --output jsonpath='{.items[0].metadata.name}')

set +e
egress_output=$(kubectl exec "$app_pod" \
  --namespace reference-dev \
  --stdin -- \
  python3 - "$api_service_ip" 443 \
  < deployment/kubernetes/tests/connect.py 2>&1)
egress_status=$?
set -e

if [ "$egress_status" -eq 42 ]; then
  echo "STOP: the application established unapproved egress" >&2
  exit 1
fi
if [ "$egress_status" -ne 0 ] ||
   ! printf '%s\n' "$egress_output" |
     grep -q '^EXPECTED_NETWORK_FAILURE:'; then
  printf '%s\n' "$egress_output" >&2
  echo "STOP: the egress test failed ambiguously" >&2
  exit 1
fi
echo "Application egress was denied as expected."
