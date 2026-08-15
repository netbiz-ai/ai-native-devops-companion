#!/usr/bin/env bash
# Chapter 15, Troubleshooting: The service account can read more resources than expected - list effective permissions to diagnose over-broad access
#
# Label: Runnable (unlabeled in the chapter)
#
# --- command as printed, verbatim ---
kubectl auth can-i --list \
  --as=system:serviceaccount:reference-staging:diagnostics-agent \
  -n reference-staging
