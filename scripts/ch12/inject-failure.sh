#!/usr/bin/env bash
# Apply Chapter 12's controlled fault, and record what it replaced.
#
# The previous version of this script refused to do anything and printed
# "design-only". It now applies a real fault to a disposable namespace, and
# the safety that matters is not refusal - it is that the fault is bounded,
# reversible, and recorded before it is applied.
#
# What it records is the point. An incident you cannot restore exactly is a
# second incident, so the prior value of the environment variable is written
# to disk before the change lands, and restore.sh reads that file rather than
# assuming the baseline was zero.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

namespace="${CH12_NAMESPACE:-reference-incident}"
state_file="${CH12_STATE_FILE:-evidence/ch12/pre-fault-state.txt}"
patch_file="deployment/gitops/overlays/incident/ch12-latency-fault.yaml"

command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found" >&2; exit 1; }
kubectl -n "$namespace" get deployment reference-app >/dev/null 2>&1 || {
  echo "reference-app is not deployed in ${namespace}; run Step 1 first" >&2
  exit 1
}

# Refuse to stack a fault on a fault. Two overlapping causes is not a lab.
current="$(kubectl -n "$namespace" get deployment reference-app \
  -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="CH12_INJECTED_LATENCY_MS")].value}')"
if [[ -n "$current" && "$current" != "0" ]]; then
  echo "a fault is already applied (CH12_INJECTED_LATENCY_MS=${current})" >&2
  echo "restore before injecting again: scripts/ch12/restore.sh" >&2
  exit 1
fi

mkdir -p "$(dirname "$state_file")"
{
  printf 'namespace=%s\n' "$namespace"
  printf 'pre_fault_latency_ms=%s\n' "${current:-0}"
  printf 'image=%s\n' "$(kubectl -n "$namespace" get deployment reference-app \
    -o jsonpath='{.spec.template.spec.containers[0].image}')"
  printf 'observed_generation=%s\n' "$(kubectl -n "$namespace" get deployment \
    reference-app -o jsonpath='{.status.observedGeneration}')"
} > "$state_file"

kubectl -n "$namespace" patch deployment reference-app \
  --type strategic --patch-file "$patch_file" >/dev/null

applied="$(kubectl -n "$namespace" get deployment reference-app \
  -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="CH12_INJECTED_LATENCY_MS")].value}')"

printf 'fault=applied namespace=%s injected_latency_ms=%s state_recorded=%s\n' \
  "$namespace" "$applied" "$state_file"
printf 'Controlled fault applied to %s.\n' "$namespace"
