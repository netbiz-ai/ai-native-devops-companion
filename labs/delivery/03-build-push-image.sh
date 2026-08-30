#!/usr/bin/env bash
# Chapter 6, Step 2 - Assemble the controlled delivery workflow - build and push once with Buildx metadata and verify the registry digest
#
# Label: Partial
# Substitute before running: set "$IMAGE" and "$VERSION" for your repository and registry.
# Destructive: pushes an image tag to the container registry
# --- command as printed, verbatim ---
docker buildx build --push \
  --tag "$IMAGE:$VERSION" \
  --metadata-file build-metadata.json .
DIGEST="$(jq -er '."containerimage.digest"' build-metadata.json)"
[[ "$DIGEST" =~ ^sha256:[0-9a-f]{64}$ ]]
docker buildx imagetools inspect "$IMAGE@$DIGEST" >/dev/null
