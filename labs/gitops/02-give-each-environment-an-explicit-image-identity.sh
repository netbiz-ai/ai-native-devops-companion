#!/usr/bin/env bash
# The gitops lab - CH07, Step 2 - Give Each Environment an Explicit Image Identity
#
# Label: Runnable
# --- command as printed, verbatim ---
: "${STAGING_DIGEST:?set STAGING_DIGEST to a verified sha256 digest}"
: "${PRODUCTION_DIGEST:?set PRODUCTION_DIGEST to the current production digest}"

kubectl kustomize deployment/gitops/overlays/staging \
  > /tmp/reference-staging.yaml
kubectl kustomize deployment/gitops/overlays/production \
  > /tmp/reference-production.yaml

for environment in staging production; do
  output="/tmp/reference-${environment}.yaml"
  expected_digest="$STAGING_DIGEST"
  if [ "$environment" = production ]; then
    expected_digest="$PRODUCTION_DIGEST"
  fi

  kubectl patch --local --type merge -p '{}' -f "$output" \
    -o 'jsonpath={.kind}{"\t"}{.metadata.name}{"\t"}{.metadata.namespace}{"\t"}{.spec.template.spec.containers[?(@.name=="app")].image}{"\n"}' \
    | awk -F '\t' -v target_namespace="reference-${environment}" \
        -v digest="$expected_digest" '
      $1 == "Deployment" && $2 == "reference-app" && $3 == target_namespace &&
        substr($4, length($4) - length(digest)) == "@" digest { matches++ }
      END { exit !(matches == 1) }
    '
done

echo 'PASS: each Deployment binds its app container to the expected digest'
