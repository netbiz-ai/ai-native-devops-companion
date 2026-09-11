#!/usr/bin/env bash
# Chapter 10 validation.
#
# The previous version of this script checked that the observability files
# existed. Existence is not evidence: a dashboard, a rule set and a runbook can
# all be present and still describe telemetry the application never emits. This
# version checks that the names line up and that the code behaves.
#
# Three tiers, each stricter than the last, and each reporting what it could not
# check rather than passing silently:
#
#   assets      files parse and the rule set is valid
#   code        the instrumentation and both fault gates, unit tested
#   cluster     the lab observed running, when a cluster is reachable
#
# The cluster tier is skipped when no cluster is in reach, and says so. It is
# never quietly assumed to have passed.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

pass() { printf '  ok    %s\n' "$1"; }
skip() { printf '  skip  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1" >&2; exit 1; }

# ---- assets ----------------------------------------------------------------
printf 'assets\n'

python3 -m json.tool observability/dashboard.json >/dev/null \
  || fail "dashboard.json is not valid JSON"
pass "dashboard.json parses"

for required in \
  observability/collector.yaml \
  observability/recording-rules.yaml \
  observability/alerts/reference-app.yaml \
  observability/runbooks/high-latency.md \
  observability/test-receiver.yaml \
  deployment/gitops/overlays/staging/ch10-lab-faults.yaml; do
  test -s "$required" || fail "$required is missing or empty"
done
pass "required files present and non-empty"

if command -v promtool >/dev/null 2>&1; then
  promtool check rules observability/recording-rules.yaml >/dev/null \
    || fail "recording rules rejected by promtool"
  promtool check rules observability/alerts/reference-app.yaml >/dev/null \
    || fail "alert rules rejected by promtool"
  pass "recording and alert rules valid"
else
  skip "promtool not installed - rule syntax unverified"
fi

# ---- code ------------------------------------------------------------------
printf 'code\n'

# The instrument name in the source and the series name in the recording rules
# are one contract expressed twice. This is the check that would have caught a
# semantic-convention rename before it reached a dashboard that renders nothing.
instrument="$(python3 - <<'PY'
import re, pathlib
source = pathlib.Path("reference-app/src/telemetry.py").read_text()
print(re.search(r'_INSTRUMENT_NAME = "([^"]+)"', source).group(1))
PY
)"
series="${instrument//./_}_seconds"
for suffix in _count _bucket; do
  grep -q "${series}${suffix}" observability/recording-rules.yaml \
    || fail "recording rules do not read ${series}${suffix}, which the code emits"
done
pass "instrument name matches the series the rules query (${series})"

grep -q "http_response_status_code" observability/recording-rules.yaml \
  || fail "recording rules do not read the status attribute the code sets"
pass "status attribute matches"

if python3 -c "import opentelemetry" >/dev/null 2>&1; then
  python3 -m unittest discover -s reference-app/tests -p 'test_*.py' >/dev/null 2>&1 \
    || fail "reference-app tests failed"
  pass "instrumentation and fault-gate tests pass"
else
  skip "opentelemetry not installed - run 'pip install -r reference-app/requirements.txt'"
fi

if command -v kustomize >/dev/null 2>&1; then
  rendered="$(kustomize build deployment/gitops/overlays/staging 2>/dev/null)"
  grep -q "CH10_OMIT_TRACE_ID" <<<"$rendered" \
    || fail "staging overlay does not carry CH10_OMIT_TRACE_ID"
  grep -q "CH10_FAULT_GATE_ENABLED" <<<"$rendered" \
    || fail "staging overlay does not carry CH10_FAULT_GATE_ENABLED"
  pass "staging overlay renders both fault switches"
else
  skip "kustomize not installed - overlay rendering unverified"
fi

# ---- cluster ---------------------------------------------------------------
printf 'cluster\n'

if ! command -v kubectl >/dev/null 2>&1 || ! kubectl cluster-info >/dev/null 2>&1; then
  skip "no cluster in reach - the lab was not observed running"
  printf '\nchapter 10 validated (assets and code; cluster tier skipped)\n'
  exit 0
fi

namespace="${CH10_NAMESPACE:-reference-staging}"
if ! kubectl -n "$namespace" get deployment reference-app >/dev/null 2>&1; then
  skip "reference-app not deployed in ${namespace} - the lab was not observed running"
  printf '\nchapter 10 validated (assets and code; cluster tier skipped)\n'
  exit 0
fi

kubectl -n "$namespace" rollout status deployment/reference-app --timeout=60s >/dev/null \
  || fail "reference-app is not rolled out in ${namespace}"
pass "reference-app rolled out"

# Requests must come from the sanctioned client: the default-deny NetworkPolicy
# admits only a pod carrying both of these labels, and the Service listens on 80.
if ! kubectl -n "$namespace" get pod reference-client >/dev/null 2>&1; then
  skip "reference-client pod absent - correlation not checked from inside the mesh"
  printf '\nchapter 10 validated (assets and code; correlation unchecked)\n'
  exit 0
fi

probe() {
  kubectl -n "$namespace" exec reference-client -- python -c "
import re, sys, urllib.request as u
r = u.urlopen('http://reference-app.${namespace}.svc.cluster.local/', timeout=5)
trace = r.headers.get('X-Trace-Id')
sys.stdout.write(f\"{r.status} {trace or 'ABSENT'}\")
" 2>/dev/null
}

omit="$(kubectl -n "$namespace" get deployment reference-app \
  -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="CH10_OMIT_TRACE_ID")].value}')"
read -r status trace <<<"$(probe)"

[ "$status" = "200" ] || fail "live request returned ${status}"

if [ "$omit" = "true" ]; then
  [ "$trace" = "ABSENT" ] \
    || fail "CH10_OMIT_TRACE_ID is true but the response still carried a trace id"
  pass "correlation broken on purpose, request still 200 (the lab's premise)"
else
  [[ "$trace" =~ ^[0-9a-f]{32}$ ]] \
    || fail "response carried no well-formed trace id: ${trace}"
  pass "live request carries a well-formed trace id"
fi

printf '\nchapter 10 validated (assets, code and cluster)\n'
