#!/usr/bin/env bash
# The infrastructure lab, Prerequisites - create the lab branch, record tool versions, scaffold directories
#
# Label: Runnable
# --- command as printed, verbatim ---
git switch -c chapter-07-iac
terraform version
aws --version
trivy --version
mkdir -p infrastructure/modules/network infrastructure/environments/dev docs/decisions
