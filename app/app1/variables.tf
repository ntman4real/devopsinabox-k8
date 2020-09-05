### Driven by user input ###
variable "app_name" {
  default = "app1"
}
variable "image" {
  default = "reg.gitlab.chewysb.com/bizunits/corp/app1:latest"
}
variable "enable_hpa" {
  default = true
}
variable "hpa_req" {
  default = 10
}
variable "container_port" {
  default = 8080
}
########################################
//data "aws_region" "current" {}
//data "aws_caller_identity" "current" {}
//data "aws_eks_cluster" "cluster" {
//  name = local.cluster_name
//}
//data "aws_eks_cluster_auth" "cluster" {
//  name = local.cluster_name
//}
data "kubernetes_secret" "glcreds" {
  metadata {
    name      = "glcreds"
    namespace = local.namespace
  }
}
//data "aws_acm_certificate" "main" {
//  domain = local.eks_zone
//  types = [
//  "AMAZON_ISSUED"]
//  most_recent = true
//}
########################################
locals {
  cluster_endpoint       = "https://192.168.1.99:50THISVER"
  cluster_name           = "kindTHISVER"
  tld                    = "ntman4real.com"
  eks_zone               = "${local.cluster_name}.${local.tld}"
  fqdn                   = "${var.app_name}.${local.eks_zone}"
  wildcardcert           = "wildcard"
//  env                    = substr(terraform.workspace, 1, 3)
//  region                 = substr(terraform.workspace, 5, 4)

//  thisregion             = local.region == "west" ? "us-west-2" : "us-east-1"
//  cluster_endpoint       = data.aws_eks_cluster.cluster.endpoint
//  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
//  token                  = data.aws_eks_cluster_auth.cluster.token
//  certarn                = data.aws_acm_certificate.main.arn
  container_port         = var.container_port
  target_port            = 80
  namespace              = "myapps"
  timestamp              = timestamp()
}
