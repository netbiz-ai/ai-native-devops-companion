#!/usr/bin/env bash
# The kubernetes lab - CH06, Step 5 - Prove Allowed and Denied Access
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl delete pod reference-client \
  --namespace reference-dev \
  --wait=true
