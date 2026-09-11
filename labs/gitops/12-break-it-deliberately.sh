#!/usr/bin/env bash
# The gitops lab - CH07, Break It Deliberately
#
# Label: Runnable - changes only a temporary file
#
# Expected result, per the chapter:
#   EXPECTED FAILURE: production source path does not target production
# --- command as printed, verbatim ---
(
validate_production_route() {
  local route
  route="$(kubectl patch --local --type merge -p '{}' -f "$1" \
    -o 'jsonpath={.spec.source.path}{"\t"}{.spec.destination.namespace}')"
  test "$route" = $'deployment/gitops/overlays/production\treference-production'
}

validate_production_route \
  deployment/gitops/argocd/production-application.yaml

cp deployment/gitops/argocd/production-application.yaml \
  /tmp/production-application-broken.yaml

production_path='path: deployment/gitops/overlays/production'
staging_path='path: deployment/gitops/overlays/staging'
grep -Fq "$production_path" /tmp/production-application-broken.yaml

sed -i \
  's#deployment/gitops/overlays/production#deployment/gitops/overlays/staging#' \
  /tmp/production-application-broken.yaml

grep -Fq "$staging_path" /tmp/production-application-broken.yaml

if ! validate_production_route /tmp/production-application-broken.yaml; then
  echo 'EXPECTED FAILURE: production source path does not target production'
else
  echo 'UNEXPECTED PASS' >&2
  exit 1
fi
)
