#!/usr/bin/env bash
# Express the resource difference between the two arms, in the units the reader
# can price.
#
# labs/ch13/03-estimate-cost.sh calls this and it did not exist, which left the
# "Estimated cost" row of optimization/scorecard-template.md with nothing able
# to fill it - and Chapter 13's decision is a trade-off, so half of it was
# unmeasurable.
#
# It does not invent a price. Rates differ by provider, region, commitment and
# instance family, and a number this script made up would be indistinguishable
# in the scorecard from one the reader looked up. It reports the resource delta
# and the arithmetic; the reader supplies the rate, either in CH13_CPU_HOUR_RATE
# and CH13_GIB_HOUR_RATE or by hand.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

# shellcheck source=labs/ch13/args.sh
. "${repo_root}/labs/ch13/args.sh"
ch13_parse_args "$@"

definition="${CH13_DEFINITION:-optimization/baseline.yaml}"
report="${CH13_BASELINE:-evidence/ch13/experiment.json}"
output="${CH13_COST_MODEL:-evidence/ch13/cost-model.md}"
namespace="${CH13_NAMESPACE:-reference-incident}"

test -s "$definition" || { echo "missing experiment definition: $definition" >&2; exit 1; }

replicas="$(kubectl -n "$namespace" get deployment reference-app \
  -o jsonpath='{.spec.replicas}' 2>/dev/null || true)"
: "${replicas:=2}"

mkdir -p "$(dirname "$output")"
DEFINITION="$definition" REPORT="$report" REPLICAS="$replicas" \
CPU_RATE="${CH13_CPU_HOUR_RATE:-}" GIB_RATE="${CH13_GIB_HOUR_RATE:-}" \
python3 - "$output" <<'PY'
import json, os, re, sys

output = sys.argv[1]
text = open(os.environ["DEFINITION"], encoding="utf-8").read()

def section(name):
    match = re.search(rf"^{name}:\n((?:  .*\n)*)", text, re.MULTILINE)
    if not match:
        raise SystemExit(f"no section named {name} in the definition")
    return dict(re.findall(r"^\s+([a-z_]+):\s*(\S+)", match.group(1), re.MULTILINE))

def cpu_cores(value):      # 250m -> 0.25
    return float(value[:-1]) / 1000 if value.endswith("m") else float(value)

def mem_gib(value):        # 128Mi -> 0.125
    units = {"Ki": 1 / 1024 / 1024, "Mi": 1 / 1024, "Gi": 1.0}
    for suffix, factor in units.items():
        if value.endswith(suffix):
            return float(value[: -len(suffix)]) * factor
    return float(value) / (1024 ** 3)

base, cand = section("baseline"), section("candidate")
replicas = int(os.environ["REPLICAS"])

rows = []
for label, key, convert, unit in (
    ("CPU request", "cpu_request", cpu_cores, "cores"),
    ("CPU limit", "cpu_limit", cpu_cores, "cores"),
    ("Memory request", "memory_request", mem_gib, "GiB"),
    ("Memory limit", "memory_limit", mem_gib, "GiB"),
):
    b, c = convert(base[key]), convert(cand[key])
    rows.append((label, base[key], cand[key], b, c, (c - b) * replicas, unit))

# Requests are what a scheduler reserves and therefore what a node is sized for,
# so they are the honest basis for a cost estimate. Limits cap a spike; they do
# not reserve anything and do not appear on a bill.
cpu_delta = next(r[5] for r in rows if r[0] == "CPU request")
mem_delta = next(r[5] for r in rows if r[0] == "Memory request")

measured = None
try:
    measured = json.load(open(os.environ["REPORT"], encoding="utf-8"))
except (OSError, json.JSONDecodeError):
    pass

lines = [
    "# Estimated cost model",
    "",
    f"Replicas: {replicas}. Deltas are candidate minus baseline across all replicas,",
    "so a negative number is a reduction.",
    "",
    "| Measure | Baseline | Candidate | Delta (all replicas) |",
    "|---|---:|---:|---:|",
]
for label, b_raw, c_raw, _b, _c, delta, unit in rows:
    lines.append(f"| {label} | {b_raw} | {c_raw} | {delta:+.4g} {unit} |")

lines += [
    "",
    "## Reserved capacity",
    "",
    f"- CPU reserved: {cpu_delta:+.4g} cores",
    f"- Memory reserved: {mem_delta:+.4g} GiB",
    "",
    "Requests are the basis here, not limits: a request is what the scheduler",
    "reserves and what a node is sized for. A limit caps a spike and reserves",
    "nothing, so it does not appear on a bill.",
    "",
    "## Price it yourself",
    "",
    "This file deliberately carries no rate. Rates differ by provider, region,",
    "commitment and instance family, and an invented one would be",
    "indistinguishable in the scorecard from a real one.",
    "",
    "    monthly change = (cpu_delta * cpu_core_hour_rate",
    "                      + mem_delta * gib_hour_rate) * 730",
    "",
]

cpu_rate, gib_rate = os.environ.get("CPU_RATE"), os.environ.get("GIB_RATE")
if cpu_rate and gib_rate:
    monthly = (cpu_delta * float(cpu_rate) + mem_delta * float(gib_rate)) * 730
    lines += [
        f"At the rates supplied (CPU {cpu_rate}/core-hour, memory {gib_rate}/GiB-hour):",
        "",
        f"- Monthly change: {monthly:+.2f} per month, at 730 hours",
        "",
    ]
else:
    lines += [
        "Set CH13_CPU_HOUR_RATE and CH13_GIB_HOUR_RATE to have that computed here.",
        "",
    ]

if measured and "p95_delta_ms" in measured:
    lines += [
        "## What the saving costs",
        "",
        f"- p95 latency delta: {measured['p95_delta_ms']:+} ms",
        f"- Arms comparable: {measured.get('comparable')}",
        "",
        "A resource reduction is worth taking only when the saving is worth the",
        "regression beside it. Both halves belong in the scorecard.",
        "",
    ]
else:
    lines += [
        "## What the saving costs",
        "",
        f"No experiment report was readable at {os.environ['REPORT']}, so the",
        "latency side of the trade-off is not recorded here. Run",
        "labs/ch13/run-experiment.sh first.",
        "",
    ]

with open(output, "w", encoding="utf-8") as handle:
    handle.write("\n".join(lines))
print(f"written={output} cpu_delta={cpu_delta:+.4g}cores mem_delta={mem_delta:+.4g}GiB")
PY
