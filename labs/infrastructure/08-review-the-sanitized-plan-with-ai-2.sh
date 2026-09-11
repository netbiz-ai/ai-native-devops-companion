#!/usr/bin/env bash
# The infrastructure lab - CH05, Step 5 - Review the Sanitized Plan with AI
#
# Label: Runnable
#
# Expected result, per the chapter:
#   PASS: no selected account or credential pattern found
# --- command as printed, verbatim ---
if grep -Eq '[0-9]{12}|arn:aws|AKIA|ASIA' infrastructure/terraform/fixtures/ch07-dev-plan.txt; then
  echo 'STOP: possible account or credential pattern found; share nothing until you have read the match'
else
  echo 'PASS: no selected account or credential pattern found'
fi
