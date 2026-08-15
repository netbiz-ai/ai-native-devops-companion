#!/usr/bin/env bash
# Chapter 12 preflight.
#
# The previous version checked four files existed and printed mode=design-only.
# The templates it checked for are still checked, because an incident record
# written from memory afterwards is not evidence - but the lab now runs, so
# this also verifies the things a running lab needs.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

namespace="${CH12_NAMESPACE:-reference-incident}"
failed=0

pass() { printf '  ok    %s\n' "$1"; }
skip() { printf '  skip  %s\n' "$1"; }
bad()  { printf '  FAIL  %s\n' "$1" >&2; failed=1; }

printf 'assets\n'
for path in \
  incidents/templates/facts-incident-record.md \
  incidents/templates/post-incident-review.md \
  observability/runbooks/high-latency.md \
  deployment/gitops/overlays/incident/kustomization.yaml \
  deployment/gitops/overlays/incident/ch12-latency-fault.yaml; do
  if [[ -s "$path" ]]; then pass "$path"; else bad "missing: $path"; fi
done

printf 'scripts\n'
for script in inject-failure restore generate-traffic capture-evidence validate; do
  if [[ -x "labs/ch12/${script}.sh" ]]; then
    bash -n "labs/ch12/${script}.sh" && pass "labs/ch12/${script}.sh"
  else
    bad "not executable: labs/ch12/${script}.sh"
  fi
done

printf 'evidence\n'
# The incident scripts write their snapshots into the working tree. Any earlier
# sudo, runuser or root-shell git pull leaves directories here owned by root,
# and the write then fails inside a step rather than before one.
state_file="${CH12_STATE_FILE:-evidence/ch12/pre-fault-state.txt}"
state_dir="$(dirname "$state_file")"
unwritable=""
if ! mkdir -p "$state_dir" 2>/dev/null || [[ ! -w "$state_dir" ]]; then
  unwritable="$state_dir"
elif [[ -e "$state_file" && ! -w "$state_file" ]]; then
  unwritable="$state_file"
fi
if [[ -z "$unwritable" ]]; then
  pass "${state_dir} is writable"
else
  bad "${unwritable} is not writable by $(id -un) - the incident steps cannot record what they change"
  # shellcheck disable=SC2016  # printed for the reader to run, not expanded here
  printf '        chown -R "$(id -un)" evidence\n' >&2
fi

printf 'environment\n'
if ! command -v kubectl >/dev/null 2>&1 || ! kubectl cluster-info >/dev/null 2>&1; then
  skip "no cluster in reach - the lab cannot run here"
  [[ $failed -eq 0 ]] && printf '\nincident_preflight=pass mode=assets-only\n'
  exit $failed
fi
pass "cluster reachable"

if kubectl get namespace "$namespace" >/dev/null 2>&1; then
  pass "namespace ${namespace} exists"
else
  skip "namespace ${namespace} absent - Step 1 creates it"
fi

# Refusing to start an incident lab in a protected namespace is the one check
# here worth more than the rest of the script combined.
case "$namespace" in
  *production*|*prod) bad "refusing: ${namespace} looks like a production namespace" ;;
  *) pass "namespace is disposable" ;;
esac

[[ $failed -eq 0 ]] && printf '\nincident_preflight=pass mode=runnable\n'
exit $failed
