#!/usr/bin/env bash
# The agent lab - CH12, Cost and Cleanup
#
# Label: Runnable, optional Tier 3:
#
# Expected result, per the chapter:
#   Error from server (NotFound): serviceaccounts "diagnostics-agent" not found
#   Error from server (NotFound): roles.rbac.authorization.k8s.io "diagnostics-agent-read" not found
#   Error from server (NotFound): rolebindings.rbac.authorization.k8s.io "diagnostics-agent-read" not found
# --- command as printed, verbatim ---
kubectl get serviceaccount diagnostics-agent -n reference-staging
kubectl get role,rolebinding diagnostics-agent-read -n reference-staging
