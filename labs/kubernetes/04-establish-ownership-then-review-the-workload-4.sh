#!/usr/bin/env bash
# The kubernetes lab - CH06, Step 1 - Establish Ownership, Then Review the Workload
#
# Label: Runnable
# --- command as printed, verbatim ---
(
if grep -ERn 'REPLACE_WITH|00000000000000000000000000000000' \
  deployment/kubernetes/base; then
  echo 'STOP: replace every ownership and image placeholder' >&2
  exit 1
fi
)
