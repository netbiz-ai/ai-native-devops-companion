#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

mode="${1:-design}"
manifest="docs/capstone/evidence-manifest.yaml"

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
    require_observed CAP-07-cleanup evidence/capstone/summary/cleanup.txt
    ;;
  all|final)
    # `final` is the acceptance run labs/ch16/04-run-verify-final.sh asks for,
    # after 03 has recorded cleanup evidence. It checks the same criteria as
    # `all` - which already includes the cleanup evidence - and says plainly
    # that every one of them is supported, so the reader has a single line to
    # point at rather than eight.
    "$0" identity
    "$0" delivery
    "$0" runtime
    "$0" reliability
    "$0" incident
    "$0" agent
    "$0" cost
    "$0" cleanup
    if [ "$mode" = "final" ]; then
      printf 'capstone_final=pass criteria=CAP-01..CAP-07 cleanup=recorded\n'
    fi
    ;;
  *)
    printf 'Usage: %s {design|identity|delivery|runtime|reliability|incident|agent|cost|cleanup|all|final}\n' "$0" >&2
    exit 2
    ;;
esac
