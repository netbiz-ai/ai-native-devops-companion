#!/usr/bin/env bash
# The kubernetes lab - CH06, Break It Deliberately
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The new Pods run but remain unready.
#   The rollout does not complete within the timeout.
#   Previously ready Pods may remain available while the replacement stalls.
# --- command as printed, verbatim ---
kubectl patch deployment reference-app \
  --namespace reference-dev \
  --type=strategic \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"app","readinessProbe":{"httpGet":{"path":"/ready-missing","port":"http"}}}]}}}}'

set +e
kubectl rollout status deployment/reference-app \
  --namespace reference-dev \
  --timeout=40s
rollout_status=$?
set -e

test "$rollout_status" -ne 0
echo 'Expected stalled rollout confirmed.'
