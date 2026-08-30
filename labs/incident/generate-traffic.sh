#!/usr/bin/env bash
# Drive traffic at the incident service for a bounded interval.
#
# Chapter 12 calls this with --duration, which the previous version did not
# accept: it took a positional target and a REQUESTS count. A script whose
# printed invocation does not parse is indistinguishable from a broken lab,
# so both forms now work and --duration is the documented one.
#
# Traffic runs from inside the cluster through the sanctioned client, because
# the namespace's default-deny NetworkPolicy admits only that pod. Requests
# from a laptop time out and look like the incident.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

duration=60
namespace="${CH12_NAMESPACE:-reference-incident}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --duration) duration="${2:?--duration needs a value}"; shift 2 ;;
    --namespace) namespace="${2:?--namespace needs a value}"; shift 2 ;;
    *) echo "usage: $0 [--duration SECONDS] [--namespace NS]" >&2; exit 2 ;;
  esac
done

case "$duration" in
  ''|*[!0-9]*) echo "--duration must be a positive integer" >&2; exit 2 ;;
esac

client_phase="$(kubectl -n "$namespace" get pod reference-client \
  -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [[ "$client_phase" != "Running" ]]; then
  if [[ -z "$client_phase" ]]; then
    echo "reference-client is not present in ${namespace}" >&2
  else
    echo "reference-client is ${client_phase}, not Running, in ${namespace}" >&2
    echo "the supplied client sleeps for one hour and then Succeeds" >&2
  fi
  echo "apply deployment/kubernetes/tests/client.yaml into that namespace" >&2
  exit 1
fi

started="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Counts outcomes rather than printing a line per request. During an incident
# the useful artifact is the failure ratio and the latency spread, not a
# thousand status codes scrolling past.
kubectl -n "$namespace" exec reference-client -- python -c "
import json, time, urllib.error, urllib.request
url = 'http://reference-app.${namespace}.svc.cluster.local/ready'
deadline = time.time() + ${duration}
ok = failed = 0
latencies = []
while time.time() < deadline:
    start = time.perf_counter()
    try:
        with urllib.request.urlopen(url, timeout=3) as response:
            response.read()
            ok += 1
            latencies.append(time.perf_counter() - start)
    except Exception:
        failed += 1
    time.sleep(0.5)
total = ok + failed
latencies.sort()
p95 = latencies[int(len(latencies) * 0.95)] if latencies else None
print(json.dumps({
    'requests': total,
    'ok': ok,
    'failed': failed,
    'failure_ratio': round(failed / total, 3) if total else None,
    'p95_seconds': round(p95, 3) if p95 is not None else None,
}))
"

printf 'traffic_window_start=%s traffic_window_end=%s duration_seconds=%s\n' \
  "$started" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$duration"
