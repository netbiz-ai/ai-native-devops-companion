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
SOURCE_REV="a567221a6f90de2ced36f182a505cddbc9c44d54"
GITOPS_REV="0a71eca8407159d5a4fdf0d895b0091ef9b86953"
# The digest delivery promoted, and the digest the lab workload actually runs.
# They differ on the local route by design, because Argo CD reconciles the lab
# cluster from a local mirror rather than from the registry.
PROMOTED="sha256:5965c499194a5a522ad2aea1f88daed8afeaee5cdfdfc8a8c28d5847f6ce48d6"
WORKLOAD="sha256:398773f0332fdcc30e26ddc40ec0a7314fa5ae3c900223b44fc3586dca4ac591"

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

  write_manifest "$RUN" "$PROMOTED" declared-limit
  write_identity "$WORKLOAD"
  printf 'criterion=CAP-02 observed_at=%s run_id=%s\nallowed_revision=%s\nallowed_digest=%s\n' \
    "$IDENTITY_AT" "$RUN" "$SOURCE_REV" "$PROMOTED" \
    >"$fixture/evidence/capstone/delivery/gates.txt"

  local rest=(
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

write_manifest() {
  local run="$1" image_digest="$2" limit="$3"
  {
    printf 'run_id: %s\nenvironment: non-production\n' "$run"
    printf 'release:\n  source_revision: %s\n  image_digest: %s\n  gitops_revision: %s\n' \
      "$SOURCE_REV" "$image_digest" "$GITOPS_REV"
    printf 'criteria:\n  CAP-01: supported\n  CAP-07: supported\n'
    printf 'limitations:\n'
    if [ "$limit" = "declared-limit" ]; then
      printf '  - The identity chain is the local lab route; it does not extend to a registry-published delivery digest.\n'
    else
      printf '  - Nothing here is evidence about a cloud provider account.\n'
    fi
  } >"$fixture/docs/capstone/evidence-manifest.yaml"
}

write_identity() {
  local workload_digest="$1"
  {
    printf 'criterion=CAP-01 observed_at=%s route=local-kind run_id=%s\n' "$IDENTITY_AT" "$RUN"
    printf 'workload_image=kind-registry:5000/reference-app@%s\n' "$workload_digest"
    printf 'gitops_declared_digest=%s\n' "$workload_digest"
    printf 'argocd_revision=%s\n' "$GITOPS_REV"
    printf 'declaration_matches_workload=true\n'
    printf 'cluster=%s kubernetes=v1.34.0\n' "$CLUSTER"
  } >"$fixture/evidence/capstone/delivery/identity.txt"
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
write_manifest "$OTHER" "$PROMOTED" declared-limit
check "a manifest describing another run is refused" fail "mixed" final

# CAP-01 is the criterion two files can contradict each other about, which no
# amount of per-file checking can see.
build_fixture
write_manifest "$RUN" "sha256:0000000000000000000000000000000000000000000000000000000000000000" \
  declared-limit
check "a promoted digest the manifest disagrees with is refused" fail "contradicted" identity

# The declared digest and the running one are written from a single value, so
# the disagreement has to be introduced into the declaration itself.
build_fixture
sed -i 's/^gitops_declared_digest=.*/gitops_declared_digest=sha256:1111111111111111111111111111111111111111111111111111111111111111/' \
  "$fixture/evidence/capstone/delivery/identity.txt"
check "a declaration that disagrees with the workload is refused" fail "contradicted" identity

# The gap between the promoted digest and the running workload is acceptable
# only while the manifest says the route cannot close it. Dropping that
# sentence must not silently widen what CAP-01 claims.
build_fixture
write_manifest "$RUN" "$PROMOTED" no-limit
check "an undeclared identity gap is refused" fail "overclaimed" identity

# `all` runs before the teardown and must stay usable then: a foreign cleanup
# record is not this run's pending teardown, and reporting it as outstanding is
# more useful than failing the pre-cleanup summary over it.
build_fixture
write_cleanup "$OTHER" "$CLUSTER" "$CLEANUP_AT"
check "a foreign teardown leaves cleanup pending, not failed" pass "cleanup: pending" all

# The teardown's blast radius is a cluster property, so the behavioural test for
# it lives with the cluster lab. What can be checked without a cluster is that
# the script still names its targets: the bug it replaced deleted whatever the
# argocd namespace happened to list, which made the damage depend on who else
# used the cluster.
check_cleanup_targets_are_named() {
  local script="$repo_root/scripts/capstone-cleanup.sh"
  checks=$((checks + 1))
  if ! grep -q '^applications=(' "$script"; then
    printf 'FAIL  the teardown names its Applications: no explicit list remains\n' >&2
    failures=$((failures + 1))
    return
  fi
  if grep -qE 'for [a-z_]+ in \$\(kubectl .*get applications' "$script" \
     && grep -qE 'kubectl -n argocd delete "\$(app|found)"' "$script"; then
    printf 'FAIL  the teardown names its Applications: it deletes whatever the namespace lists\n' >&2
    failures=$((failures + 1))
    return
  fi
  printf 'ok    the teardown names its Applications\n'
}

check_cleanup_targets_are_named

printf '\n%s check(s), %s failure(s)\n' "$checks" "$failures"
[ "$failures" -eq 0 ]
