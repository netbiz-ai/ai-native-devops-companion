#!/usr/bin/env bash
# Chapter 13 preflight.
#
# The experiment compares two resource configurations and asks whether the
# difference is real. That question is only answerable if the measurements are
# comparable, so this checks the inputs that make them so: a defined
# experiment, thresholds to judge against, and an environment that is not
# production.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

# shellcheck source=labs/capacity/args.sh
. "${repo_root}/labs/capacity/args.sh"
ch13_parse_args "$@"

namespace="${CH13_NAMESPACE:-reference-incident}"
failed=0

pass() { printf '  ok    %s\n' "$1"; }
skip() { printf '  skip  %s\n' "$1"; }
bad()  { printf '  FAIL  %s\n' "$1" >&2; failed=1; }

printf 'assets\n'
for path in \
  optimization/baseline.yaml \
  optimization/scorecard-template.md \
  docs/optimization/experiment-template.md \
  docs/decisions/adr-template.md; do
  if [[ -s "$path" ]]; then pass "$path"; else bad "missing: $path"; fi
done

printf 'experiment definition\n'
for key in experiment_id success_ratio_min p95_latency_ms_max minimum_requests; do
  if grep -q "^\s*${key}:" optimization/baseline.yaml; then
    pass "$key defined"
  else
    bad "optimization/baseline.yaml does not define ${key}"
  fi
done

# A candidate identical to the baseline measures nothing, and it is an easy
# mistake to make when editing YAML by hand.
if diff <(sed -n '/^baseline:/,/^candidate:/p' optimization/baseline.yaml | sed '1d;$d') \
        <(sed -n '/^candidate:/,/^stop_conditions:/p' optimization/baseline.yaml | sed '1d;$d') \
        >/dev/null 2>&1; then
  bad "candidate is identical to baseline; there is nothing to compare"
else
  pass "candidate differs from baseline"
fi

printf 'environment\n'
if ! command -v kubectl >/dev/null 2>&1 || ! kubectl cluster-info >/dev/null 2>&1; then
  skip "no cluster in reach - the experiment cannot run here"
  [[ $failed -eq 0 ]] && printf '\ncapacity_preflight=pass mode=assets-only\n'
  exit $failed
fi
pass "cluster reachable"

case "$namespace" in
  *production*|*prod) bad "refusing: ${namespace} looks like a production namespace" ;;
  *) pass "namespace is disposable" ;;
esac

if kubectl -n "$namespace" get deployment reference-app >/dev/null 2>&1; then
  pass "reference-app deployed in ${namespace}"
else
  bad "reference-app is not deployed in ${namespace}"
fi

if kubectl -n "$namespace" get pod reference-client >/dev/null 2>&1; then
  pass "reference-client available to generate load"
else
  bad "reference-client is not running in ${namespace}; the NetworkPolicy admits only that pod"
fi

[[ $failed -eq 0 ]] && printf '\ncapacity_preflight=pass mode=runnable\n'
exit $failed
