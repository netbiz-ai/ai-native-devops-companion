#!/usr/bin/env bash
# Chapter 12 validation.
#
# The chapter's claim is that a controlled failure was diagnosed and restored
# under human control, so what this checks is the restoration, not the fault.
# A lab that can break a service and cannot prove it put it back has taught
# the wrong half.
#
# Tiers, as in Chapter 10: assets, then the running environment. The cluster
# tier reports what it could not check rather than passing silently.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

namespace="${CH12_NAMESPACE:-reference-incident}"
evidence_dir="${CH12_EVIDENCE_DIR:-evidence/ch12}"

pass() { printf '  ok    %s\n' "$1"; }
skip() { printf '  skip  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1" >&2; exit 1; }

printf 'assets\n'
for path in \
  incidents/templates/facts-incident-record.md \
  incidents/templates/post-incident-review.md \
  deployment/gitops/overlays/incident/ch12-latency-fault.yaml; do
  [[ -s "$path" ]] || fail "missing: $path"
done
pass "incident templates and fault manifest present"

# The fault manifest and the application's ceiling are one contract in two
# files: a fault above the ceiling would refuse to start rather than degrade.
fault_ms="$(grep -A1 'CH12_INJECTED_LATENCY_MS' \
  deployment/gitops/overlays/incident/ch12-latency-fault.yaml \
  | grep -oE '"[0-9]+"' | tr -d '"' | head -1)"
ceiling="$(grep -oE 'MAX_INJECTED_LATENCY_MS = [0-9]+' reference-app/src/app.py \
  | grep -oE '[0-9]+')"
[[ -n "$fault_ms" && -n "$ceiling" ]] || fail "could not read the fault value or the application ceiling"
(( fault_ms <= ceiling )) || fail "fault ${fault_ms}ms exceeds the application ceiling ${ceiling}ms"
pass "fault ${fault_ms}ms is within the application ceiling ${ceiling}ms"

# The fault has to land inside a window, and both edges were established by
# getting one of them wrong. Above the readiness timeout, the probe fails, the
# rolling update never promotes the faulted pod, the old pods keep serving and
# no incident reaches anyone. Below the alert threshold, the service is
# slightly slow and nothing fires. Neither gives a reader an incident.
timeout_s="$(grep -A1 'readinessProbe/timeoutSeconds' \
  deployment/gitops/overlays/incident/kustomization.yaml \
  | grep -oE 'value: [0-9]+' | grep -oE '[0-9]+' | head -1)"
if [[ -n "$timeout_s" ]]; then
  (( fault_ms < timeout_s * 1000 )) \
    || fail "fault ${fault_ms}ms exceeds the ${timeout_s}s readiness timeout; the faulted pods would never become ready and the rollout would stall without degrading the service"
  pass "fault stays under the ${timeout_s}s readiness timeout, so the faulted pods serve"
else
  skip "readiness timeout not found in the incident overlay"
fi

# The threshold the reader's own Chapter 10 alert uses.
threshold_s="$(grep -oE 'p95_5m\{environment="staging"\} > [0-9.]+' \
  observability/alerts/reference-app.yaml | grep -oE '[0-9.]+$' | head -1)"
if [[ -n "$threshold_s" ]]; then
  threshold_ms="$(python3 -c "print(int(float('$threshold_s') * 1000))")"
  (( fault_ms > threshold_ms )) \
    || fail "fault ${fault_ms}ms does not exceed the ${threshold_ms}ms alert threshold, so ReferenceAppHighLatency would not fire"
  pass "fault exceeds the ${threshold_ms}ms alert threshold"
else
  skip "alert threshold not found"
fi

printf 'cluster\n'
if ! command -v kubectl >/dev/null 2>&1 || ! kubectl cluster-info >/dev/null 2>&1; then
  skip "no cluster in reach - restoration not observed"
  printf '\nchapter 12 validated (assets only)\n'
  exit 0
fi

if ! kubectl -n "$namespace" get deployment reference-app >/dev/null 2>&1; then
  skip "reference-app not deployed in ${namespace} - restoration not observed"
  printf '\nchapter 12 validated (assets only)\n'
  exit 0
fi

latency="$(kubectl -n "$namespace" get deployment reference-app \
  -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="CH12_INJECTED_LATENCY_MS")].value}')"
[[ -z "$latency" || "$latency" == "0" ]] \
  || fail "the fault is still applied (CH12_INJECTED_LATENCY_MS=${latency}); run scripts/ch12/restore.sh"
pass "no fault is applied"

ready="$(kubectl -n "$namespace" get deployment reference-app -o jsonpath='{.status.readyReplicas}')"
desired="$(kubectl -n "$namespace" get deployment reference-app -o jsonpath='{.spec.replicas}')"
[[ "${ready:-0}" == "$desired" ]] || fail "only ${ready:-0}/${desired} replicas ready"
pass "${ready}/${desired} replicas ready"

printf 'evidence\n'
if [[ -d "$evidence_dir" ]]; then
  phases=$(find "$evidence_dir" -name '*.txt' -print 2>/dev/null | wc -l)
  (( phases > 0 )) && pass "${phases} evidence file(s) under ${evidence_dir}" \
                   || skip "no evidence captured under ${evidence_dir}"
else
  skip "no evidence directory at ${evidence_dir}"
fi

printf '\nchapter 12 validated (assets and cluster)\n'
