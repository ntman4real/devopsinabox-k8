##### SERVICE ACCOUNTS #####
resource "kubernetes_service_account" "prometheus_kube_state_metrics" {
  metadata {
    name      = "prometheus-kube-state-metrics"
    namespace = "myutils"

    labels = {
      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "kube-state-metrics"

      "helm.sh/chart" = "kube-state-metrics-2.7.2"
    }
  }
}

resource "kubernetes_service_account" "prometheus_alertmanager" {
  metadata {
    name      = "prometheus-alertmanager"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "alertmanager"

      heritage = "Helm"

      release = "prometheus"
    }
  }
}

resource "kubernetes_service_account" "prometheus_node_exporter" {
  metadata {
    name      = "prometheus-node-exporter"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "node-exporter"

      heritage = "Helm"

      release = "prometheus"
    }
  }
}

resource "kubernetes_service_account" "prometheus_pushgateway" {
  metadata {
    name      = "prometheus-pushgateway"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "pushgateway"

      heritage = "Helm"

      release = "prometheus"
    }
  }
}

resource "kubernetes_service_account" "prometheus_server" {
  metadata {
    name      = "prometheus"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "server"

      heritage = "Helm"

      release = "prometheus"
    }
  }
}
##### CONFIG MAPS #####
resource "kubernetes_config_map" "prometheus_alertmanager" {
  metadata {
    name      = "prometheus-alertmanager"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "alertmanager"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  data = {
    "alertmanager.yml" = "global: {}\nreceivers:\n- name: default-receiver\nroute:\n  group_interval: 5m\n  group_wait: 10s\n  receiver: default-receiver\n  repeat_interval: 3h\n"
  }
}

resource "kubernetes_config_map" "prometheus_server" {
  metadata {
    name      = "prometheus"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "server"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  data = {
    "alerting_rules.yml" = "{}\n"

    alerts = "{}\n"

    "prometheus.yml" = file("${path.module}/configs/prometheus-config.yaml")

    "recording_rules.yml" = "{}\n"

    rules = "{}\n"
  }
}

##### PVC's #####
resource "kubernetes_persistent_volume_claim" "prometheus_alertmanager" {
  metadata {
    name      = "prometheus-alertmanager"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "alertmanager"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "prometheus_server" {
  metadata {
    name      = "prometheus"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "server"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "20Gi"
      }
    }
  }
}

##### RBAC #####
resource "kubernetes_cluster_role" "prometheus_kube_state_metrics" {
  metadata {
    name = "prometheus-kube-state-metrics"

    labels = {
      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "kube-state-metrics"

      "helm.sh/chart" = "kube-state-metrics-2.7.2"
    }
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["batch"]
    resources  = ["cronjobs"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["extensions", "apps"]
    resources  = ["daemonsets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["extensions", "apps"]
    resources  = ["deployments"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["endpoints"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["batch"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["limitranges"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["namespaces"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["nodes"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["persistentvolumes"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["extensions", "apps"]
    resources  = ["replicasets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["replicationcontrollers"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["resourcequotas"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["secrets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["services"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["apps"]
    resources  = ["statefulsets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
  }
}

//resource "kubernetes_cluster_role" "prometheus_alertmanager" {
//  metadata {
//    name = "prometheus-alertmanager"
//
//    labels = {
//      app = "prometheus"
//
//      chart = "prometheus-11.3.0"
//
//      component = "alertmanager"
//
//      heritage = "Helm"
//
//      release = "prometheus"
//    }
//  }
//  rule {
//    verbs = []
//  }
//}
//
//resource "kubernetes_cluster_role" "prometheus_pushgateway" {
//  metadata {
//    name = "prometheus-pushgateway"
//
//    labels = {
//      app = "prometheus"
//
//      chart = "prometheus-11.3.0"
//
//      component = "pushgateway"
//
//      heritage = "Helm"
//
//      release = "prometheus"
//    }
//  }
//  rule {
//    verbs = []
//  }
//}

resource "kubernetes_cluster_role" "prometheus_server" {
  metadata {
    name = "prometheus"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "server"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "nodes/metrics", "services", "endpoints", "pods", "ingresses", "configmaps"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["extensions"]
    resources  = ["ingresses/status", "ingresses"]
  }

  rule {
    verbs             = ["get"]
    non_resource_urls = ["/metrics"]
  }
}

resource "kubernetes_cluster_role_binding" "prometheus_kube_state_metrics" {
  metadata {
    name = "prometheus-kube-state-metrics"

    labels = {
      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "kube-state-metrics"

      "helm.sh/chart" = "kube-state-metrics-2.7.2"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "prometheus-kube-state-metrics"
    namespace = "myutils"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "prometheus-kube-state-metrics"
  }
}

resource "kubernetes_cluster_role_binding" "prometheus_alertmanager" {
  metadata {
    name = "prometheus-alertmanager"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "alertmanager"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "prometheus-alertmanager"
    namespace = "myutils"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "prometheus-alertmanager"
  }
}

resource "kubernetes_cluster_role_binding" "prometheus_pushgateway" {
  metadata {
    name = "prometheus-pushgateway"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "pushgateway"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "prometheus-pushgateway"
    namespace = "myutils"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "prometheus-pushgateway"
  }
}

resource "kubernetes_cluster_role_binding" "prometheus_server" {
  metadata {
    name = "prometheus"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "server"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "prometheus"
    namespace = "myutils"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "prometheus"
  }
}

##### SERVICES #####
resource "kubernetes_service" "prometheus_kube_state_metrics" {
  metadata {
    name      = "prometheus-kube-state-metrics"
    namespace = "myutils"

    labels = {
      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "kube-state-metrics"

      "helm.sh/chart" = "kube-state-metrics-2.7.2"
    }

    annotations = {
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8080
      target_port = "8080"
    }

    selector = {
      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/name" = "kube-state-metrics"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "prometheus_alertmanager" {
  metadata {
    name      = "prometheus-alertmanager"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "alertmanager"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = "9093"
    }

    selector = {
      app = "prometheus"

      component = "alertmanager"

      release = "prometheus"
    }

    type             = "ClusterIP"
    session_affinity = "None"
  }
}

resource "kubernetes_service" "prometheus_node_exporter" {
  metadata {
    name      = "prometheus-node-exporter"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "node-exporter"

      heritage = "Helm"

      release = "prometheus"
    }

    annotations = {
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      name        = "metrics"
      protocol    = "TCP"
      port        = 9100
      target_port = "9100"
    }

    selector = {
      app = "prometheus"

      component = "node-exporter"

      release = "prometheus"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "prometheus_pushgateway" {
  metadata {
    name      = "prometheus-pushgateway"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "pushgateway"

      heritage = "Helm"

      release = "prometheus"
    }

    annotations = {
      "prometheus.io/probe" = "pushgateway"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 9091
      target_port = "9091"
    }

    selector = {
      app = "prometheus"

      component = "pushgateway"

      release = "prometheus"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "prometheus_server" {
  metadata {
    name      = "prometheus"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "server"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = "9090"
    }

    selector = {
      app = "prometheus"

      component = "server"

      release = "prometheus"
    }

    type             = "ClusterIP"
    session_affinity = "None"
  }
}

##### DEPLOYS #####
resource "kubernetes_daemonset" "prometheus_node_exporter" {
  metadata {
    name      = "prometheus-node-exporter"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "node-exporter"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "prometheus"

        component = "node-exporter"

        release = "prometheus"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus"

          chart = "prometheus-11.3.0"

          component = "node-exporter"

          heritage = "Helm"

          release = "prometheus"
        }
      }

      spec {
        volume {
          name = "proc"

          host_path {
            path = "/proc"
          }
        }

        volume {
          name = "sys"

          host_path {
            path = "/sys"
          }
        }

        container {
          name  = "prometheus-node-exporter"
          image = "prom/node-exporter" #:v0.18.1"
          args  = ["--path.procfs=/host/proc", "--path.sysfs=/host/sys"]

          port {
            name           = "metrics"
            host_port      = 9100
            container_port = 9100
          }

          volume_mount {
            name       = "proc"
            read_only  = true
            mount_path = "/host/proc"
          }

          volume_mount {
            name       = "sys"
            read_only  = true
            mount_path = "/host/sys"
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = "prometheus-node-exporter"
        host_network         = true
        host_pid             = true
      }
    }

    strategy {
      type = "RollingUpdate"
    }
  }
  depends_on = [kubernetes_service_account.prometheus_node_exporter]

}

resource "kubernetes_deployment" "prometheus_kube_state_metrics" {
  metadata {
    name      = "prometheus-kube-state-metrics"
    namespace = "myutils"

    labels = {
      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "kube-state-metrics"

      "helm.sh/chart" = "kube-state-metrics-2.7.2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "kube-state-metrics"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/instance" = "prometheus"

          "app.kubernetes.io/name" = "kube-state-metrics"
        }
      }

      spec {
        automount_service_account_token = true

        container {
          name  = "kube-state-metrics"
          image = "quay.io/coreos/kube-state-metrics" #:v1.9.5"
          args  = ["--collectors=certificatesigningrequests", "--collectors=configmaps", "--collectors=cronjobs", "--collectors=daemonsets", "--collectors=deployments", "--collectors=endpoints", "--collectors=horizontalpodautoscalers", "--collectors=ingresses", "--collectors=jobs", "--collectors=limitranges", "--collectors=namespaces", "--collectors=nodes", "--collectors=persistentvolumeclaims", "--collectors=persistentvolumes", "--collectors=poddisruptionbudgets", "--collectors=pods", "--collectors=replicasets", "--collectors=replicationcontrollers", "--collectors=resourcequotas", "--collectors=secrets", "--collectors=services", "--collectors=statefulsets", "--collectors=storageclasses"]

          port {
            container_port = 8080
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "8080"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "8080"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = "prometheus-kube-state-metrics"

        security_context {
          run_as_user = 65534
          fs_group    = 65534
        }
      }
    }
  }
  depends_on = [kubernetes_service_account.prometheus_kube_state_metrics]

}

resource "kubernetes_deployment" "prometheus_alertmanager" {
  metadata {
    name      = "prometheus-alertmanager"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "alertmanager"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prometheus"

        component = "alertmanager"

        release = "prometheus"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus"

          chart = "prometheus-11.3.0"

          component = "alertmanager"

          heritage = "Helm"

          release = "prometheus"
        }
      }

      spec {
        volume {
          name = "config-volume"

          config_map {
            name = "prometheus-alertmanager"
          }
        }

        volume {
          name = "storage-volume"

          persistent_volume_claim {
            claim_name = "prometheus-alertmanager"
          }
        }

        automount_service_account_token = true
        container {
          name  = "prometheus-alertmanager"
          image = "prom/alertmanager" #:v0.20.0"
          args  = ["--config.file=/etc/config/alertmanager.yml", "--storage.path=/data", "--cluster.advertise-address=$(POD_IP):6783", "--web.external-url=http://localhost:9093"]

          port {
            container_port = 9093
          }

          env {
            name = "POD_IP"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "status.podIP"
              }
            }
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/config"
          }

          volume_mount {
            name       = "storage-volume"
            mount_path = "/data"
          }

          readiness_probe {
            http_get {
              path = "/-/ready"
              port = "9093"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 30
          }

          image_pull_policy = "IfNotPresent"
        }

        container {
          name  = "prometheus-alertmanager-configmap-reload"
          image = "jimmidyson/configmap-reload" #:v0.3.0"
          args  = ["--volume-dir=/etc/config", "--webhook-url=http://127.0.0.1:9093/-/reload"]

          volume_mount {
            name       = "config-volume"
            read_only  = true
            mount_path = "/etc/config"
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = "prometheus-alertmanager"

        security_context {
          run_as_user     = 65534
          run_as_group    = 65534
          run_as_non_root = true
          fs_group        = 65534
        }
      }
    }
  }
  depends_on = [kubernetes_service_account.prometheus_alertmanager]

}

resource "kubernetes_deployment" "prometheus_pushgateway" {
  metadata {
    name      = "prometheus-pushgateway"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "pushgateway"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prometheus"

        component = "pushgateway"

        release = "prometheus"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus"

          chart = "prometheus-11.3.0"

          component = "pushgateway"

          heritage = "Helm"

          release = "prometheus"
        }
      }

      spec {
        automount_service_account_token = true
        container {
          name  = "prometheus-pushgateway"
          image = "prom/pushgateway" #:v1.0.1"

          port {
            container_port = 9091
          }

          liveness_probe {
            http_get {
              path = "/-/healthy"
              port = "9091"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 10
          }

          readiness_probe {
            http_get {
              path = "/-/ready"
              port = "9091"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 10
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = "prometheus-pushgateway"

        security_context {
          run_as_user     = 65534
          run_as_non_root = true
        }
      }
    }
  }
  depends_on = [kubernetes_service_account.prometheus_pushgateway]
}

resource "kubernetes_deployment" "prometheus_server" {
  metadata {
    name      = "prometheus"
    namespace = "myutils"

    labels = {
      app = "prometheus"

      chart = "prometheus-11.3.0"

      component = "server"

      heritage = "Helm"

      release = "prometheus"
    }
  }

  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "prometheus"

        component = "server"

        release = "prometheus"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus"

          chart = "prometheus-11.3.0"

          component = "server"

          heritage = "Helm"

          release = "prometheus"
        }
      }

      spec {
        automount_service_account_token = true
        volume {
          name = "config-volume"

          config_map {
            name = "prometheus"
          }
        }

        volume {
          name = "storage-volume"

          persistent_volume_claim {
            claim_name = "prometheus"
          }
        }

        container {
          name  = "prometheus-configmap-reload"
          image = "jimmidyson/configmap-reload" #:v0.3.0"
          args  = ["--volume-dir=/etc/config", "--webhook-url=http://127.0.0.1:9090/-/reload"]

          volume_mount {
            name       = "config-volume"
            read_only  = true
            mount_path = "/etc/config"
          }

          image_pull_policy = "IfNotPresent"
        }

        container {
          name = "prometheus"
          //          image = "prom/prometheus:v2.18.1"
          image = "prom/prometheus"
          args  = ["--storage.tsdb.retention.time=2d", "--config.file=/etc/config/prometheus.yml", "--storage.tsdb.path=/data", "--web.console.libraries=/etc/prometheus/console_libraries", "--web.console.templates=/etc/prometheus/consoles", "--web.enable-lifecycle"]

          port {
            container_port = 9090
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/config"
          }

          volume_mount {
            name       = "storage-volume"
            mount_path = "/data"
          }

          liveness_probe {
            http_get {
              path = "/-/healthy"
              port = "9090"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 30
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/-/ready"
              port = "9090"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 30
            success_threshold     = 1
            failure_threshold     = 3
          }

          image_pull_policy = "IfNotPresent"
        }

        termination_grace_period_seconds = 300
        service_account_name             = "prometheus"

        security_context {
          run_as_user     = 65534
          run_as_group    = 65534
          run_as_non_root = true
          fs_group        = 65534
        }
      }
    }
  }
  timeouts {
    create = "3m"
    update = "3m"
  }
  depends_on = [kubernetes_service_account.prometheus_server]

}

