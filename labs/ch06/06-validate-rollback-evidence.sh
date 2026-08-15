#!/usr/bin/env bash
# Chapter 6, Step 4 - Assemble and audit rollback - validate a rollback request against recorded release evidence before pulling the digest
#
# Label: Partial
# Substitute before running: set "$DIGEST", "$REFERENCE", and "$IMAGE", and provide the release-evidence.json asset from the approved release.
# --- command as printed, verbatim ---
[[ "$DIGEST" =~ ^sha256:[0-9a-f]{64}$ ]]
[[ "$REFERENCE" =~ ^[A-Za-z0-9._/-]{3,80}$ ]]
test "$(jq -r .image release-evidence.json)" = "$IMAGE"
test "$(jq -r .digest release-evidence.json)" = "$DIGEST"
test "$(jq -r .decision release-evidence.json)" = "Promote"
docker pull "$IMAGE@$DIGEST"
