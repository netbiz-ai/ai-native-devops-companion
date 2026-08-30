#!/usr/bin/env bash
# Verify a GitHub repository ruleset before anyone applies it.
#
# Chapter 11 has the reader author docs/security/security-ruleset.json and POST
# it to a repository. A ruleset decides which checks are required and who may
# bypass them, so applying one you have not read is handing over the gate you
# just built. This script reads it for you and refuses the shapes that quietly
# disable enforcement.
#
# It checks structure, not policy. Whether *your* five check names are the
# right five is a review question; whether the document will enforce anything
# at all is a factual one, and that is what this answers.
#
# Usage: labs/security/verify-security-ruleset.sh [path]
#        default path: docs/security/security-ruleset.json
set -euo pipefail

ruleset="${1:-docs/security/security-ruleset.json}"

pass() { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1" >&2; exit 1; }

test -f "$ruleset" || fail "$ruleset not found - author it before applying it"

python3 - "$ruleset" <<'PY'
import json
import sys

path = sys.argv[1]


def fail(message: str) -> None:
    print(f"  FAIL  {message}", file=sys.stderr)
    raise SystemExit(1)


def ok(message: str) -> None:
    print(f"  ok    {message}")


try:
    document = json.loads(open(path, encoding="utf-8").read())
except json.JSONDecodeError as exc:
    fail(f"{path} is not valid JSON: {exc}")

if not isinstance(document, dict):
    fail("ruleset must be a JSON object")
ok("parses as JSON")

# A ruleset in evaluate mode reports what it would have blocked and blocks
# nothing. It is the correct way to trial a rule and the wrong way to ship one,
# and the difference is one word in a file nobody rereads.
enforcement = document.get("enforcement")
if enforcement != "active":
    fail(f"enforcement is {enforcement!r}, so this ruleset blocks nothing - expected 'active'")
ok("enforcement is active")

target = document.get("target")
if target != "branch":
    fail(f"target is {target!r} - expected 'branch'")
ok("targets branches")

rules = document.get("rules")
if not isinstance(rules, list) or not rules:
    fail("'rules' must be a non-empty list")

by_type = {rule.get("type") for rule in rules if isinstance(rule, dict)}
required_checks = [
    rule for rule in rules
    if isinstance(rule, dict) and rule.get("type") == "required_status_checks"
]
if not required_checks:
    fail("no required_status_checks rule - nothing is actually required")

checks = required_checks[0].get("parameters", {}).get("required_status_checks", [])
names = [check.get("context") for check in checks if isinstance(check, dict)]
if not names:
    fail("required_status_checks rule names no checks")
ok(f"requires {len(names)} check(s): {', '.join(sorted(filter(None, names)))}")

# Without this, a stale green run on an old commit satisfies the gate.
if required_checks[0].get("parameters", {}).get("strict_required_status_checks_policy") is not True:
    fail(
        "strict_required_status_checks_policy is not true, so a check that passed "
        "on an older commit would still satisfy the gate"
    )
ok("checks must pass on the latest commit")

if "non_fast_forward" not in by_type:
    print(
        "  warn  no non_fast_forward rule: history on this branch can be rewritten",
        file=sys.stderr,
    )

# Bypass actors are the part people skim. An empty list is fine and an
# unreviewed list is not, so the script prints them rather than judging them.
actors = document.get("bypass_actors") or []
if actors:
    described = ", ".join(
        f"{actor.get('actor_type', '?')}:{actor.get('actor_id', '?')}"
        f"({actor.get('bypass_mode', '?')})"
        for actor in actors
        if isinstance(actor, dict)
    )
    print(f"  ok    {len(actors)} bypass actor(s) declared - review them: {described}")
else:
    ok("no bypass actors")
PY

pass "ruleset verified: $ruleset"
