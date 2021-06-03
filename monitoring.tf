resource "kubernetes_namespace" "monitoring-namespace" {
  metadata {
    annotations = {
      name = var.context-name
    }
    name = var.context-name
  }
}

resource "helm_release" "monitor-prometheus-operator" {
  name       = "${var.context-name}-monitoring-prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-operator"
  namespace  = kubernetes_namespace.monitoring-namespace.metadata[0].name
}

resource "helm_release" "monitor-thanos-operator" {
  name       = "${var.context-name}-monitoring-thanos"
  repository = "https://kubernetes-charts.banzaicloud.com"
  chart      = "thanos-operator"
  namespace  = kubernetes_namespace.monitoring-namespace.metadata[0].name
}
