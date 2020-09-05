//terraform {
//  backend "remote" {
//    hostname     = "app.terraform.io"
//    organization = "chewyinc-corp"  #Vertical ORG
//    workspaces {
//      prefix = "app1"               #APP Name
//    }
//  }
//}
//variable "image" {}
//module "main" {
//  source         = "app.terraform.io/chewycorp-devops/eksdeploy/aws"
//  image          = var.image
//  eks_ver        = "00"
//  vertical       = "corp"
//  app_name       = "app1"
//  hpa_req        = 10
//}