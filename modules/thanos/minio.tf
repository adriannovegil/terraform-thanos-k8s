resource "kubernetes_deployment" "minio_deployment" {
  metadata {
    name      = "minio-deployment"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "minio"
      }
    }
    template {
      metadata {
        labels = {
          app = "minio"
        }
      }
      spec {
        container {
          name  = "minio"
          image = "minio/minio"
          args  = ["server", "/storage"]
          port {
            container_port = 9000
          }
          env {
            name  = "MINIO_ACCESS_KEY"
            value = "minio_access_key"
          }
          env {
            name  = "MINIO_SECRET_KEY"
            value = "minio_secret_key"
          }
          env {
            name  = "MINIO_REGION"
            value = "test_region"
          }
          readiness_probe {
            http_get {
              path = "/minio/health/ready"
              port = "9000"
            }
            initial_delay_seconds = 10
            period_seconds        = 5
          }
        }
      }
    }
    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_service" "minio_service" {
  metadata {
    name      = "minio-service"
    namespace = var.namespace
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 9000
      target_port = "9000"
    }
    selector = {
      app = "minio"
    }
  }
}
