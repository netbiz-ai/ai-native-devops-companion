#!/usr/bin/env bash
# The observability lab - CH08, Break It Deliberately
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl apply -k deployment/gitops/overlays/staging/
kubectl -n reference-staging rollout status deployment/reference-app --timeout=90s
./labs/observability/validate.sh
