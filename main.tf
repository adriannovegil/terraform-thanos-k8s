#------------------------------------------------------------------------------
# Require Version .12
#------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.0"
}

resource "kubernetes_namespace" "monitoring-namespace" {
  metadata {
    annotations = {
      name = var.context_name
    }
    name = var.context_name
  }
}

module "monitoring-prometheus" {
  source = "./modules/prometheus"

  context_name = var.context_name
  namespace    = kubernetes_namespace.monitoring-namespace.metadata[0].name
}

module "monitoring-thanos" {
  source = "./modules/thanos"

  context_name = var.context_name
  namespace    = kubernetes_namespace.monitoring-namespace.metadata[0].name
}
