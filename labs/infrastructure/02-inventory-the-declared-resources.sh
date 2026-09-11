#!/usr/bin/env bash
# The infrastructure lab - CH05, Step 2 - Inventory the Declared Resources
#
# Label: Runnable
#
# Expected result, per the chapter:
#   infrastructure/terraform/modules/network/main.tf:resource "aws_vpc" "this" {
#   infrastructure/terraform/modules/network/main.tf:resource "aws_subnet" "this" {
#
#   output "vpc_id" {
#     ...
#   }
#
#   output "subnet_ids" {
#     ...
#   }
# --- command as printed, verbatim ---
grep -R '^resource "' infrastructure/terraform/modules/network
sed -n '1,160p' infrastructure/terraform/modules/network/outputs.tf
