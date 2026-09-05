#!/usr/bin/env bash
# The observability lab, Prerequisites - Required environment - record cluster context, namespaces, and tool versions
#
# Label: Runnable
#
# Expected result, per the chapter:
#   The current context is the authorized lab cluster.
#   The two namespaces exist, and client versions are recorded.
# --- command as printed, verbatim ---
kubectl config current-context
kubectl get namespace reference-staging observability
promtool --version
otelcol-contrib --version
curl --version
jq --version
