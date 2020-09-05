resource "kubernetes_service_account" "custom_metrics_apiserver" {
  metadata {
    name      = "custom-metrics-apiserver"
    namespace = "myutils"
  }
}

resource "kubernetes_cluster_role" "custom_metrics_resource_reader" {
  metadata {
    name = "custom-metrics-resource-reader"
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = [""]
    resources  = ["nodes", "namespaces", "pods", "services"]
  }
}

resource "kubernetes_cluster_role" "custom_metrics_server_resources" {
  metadata {
    name = "custom-metrics-server-resources"
  }

  rule {
    verbs      = ["*"]
    api_groups = ["custom.metrics.k8s.io"]
    resources  = ["*"]
  }
}

resource "kubernetes_role_binding" "custom_metrics_auth_reader" {
  metadata {
    name      = "custom-metrics-auth-reader"
    namespace = "kube-system"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "custom-metrics-apiserver"
    namespace = "myutils"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "extension-apiserver-authentication-reader"
  }
}

resource "kubernetes_cluster_role_binding" "custom_metrics_resource_reader" {
  metadata {
    name = "custom-metrics-resource-reader"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "custom-metrics-apiserver"
    namespace = "myutils"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "custom-metrics-resource-reader"
  }
}

resource "kubernetes_cluster_role_binding" "custom_metrics" {
  metadata {
    name = "custom-metrics:system:auth-delegator"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "custom-metrics-apiserver"
    namespace = "myutils"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
}

resource "kubernetes_cluster_role_binding" "hpa_controller_custom_metrics" {
  metadata {
    name = "hpa-controller-custom-metrics"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "horizontal-pod-autoscaler"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "custom-metrics-server-resources"
  }
}

resource "kubernetes_config_map" "adapter_config" {
  metadata {
    name      = "adapter-config"
    namespace = "myutils"
  }

  data = {
    "config.yaml" = file("${path.module}/configs/adapter_config.yaml")
  }
}

resource "kubernetes_service" "custom_metrics_apiserver" {
  metadata {
    name      = "custom-metrics-apiserver"
    namespace = "myutils"
  }

  spec {
    port {
      port        = 443
      target_port = "6443"
    }

    selector = {
      app = "custom-metrics-apiserver"
    }
  }
}

resource "kubernetes_deployment" "custom_metrics_apiserver" {
  metadata {
    name      = "custom-metrics-apiserver"
    namespace = "myutils"

    labels = {
      app = "custom-metrics-apiserver"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "custom-metrics-apiserver"
      }
    }

    template {
      metadata {
        name = "custom-metrics-apiserver"

        labels = {
          app = "custom-metrics-apiserver"
        }
      }

      spec {
        volume {
          name = "volume-serving-cert"

          secret {
            secret_name = "cm-adapter-serving-certs"
          }
        }

        volume {
          name = "config"

          config_map {
            name = "adapter-config"
          }
        }

        container {
          name = "custom-metrics-apiserver"
          //          image = "quay.io/coreos/k8s-prometheus-adapter-amd64:v0.4.1"
//          image = "directxman12/k8s-prometheus-adapter-amd64"
          image = "directxman12/k8s-prometheus-adapter:v0.7.0"
          args = [
            "/adapter", "--secure-port=6443",
            "--tls-cert-file=/var/run/serving-cert/serving.crt",
            "--tls-private-key-file=/var/run/serving-cert/serving.key",
            "--logtostderr=true", "--prometheus-url=http://prometheus.myutils.svc/",
          "--metrics-relist-interval=30s", "--v=10", "--config=/etc/adapter/config.yaml"]

          image_pull_policy = "IfNotPresent"

          port {
            container_port = 6443
          }

          volume_mount {
            name       = "volume-serving-cert"
            read_only  = true
            mount_path = "/var/run/serving-cert"
          }

          volume_mount {
            name       = "config"
            read_only  = true
            mount_path = "/etc/adapter/"
          }
        }
        container {
          name  = "adapter-config-reload"
          image = "jimmidyson/configmap-reload"
          args  = ["--volume-dir=/etc/adapter/", "--webhook-url=http://127.0.0.1:6443/-/reload"]

          volume_mount {
            name       = "config"
            read_only  = true
            mount_path = "/etc/adapter/"
          }

          image_pull_policy = "IfNotPresent"
        }

        automount_service_account_token = true
        service_account_name            = "custom-metrics-apiserver"
      }
    }
  }
  timeouts {
    create = "2m"
    update = "2m"
  }
}

