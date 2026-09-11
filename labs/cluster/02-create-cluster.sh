#!/usr/bin/env bash
# Interlude, Step 1 - create the cluster and its registry, then confirm the node is Ready
#
# Label: Runnable
# Destructive: creates a kind cluster, a registry container, and cluster
# objects in the current docker daemon, and switches your current kubectl
# context. 08-delete-cluster.sh removes what it creates.
#
# Expected result, per the interlude:
#   cluster=ai-native-lab registry=localhost:5001 calico=ready
#   followed by one Ready control-plane node.
# --- command as printed, verbatim ---
./scripts/lab-environment/create-cluster.sh
kubectl config use-context kind-ai-native-lab
kubectl get nodes
