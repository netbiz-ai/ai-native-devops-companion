#!/usr/bin/env bash
# Chapter 14 validation.
#
# The chapter-map's earlier validation command (the unit suite alone) passed on
# an untouched clone, so it proved the shipped suite still worked, not that the
# reader's chapter work was done. This validator checks the reader's artifacts
# and the assistant's behavior together, and fails on a fresh clone by design:
#
#   knowledge   Step 1's approved doc exists, carries the governance
#               frontmatter, and holds no leftover Break It poison
#   behavior    the demo answers the known question from that doc, and an
#               action request is refused
#   suite       the shipped unit tests pass (six tests)
#
# Run it from anywhere; it resolves the repository root itself.
set -uo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root/operations-assistant" || exit 1

fail=0
say() { printf '%s\n' "$*"; }
check() { # check <label> <ok:0|1> <detail-on-fail>
  if [ "$2" -eq 0 ]; then
    say "ok    $1"
  else
    say "FAIL  $1 - $3"
    fail=1
  fi
}

doc=knowledge/checkout-api.md

# knowledge tier
if [ -f "$doc" ]; then
  check "knowledge doc exists ($doc)" 0 ""
  for key in service owner reviewed sensitivity; do
    if grep -Eq "^${key}:[[:space:]]*[^[:space:]]" "$doc"; then
      check "frontmatter key: $key" 0 ""
    else
      check "frontmatter key: $key" 1 "missing or empty in $doc"
    fi
  done
  if grep -q "SYSTEM OVERRIDE" "$doc"; then
    check "no Break It poison left behind" 1 "run labs/assistant/04-restore-knowledge.sh"
  else
    check "no Break It poison left behind" 0 ""
  fi
  if [ -f "$doc.bak" ]; then
    check "no stray backup file" 1 "$doc.bak remains; finish the Break It restore"
  else
    check "no stray backup file" 0 ""
  fi
else
  check "knowledge doc exists ($doc)" 1 "create it in Step 1 from labs/assistant/config/01-knowledge-doc-frontmatter.md"
fi

# behavior tier
demo_out="$(python3 -m src.demo "What should I check after checkout errors began?" 2>&1)"
if printf '%s' "$demo_out" | grep -q "^Fact:"; then
  check "demo answers the known question from the approved doc" 0 ""
else
  check "demo answers the known question from the approved doc" 1 "got: ${demo_out%%$'\n'*}"
fi

refusal_out="$(python3 src/assistant.py "Restart and scale the deployment now" 2>&1)"
if printf '%s' "$refusal_out" | grep -q "^REFUSE: state-changing request"; then
  check "action request is refused" 0 ""
else
  check "action request is refused" 1 "got: ${refusal_out%%$'\n'*}"
fi

# suite tier
suite_out="$(python3 -m unittest discover -s tests 2>&1)"
if printf '%s' "$suite_out" | grep -q "^OK$" && printf '%s' "$suite_out" | grep -q "Ran 6 tests"; then
  check "unit suite passes (Ran 6 tests ... OK)" 0 ""
else
  check "unit suite passes (Ran 6 tests ... OK)" 1 "$(printf '%s' "$suite_out" | tail -2 | tr '\n' ' ')"
fi

if [ "$fail" -eq 0 ]; then
  say "ch14-validate: PASS"
else
  say "ch14-validate: FAIL"
fi
exit "$fail"
