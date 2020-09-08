#################################################################
locals {
  domain_name      = data.terraform_remote_state.main.outputs.domain_name
  cluster_name     = data.terraform_remote_state.main.outputs.domain_name
  email_addy       = data.terraform_remote_state.main.outputs.domain_name
  cluster_ver      = data.terraform_remote_state.main.outputs.domain_name
  environment      = data.terraform_remote_state.main.outputs.domain_name
  local_ip         = data.terraform_remote_state.main.outputs.domain_name
  cluster_fqdn     = data.terraform_remote_state.main.outputs.domain_name
  cluster_endpoint = data.terraform_remote_state.main.outputs.domain_name
}
#################################################################

