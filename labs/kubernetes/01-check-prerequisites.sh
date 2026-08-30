#!/usr/bin/env bash
# Chapter 8, Prerequisites - verify required tools, cluster access, and namespace permissions
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Every command exists, `kubectl version` reaches the server, and the authorization checks pass.
# --- command as printed, verbatim ---
set -euo pipefail

for tool in cat cp git grep kubectl mkdir mv python3 sed sleep; do
  command -v "$tool" >/dev/null || {
    echo "STOP: required command is missing: $tool" >&2
    exit 1
  }
done

git switch -c chapter-08-kubernetes
kubectl version
kubectl config current-context
mkdir -p deployment/kubernetes/base deployment/kubernetes/tests docs/decisions evidence/ch08

for rule in \
  "get namespaces" \
  "create namespaces" \
  "delete namespaces"; do
  set -- $rule
  test "$(kubectl auth can-i "$1" "$2")" = "yes" || {
    echo "STOP: missing cluster permission: $rule" >&2
    exit 1
  }
done
