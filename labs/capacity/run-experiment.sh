#!/usr/bin/env bash
# Run Chapter 13's capacity experiment: baseline, then candidate, then compare.
#
# This script measures. It does not decide. Whether to retain or revert is a
# judgement about risk and cost that belongs to a named person, and a script
# that printed "retain" would let that person skip making it. What it produces
# is a scorecard with enough information to make the call defensible, plus the
# one thing that decides whether the call means anything: whether the two arms
# were comparable.
#
# Both arms run the same traffic against the same image in the same namespace,
# and the baseline is restored at the end regardless of outcome.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

# shellcheck source=labs/capacity/args.sh
. "${repo_root}/labs/capacity/args.sh"
ch13_parse_args "$@"

namespace="${CH13_NAMESPACE:-reference-incident}"
definition="${CH13_DEFINITION:-optimization/baseline.yaml}"
output="${CH13_OUTPUT:-evidence/ch13/experiment.json}"
requests="${CH13_REQUESTS:-120}"

command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found" >&2; exit 1; }
test -s "$definition" || { echo "missing experiment definition: $definition" >&2; exit 1; }

field() {  # field SECTION KEY - reads the flat two-level YAML this file uses
  awk -v section="$1" -v key="$2" '
    $0 ~ "^"section":" {inside=1; next}
    /^[a-z_]+:/ {inside=0}
    inside && $1 == key":" {gsub(/[",]/,"",$2); print $2; exit}
  ' "$definition"
}

top() { awk -v key="$1" '$1 == key":" {gsub(/[",]/,"",$2); print $2; exit}' "$definition"; }

experiment_id="$(top experiment_id)"
success_min="$(field service_target success_ratio_min)"
p95_max_ms="$(field service_target p95_latency_ms_max)"
min_requests="$(field service_target minimum_requests)"

(( requests >= min_requests )) || {
  echo "CH13_REQUESTS=${requests} is below the experiment's minimum_requests=${min_requests}" >&2
  exit 1
}

# The chapter passes --candidate candidate-a and candidate-b. This definition
# carries one section named `candidate`, so a name that is not in the file is a
# mistake worth reporting rather than silently running something else.
candidate_section="${CH13_CANDIDATE:-candidate}"
grep -Eq "^${candidate_section}:" "$definition" || {
  printf 'no section named %s in %s; it defines: %s\n' \
    "$candidate_section" "$definition" \
    "$(grep -Eo '^[a-z_-]+:' "$definition" | tr -d ':' | tr '\n' ' ')" >&2
  exit 1
}

apply_arm() {  # apply_arm SECTION
  local section="$1"
  kubectl -n "$namespace" set resources deployment/reference-app \
    --containers=app \
    --requests="cpu=$(field "$section" cpu_request),memory=$(field "$section" memory_request)" \
    --limits="cpu=$(field "$section" cpu_limit),memory=$(field "$section" memory_limit)" >/dev/null
  kubectl -n "$namespace" rollout status deployment/reference-app --timeout=180s >/dev/null
}

measure() {  # measure -> one JSON object on stdout
  kubectl -n "$namespace" exec reference-client -- python -c "
import json, time, urllib.request
url = 'http://reference-app.${namespace}.svc.cluster.local/'
ok = failed = 0
latencies = []
for _ in range(${requests}):
    start = time.perf_counter()
    try:
        with urllib.request.urlopen(url, timeout=5) as response:
            response.read()
            ok += 1
            latencies.append(time.perf_counter() - start)
    except Exception:
        failed += 1
total = ok + failed
latencies.sort()
print(json.dumps({
    'requests': total,
    'ok': ok,
    'failed': failed,
    'success_ratio': round(ok / total, 4) if total else 0.0,
    'p95_ms': round(latencies[int(len(latencies) * 0.95)] * 1000, 1) if latencies else None,
    'median_ms': round(latencies[len(latencies) // 2] * 1000, 1) if latencies else None,
}))
" 2>/dev/null
}

printf 'experiment=%s namespace=%s requests=%s\n' "$experiment_id" "$namespace" "$requests"

printf 'arm=baseline applying...\n'
apply_arm baseline
baseline_json="$(measure)"
printf 'arm=baseline %s\n' "$baseline_json"

printf 'arm=%s applying...\n' "$candidate_section"
apply_arm "$candidate_section"
candidate_json="$(measure)"
printf 'arm=%s %s\n' "$candidate_section" "$candidate_json"

printf 'restoring baseline resources...\n'
apply_arm baseline

mkdir -p "$(dirname "$output")"
BASELINE="$baseline_json" CANDIDATE="$candidate_json" python3 - "$output" <<PY
import json, os, sys, datetime

baseline = json.loads(os.environ["BASELINE"])
candidate = json.loads(os.environ["CANDIDATE"])
success_min = float("${success_min}")
p95_max = float("${p95_max_ms}")

def within(arm):
    return (arm["success_ratio"] >= success_min
            and arm["p95_ms"] is not None
            and arm["p95_ms"] <= p95_max)

# Comparability is the question that decides whether the rest is worth
# reading. Two arms measured over different request counts, or an arm that
# breached the service target, cannot be compared on latency alone.
comparable = (
    baseline["requests"] == candidate["requests"]
    and baseline["failed"] == 0
    and candidate["failed"] == 0
)

report = {
    "experiment_id": "${experiment_id}",
    "namespace": "${namespace}",
    "recorded_at": datetime.datetime.now(datetime.timezone.utc).isoformat(timespec="seconds"),
    "service_target": {"success_ratio_min": success_min, "p95_latency_ms_max": p95_max},
    "baseline": baseline,
    "candidate": candidate,
    "baseline_within_target": within(baseline),
    "candidate_within_target": within(candidate),
    "comparable": comparable,
    "p95_delta_ms": (round(candidate["p95_ms"] - baseline["p95_ms"], 1)
                     if baseline["p95_ms"] is not None and candidate["p95_ms"] is not None else None),
    "decision": "pending - a named reviewer records retain or revert",
}
path = sys.argv[1]
open(path, "w").write(json.dumps(report, indent=2) + "\n")

print()
print(f"comparable={report['comparable']}")
print(f"baseline_within_target={report['baseline_within_target']} "
      f"candidate_within_target={report['candidate_within_target']}")
print(f"p95 baseline={baseline['p95_ms']}ms candidate={candidate['p95_ms']}ms "
      f"delta={report['p95_delta_ms']}ms")
print(f"written={path}")
print()
print("Decision is not recorded here. Fill optimization/scorecard-template.md")
print("and record retain or revert with a named reviewer and a reason.")
PY
