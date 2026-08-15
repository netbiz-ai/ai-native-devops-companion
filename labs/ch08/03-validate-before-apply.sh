#!/usr/bin/env bash
# Chapter 8, Build It Step 3 - prove namespace ownership, check permissions, and server-dry-run the manifests
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The server reports each object without persisting it.
#   This checks schema and admission, not runtime or policy enforcement.
# --- command as printed, verbatim ---
expected_uid=$(cat evidence/ch08/namespace-uid.txt)
actual_uid=$(kubectl get namespace reference-dev \
  -o jsonpath='{.metadata.uid}')
test -n "$expected_uid" && test "$actual_uid" = "$expected_uid" || {
  echo "STOP: namespace ownership cannot be proved" >&2
  exit 1
}

for rule in \
  "create deployments.apps" "patch deployments.apps" "get deployments.apps" \
  "create services" "get services" \
  "create networkpolicies.networking.k8s.io" \
  "get networkpolicies.networking.k8s.io" \
  "create pods" "get pods" "list pods" "watch pods" "patch pods" "delete pods" \
  "create pods/exec" "get pods/log" \
  "get replicasets.apps" "list endpointslices.discovery.k8s.io" \
  "list events"; do
  set -- $rule
  test "$(kubectl auth can-i "$1" "$2" --namespace reference-dev)" = "yes" || {
    echo "STOP: missing namespace permission: $rule" >&2
    exit 1
  }
done

test "$(kubectl auth can-i get services --namespace default)" = "yes" || {
  echo "STOP: cannot read the API Service control endpoint" >&2
  exit 1
}

if grep -ERn 'REPLACE_WITH|example\.invalid' \
  deployment/kubernetes/base deployment/kubernetes/tests; then
  echo "STOP: replace every image placeholder" >&2
  exit 1
fi

kubectl apply --dry-run=server \
  --validate=strict \
  -f deployment/kubernetes/base/network-policy.yaml \
  -f deployment/kubernetes/base/workload.yaml
