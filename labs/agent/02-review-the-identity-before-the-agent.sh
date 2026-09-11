#!/usr/bin/env bash
# The agent lab - CH12, Step 2 - Review the Identity Before the Agent
#
# Label: Runnable, optional Tier 3:
#
# Expected result, per the chapter:
#   serviceaccount/diagnostics-agent created (server dry run)
#   role.rbac.authorization.k8s.io/diagnostics-agent-read created (server dry run)
#   rolebinding.rbac.authorization.k8s.io/diagnostics-agent-read created (server dry run)
# --- command as printed, verbatim ---
kubectl apply --dry-run=server -f operations-agent/policy/rbac.yaml
