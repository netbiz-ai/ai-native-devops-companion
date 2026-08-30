#!/usr/bin/env bash
# Interlude, Step 3 - build the reference-app image, push it, and record the digest
#
# Label: Runnable
# Destructive: builds an image and pushes it to the lab registry.
#
# Expected result, per the interlude:
#   image=localhost:5001/reference-app digest=sha256:...
#   followed by the two values Chapter 6 pastes into kustomization.yaml.
# --- command as printed, verbatim ---
./scripts/lab-environment/push-image.sh | tee evidence/cluster/image-digest.txt
