#!/usr/bin/env bash
# Chapter 10, Test and Validate - port-forward the staging service for local requests
#
# Label: Runnable
# --- command as printed, verbatim ---
kubectl -n reference-staging port-forward service/reference-app 8080:8080
