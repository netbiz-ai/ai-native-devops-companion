#!/usr/bin/env bash
# Tear down what create-cluster.sh created, so the lab stays disposable.
#
# Label: Runnable.
# Destructive: deletes the named kind cluster and its registry container,
# including every workload and image in them. It touches nothing else - a
# registry or cluster under a different name is left alone.
#
# Expected result:
#   deleted cluster=<name> registry=<name>
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-ai-native-lab}"
REG_NAME="${REG_NAME:-${CLUSTER_NAME}-registry}"

kind delete cluster --name "$CLUSTER_NAME"
docker rm -f "$REG_NAME" >/dev/null 2>&1 || true

echo "deleted cluster=${CLUSTER_NAME} registry=${REG_NAME}"
