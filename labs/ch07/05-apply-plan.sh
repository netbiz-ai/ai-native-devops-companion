#!/usr/bin/env bash
# Chapter 7, Test and Validate - apply the reviewed plan and check convergence
#
# Label: Runnable
# Destructive: creates the lab VPC and two subnets in the sandbox AWS account
# --- command as printed, verbatim ---
terraform apply tfplan
terraform plan -detailed-exitcode
