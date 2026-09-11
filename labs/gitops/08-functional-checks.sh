#!/usr/bin/env bash
# The gitops lab - CH07, Functional Checks
#
# Label: Runnable
#
# Expected result, per the chapter:
#   PASS: exact objects, namespaces, container, and promoted digest match
# --- command as printed, verbatim ---
validate_inventory() {
  awk -F '\t' -v target_namespace="$2" -v digest="$3" '
    { kinds[$1]++ }
    $1 == "Namespace" && $2 == target_namespace && $3 == "" { namespace_object++ }
    $1 != "Namespace" && $3 != target_namespace { wrong_namespace++ }
    $1 == "Deployment" && $2 == "reference-app" && $3 == target_namespace &&
      substr($4, length($4) - length(digest)) == "@" digest { workload++ }
    END {
      ok = kinds["Namespace"] == 1 && kinds["Deployment"] == 1 &&
        kinds["Service"] == 1 && kinds["NetworkPolicy"] == 1 &&
        length(kinds) == 4 && namespace_object == 1 &&
        wrong_namespace == 0 && workload == 1
      exit !ok
    }
  ' "$1"
}

(
set -euo pipefail

for environment in staging production; do
  output="/tmp/reference-${environment}-final.yaml"
  inventory="/tmp/reference-${environment}-inventory.tsv"
  kubectl kustomize "deployment/gitops/overlays/${environment}" > "$output"
  kubectl patch --local --type merge -p '{}' -f "$output" \
    -o 'jsonpath={.kind}{"\t"}{.metadata.name}{"\t"}{.metadata.namespace}{"\t"}{.spec.template.spec.containers[?(@.name=="app")].image}{"\n"}' \
    > "$inventory"
  validate_inventory "$inventory" "reference-${environment}" \
    "$STAGING_DIGEST"
done

echo 'PASS: exact objects, namespaces, container, and promoted digest match'
)
