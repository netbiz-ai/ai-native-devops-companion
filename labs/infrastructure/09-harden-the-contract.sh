#!/usr/bin/env bash
# The infrastructure lab - CH05, Step 6 - Harden the Contract
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Success! The configuration is valid.
# --- command as printed, verbatim ---
terraform fmt -check -recursive infrastructure/terraform/
terraform -chdir=infrastructure/terraform/environments/dev validate
git diff --check -- infrastructure/terraform/
git diff -- infrastructure/terraform/modules/network/variables.tf
