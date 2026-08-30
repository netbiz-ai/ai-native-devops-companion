#!/usr/bin/env bash
# Interlude, Step 5 - build the lab again and re-record the digest
#
# Label: Runnable
# Destructive: creates the kind cluster and registry again, switches your
# current kubectl context, and pushes the image.
#
# Expected result, per the interlude:
#   The same two lines as Steps 1 and 3, and the same digest, because the
#   same source built it.
# --- command as printed, verbatim ---
./scripts/lab-environment/create-cluster.sh
kubectl config use-context kind-ai-native-lab
./scripts/lab-environment/push-image.sh | tee evidence/cluster/image-digest.txt
