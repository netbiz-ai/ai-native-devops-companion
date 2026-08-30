#!/usr/bin/env bash
# Chapter 9, Troubleshooting - diagnose Synced but not Healthy
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl -n reference-production rollout status \
  deployment/reference-app --timeout=60s
kubectl -n reference-production get pods
kubectl -n reference-production describe deployment reference-app
