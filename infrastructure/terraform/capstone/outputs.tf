output "namespace" {
  description = "Namespace holding the capstone's Terraform-managed objects."
  value       = kubernetes_namespace.capstone_iac.metadata[0].name
}

output "config_map" {
  description = "Name of the platform-contract ConfigMap."
  value       = kubernetes_config_map.platform_contract.metadata[0].name
}
