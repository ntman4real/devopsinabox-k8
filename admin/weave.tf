//resource "kubernetes_service_account" "weave_scope" {
//  metadata {
//    name      = "weave-scope"
//    namespace = "myutils"
//
//    labels = {
//      name = "weave-scope"
//    }
//  }
//}
//
//resource "kubernetes_cluster_role" "weave_scope" {
//  metadata {
//    name = "weave-scope"
//
//    labels = {
//      name = "weave-scope"
//    }
//
//  }
//
//  rule {
//    verbs      = ["get", "list", "watch", "delete"]
//    api_groups = [""]
//    resources  = ["pods"]
//  }
//
//  rule {
//    verbs      = ["get", "list", "watch"]
//    api_groups = [""]
//    resources  = ["pods/log", "services", "nodes", "namespaces", "persistentvolumes", "persistentvolumeclaims"]
//  }
//
//  rule {
//    verbs      = ["get", "list", "watch"]
//    api_groups = ["apps"]
//    resources  = ["deployments", "daemonsets", "statefulsets"]
//  }
//
//  rule {
//    verbs      = ["get", "list", "watch"]
//    api_groups = ["batch"]
//    resources  = ["cronjobs", "jobs"]
//  }
//
//  rule {
//    verbs      = ["get", "list", "watch"]
//    api_groups = ["extensions"]
//    resources  = ["deployments", "daemonsets"]
//  }
//
//  rule {
//    verbs      = ["get", "update"]
//    api_groups = ["apps"]
//    resources  = ["deployments/scale"]
//  }
//
//  rule {
//    verbs      = ["get", "update"]
//    api_groups = ["extensions"]
//    resources  = ["deployments/scale"]
//  }
//
//  rule {
//    verbs      = ["get", "list", "watch"]
//    api_groups = ["storage.k8s.io"]
//    resources  = ["storageclasses"]
//  }
//
//  rule {
//    verbs      = ["list", "watch"]
//    api_groups = ["volumesnapshot.external-storage.k8s.io"]
//    resources  = ["volumesnapshots", "volumesnapshotdatas"]
//  }
//}
//
//resource "kubernetes_cluster_role_binding" "weave_scope" {
//  metadata {
//    name = "weave-scope"
//
//    labels = {
//      name = "weave-scope"
//    }
//  }
//
//  subject {
//    kind      = "ServiceAccount"
//    name      = "weave-scope"
//    namespace = "myutils"
//  }
//
//  role_ref {
//    api_group = "rbac.authorization.k8s.io"
//    kind      = "ClusterRole"
//    name      = "weave-scope"
//  }
//}
//
//resource "kubernetes_deployment" "weave_scope_app" {
//  metadata {
//    name      = "weave-scope-app"
//    namespace = "myutils"
//
//    labels = {
//      app = "weave-scope"
//
//      name = "weave-scope-app"
//
//      weave-cloud-component = "scope"
//
//      weave-scope-component = "app"
//    }
//  }
//
//  spec {
//    replicas = 1
//
//    selector {
//      match_labels = {
//        app = "weave-scope"
//
//        name = "weave-scope-app"
//
//        weave-cloud-component = "scope"
//
//        weave-scope-component = "app"
//      }
//    }
//
//    template {
//      metadata {
//        labels = {
//          app = "weave-scope"
//
//          name = "weave-scope-app"
//
//          weave-cloud-component = "scope"
//
//          weave-scope-component = "app"
//        }
//      }
//
//      spec {
//        container {
//          name    = "app"
//          image   = "docker.io/weaveworks/scope:1.13.1"
//          command = ["/home/weave/scope"]
//          args    = ["--mode=app"]
//
//          port {
//            container_port = 4040
//            protocol       = "TCP"
//          }
//
//          image_pull_policy = "IfNotPresent"
//        }
//      }
//    }
//
//    revision_history_limit = 2
//  }
//}
//
//resource "kubernetes_service" "weave_scope_app" {
//  metadata {
//    name      = "weave-scope-app"
//    namespace = "myutils"
//
//    labels = {
//      app = "weave-scope"
//
//      name = "weave-scope-app"
//
//      weave-cloud-component = "scope"
//
//      weave-scope-component = "app"
//    }
//
//  }
//
//  spec {
//    port {
//      name        = "app"
//      protocol    = "TCP"
//      port        = 80
//      target_port = "4040"
//    }
//
//    selector = {
//      app = "weave-scope"
//
//      name = "weave-scope-app"
//
//      weave-cloud-component = "scope"
//
//      weave-scope-component = "app"
//    }
//  }
//}
//
//resource "kubernetes_deployment" "weave_scope_cluster_agent" {
//  metadata {
//    name      = "weave-scope-cluster-agent"
//    namespace = "myutils"
//
//    labels = {
//      app = "weave-scope"
//
//      name = "weave-scope-cluster-agent"
//
//      weave-cloud-component = "scope"
//
//      weave-scope-component = "cluster-agent"
//    }
//  }
//
//  spec {
//    replicas = 1
//
//    selector {
//      match_labels = {
//        app = "weave-scope"
//
//        name = "weave-scope-cluster-agent"
//
//        weave-cloud-component = "scope"
//
//        weave-scope-component = "cluster-agent"
//      }
//    }
//
//    template {
//      metadata {
//        labels = {
//          app = "weave-scope"
//
//          name = "weave-scope-cluster-agent"
//
//          weave-cloud-component = "scope"
//
//          weave-scope-component = "cluster-agent"
//        }
//      }
//
//      spec {
//        container {
//          name    = "scope-cluster-agent"
//          image   = "docker.io/weaveworks/scope:1.13.1"
//          command = ["/home/weave/scope"]
//          args    = ["--mode=probe", "--probe-only", "--probe.kubernetes.role=cluster", "--probe.http.listen=:4041", "--probe.publish.interval=4500ms", "--probe.spy.interval=2s", "weave-scope-app.myutils.svc.cluster.local:80"]
//
//          port {
//            container_port = 4041
//            protocol       = "TCP"
//          }
//
//          resources {
//            requests {
//              cpu    = "25m"
//              memory = "80Mi"
//            }
//          }
//
//          image_pull_policy = "IfNotPresent"
//        }
//
//        service_account_name = "weave-scope"
//      }
//    }
//
//    revision_history_limit = 2
//  }
//}
//
//resource "kubernetes_daemonset" "weave_scope_agent" {
//  metadata {
//    name      = "weave-scope-agent"
//    namespace = "myutils"
//
//    labels = {
//      app = "weave-scope"
//
//      name = "weave-scope-agent"
//
//      weave-cloud-component = "scope"
//
//      weave-scope-component = "agent"
//    }
//  }
//
//  spec {
//    selector {
//      match_labels = {
//        app = "weave-scope"
//
//        name = "weave-scope-agent"
//
//        weave-cloud-component = "scope"
//
//        weave-scope-component = "agent"
//      }
//    }
//
//    template {
//      metadata {
//        labels = {
//          app = "weave-scope"
//
//          name = "weave-scope-agent"
//
//          weave-cloud-component = "scope"
//
//          weave-scope-component = "agent"
//        }
//      }
//
//      spec {
//        volume {
//          name = "scope-plugins"
//
//          host_path {
//            path = "/var/run/scope/plugins"
//          }
//        }
//
//        volume {
//          name = "sys-kernel-debug"
//
//          host_path {
//            path = "/sys/kernel/debug"
//          }
//        }
//
//        volume {
//          name = "docker-socket"
//
//          host_path {
//            path = "/var/run/docker.sock"
//          }
//        }
//
//        container {
//          name    = "scope-agent"
//          image   = "docker.io/weaveworks/scope:1.13.1"
//          command = ["/home/weave/scope"]
//          args    = ["--mode=probe", "--probe-only", "--probe.kubernetes.role=host", "--probe.publish.interval=4500ms", "--probe.spy.interval=2s", "--probe.docker.bridge=docker0", "--probe.docker=true", "weave-scope-app.myutils.svc.cluster.local:80"]
//
//          resources {
//            requests {
//              cpu    = "100m"
//              memory = "100Mi"
//            }
//          }
//
//          volume_mount {
//            name       = "scope-plugins"
//            mount_path = "/var/run/scope/plugins"
//          }
//
//          volume_mount {
//            name       = "sys-kernel-debug"
//            mount_path = "/sys/kernel/debug"
//          }
//
//          volume_mount {
//            name       = "docker-socket"
//            mount_path = "/var/run/docker.sock"
//          }
//
//          image_pull_policy = "IfNotPresent"
//
//          security_context {
//            privileged = true
//          }
//        }
//
//        dns_policy   = "ClusterFirstWithHostNet"
//        host_network = true
//        host_pid     = true
//
//        toleration {
//          operator = "Exists"
//          effect   = "NoSchedule"
//        }
//
//        toleration {
//          operator = "Exists"
//          effect   = "NoExecute"
//        }
//      }
//    }
//
//    strategy {
//      type = "RollingUpdate"
//    }
//
//    min_ready_seconds = 5
//  }
//}
//
