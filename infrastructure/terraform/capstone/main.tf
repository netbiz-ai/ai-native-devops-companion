# The capstone's Infrastructure as Code contract, local route.
#
# Chapter 7's sandbox track proves drift detection against a cloud account you
# approve. This configuration proves the same discipline against the lab
# cluster you already run, so CAP-03 has a state file, a declared object, and a
# live object to compare on every route. It manages exactly one namespace and
# one ConfigMap, in a namespace of its own, so nothing here competes with the
# GitOps controller over the reference workloads.

resource "kubernetes_namespace" "capstone_iac" {
  metadata {
    name = "capstone-iac"

    labels = {
      "app.kubernetes.io/part-of"    = "ai-native-devops"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "kubernetes_config_map" "platform_contract" {
  metadata {
    name      = "platform-contract"
    namespace = kubernetes_namespace.capstone_iac.metadata[0].name

    labels = {
      "app.kubernetes.io/part-of"    = "ai-native-devops"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  data = {
    run_id      = var.run_id
    environment = var.environment
  }
}
