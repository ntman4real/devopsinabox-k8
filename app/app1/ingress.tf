resource "kubernetes_ingress" "main" {
  metadata {
    name      = "ing-${var.app_name}"
    namespace = local.namespace

    labels = {
      app = "ingress-${var.app_name}"
    }

    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "kubernetes.io/tls"                                 = true
      "nginx.ingress.kubernetes.io/ssl-redirect"          = true
    }
  }

  spec {
    tls {
      hosts = [local.fqdn]
      secret_name = local.wildcardcert
    }
    rule {
      host = local.fqdn
      http {
        path {
          path = "/"
          backend {
            service_name = "svc-${var.app_name}"#kubernetes_service.main.metadata[0].name
            service_port = local.target_port
          }
        }
      }
    }
  }
  depends_on = [kubernetes_service.main]
}






output "hostname" {
  value = kubernetes_ingress.main.load_balancer_ingress
}
output "ingress_id" {
  value = kubernetes_ingress.main.id
}