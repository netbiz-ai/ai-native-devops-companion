#!/usr/bin/env bash
# Chapter 12, Troubleshooting: The alert fires but requests appear healthy - inspect service and endpoints, then regenerate traffic
#
# Label: Runnable
#
# --- command as printed, verbatim ---
kubectl -n reference-incident get service,endpoints
labs/incident/generate-traffic.sh --duration 60
