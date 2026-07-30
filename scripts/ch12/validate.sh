#!/usr/bin/env bash
set -euo pipefail

record="${1:-incidents/templates/facts-incident-record.md}"
test -s "$record"
grep -q '^## Frame' "$record"
grep -q '^## Acquire evidence' "$record"
grep -q '^## Compare hypotheses' "$record"
grep -q '^## Take bounded action' "$record"
grep -q '^## Stabilize and learn' "$record"
printf 'facts_record_structure=pass file=%s\n' "$record"
