#!/usr/bin/env bash
# The security lab - CH09, Prerequisites
#
# Label: Runnable
#
# Expected result, per the chapter:
#   chapter=security state=start tag=security-start branch=lab/security ...
#   ...
#   Logged in to github.com account ...
# --- command as printed, verbatim ---
make security-start
test -f .github/workflows/security.yml
test -f security/finding-disposition-template.yaml
test -x labs/security/verify-security-ruleset.sh
actionlint --version
docker --version
semgrep --version
gh auth status
jq --version
