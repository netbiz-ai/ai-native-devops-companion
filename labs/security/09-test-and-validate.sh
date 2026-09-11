#!/usr/bin/env bash
# The security lab - CH09, Test and Validate
#
# Label: Runnable
# --- command as printed, verbatim ---
ruleset_file="$(git rev-parse --git-path ch09-security-ruleset.json)"
actionlint .github/workflows/security.yml
test -s security/finding-disposition-template.yaml
for field in finding_id scanner artifact_identity disposition owner \
  validation_plan expiry sanitization_status evidence_path; do
  grep -Eq "^${field}:" security/finding-disposition-template.yaml
done
grep -c '^  - id:' rules/semgrep.yml
grep -E '^    name: (SAST|Dependencies|Secrets|IaC|Image)$' \
  .github/workflows/security.yml | wc -l
labs/security/verify-security-ruleset.sh "$ruleset_file"
jq -e '[.rules[] | select(.type == "required_status_checks") | .parameters.required_status_checks[].integration_id] as $ids | ($ids | length) == 5 and ($ids | unique | length) == 1 and ($ids | all(type == "number"))' \
  "$ruleset_file" >/dev/null
git diff --check
gh pr checks
gh ruleset check --default
