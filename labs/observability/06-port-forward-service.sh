#!/usr/bin/env bash
# The observability lab, Test and Validate - port-forward the staging service for local requests
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl -n reference-staging port-forward service/reference-app 8080:8080
