#!/usr/bin/env bash
# Prove that capstone acceptance is bound to one acceptance run.
#
# The verifier used to check that each evidence file existed and looked
# finished. Both are true of a file left behind by an earlier run, so a
# retained cleanup record could carry `final` to PASS while describing a
# different cluster torn down on a different day. Every case below is a shape
# of that mistake, and each one must be refused.
#
# The fixture is a throwaway tree rather than the repository's own evidence:
# a test that edits real evidence to prove a point leaves the repository one
# interrupted run away from a false record.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
verifier="$repo_root/labs/capstone/capstone-verify.sh"

RUN="capstone-acceptance-001"
OTHER="capstone-acceptance-002"
IDENTITY_AT="2026-08-10T17:50:47Z"
CLEANUP_AT="2026-09-05T14:45:11Z"
CLUSTER="kind-lab"

fixture=""
cleanup_fixture() { [ -n "$fixture" ] && rm -rf "$fixture"; }
trap cleanup_fixture EXIT

failures=0
checks=0

# Build a complete, internally consistent acceptance run. Each case then
# damages exactly one thing, so a refusal names the damage and nothing else.
build_fixture() {
  fixture="$(mktemp -d)"
  mkdir -p "$fixture/labs/capstone" \
           "$fixture/docs/capstone" \
           "$fixture/evidence/capstone/delivery" \
           "$fixture/evidence/capstone/runtime" \
           "$fixture/evidence/capstone/incident" \
           "$fixture/evidence/capstone/ai" \
           "$fixture/evidence/capstone/summary"
  cp "$verifier" "$fixture/labs/capstone/capstone-verify.sh"

  printf 'run_id: %s\nenvironment: non-production\ncriteria:\n  CAP-01: supported\n  CAP-07: supported\n' \
    "$RUN" >"$fixture/docs/capstone/evidence-manifest.yaml"

  printf 'criterion=CAP-01 observed_at=%s route=local-kind run_id=%s\ncluster=%s kubernetes=v1.34.0\n' \
    "$IDENTITY_AT" "$RUN" "$CLUSTER" >"$fixture/evidence/capstone/delivery/identity.txt"

  local rest=(
    "delivery/gates.txt CAP-02"
    "runtime/reconciliation.txt CAP-03"
    "runtime/service-targets.txt CAP-04"
    "incident/timeline.md CAP-05"
    "ai/boundary-tests.txt CAP-06"
    "summary/cost-control.txt CAP-07"
  )
  local entry path criterion
  for entry in "${rest[@]}"; do
    path="${entry%% *}"
    criterion="${entry##* }"
    printf 'criterion=%s observed_at=%s run_id=%s\nobservation=recorded\n' \
      "$criterion" "$IDENTITY_AT" "$RUN" >"$fixture/evidence/capstone/$path"
  done

  write_cleanup "$RUN" "$CLUSTER" "$CLEANUP_AT"
}

write_cleanup() {
  local run="$1" context="$2" at="$3"
  {
    printf 'capstone cleanup\n'
    [ "$run" != "none" ] && printf 'run_id: %s\n' "$run"
    printf 'context: %s\n' "$context"
    printf 'run_at: %s\n\n' "$at"
    printf 'namespaces\n  absent    reference-staging\n\n'
    printf 'cleanup=complete\n'
  } >"$fixture/evidence/capstone/summary/cleanup.txt"
}

# Run one mode and require an outcome. `expect` is pass or fail; `pattern` is
# text the run must mention, so a case cannot pass by failing for an unrelated
# reason.
check() {
  local name="$1" expect="$2" pattern="$3" mode="$4"
  local output status
  checks=$((checks + 1))
  set +e
  output="$(cd "$fixture" && CAPSTONE_RUN_ID="${CAPSTONE_RUN_ID_OVERRIDE:-$RUN}" \
    bash labs/capstone/capstone-verify.sh "$mode" 2>&1)"
  status=$?
  set -e

  if [ "$expect" = "pass" ] && [ "$status" -ne 0 ]; then
    printf 'FAIL  %s: expected acceptance, got exit %s\n%s\n' "$name" "$status" "$output" >&2
    failures=$((failures + 1))
    return
  fi
  if [ "$expect" = "fail" ] && [ "$status" -eq 0 ]; then
    printf 'FAIL  %s: expected refusal, got PASS\n%s\n' "$name" "$output" >&2
    failures=$((failures + 1))
    return
  fi
  if ! printf '%s' "$output" | grep -q -- "$pattern"; then
    printf 'FAIL  %s: outcome was right but never mentioned %s\n%s\n' "$name" "$pattern" "$output" >&2
    failures=$((failures + 1))
    return
  fi
  printf 'ok    %s\n' "$name"
}

build_fixture
check "one coherent run is accepted" pass "CAPSTONE RESULT: PASS" final

build_fixture
write_cleanup "$OTHER" "$CLUSTER" "$CLEANUP_AT"
check "a teardown recorded for another run is refused" fail "stale" final

build_fixture
write_cleanup none "$CLUSTER" "$CLEANUP_AT"
check "a teardown that names no run is refused" fail "unbound" final

build_fixture
write_cleanup "$RUN" "$CLUSTER" "2025-01-02T09:00:00Z"
check "a teardown observed before the release is refused" fail "precedes-identity" final

build_fixture
write_cleanup "$RUN" "someone-elses-cluster" "$CLEANUP_AT"
check "a teardown of a different cluster is refused" fail "different-cluster" final

build_fixture
printf 'run_id: %s\nenvironment: non-production\ncriteria:\n  CAP-01: supported\n  CAP-07: supported\n' \
  "$OTHER" >"$fixture/docs/capstone/evidence-manifest.yaml"
check "a manifest describing another run is refused" fail "mixed" final

# `all` runs before the teardown and must stay usable then: a foreign cleanup
# record is not this run's pending teardown, and reporting it as outstanding is
# more useful than failing the pre-cleanup summary over it.
build_fixture
write_cleanup "$OTHER" "$CLUSTER" "$CLEANUP_AT"
check "a foreign teardown leaves cleanup pending, not failed" pass "cleanup: pending" all

printf '\n%s check(s), %s failure(s)\n' "$checks" "$failures"
[ "$failures" -eq 0 ]
