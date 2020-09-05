### Driven by user input ###
variable "app_name" {
  default = "kindTHISVER"
}

variable "environment" {
  default = "local"
}

variable "purpose" {
  default = "test"
}
#################################################################
locals {
  cluster_name           = var.app_name
  cluster_endpoint       = "https://192.168.1.99:50THISVER"
//  cluster_ca_certificate = base64decode(data.terraform_remote_state.base.outputs.cluster_certificate_authority_data)
  gitlabauth = "zRf]5-wwg]"
  default_tags = {
    Name        = local.cluster_name,
    Environment = var.environment,
    Purpose     = var.purpose,
    Terraform   = true
    APP         = var.app_name
  }
}
#################################################################

