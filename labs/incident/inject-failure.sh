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
  echo "restore before injecting again: labs/incident/restore.sh" >&2
  exit 1
fi

# The snapshot is written before the fault is applied, and the script stops
# here if it cannot be written: a fault whose baseline was never recorded is
# the thing restore.sh needs and cannot reconstruct. The usual cause is a
# working tree carrying root-owned directories from an earlier sudo or
# root-shell git pull, so say that rather than only naming the file.
# The stderr redirection comes first deliberately: a failing `>>` is reported
# by the shell before a later redirection takes effect, and a bare
# "Permission denied" ahead of the explanation is the thing being fixed.
if ! mkdir -p "$(dirname "$state_file")" 2>/dev/null ||
   ! { : 2>/dev/null >>"$state_file"; }; then
  echo "cannot write ${state_file}, so the fault was not applied" >&2
  echo "usually a root-owned working tree: chown -R \"\$(id -un)\" evidence" >&2
  exit 1
fi
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
