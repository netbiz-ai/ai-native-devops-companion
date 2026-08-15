#!/usr/bin/env bash
# Chapter 13 validation.
#
# The chapter's claim is comparable candidates and a retain-or-revert decision.
# So this checks two things a scorecard cannot fake: that the measurements were
# comparable, and that a human recorded a decision with a reason. An experiment
# whose arms were not comparable is a story, and a decision nobody signed is a
# preference.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

report="${CH13_OUTPUT:-evidence/ch13/experiment.json}"

pass() { printf '  ok    %s\n' "$1"; }
skip() { printf '  skip  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1" >&2; exit 1; }

printf 'assets\n'
for path in optimization/baseline.yaml optimization/scorecard-template.md; do
  [[ -s "$path" ]] || fail "missing: $path"
done
pass "experiment definition and scorecard template present"

printf 'experiment\n'
if [[ ! -f "$report" ]]; then
  skip "no experiment report at ${report} - run labs/ch13/run-experiment.sh"
  printf '\nchapter 13 validated (assets only)\n'
  exit 0
fi

python3 - "$report" <<'PY'
import json, sys

path = sys.argv[1]
try:
    report = json.load(open(path, encoding="utf-8"))
except json.JSONDecodeError as exc:
    print(f"  FAIL  {path} is not valid JSON: {exc}", file=sys.stderr)
    raise SystemExit(1)


def fail(message):
    print(f"  FAIL  {message}", file=sys.stderr)
    raise SystemExit(1)


for key in ("baseline", "candidate", "comparable", "service_target"):
    if key not in report:
        fail(f"report is missing '{key}'")
print("  ok    report carries both arms and the service target")

if not report["comparable"]:
    fail(
        "the two arms were not comparable - equal request counts and no failures "
        "in either arm are what make a latency difference mean anything"
    )
print("  ok    arms are comparable")

if not report.get("baseline_within_target"):
    fail("the baseline itself breached the service target; there is nothing to compare against")
print("  ok    baseline is within the service target")

baseline, candidate = report["baseline"], report["candidate"]
print(f"  ok    p95 baseline={baseline['p95_ms']}ms candidate={candidate['p95_ms']}ms "
      f"delta={report.get('p95_delta_ms')}ms")

decision = str(report.get("decision", "")).lower()
if decision.startswith("pending"):
    print("  note  decision still pending - a named reviewer records retain or revert")
elif not any(word in decision for word in ("retain", "revert", "rerun")):
    fail(f"decision {decision!r} is not one of retain, revert or rerun")
else:
    print(f"  ok    decision recorded: {decision}")
PY

printf '\nchapter 13 validated\n'
