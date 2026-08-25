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

usage() {
  cat <<'USAGE'
Usage: labs/ch10/validate.sh [--service-url URL] [--evidence PATH] [--namespace NS]

  --service-url  Probe this URL directly instead of exec'ing into the
                 in-cluster client. Use it with the port-forward from
                 labs/ch10/06-port-forward-service.sh.
  --evidence     Write this run's report to PATH as well as to the terminal.
  --namespace    Namespace to check. Same as setting CH10_NAMESPACE.
USAGE
}

service_url=""
evidence_path=""

# Re-run through tee so the evidence file is written by a process that owns the
# pipe, rather than by a process substitution the shell does not wait for. The
# guard stops the second run from recursing.
if [ -z "${CH10_EVIDENCE_ACTIVE:-}" ]; then
  prev=""
  for arg in "$@"; do
    if [ "$prev" = "--evidence" ]; then
      [ -n "$arg" ] || { printf '--evidence needs a value\n' >&2; exit 2; }
      mkdir -p "$(dirname "$arg")"
      CH10_EVIDENCE_ACTIVE=1 "${BASH_SOURCE[0]}" "$@" 2>&1 | tee "$arg"
      exit "${PIPESTATUS[0]}"
    fi
    prev="$arg"
  done
fi

while [ $# -gt 0 ]; do
  case "$1" in
    --service-url) service_url="${2:-}"; [ -n "$service_url" ] || { printf -- '--service-url needs a value\n' >&2; exit 2; }; shift 2 ;;
    --evidence)    evidence_path="${2:-}"; shift 2 ;;
    --namespace)   CH10_NAMESPACE="${2:-}"; [ -n "$CH10_NAMESPACE" ] || { printf -- '--namespace needs a value\n' >&2; exit 2; }; export CH10_NAMESPACE; shift 2 ;;
    -h|--help)     usage; exit 0 ;;
    *)             printf 'unknown argument: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

pass()   { printf '  ok    %s\n' "$1"; }
skip()   { printf '  skip  %s\n' "$1"; }
fail()   { printf '  FAIL  %s\n' "$1" >&2; exit 1; }
# `fail` exits, so anything worth saying about a failure has to be said first.
detail() { printf '        %s\n' "$1" >&2; }

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
# Name the namespace in the header. The default is a reasonable one and it is
# also the whole failure when your client is somewhere else: "reference-app
# rolled out" reads as confirmation you are looking in the right place.
namespace="${CH10_NAMESPACE:-reference-staging}"
printf 'cluster (namespace %s, set CH10_NAMESPACE to change)\n' "$namespace"

if ! command -v kubectl >/dev/null 2>&1 || ! kubectl cluster-info >/dev/null 2>&1; then
  skip "no cluster in reach - the lab was not observed running"
  printf '\nchapter 10 validated (assets and code; cluster tier skipped)\n'
  exit 0
fi

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
# --service-url is the way past that from outside, and is what
# labs/ch10/06-port-forward-service.sh sets up.
if [ -z "$service_url" ] && ! kubectl -n "$namespace" get pod reference-client >/dev/null 2>&1; then
  skip "reference-client pod absent in ${namespace} - correlation not checked from inside the mesh"
  # A bare `kubectl apply -f` skips the overlay's commonLabels, and the
  # NetworkPolicy admits the client only when it carries the environment label
  # too - so applying the file alone produces a pod whose requests time out.
  printf '        recreate it: kubectl apply -k deployment/gitops/overlays/<env>\n'
  printf '        or: kubectl apply -f deployment/kubernetes/tests/client.yaml -n %s \\\n' "$namespace"
  printf '            && kubectl label pod reference-client -n %s app.kubernetes.io/environment=<env>\n' "$namespace"
  printf '        or probe from outside: labs/ch10/validate.sh --service-url http://127.0.0.1:8080\n'
  printf '\nchapter 10 validated (assets and code; correlation unchecked)\n'
  exit 0
fi

# A client that is not Running cannot be exec'd into, and the exec failure
# arrives as an empty status rather than as an explanation. Say what happened.
phase="Running"
[ -n "$service_url" ] || phase="$(kubectl -n "$namespace" get pod reference-client -o jsonpath='{.status.phase}')"
if [[ "$phase" != "Running" ]]; then
  detail "kubectl delete pod reference-client -n ${namespace}"
  detail "kubectl apply -f deployment/kubernetes/tests/client.yaml -n ${namespace}"
  detail "kubectl label pod reference-client -n ${namespace} app.kubernetes.io/environment=<env>"
  fail "reference-client in ${namespace} is ${phase}, not Running - nothing can be probed from inside the mesh"
fi

# Keep the probe's stderr. A refused connection, a client the NetworkPolicy
# does not admit, and a client that is no longer there all produce the same
# empty status, and only the error text tells them apart. It goes to a file
# because the probe runs in a subshell, where a variable would not survive.
probe_stderr="$(mktemp)"
trap 'rm -f "$probe_stderr"' EXIT

probe() {
  if [ -n "$service_url" ]; then
    # Same assertion, made from outside the mesh against the reader's forwarded
    # port, so the result is comparable with the in-cluster one.
    python3 -c "
import sys, urllib.request as u
r = u.urlopen('${service_url%/}/', timeout=5)
trace = r.headers.get('X-Trace-Id')
sys.stdout.write(f\"{r.status} {trace or 'ABSENT'}\")
" 2>"$probe_stderr" || true
    return
  fi
  kubectl -n "$namespace" exec reference-client -- python -c "
import re, sys, urllib.request as u
r = u.urlopen('http://reference-app.${namespace}.svc.cluster.local/', timeout=5)
trace = r.headers.get('X-Trace-Id')
sys.stdout.write(f\"{r.status} {trace or 'ABSENT'}\")
" 2>"$probe_stderr" || true
}

omit="$(kubectl -n "$namespace" get deployment reference-app \
  -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="CH10_OMIT_TRACE_ID")].value}')"
[ -z "$service_url" ] || printf '        probing %s directly (outside the mesh)\n' "$service_url"
read -r status trace <<<"$(probe)"

if [ "$status" != "200" ]; then
  while IFS= read -r line; do detail "$line"; done <"$probe_stderr"
  [[ -s "$probe_stderr" ]] ||
    detail "the probe produced no output and no error; check that the client carries app.kubernetes.io/environment"
  fail "live request to ${service_url:-reference-app.${namespace}} returned ${status:-no status}"
fi

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
