#!/usr/bin/env bash
# Chapter 7, Break It Deliberately - run the module's mock-provider Terraform tests
#
# Label: Runnable
#
# Expected result, per the chapter:
#   Success! 2 passed, 0 failed.
# --- command as printed, verbatim ---
cd "$(git rev-parse --show-toplevel)"
cd infrastructure/modules/network
cp ../../environments/dev/.terraform.lock.hcl .terraform.lock.hcl
terraform init -backend=false -lockfile=readonly
terraform test
