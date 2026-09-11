#!/usr/bin/env bash
# The observability lab - CH08, Step 2 - Review and Adopt the Instrumented Route
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Merge made by the 'ort' strategy.
#   ...
#   OK
#   namespace/reference-staging unchanged
#   deployment.apps/reference-app configured
#   deployment "reference-app" successfully rolled out
# --- command as printed, verbatim ---
git show observability-complete:reference-app/src/telemetry.py | sed -n '1,240p'
git merge --no-edit observability-complete
make test
git diff --check
kubectl apply -k deployment/gitops/overlays/staging/
kubectl -n reference-staging rollout status deployment/reference-app --timeout=90s
