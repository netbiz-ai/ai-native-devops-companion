#!/usr/bin/env bash
# The infrastructure lab - CH05, Symptom: Initialization Requests Credentials or Backend Access
#
# Label: Runnable
# --- command as printed, verbatim ---
pwd
terraform -chdir=infrastructure/terraform/environments/dev init -backend=false
