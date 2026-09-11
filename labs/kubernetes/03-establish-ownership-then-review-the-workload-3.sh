#!/usr/bin/env bash
# The kubernetes lab - CH06, Step 1 - Establish Ownership, Then Review the Workload
#
# Label: Runnable - builds and pushes an image, then creates and deletes a pull test Pod
# --- command as printed, verbatim ---
./labs/cluster/05-push-image.sh
./labs/cluster/06-verify-pull-by-digest.sh
