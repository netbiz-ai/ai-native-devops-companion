#!/usr/bin/env bash
# The kubernetes lab, Cost and Cleanup - prove ownership and inventory every namespaced resource before deletion
#
# Label: Runnable
#
# --- command as printed, verbatim ---
set -euo pipefail

expected_uid=$(cat evidence/ch08/namespace-uid.txt)
actual_uid=$(kubectl get namespace reference-dev \
  -o jsonpath='{.metadata.uid}')
owner_token=$(kubectl get namespace reference-dev \
  -o jsonpath='{.metadata.annotations.ai-native-devops\.dev/owner-token}')

test -n "$expected_uid" &&
  test "$actual_uid" = "$expected_uid" &&
  test -n "$owner_token" &&
  test "$owner_token" != "REPLACE_WITH_OWNER_TOKEN" || {
  echo "STOP: namespace ownership cannot be proved" >&2
  exit 1
}

inventory=evidence/ch08/namespace-inventory.txt
: > "$inventory"
while IFS= read -r resource; do
  kubectl get "$resource" \
    --namespace reference-dev \
    --ignore-not-found \
    --output=name >> "$inventory"
done < <(kubectl api-resources \
  --verbs=list \
  --namespaced=true \
  --output=name)

test -s "$inventory" || {
  echo "STOP: inventory is empty or incomplete" >&2
  exit 1
}
sed -n '1,240p' "$inventory"
