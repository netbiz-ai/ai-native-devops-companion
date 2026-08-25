#!/usr/bin/env bash
# Measure the baseline arm on its own and write the report.
#
# labs/ch13/01-capture-baseline.sh calls this and it did not exist. It is the
# same measurement run-experiment.sh takes for its baseline arm, without the
# candidate: a reader who wants the accepted configuration's numbers before
# proposing a change should not have to run a comparison to get them.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

# shellcheck source=labs/ch13/args.sh
. "${repo_root}/labs/ch13/args.sh"
ch13_parse_args "$@"

namespace="${CH13_NAMESPACE:-reference-incident}"
definition="${CH13_DEFINITION:-optimization/baseline.yaml}"
output="${CH13_OUTPUT:-evidence/ch13/baseline.json}"
requests="${CH13_REQUESTS:-120}"

command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found" >&2; exit 1; }
test -s "$definition" || { echo "missing experiment definition: $definition" >&2; exit 1; }

field() {
  awk -v section="$1" -v key="$2" '
    $0 ~ "^"section":" {inside=1; next}
    /^[a-z_]+:/ {inside=0}
    inside && $1 == key":" {gsub(/[",]/,"",$2); print $2; exit}
  ' "$definition"
}
top() { awk -v key="$1" '$1 == key":" {gsub(/[",]/,"",$2); print $2; exit}' "$definition"; }

kubectl -n "$namespace" get deployment reference-app >/dev/null 2>&1 || {
  echo "reference-app is not deployed in ${namespace}; run Step 1 first" >&2
  exit 1
}
kubectl -n "$namespace" get pod reference-client >/dev/null 2>&1 || {
  echo "reference-client is not in ${namespace}; the NetworkPolicy admits only that pod" >&2
  exit 1
}

min_requests="$(field service_target minimum_requests)"
(( requests >= min_requests )) || {
  echo "CH13_REQUESTS=${requests} is below minimum_requests=${min_requests}" >&2
  exit 1
}

kubectl -n "$namespace" set resources deployment/reference-app \
  --containers=app \
  --requests="cpu=$(field baseline cpu_request),memory=$(field baseline memory_request)" \
  --limits="cpu=$(field baseline cpu_limit),memory=$(field baseline memory_limit)" >/dev/null
kubectl -n "$namespace" rollout status deployment/reference-app --timeout=180s >/dev/null

measured="$(kubectl -n "$namespace" exec reference-client -- python -c "
import json, time, urllib.request
url = 'http://reference-app.${namespace}.svc.cluster.local/'
ok = failed = 0
latencies = []
for _ in range(${requests}):
    started = time.perf_counter()
    try:
        with urllib.request.urlopen(url, timeout=5) as response:
            response.read()
            ok += 1 if response.status == 200 else 0
            failed += 0 if response.status == 200 else 1
    except Exception:
        failed += 1
    latencies.append((time.perf_counter() - started) * 1000)
latencies.sort()
p95 = latencies[min(int(len(latencies) * 0.95), len(latencies) - 1)] if latencies else None
total = ok + failed
print(json.dumps({
    'requests': total,
    'ok': ok,
    'failed': failed,
    'success_ratio': round(ok / total, 4) if total else 0.0,
    'p95_ms': round(p95, 1) if p95 is not None else None,
}))
")"

printf 'arm=baseline %s\n' "$measured"

mkdir -p "$(dirname "$output")"
MEASURED="$measured" python3 - "$output" "$(top experiment_id)" "$namespace" \
  "$(field service_target success_ratio_min)" "$(field service_target p95_latency_ms_max)" <<'PY'
import json, os, sys, datetime
output, experiment_id, namespace, success_min, p95_max = sys.argv[1:6]
arm = json.loads(os.environ["MEASURED"])
within = (arm["success_ratio"] >= float(success_min)
          and arm["p95_ms"] is not None
          and arm["p95_ms"] <= float(p95_max))
report = {
    "experiment_id": experiment_id,
    "namespace": namespace,
    "arm": "baseline",
    "recorded_at": datetime.datetime.now(datetime.UTC).isoformat(),
    "service_target": {
        "success_ratio_min": float(success_min),
        "p95_latency_ms_max": float(p95_max),
    },
    "baseline": arm,
    "baseline_within_target": within,
}
with open(output, "w", encoding="utf-8") as handle:
    json.dump(report, handle, indent=2)
    handle.write("\n")
print(f"written={output} baseline_within_target={within}")
PY
