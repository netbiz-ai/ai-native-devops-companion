#!/usr/bin/env bash
# The agent lab - CH12, Symptom: The Optional Identity Has Unexpected Permissions
#
# Label: Runnable, optional Tier 3:
#
# Expected result, per the chapter:
#   no
# --- command as printed, verbatim ---
kubectl auth can-i get secrets \
  --as=system:serviceaccount:reference-staging:diagnostics-agent \
  -n reference-staging
