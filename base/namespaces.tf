############# NAMESPACES ###########################
resource "kubernetes_namespace" "myutils" {
  metadata {
    name = "myutils"
  }
}

resource "kubernetes_namespace" "myapps" {
  metadata {
    name = "myapps"
  }
}
######################################################################################