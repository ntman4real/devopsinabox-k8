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
resource "kubernetes_secret" "myapps" {
  metadata {
    name      = "glcreds"
    namespace = kubernetes_namespace.myapps.metadata[0].name
  }

  data = {
    ".dockerconfigjson" = "{\"auths\":{\"reg.gitlab.chewysb.com\":{\"username\":\"gldeploy2\",\"password\":\"${local.gitlabauth}\",\"auth\":\"Z2xkZXBsb3kyOnpSZl01LXd3Z10=\"}}}"
  }

  type = "kubernetes.io/dockerconfigjson"
}
resource "kubernetes_secret" "myutils" {
  metadata {
    name      = "glcreds"
    namespace = kubernetes_namespace.myutils.metadata[0].name
  }

  data = {
    ".dockerconfigjson" = "{\"auths\":{\"reg.gitlab.chewysb.com\":{\"username\":\"gldeploy2\",\"password\":\"${local.gitlabauth}\",\"auth\":\"Z2xkZXBsb3kyOnpSZl01LXd3Z10=\"}}}"
  }

  type = "kubernetes.io/dockerconfigjson"
}
########################################
resource "kubernetes_secret" "regcreds" {
  depends_on = [
  kubernetes_namespace.myapps]
  metadata {
    name      = "basic-auth"
    namespace = kubernetes_namespace.myapps.metadata[0].name
  }

  data = {
    username = "gldeploy2"
    password = local.gitlabauth
  }

  type = "kubernetes.io/basic-auth"
}
########################################
//resource "null_resource" "token" {
//  provisioner "local-exec" {
//    command = "kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}') |grep token | awk '{print $2}' |tee ../configs/token.txt"
//  }
//}