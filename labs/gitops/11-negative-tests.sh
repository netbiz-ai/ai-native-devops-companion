#!/usr/bin/env bash
# The gitops lab - CH07, Negative Tests
#
# Label: Runnable - changes only temporary files
# --- command as printed, verbatim ---
(
awk -F '\t' -v OFS='\t' -v digest="$STAGING_DIGEST" '
  $1 == "Deployment" { $4 = "example.invalid/reference-app@sha256:0000000000000000000000000000000000000000000000000000000000000000" }
  $1 == "Service" { $4 = "example.invalid/reference-app@" digest }
  { print }
' /tmp/reference-production-inventory.tsv \
  > /tmp/reference-digest-wrong-object.tsv

if validate_inventory /tmp/reference-digest-wrong-object.tsv \
  reference-production "$STAGING_DIGEST"; then
  echo 'STOP: digest in wrong object passed' >&2
  exit 1
fi

awk -F '\t' -v OFS='\t' '
  $1 == "Deployment" { $3 = "reference-staging" }
  { print }
' /tmp/reference-production-inventory.tsv \
  > /tmp/reference-wrong-namespace.tsv

if validate_inventory /tmp/reference-wrong-namespace.tsv \
  reference-production "$STAGING_DIGEST"; then
  echo 'STOP: wrong Deployment namespace passed' >&2
  exit 1
fi

rm -f /tmp/reference-digest-wrong-object.tsv \
  /tmp/reference-wrong-namespace.tsv
echo 'EXPECTED FAILURE: both false-pass fixtures were rejected'
)
