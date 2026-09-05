#!/usr/bin/env bash
# agent lab, Step 1 - Create a least-privilege diagnostic identity - dry-run, apply the RBAC manifest, then verify effective permissions by impersonation
#
# Label: Runnable (unlabeled in the chapter)
# Destructive: creates the diagnostics-agent ServiceAccount, Role, and RoleBinding in the reference-staging namespace
#
# Expected result, per the chapter:
#   yes
#   no
#   no
#   no
# --- command as printed, verbatim ---
kubectl apply --dry-run=server \
  -f agents/k8s-diagnostics/rbac/diagnostics-reader.yml
kubectl apply -f agents/k8s-diagnostics/rbac/diagnostics-reader.yml
kubectl auth can-i get pods \
  --as=system:serviceaccount:reference-staging:diagnostics-agent \
  -n reference-staging
kubectl auth can-i get secrets \
  --as=system:serviceaccount:reference-staging:diagnostics-agent \
  -n reference-staging
kubectl auth can-i delete pods \
  --as=system:serviceaccount:reference-staging:diagnostics-agent \
  -n reference-staging
kubectl auth can-i get pods \
  --as=system:serviceaccount:reference-staging:diagnostics-agent \
  -n production
