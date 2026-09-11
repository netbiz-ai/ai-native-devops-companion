#!/usr/bin/env bash
# Restore the accepted state after Chapter 12's controlled fault.
#
# Restores to the value inject-failure.sh recorded, not to a value assumed
# here. If the baseline had been something other than zero, restoring to zero
# would be a second unreviewed change dressed up as a recovery.
#
# Prints what it did in a form that belongs in the incident record: what was
# restored, from what, by whom, and whether the service came back.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

namespace="${CH12_NAMESPACE:-reference-incident}"
state_file="${CH12_STATE_FILE:-evidence/ch12/pre-fault-state.txt}"
timeout="${CH12_ROLLOUT_TIMEOUT:-180s}"

command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found" >&2; exit 1; }

if [[ -f "$state_file" ]]; then
  baseline="$(awk -F= '$1=="pre_fault_latency_ms"{print $2}' "$state_file")"
  source_of_truth="$state_file"
else
  # Restoring without the record is worse than refusing, but refusing during
  # an incident is worse still. Say plainly which case this is.
  baseline=0
  source_of_truth="assumed (no state file at ${state_file})"
  echo "WARNING: no recorded pre-fault state; restoring to 0" >&2
fi

current="$(kubectl -n "$namespace" get deployment reference-app \
  -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="CH12_INJECTED_LATENCY_MS")].value}')"

kubectl -n "$namespace" set env deployment/reference-app \
  "CH12_INJECTED_LATENCY_MS=${baseline}" >/dev/null

kubectl -n "$namespace" rollout status deployment/reference-app --timeout="$timeout" >/dev/null

ready="$(kubectl -n "$namespace" get deployment reference-app \
  -o jsonpath='{.status.readyReplicas}')"
desired="$(kubectl -n "$namespace" get deployment reference-app \
  -o jsonpath='{.spec.replicas}')"

printf 'restore=complete namespace=%s from_latency_ms=%s to_latency_ms=%s source=%s\n' \
  "$namespace" "${current:-0}" "$baseline" "$source_of_truth"
printf 'ready_replicas=%s/%s operator=%s\n' \
  "${ready:-0}" "$desired" "${USER:-unknown}"

if [[ "${ready:-0}" != "$desired" ]]; then
  echo "FAIL: not all replicas are ready after restoration" >&2
  exit 1
fi
