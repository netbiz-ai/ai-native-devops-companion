#!/usr/bin/env bash
# Chapter 10, Troubleshooting - The metric query returns no data - inspect Collector logs and regenerate traffic
#
# Label: Runnable (unlabeled in the chapter)
# --- command as printed, verbatim ---
kubectl -n observability logs deploy/otel-collector --since=10m
./labs/ch10/generate-traffic.sh http://127.0.0.1:8080/
