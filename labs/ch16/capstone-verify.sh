#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

mode="${1:-design}"
manifest="${CAPSTONE_MANIFEST:-docs/capstone/evidence-manifest.yaml}"
cleanup_evidence="evidence/capstone/summary/cleanup.txt"

require_observed() {
  local criterion="$1"
  local evidence="$2"
  if [[ ! -s "$evidence" ]]; then
    printf '%s=missing evidence=%s\n' "$criterion" "$evidence" >&2
    return 1
  fi
  if grep -Eq 'REPLACE|pending|not[_ -]evaluated' "$evidence"; then
    printf '%s=not-supported evidence=%s\n' "$criterion" "$evidence" >&2
    return 1
  fi
  printf '%s=supported evidence=%s\n' "$criterion" "$evidence"
}

# The seven pre-cleanup criteria, in contract order. Cleanup is checked apart
# from them because before the cleanup step it is legitimately unrecorded,
# and `all` must be able to say so without failing.
verify_criteria() {
  "$0" identity
  "$0" delivery
  "$0" runtime
  "$0" reliability
  "$0" incident
  "$0" agent
  "$0" cost
}

criteria_summary() {
  printf 'release identity: consistent\n'
  printf 'delivery gates: pass\n'
  printf 'runtime state: reconciled\n'
  printf 'service targets: pass\n'
  printf 'incident recovery: pass\n'
  printf 'agent boundary tests: pass\n'
  printf 'cost guardrail: pass\n'
}

case "$mode" in
  design)
    ./scripts/validate-offline.sh
    grep -q 'CAP-01:' "$manifest"
    grep -q 'CAP-07:' "$manifest"
    printf 'capstone_design=pass live_acceptance=not_evaluated\n'
    ;;
  identity)
    require_observed CAP-01 evidence/capstone/delivery/identity.txt
    ;;
  delivery)
    require_observed CAP-02 evidence/capstone/delivery/gates.txt
    ;;
  runtime)
    require_observed CAP-03 evidence/capstone/runtime/reconciliation.txt
    ;;
  reliability)
    require_observed CAP-04 evidence/capstone/runtime/service-targets.txt
    ;;
  incident)
    require_observed CAP-05 evidence/capstone/incident/timeline.md
    ;;
  agent)
    require_observed CAP-06 evidence/capstone/ai/boundary-tests.txt
    ;;
  cost)
    require_observed CAP-07 evidence/capstone/summary/cost-control.txt
    ;;
  cleanup)
    # Presence is not completion: a run that recorded FAILED lines leaves a
    # non-empty file, and that must not read as a clean teardown.
    require_observed CAP-07-cleanup "$cleanup_evidence"
    if ! grep -q '^cleanup=complete$' "$cleanup_evidence"; then
      printf 'CAP-07-cleanup=not-complete evidence=%s\n' "$cleanup_evidence" >&2
      exit 1
    fi
    ;;
  all)
    verify_criteria
    if [[ -s "$cleanup_evidence" ]]; then
      "$0" cleanup
      printf 'RESULT: READY\n'
      criteria_summary
      printf 'cleanup: pass\n'
    else
      printf 'PRE-CLEANUP RESULT: READY\n'
      criteria_summary
      printf 'cleanup: pending\n'
    fi
    ;;
  final)
    verify_criteria
    "$0" cleanup
    if [[ ! -s "$manifest" ]] || grep -Eq 'REPLACE|pending' "$manifest"; then
      printf 'manifest=not-consistent manifest=%s\n' "$manifest" >&2
      exit 1
    fi
    printf 'CAPSTONE RESULT: PASS\n'
    printf 'CAP-01 through CAP-06: pass\n'
    printf 'cost guardrail: pass\n'
    printf 'cleanup: pass\n'
    printf 'sanitized manifest: consistent\n'
    printf 'capstone_final=pass criteria=CAP-01..CAP-07 cleanup=recorded\n'
    ;;
  *)
    printf 'Usage: %s {design|identity|delivery|runtime|reliability|incident|agent|cost|cleanup|all|final}\n' "$0" >&2
    exit 2
    ;;
esac
