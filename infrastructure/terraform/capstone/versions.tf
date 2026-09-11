terraform {
  required_version = ">= 1.7, < 2.0"

  # The capstone's identity check needs state on disk to compare against, and
  # this route must work with no cloud account, so the backend is explicit
  # rather than implied: state lives next to the configuration.
  backend "local" {}

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path    = pathexpand(var.kubeconfig_path)
  config_context = var.kube_context != "" ? var.kube_context : null
}
