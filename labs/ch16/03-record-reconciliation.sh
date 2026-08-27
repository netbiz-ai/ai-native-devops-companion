#!/usr/bin/env bash
# Chapter 16, Step 5 - Record the infrastructure reconciliation - apply, drift, reconcile, and retain CAP-03 evidence
#
# Label: Runnable (unlabeled in the chapter)
#
# The local route (default) applies infrastructure/terraform/capstone against
# the lab cluster, induces one out-of-band change, detects it with
# `terraform plan -detailed-exitcode`, reconciles it, and writes
# evidence/capstone/runtime/reconciliation.txt. A reader with an approved
# cloud sandbox sets CAPSTONE_IAC_ROUTE=cloud-sandbox to read the drift
# result from Chapter 7's workspace instead.
# --- command as printed, verbatim ---
bash scripts/capstone-reconcile.sh
