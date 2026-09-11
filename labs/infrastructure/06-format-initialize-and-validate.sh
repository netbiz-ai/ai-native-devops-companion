#!/usr/bin/env bash
# The infrastructure lab - CH05, Step 4 - Format, Initialize, and Validate
#
# Label: Runnable
# --- command as printed, verbatim ---
terraform version
terraform fmt -check -recursive infrastructure/terraform/
terraform -chdir=infrastructure/terraform/environments/dev init -backend=false
terraform -chdir=infrastructure/terraform/environments/dev validate
