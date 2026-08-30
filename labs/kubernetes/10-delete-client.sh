#!/usr/bin/env bash
# Chapter 8, Build It Step 5 - delete the test client Pod after retaining the result
#
# Label: Runnable
# Destructive: deletes the reference-client Pod from the reference-dev namespace
#
# --- command as printed, verbatim ---
kubectl delete pod reference-client \
  --namespace reference-dev \
  --wait=true
