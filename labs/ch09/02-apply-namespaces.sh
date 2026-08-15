#!/usr/bin/env bash
# Chapter 9, Build It, Step 1 - verify namespace owner tokens, dry-run, then create both owned namespaces
#
# Label: Runnable
# Destructive: creates the reference-staging and reference-production namespaces in the cluster
# --- command as printed, verbatim ---
for environment in staging production; do
  manifest="deployment/gitops/overlays/${environment}/namespace.yaml"
  namespace="reference-${environment}"
  expected="$(kubectl create --dry-run=client -f "$manifest" \
    -o jsonpath='{.metadata.annotations.ai-native-devops\.dev/owner-token}')"
  test -n "$expected" || exit 1
  if kubectl get namespace "$namespace" >/dev/null 2>&1; then
    actual="$(kubectl get namespace "$namespace" \
      -o jsonpath='{.metadata.annotations.ai-native-devops\.dev/owner-token}')"
    test "$actual" = "$expected" || {
      echo "Refusing namespace ownership collision: $namespace" >&2
      exit 1
    }
  fi
done
kubectl apply --dry-run=client --validate=strict \
  -f deployment/gitops/overlays/staging/namespace.yaml
kubectl apply --dry-run=client --validate=strict \
  -f deployment/gitops/overlays/production/namespace.yaml
kubectl apply -f deployment/gitops/overlays/staging/namespace.yaml
kubectl apply -f deployment/gitops/overlays/production/namespace.yaml
