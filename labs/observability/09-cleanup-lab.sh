#!/usr/bin/env bash
# The observability lab, Cost and Cleanup - delete the temporary alert sink and confirm the app is healthy
#
# Label: Runnable
# Destructive: deletes the ch10-alert-sink deployment in the observability namespace
#
# Expected result, per the chapter:
#   Temporary workloads are absent.
#   The fault configuration matches the completed baseline.
#   The application is available and normal telemetry continues.
# --- command as printed, verbatim ---
kubectl -n observability delete deployment ch10-alert-sink \
  --ignore-not-found
kubectl -n reference-staging rollout status deployment/reference-app
