#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

mode="${1:-design}"
manifest="${CAPSTONE_MANIFEST:-docs/capstone/evidence-manifest.yaml}"
cleanup_evidence="evidence/capstone/summary/cleanup.txt"
identity_evidence="evidence/capstone/delivery/identity.txt"

# The active run. Evidence is only evidence of the run it was observed for, so
# every check below is made against one declared identifier rather than against
# whatever files happen to be on disk. The reader exports CAPSTONE_RUN_ID in
# Step 1; with nothing exported the manifest's own run_id is the declaration.
manifest_run_id() {
  sed -n 's/^run_id:[[:space:]]*//p' "$manifest" | head -1
}

active_run="${CAPSTONE_RUN_ID:-$(manifest_run_id)}"

if [[ -z "$active_run" ]]; then
  printf 'run=undeclared manifest=%s - export CAPSTONE_RUN_ID or set run_id in the manifest\n' \
    "$manifest" >&2
  exit 1
fi

# A run identifier that the manifest does not share is a mixed claim: the index
# describes one run and the shell is asking about another.
require_manifest_agrees() {
  local declared
  declared="$(manifest_run_id)"
  if [[ "$declared" != "$active_run" ]]; then
    printf 'run=mixed active=%s manifest=%s evidence=%s\n' \
      "$active_run" "${declared:-none}" "$manifest" >&2
    return 1
  fi
}

# Both spellings are accepted because the evidence files are two formats: the
# criterion records are key=value, the cleanup record is a written report.
evidence_run_id() {
  sed -n -e 's/.*[^a-z_]run_id=\([^ ]*\).*/\1/p' -e 's/^run_id[=:][[:space:]]*//p' "$1" \
    | head -1
}

# An ISO 8601 UTC stamp sorts correctly as a string, so no date parsing is
# needed to order two observations.
evidence_observed_at() {
  sed -n -e 's/.*observed_at=\([^ ]*\).*/\1/p' -e 's/^run_at:[[:space:]]*//p' "$1" | head -1
}

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
  # Presence and completeness are not currency. A file retained from an earlier
  # acceptance run satisfies both and still says nothing about this one, which
  # is how a stale record reaches a PASS. Binding it to the declared run is what
  # makes the check answer the question actually being asked.
  local observed_run
  observed_run="$(evidence_run_id "$evidence")"
  if [[ -z "$observed_run" ]]; then
    printf '%s=unbound evidence=%s - no run_id recorded, cannot be tied to run %s\n' \
      "$criterion" "$evidence" "$active_run" >&2
    return 1
  fi
  if [[ "$observed_run" != "$active_run" ]]; then
    printf '%s=stale evidence=%s observed_for=%s active_run=%s\n' \
      "$criterion" "$evidence" "$observed_run" "$active_run" >&2
    return 1
  fi
  printf '%s=supported evidence=%s run_id=%s\n' "$criterion" "$evidence" "$active_run"
}

# The cleanup claim is the one claim whose whole meaning is temporal: it says
# the platform this run stood up is gone. A teardown recorded before this run's
# release identity was observed cannot be describing this run's teardown, and a
# teardown recorded against a different cluster is not describing this cluster.
require_cleanup_follows_identity() {
  local identity_at cleanup_at identity_cluster cleanup_context
  identity_at="$(evidence_observed_at "$identity_evidence")"
  cleanup_at="$(evidence_observed_at "$cleanup_evidence")"

  if [[ -z "$identity_at" || -z "$cleanup_at" ]]; then
    printf 'CAP-07-cleanup=unordered identity_at=%s cleanup_at=%s - both must record when they were observed\n' \
      "${identity_at:-none}" "${cleanup_at:-none}" >&2
    return 1
  fi
  if [[ "$cleanup_at" < "$identity_at" ]]; then
    printf 'CAP-07-cleanup=precedes-identity cleanup_at=%s identity_at=%s - a teardown observed before the release cannot be this run\n' \
      "$cleanup_at" "$identity_at" >&2
    return 1
  fi

  identity_cluster="$(sed -n 's/.*cluster=\([^ ]*\).*/\1/p' "$identity_evidence" | head -1)"
  cleanup_context="$(sed -n 's/^context:[[:space:]]*//p' "$cleanup_evidence" | head -1)"
  if [[ -n "$identity_cluster" && -n "$cleanup_context" && "$identity_cluster" != "$cleanup_context" ]]; then
    printf 'CAP-07-cleanup=different-cluster cleanup_context=%s identity_cluster=%s\n' \
      "$cleanup_context" "$identity_cluster" >&2
    return 1
  fi

  printf 'CAP-07-cleanup=same-run identity_at=%s cleanup_at=%s cluster=%s\n' \
    "$identity_at" "$cleanup_at" "${identity_cluster:-unrecorded}"
}

