resource "kubernetes_service" "main" {
  metadata {
    name      = "svc-${var.app_name}"
    namespace = local.namespace
  }
  spec {
//    type          = "NodePort" #supported values: "ClusterIP", "ExternalName", "LoadBalancer", "NodePort"
//    external_name = "${var.app_name}.${local.eks_zone}"
    port {
      port        = local.target_port
      target_port = local.container_port
    }

    selector = {
      app = var.app_name
    }

  }
  timeouts {
    create = "2m"
  }
}
output "service_id" {
  value = kubernetes_service.main.id
}