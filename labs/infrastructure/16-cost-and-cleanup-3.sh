#!/usr/bin/env bash
# The infrastructure lab - CH05, Cost and Cleanup
#
# Label: Runnable
# --- command as printed, verbatim ---
test ! -d infrastructure/terraform/environments/dev/.terraform &&
  echo 'PASS: local initialization data removed'
git status --short -- infrastructure/terraform/
