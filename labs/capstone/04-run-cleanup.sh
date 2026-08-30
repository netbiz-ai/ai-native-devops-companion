#!/usr/bin/env bash
# Chapter 16, Cost and Cleanup - remove the capstone's temporary resources
#
# Label: Runnable (unlabeled in the chapter)
# Destructive: destroys the capstone's Terraform-managed objects, then deletes
# the lab namespaces, the Argo CD Applications and AppProject, and the local
# lab images - by name, in the current kubectl context only. It does not
# delete the cluster, the registry, or any cloud resource; cloud teardown is
# labs/infrastructure/07-destroy-lab.sh against your own approved sandbox.
# --- command as printed, verbatim ---
terraform -chdir=infrastructure/terraform/capstone destroy -auto-approve
bash scripts/capstone-cleanup.sh
