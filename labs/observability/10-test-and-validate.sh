#!/usr/bin/env bash
# The observability lab - CH08, Test and Validate
#
# Label: Runnable, terminal one
# --- command as printed, verbatim ---
kubectl -n reference-staging port-forward service/reference-app 8080:80
