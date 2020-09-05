//resource "kubernetes_pod" "foo_app" {
//  metadata {
//    name = "foo-app"
//
//    labels = {
//      app = "foo"
//    }
//  }
//
//  spec {
//    container {
//      name  = "foo-app"
//      image = "hashicorp/http-echo:0.2.3"
//      args  = ["-text=foo"]
//    }
//  }
//}
//
//resource "kubernetes_service" "foo_service" {
//  metadata {
//    name = "foo-service"
//  }
//
//  spec {
//    port {
//      port = 5678
//    }
//
//    selector = {
//      app = "foo"
//    }
//  }
//}
//
//resource "kubernetes_pod" "bar_app" {
//  metadata {
//    name = "bar-app"
//
//    labels = {
//      app = "bar"
//    }
//  }
//
//  spec {
//    container {
//      name  = "bar-app"
//      image = "hashicorp/http-echo:0.2.3"
//      args  = ["-text=bar"]
//    }
//  }
//}
//
//resource "kubernetes_service" "bar_service" {
//  metadata {
//    name = "bar-service"
//  }
//
//  spec {
//    port {
//      port = 5678
//    }
//
//    selector = {
//      app = "bar"
//    }
//  }
//}
//
//resource "kubernetes_ingress" "example_ingress" {
//  metadata {
//    name = "example-ingress"
//  }
//
//  spec {
//    rule {
//      http {
//        path {
//          path = "/foo"
//
//          backend {
//            service_name = "foo-service"
//            service_port = "5678"
//          }
//        }
//
//        path {
//          path = "/bar"
//
//          backend {
//            service_name = "bar-service"
//            service_port = "5678"
//          }
//        }
//      }
//    }
//  }
//}
//
