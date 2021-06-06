#------------------------------------------------------------------------------
# Require Version .12
#------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.0"
}

resource "helm_release" "monitor-thanos-operator" {
  name       = "${var.context_name}-monitoring-thanos"
  repository = "https://kubernetes-charts.banzaicloud.com"
  chart      = "thanos-operator"
  namespace  = var.namespace
}

resource "kubernetes_config_map" "grafana-thanos-dashboards" {
  metadata {
    name      = "${var.context_name}-grafana-thanos-dashboards"
    namespace = var.namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "bucket-replicate.json" = file("${path.module}/dashboards/bucket-replicate.json")
    "compact.json"          = file("${path.module}/dashboards/compact.json")
    "overview.json"         = file("${path.module}/dashboards/overview.json")
    "query.json"            = file("${path.module}/dashboards/query.json")
    "receive.json"          = file("${path.module}/dashboards/receive.json")
    "rule.json"             = file("${path.module}/dashboards/rule.json")
    "sidecar.json"          = file("${path.module}/dashboards/sidecar.json")
    "store.json"            = file("${path.module}/dashboards/store.json")
  }
}
