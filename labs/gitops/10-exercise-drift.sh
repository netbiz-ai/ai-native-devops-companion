#!/usr/bin/env bash
# Chapter 9, Break It Deliberately - inject replica drift in staging and watch self-heal restore it
#
# Label: Runnable
# Destructive: patches the staging Application sync policy and scales the staging Deployment
#
# Expected result, per the chapter:
#   The injected replica value is observed.
#   Staging self-healing restores the Git-declared replica count.
#   The application returns to Synced, and controller events explain the action.
# --- command as printed, verbatim ---
DECLARED_REPLICAS="$(awk '/^[[:space:]]*replicas:/ {print $2; exit}' \
  deployment/kubernetes/base/workload.yaml)"
test "$DECLARED_REPLICAS" -ge 1 || exit 1
DRIFT_REPLICAS=$((DECLARED_REPLICAS + 1))
kubectl -n argocd patch application reference-app-staging \
  --type merge \
  -p '{"spec":{"syncPolicy":{"automated":{"enabled":true,"prune":false,"selfHeal":false}}}}'
kubectl -n reference-staging scale deployment/reference-app \
  --replicas="$DRIFT_REPLICAS"
test "$(kubectl -n reference-staging get deployment reference-app \
  -o jsonpath='{.spec.replicas}')" = "$DRIFT_REPLICAS" || {
    kubectl -n argocd patch application reference-app-staging \
      --type merge \
      -p '{"spec":{"syncPolicy":{"automated":{"enabled":true,"prune":false,"selfHeal":true}}}}'
    exit 1
  }
argocd app get reference-app-staging --refresh
kubectl -n argocd patch application reference-app-staging \
  --type merge \
  -p '{"spec":{"syncPolicy":{"automated":{"enabled":true,"prune":false,"selfHeal":true}}}}'
for attempt in $(seq 1 60); do
  observed="$(kubectl -n reference-staging get deployment reference-app \
    -o jsonpath='{.spec.replicas}')"
  test "$observed" = "$DECLARED_REPLICAS" && break
  sleep 2
done
test "$observed" = "$DECLARED_REPLICAS" || exit 1
argocd app get reference-app-staging --refresh
kubectl -n argocd describe application reference-app-staging