resource "kubernetes_api_service" "custom_metrics_apiserver" {
  metadata {
    name = "v1beta1.custom.metrics.k8s.io"
  }

  spec {
    service {
      namespace = "myutils"
      name      = "custom-metrics-apiserver"
    }

    group                    = "custom.metrics.k8s.io"
    version                  = "v1beta1"
    insecure_skip_tls_verify = true
    group_priority_minimum   = 100
    version_priority         = 100
  }
}

resource "kubernetes_secret" "cm_adapter_serving_certs" {
  metadata {
    name      = "cm-adapter-serving-certs"
    namespace = "myutils"
  }

  data = {
    "serving.crt" = "-----BEGIN CERTIFICATE-----\nMIIDUjCCAjqgAwIBAgIUamgFjod/OfV2m/pZUH4R9alxtLgwDQYJKoZIhvcNAQEL\nBQAwDTELMAkGA1UEAwwCY2EwHhcNMjAwNTI3MTk1OTAwWhcNMjUwNTI2MTk1OTAw\nWjAjMSEwHwYDVQQDExhjdXN0b20tbWV0cmljcy1hcGlzZXJ2ZXIwggEiMA0GCSqG\nSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDntEiM4IyuPY8FixYoLtLtnjunBV/U5H8W\nakHWM16MehOb158GFkwOFjwW48RF6mAUydcdhvpCeZc8q4BanFOpJQ3q6YBj6+IL\nRVzM+2ErrBe4FW0pGRvrHpqUBAkgiCkzjKBStnCb0unsJBby1o2WJOQq+kB/GCm2\ndRMh9Hjf9THTtqSgqvu+sfMiO+xBEQkLjfgaca9dYUe/SVLLuGjMZYCazLVZUoCg\n/aUlRtC6VMBjETgoTxZLzSQgqlCr0cUuf/meKtu3tECPLpCo/tm96CfLEJLYA64N\nULLETPecYbNw28N/op1Bs4gy13aE7ks5NFPVG3pcogq88VEAij45AgMBAAGjgZMw\ngZAwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFOnFtu3y\n3iv32GESbJi9Rfykd6C6MFEGA1UdEQRKMEiCIGN1c3RvbS1tZXRyaWNzLWFwaXNl\ncnZlci5teXV0aWxzgiRjdXN0b20tbWV0cmljcy1hcGlzZXJ2ZXIubXl1dGlscy5z\ndmMwDQYJKoZIhvcNAQELBQADggEBAEwH412R7URFVMV0IMAmknmDAa2XIIZEm6HQ\nHgnV/3WI6B0OxH6rdhwV5SswdjlGHnrdDEAzv7Wfh+avweLTh2wt81w3veuXDOjM\nE1QyO3SkO6Ug91WJrVDAdYCkZjbpXIY36/wfIzYeSbBBNqHIiwXSgBIVYiuL8aoM\nuaRdi1Wq8P50D/0A9C1AqybqLyTx1e+ouxWG0+zgCJImXyLSV1xjuVynBlRSiwuA\nWGTbCRVsxwgV45Wwb/VUYlhoqya23lRiuWajEQmzYpwKE+i2tI7QYov502QGnv+e\nSAfHfV+kqKdk2at4zY1G+KawpBkHuOzPckbw/tW31+4qmtiWuos=\n-----END CERTIFICATE-----\n"

    "serving.key" = "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEA57RIjOCMrj2PBYsWKC7S7Z47pwVf1OR/FmpB1jNejHoTm9ef\nBhZMDhY8FuPERepgFMnXHYb6QnmXPKuAWpxTqSUN6umAY+viC0VczPthK6wXuBVt\nKRkb6x6alAQJIIgpM4ygUrZwm9Lp7CQW8taNliTkKvpAfxgptnUTIfR43/Ux07ak\noKr7vrHzIjvsQREJC434GnGvXWFHv0lSy7hozGWAmsy1WVKAoP2lJUbQulTAYxE4\nKE8WS80kIKpQq9HFLn/5nirbt7RAjy6QqP7ZvegnyxCS2AOuDVCyxEz3nGGzcNvD\nf6KdQbOIMtd2hO5LOTRT1Rt6XKIKvPFRAIo+OQIDAQABAoIBAH7n4IDAkGzyrH4V\nwun5U2/wJa4CJI3fJLhrNGoUsqlwR4Mo4yGbXsasaPcEg0Dj8QIR1u+GOVXlcO86\n4889JhlTgT7z621PCfywXfarjHo2BLu/iI1lAkSR+4osd69IxIBGep0y7ZR7PcIn\ntiYFW4Er7YiYjnDOFDKqBvOnCflnMHbB6aYYYgt7OQA+NBAEakz20nv006nFKUbS\n5m+mVGC7EAIN1FSu+8lm7fTwRYCZOh4U60so27wSDTaWGVdrtPTplsls1TzE47CM\nO0EYNuwGMeuohhH737y5ecVdyikZFrv3LvCnqmkpdTilZda/ZoWxzrj/G6PAakao\n6HO2lb0CgYEA/sB25M2dcHaWaZB9WKYbsFMKBVq+9Mji87+6/8AiMoL6Gbr0GFDw\nXzTaI3pDPi0MgwH6A/AzeoC2Mqv6kQkIHkRQbs55gewWO7naVInboNUv1VxoB+pu\nsCQhemUHkPHdF1Xz92ngm7FPytjsr07th2jZfT/J5We60Kg/SHfJQ+MCgYEA6Nbp\nDQb+kOjjMu9FWJ2dfHwOrMz0REWJjayU/32xILDhCZhkhkc949QWndje2q9ab2+a\nlAktxGVTbUovat6RKiFj1BPMUaV9ORtsCubn/7Aic8+HKP8DRkunO4S5UcNkcF1c\neAW06ygi4RpPbzzei0dOP1aUmI1Y88ClAKYk6DMCgYA3pPyTT6JDDXQfTNNESMwl\ngI3gy4iIWVTRXyDOej4+AEP22NI2eX93nEjFlRAZBagE+aqNr6re6Dxj5xLNGUbv\nrYZQHcOGsHXOx/K7on0ZrVdMaGnEyN0ylkHFxUmYzGu5jCnE8hiAiYNfUHCqfjf9\n6tYOuJ81/6lbqFRiVN/edwKBgQDA5iNnlo7aUQbBkPdbpiDuG/0wbhBEa3O9Ouiq\nDmDrm36kq2tEz8rXcENYfG6MsE/1GHnxAPW4ytVmKtrD6CZNyCHjdo+EaN0ora5C\nDfDQpQS1+42XikYVO+INbjT2JzGT4dUU3m13kOXsphZ/KueYbffGg51SEXBLaSOK\nORtEfwKBgBJp5K5B+2XiX368Tr/xiHp+R66uYeihbVJz3N/BWIpYkkSGQGydWyS2\nnTbGxlEnkJv5oOriomgZ76JKdKcO2qtuwLdjmHw/jMhMbDMH8LT6gQOyi2H9gNKe\nxrPKY/mbiwWv6FLZ9sAN30qt5tJ+yJ3rbk9DJ/08IJN9ecMHBOax\n-----END RSA PRIVATE KEY-----\n"
  }
}

