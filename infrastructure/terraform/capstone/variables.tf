variable "kubeconfig_path" {
  description = "Kubeconfig used to reach the lab cluster."
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubeconfig context of the lab cluster. Empty means the current context."
  type        = string
  default     = ""
}

variable "run_id" {
  description = "Acceptance-run identifier recorded in the platform contract."
  type        = string
  default     = "capstone-acceptance-001"
}

variable "environment" {
  description = "Declared environment for this acceptance run."
  type        = string
  default     = "non-production"
}
