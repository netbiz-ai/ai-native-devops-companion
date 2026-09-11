#!/usr/bin/env bash
# The capstone lab - CH13, Cost and Cleanup
#
# Label: Runnable:
# --- command as printed, verbatim ---
(
set -euo pipefail
for namespace in \
  reference-dev reference-staging reference-production reference-incident \
  observability lab-source capstone-iac; do
  found="$(kubectl get namespace "$namespace" --ignore-not-found -o name)"
  if [ -n "$found" ]; then
    printf 'FAILED namespace=%s still-present\n' "$namespace"
    exit 1
  fi
  printf 'verified-absent namespace=%s\n' "$namespace"
done

application_crd="$(kubectl get crd applications.argoproj.io \
  --ignore-not-found -o name)"
if [ -n "$application_crd" ]; then
  [ "$(kubectl auth can-i get applications.argoproj.io -n argocd)" = "yes" ]
  for application in reference-staging reference-production; do
    found="$(kubectl -n argocd get applications.argoproj.io "$application" \
      --ignore-not-found -o name)"
    if [ -n "$found" ]; then
      printf 'FAILED application=%s still-present\n' "$application"
      exit 1
    fi
    printf 'verified-absent application=%s\n' "$application"
  done
else
  printf 'verified-absent resource-type=applications.argoproj.io\n'
fi
)
