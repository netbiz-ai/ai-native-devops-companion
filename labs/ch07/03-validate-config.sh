#!/usr/bin/env bash
# Chapter 7, Step 4 - Format, initialize, and validate - run fmt, init, validate, and the Trivy scan
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Success! The configuration is valid.
# --- command as printed, verbatim ---
cd infrastructure/environments/dev
terraform fmt -check -recursive ../..
terraform init
terraform validate
trivy config --misconfig-scanners terraform --severity HIGH,CRITICAL --exit-code 1 ../..
