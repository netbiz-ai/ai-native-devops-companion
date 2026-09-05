output "namespace" {
  description = "Namespace holding the capstone's Terraform-managed objects."
  value       = kubernetes_namespace.capstone_iac.metadata[0].name
}

output "config_map" {
  description = "Name of the platform-contract ConfigMap."
  value       = kubernetes_config_map.platform_contract.metadata[0].name
}

# CAP-03 compares three values that can disagree: the run the operator asked
# for, the run recorded in state, and the run stamped on the live object. This
# output is how the state copy is read back without parsing the state file.
output "run_id" {
  description = "Acceptance run recorded in the platform contract by this state."
  value       = kubernetes_config_map.platform_contract.data["run_id"]
}
