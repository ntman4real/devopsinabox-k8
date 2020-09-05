resource "kubernetes_horizontal_pod_autoscaler" "main" {
  count = var.enable_hpa == false ? 0 : 1
  metadata {
    name      = "hpa-${var.app_name}"
    namespace = local.namespace
  }

  spec {
    min_replicas = 1
    max_replicas = 10
    metric {
      type = "Pods"
      pods {
        metric {
          name = "myrequests"
          selector {
            match_labels = {
              verb = "GET"
            }
          }
        }

        target {

          type          = "AverageValue"
          average_value = var.hpa_req
        }
      }
    }

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.main.metadata[0].name
    }
  }
}