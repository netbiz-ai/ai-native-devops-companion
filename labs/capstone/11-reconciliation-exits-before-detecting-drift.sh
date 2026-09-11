#!/usr/bin/env bash
# The capstone lab - CH13, Symptom: Reconciliation Exits Before Detecting Drift
#
# Label: Runnable:
# --- command as printed, verbatim ---
kubectl config current-context
terraform -chdir=infrastructure/terraform/capstone init -input=false
terraform -chdir=infrastructure/terraform/capstone plan -detailed-exitcode \
  -input=false -var "run_id=$CAPSTONE_RUN_ID"
printf 'plan_exit=%s\n' "$?"
