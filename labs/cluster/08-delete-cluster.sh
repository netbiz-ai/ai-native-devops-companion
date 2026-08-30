#!/usr/bin/env bash
# Interlude, Step 5 - tear the lab down and confirm it is gone
#
# Label: Runnable
# Destructive: deletes the ai-native-lab kind cluster and its registry
# container, including every workload and image in them. Clusters and
# containers under other names are left alone.
#
# Expected result, per the interlude:
#   deleted cluster=ai-native-lab registry=ai-native-lab-registry
#   and neither name appears in the two listings that follow.
# --- command as printed, verbatim ---
./scripts/lab-environment/delete-cluster.sh
kind get clusters
docker ps --filter name=ai-native-lab --format '{{.Names}}'
