#!/usr/bin/env bash
# The delivery lab - CH04, Step 6 - Dispatch and Review One Complete Release
#
# Label: Runnable
# --- command as printed, verbatim ---
set -Eeuo pipefail
gh release download ch04-bootstrap \
  --pattern release-evidence.json \
  --output ch04-bootstrap-evidence.json \
  --clobber
jq '{image, digest, decision, run_url, approver}' \
  ch04-bootstrap-evidence.json
bootstrap_digest="$(jq -er '.digest' ch04-bootstrap-evidence.json)"
[[ "$bootstrap_digest" =~ ^sha256:[0-9a-f]{64}$ ]]
