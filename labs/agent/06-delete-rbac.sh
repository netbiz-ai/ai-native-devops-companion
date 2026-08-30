#!/usr/bin/env bash
# Chapter 15, Cost and Cleanup - delete the chapter's RBAC objects and confirm they are gone
#
# Label: Runnable (unlabeled in the chapter)
# Destructive: deletes the diagnostics-agent ServiceAccount, Role, and RoleBinding from the reference-staging namespace
#
# Expected result, per the chapter:
#   Each `get` command should return `NotFound`.
# --- command as printed, verbatim ---
kubectl delete -f agents/k8s-diagnostics/rbac/diagnostics-reader.yml
kubectl get serviceaccount diagnostics-agent -n reference-staging
kubectl get role diagnostics-reader -n reference-staging
kubectl get rolebinding diagnostics-agent-reader -n reference-staging
