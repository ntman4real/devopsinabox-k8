### Driven by user input ###

variable "environment" {
  default = "local"
}

variable "purpose" {
  default = "test"
}
#################################################################
locals {
  cluster_endpoint       = "https://192.168.1.99:50THISVER"
  cluster_name           = "kindTHISVER"
  tld                    = "ntman4real.com"
  eks_zone               = "${local.cluster_name}.${local.tld}"
  as_version             = "1.18.2"
//  cluster_ca_certificate = base64decode(data.terraform_remote_state.base.outputs.cluster_certificate_authority_data)
  gitlabauth = "zRf]5-wwg]"
  default_tags = {
    Name        = local.cluster_name,
    Environment = var.environment,
    Purpose     = var.purpose,
    Terraform   = true
    APP         = local.cluster_name
  }
}
#################################################################

