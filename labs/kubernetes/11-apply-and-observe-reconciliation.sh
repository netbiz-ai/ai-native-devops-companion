#!/usr/bin/env bash
# The kubernetes lab - CH06, Step 4 - Apply and Observe Reconciliation
#
# Label: Runnable
# --- command as printed, verbatim ---
(
kubectl config current-context
declared_owner=$(sed -n \
  's/.*ai-native-devops.dev\/owner-token: //p' \
  deployment/kubernetes/base/namespace.yaml)
live_owner=$(kubectl get namespace reference-dev \
  -o jsonpath='{.metadata.annotations.ai-native-devops\.dev/owner-token}')
test -n "$declared_owner" && test "$live_owner" = "$declared_owner" || {
  echo 'STOP: reference-dev ownership cannot be proved' >&2
  exit 1
}
for resource in deployments.apps services \
  networkpolicies.networking.k8s.io; do
  test "$(kubectl auth can-i create "$resource" \
    --namespace reference-dev)" = yes || {
    echo "STOP: create permission denied for $resource" >&2
    exit 1
  }
done
)
