#!/usr/bin/env bash
# The kubernetes lab, Build It Step 5 - deploy the labeled test client and prove it reaches /ready through the Service
#
# Label: Runnable
# Destructive: creates the reference-client Pod in the reference-dev namespace
#
# Expected result, per the chapter:
#   {"status": "ready"}
#   The exact response is part of this lab's contract.
# --- command as printed, verbatim ---
if grep -En 'REPLACE_WITH|example\.invalid' \
  deployment/kubernetes/tests/client.yaml; then
  echo "STOP: replace the client image placeholder" >&2
  exit 1
fi

kubectl apply --dry-run=server \
  --validate=strict \
  --namespace reference-dev \
  -f deployment/kubernetes/tests/client.yaml
kubectl apply \
  --namespace reference-dev \
  -f deployment/kubernetes/tests/client.yaml
kubectl wait pod/reference-client \
  --namespace reference-dev \
  --for=condition=Ready \
  --timeout=60s
kubectl exec reference-client \
  --namespace reference-dev -- \
  python3 -c \
  'import urllib.request
body = urllib.request.urlopen("http://reference-app/ready", timeout=3).read().decode()
assert body == "{\"status\": \"ready\"}", body
print(body)'
