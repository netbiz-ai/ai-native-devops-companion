#!/usr/bin/env bash
# Interlude, Step 2 - remove the probe namespace once enforcement is proved
#
# Label: Runnable
# Destructive: deletes the policy-check Namespace and everything in it.
#
# Expected result, per the interlude:
#   namespace "policy-check" deleted
# --- command as printed, verbatim ---
kubectl delete namespace policy-check --wait
