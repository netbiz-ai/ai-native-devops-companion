#!/usr/bin/env bash
# Chapter 7, Cost and Cleanup - plan, review, and apply destruction, then verify empty state
#
# Label: Runnable - destructive
# Destructive: deletes the lab VPC and subnets from the sandbox AWS account
# --- command as printed, verbatim ---
terraform plan -destroy -out=destroy.tfplan
terraform show -no-color destroy.tfplan
terraform apply destroy.tfplan
terraform plan -destroy -detailed-exitcode
terraform state list
