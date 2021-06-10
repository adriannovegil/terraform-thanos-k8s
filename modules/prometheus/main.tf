#------------------------------------------------------------------------------
# Require Version .12
#------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.0"
}

resource "kubernetes_secret" "monitor-prometheus-sidecar-secret" {
  metadata {
    name      = "thanos"
    namespace = var.namespace
    labels = {
      "sensitive" = "true"
      "app"       = "my-app"
    }
  }
  data = {
    "object-store.yaml" = file("${path.module}/object-store.yaml")
  }
}

resource "helm_release" "monitor-prometheus-operator" {
  name       = "${var.context_name}-monitoring-prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-operator"
  namespace  = var.namespace
  values = [
    "${templatefile("${path.module}/thanos-sidecar.yaml.tpl",
      {retention = var.retention})}"
  ]
}
