#!/usr/bin/env bash
# The security lab - CH09, Step 5 - Require the Exact Names
#
# Label: Runnable
# --- command as printed, verbatim ---
ruleset_file="$(git rev-parse --git-path ch09-security-ruleset.json)"
cat >"$ruleset_file" <<'JSON'
{
  "name": "default-branch-security-gates",
  "target": "branch",
  "enforcement": "active",
  "bypass_actors": [],
  "conditions": {
    "ref_name": {
      "include": ["~DEFAULT_BRANCH"],
      "exclude": []
    }
  },
  "rules": [
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": true,
        "do_not_enforce_on_create": false,
        "required_status_checks": [
          {"context": "SAST"},
          {"context": "Dependencies"},
          {"context": "Secrets"},
          {"context": "IaC"},
          {"context": "Image"}
        ]
      }
    },
    {"type": "non_fast_forward"}
  ]
}
JSON
