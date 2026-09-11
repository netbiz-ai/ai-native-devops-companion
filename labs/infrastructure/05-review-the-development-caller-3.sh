#!/usr/bin/env bash
# The infrastructure lab - CH05, Step 3 - Review the Development Caller
#
# Label: Runnable
#
# Expected result, per the chapter:
#   .../variables.tf:...:variable "vpc_cidr" {
#   .../main.tf:...:cidr_block = var.vpc_cidr
#   .../main.tf:...:map_public_ip_on_launch = false
#   ...
# --- command as printed, verbatim ---
grep -R -nE 'vpc_cidr|cidr_block|map_public_ip_on_launch|Owner|Environment|ExpiresAt' \
  infrastructure/terraform/modules/network \
  infrastructure/terraform/environments/dev