# A field from the manifest's release block, addressed by name.
manifest_release_field() {
  sed -n "/^release:/,/^[a-z]/{s/^[[:space:]]\{1,\}$1:[[:space:]]*//p}" "$manifest" | head -1
}

# A key=value field from an evidence record.
evidence_field() {
  sed -n "s/.*[^a-z_]$2=\([^ ]*\).*/\1/p;s/^$2=\([^ ]*\).*/\1/p" "$1" | head -1
}

compare_field() {
  local label="$1" left="$2" right="$3"
  if [[ -z "$left" || -z "$right" ]]; then
    printf 'CAP-01=incomplete %s: one side is unrecorded (%s vs %s)\n' \
      "$label" "${left:-none}" "${right:-none}" >&2
    return 1
  fi
  if [[ "$left" != "$right" ]]; then
    printf 'CAP-01=contradicted %s: %s != %s\n' "$label" "$left" "$right" >&2
    return 1
  fi
  printf '  %s=agree value=%s\n' "$label" "$left"
}

# CAP-01 claims one release identity holds across delivery and runtime. Reading
# each file and finding it non-empty cannot see a contradiction between two
# files, which is the failure this criterion exists to catch, so the fields are
# compared to each other.
#
# On the local lab route one tie cannot be made: Argo CD reconciles the cluster
# from a lab-local mirror, so the digest that delivery promoted is not the
# digest the workload runs. That is a boundary of the route, not a defect, and
# the manifest has to say so out loud - if the limitation is ever dropped from
# the manifest, this check fails rather than letting the claim quietly widen to
# something the evidence does not support.
verify_identity_chain() {
  local gates="evidence/capstone/delivery/gates.txt"
  local workload_digest promoted_digest
  local ok=0

  compare_field source_revision \
    "$(evidence_field "$gates" allowed_revision)" \
    "$(manifest_release_field source_revision)" || ok=1
  compare_field promoted_digest \
    "$(evidence_field "$gates" allowed_digest)" \
    "$(manifest_release_field image_digest)" || ok=1
  compare_field gitops_revision \
    "$(evidence_field "$identity_evidence" argocd_revision)" \
    "$(manifest_release_field gitops_revision)" || ok=1

  workload_digest="$(sed -n 's/.*workload_image=[^@]*@\([^ ]*\).*/\1/p' "$identity_evidence" | head -1)"
  compare_field declaration_matches_workload \
    "$(evidence_field "$identity_evidence" gitops_declared_digest)" \
    "$workload_digest" || ok=1

  [[ "$ok" -eq 0 ]] || return 1

  promoted_digest="$(evidence_field "$gates" allowed_digest)"
  if [[ "$promoted_digest" != "$workload_digest" ]]; then
    if ! grep -q 'does not extend to a registry-published delivery digest' "$manifest"; then
      printf 'CAP-01=overclaimed promoted_digest=%s workload_digest=%s - the manifest no longer declares the limit that makes this gap acceptable\n' \
        "$promoted_digest" "$workload_digest" >&2
      return 1
    fi
    printf '  promoted_to_workload=out-of-scope route=local-kind declared_limitation=yes\n'
  fi
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
    require_manifest_agrees
    require_observed CAP-01 "$identity_evidence"
    verify_identity_chain
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
    require_cleanup_follows_identity
    ;;
  all)
    verify_criteria
    # A cleanup record for some other run is not this run's pending teardown and
    # not this run's completed one, so `all` reports it as still outstanding
    # rather than checking it and failing the pre-cleanup summary.
    if [[ -s "$cleanup_evidence" ]] && \
       [[ "$(evidence_run_id "$cleanup_evidence")" == "$active_run" ]]; then
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
    require_manifest_agrees
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
    printf 'capstone_final=pass criteria=CAP-01..CAP-07 cleanup=recorded run_id=%s\n' "$active_run"
    ;;
  *)
    printf 'Usage: %s {design|identity|delivery|runtime|reliability|incident|agent|cost|cleanup|all|final}\n' "$0" >&2
    exit 2
    ;;
esac
