resource "kubernetes_deployment" "main" {
  metadata {
    name      = "dep-${var.app_name}"
    namespace = local.namespace
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.app_name
      }
    }
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 1
        max_unavailable = 0
      }

    }
    template {
      metadata {
        labels = {
          app = var.app_name
          "app.kubernetes.io/name" = "ingress-nginx"

        }
        annotations = {
          "prometheus.io/scrape" = true
          "prometheus.io/path"   = "/status/format/prometheus"
        }
      }
      spec {

        container {
          name              = var.app_name
          image             = var.image
          image_pull_policy = "IfNotPresent"
          command           = ["/entrypoint.sh"] #EntryPoint
          resources {
            requests {
              cpu    = "1m"
              memory = "5Mi"
            }
          }
          port {
            container_port = local.container_port
          }
          env {
            name  = "name"
            value = "${var.app_name}_local"
          }
//          env {
//            name  = "region"
//            value = data.aws_region.current.name
//          }
          env {
            name  = "hostname"
            value = var.app_name
          }
          env {
            name  = "TZ"
            value = "America/New_York"
          }
//          env {
//            name  = "thisenv"
//            value = local.env
//          }
//          env {
//            name  = "timestamp"
//            value = local.timestamp
//          }
        }

        image_pull_secrets {
          name = data.kubernetes_secret.glcreds.metadata[0].name
        }
      }
    }
  }
  timeouts {
    create = "3m"
    update = "3m"
  }
}