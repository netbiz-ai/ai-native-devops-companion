#!/usr/bin/env bash
# The gitops lab - CH07, Step 5 - Prepare the Digest Promotion
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The diff changes the intended production digest and no unrelated scope.
#   The rendered production image contains the verified staging digest.
# --- command as printed, verbatim ---
git diff --check
git diff -- deployment/gitops/

kubectl kustomize deployment/gitops/overlays/production \
  > /tmp/reference-production-promoted.yaml
grep -F "@${STAGING_DIGEST}" /tmp/reference-production-promoted.yaml
