#!/usr/bin/env bash
# Create the disposable lab cluster: kind, plus a local registry the cluster
# can pull from, plus the Calico network plugin.
#
# Label: Runnable. Needs docker, kind, and kubectl on PATH.
# Destructive: creates a kind cluster, a registry container, and cluster
# objects in the current docker daemon. delete-cluster.sh removes them.
#
# The names are variables so a second lab never collides with an existing
# cluster or registry. Override them the same way in push-image.sh and
# delete-cluster.sh:
#
#   CLUSTER_NAME=my-lab ./scripts/lab-environment/create-cluster.sh
#
# Expected result:
#   cluster=<name> registry=localhost:<port> calico=ready
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-ai-native-lab}"
REG_NAME="${REG_NAME:-${CLUSTER_NAME}-registry}"
REG_PORT="${REG_PORT:-5001}"
CALICO_VERSION="${CALICO_VERSION:-v3.28.2}"

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for tool in docker kind kubectl; do
  command -v "$tool" >/dev/null || { echo "missing tool: $tool" >&2; exit 1; }
done

# 1. The registry container, if it is not already running.
if [ "$(docker inspect -f '{{.State.Running}}' "$REG_NAME" 2>/dev/null || true)" != "true" ]; then
  docker run -d --restart=always -p "127.0.0.1:${REG_PORT}:5000" \
    --network bridge --name "$REG_NAME" registry:2 >/dev/null
fi

# 2. The cluster.
kind create cluster --name "$CLUSTER_NAME" --config "$here/kind-cluster.yaml"

# 3. Tell every node how to reach the registry as localhost:<port>.
REGISTRY_DIR="/etc/containerd/certs.d/localhost:${REG_PORT}"
for node in $(kind get nodes --name "$CLUSTER_NAME"); do
  docker exec "$node" mkdir -p "$REGISTRY_DIR"
  cat <<EOF | docker exec -i "$node" cp /dev/stdin "${REGISTRY_DIR}/hosts.toml"
[host."http://${REG_NAME}:5000"]
EOF
done

# 4. Put the registry on the cluster's network so the nodes can resolve it.
if [ "$(docker inspect -f '{{json .NetworkSettings.Networks.kind}}' "$REG_NAME")" = "null" ]; then
  docker network connect kind "$REG_NAME"
fi

# 5. Advertise the registry to tooling, per the standard kind recipe.
cat <<EOF | kubectl --context "kind-${CLUSTER_NAME}" apply -f - >/dev/null
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:${REG_PORT}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF

# 6. Calico, so NetworkPolicy is enforced rather than silently ignored.
kubectl --context "kind-${CLUSTER_NAME}" apply -f \
  "https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/calico.yaml" >/dev/null
kubectl --context "kind-${CLUSTER_NAME}" -n kube-system rollout status \
  daemonset/calico-node --timeout=180s >/dev/null

echo "cluster=${CLUSTER_NAME} registry=localhost:${REG_PORT} calico=ready"
