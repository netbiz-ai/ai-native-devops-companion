#!/usr/bin/env bash
# The infrastructure lab - CH05, Symptom: Validation Succeeds in the Wrong Directory
#
# Label: Runnable
#
# Expected result, per the chapter:
#   infrastructure/terraform/environments/dev/main.tf
#   infrastructure/terraform/environments/dev/variables.tf
#   infrastructure/terraform/environments/dev/versions.tf
# --- command as printed, verbatim ---
find infrastructure/terraform/environments/dev -maxdepth 1 -name '*.tf' -print
