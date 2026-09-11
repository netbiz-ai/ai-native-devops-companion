#!/usr/bin/env bash
# The gitops lab - CH07, Step 1 - Inspect the Declared Promotion Path
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Both overlays render without a Kustomize error.
#   Each row shows the kind, object name, namespace, and the image of the Deployment's `app` container.
# --- command as printed, verbatim ---
git status --short

sed -n '1,220p' deployment/gitops/argocd/project.yaml
sed -n '1,180p' deployment/gitops/argocd/staging-application.yaml
sed -n '1,180p' deployment/gitops/argocd/production-application.yaml

kubectl kustomize deployment/gitops/overlays/staging \
  > /tmp/reference-staging.yaml
kubectl kustomize deployment/gitops/overlays/production \
  > /tmp/reference-production.yaml

for environment in staging production; do
  kubectl patch --local --type merge -p '{}' \
    -f "/tmp/reference-${environment}.yaml" \
    -o 'jsonpath={.kind}{"\t"}{.metadata.name}{"\t"}{.metadata.namespace}{"\t"}{.spec.template.spec.containers[?(@.name=="app")].image}{"\n"}'
done
