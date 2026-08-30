#!/usr/bin/env bash
# Build the reference-app image, push it to the lab registry, and print the
# digest that replaces the all-zero placeholder in
# deployment/kubernetes/base/kustomization.yaml.
#
# Label: Runnable. Needs docker, and a registry from create-cluster.sh
# (or set REG_HOST to any registry your cluster can pull from).
# Destructive: builds an image and pushes it to that registry.
#
# Expected result:
#   image=localhost:<port>/reference-app digest=sha256:<64 hex characters>
#   followed by the two lines to paste into kustomization.yaml.
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-ai-native-lab}"
REG_PORT="${REG_PORT:-5001}"
REG_HOST="${REG_HOST:-localhost:${REG_PORT}}"
IMAGE="${REG_HOST}/reference-app"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

command -v docker >/dev/null || { echo "missing tool: docker" >&2; exit 1; }

# Buildx attaches a provenance attestation stamped with the build's own time,
# which changes the manifest-list digest on every rebuild - including a fully
# cached rebuild that changed nothing. A digest that moves for no reason is
# the wrong lesson at the step where the reader learns to pin one, so turn the
# attestation off where the flag exists. Docker Engine 25, the supported
# floor, has it; a classic builder does not, and there the digest still moves.
provenance=()
if docker build --help 2>/dev/null | grep -q -- '--provenance'; then
  provenance=(--provenance=false)
fi

docker build "${provenance[@]}" -t "${IMAGE}:lab" "$repo_root/reference-app"
docker push "${IMAGE}:lab" >/dev/null

digest="$(docker inspect --format='{{index .RepoDigests 0}}' "${IMAGE}:lab" | cut -d@ -f2)"

echo "image=${IMAGE} digest=${digest}"
echo
echo "Put these two values in deployment/kubernetes/base/kustomization.yaml:"
echo
echo "    newName: ${IMAGE}"
echo "    digest: ${digest}"
echo
echo "Then commit the change - the GitOps chapter's Argo CD reconciles from Git, not from your working tree."
