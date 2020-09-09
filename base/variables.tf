locals {
  domain_name      = "domainvar"
  cluster_name     = "clustername"
  email_addy       = "email"
  cluster_ver      = "clusterver"
  environment      = "thisenv"
  local_ip         = "LOCAL_IP_ADDY"
  cluster_fqdn     = "thiscluster_fqdn"
  cluster_endpoint = "https://LOCAL_IP_ADDY:5000"
}


//#################################################################
//locals {
//  domain_name      = data.terraform_remote_state.main.outputs.domain_name
//  cluster_name     = data.terraform_remote_state.main.outputs.domain_name
//  email_addy       = data.terraform_remote_state.main.outputs.domain_name
//  cluster_ver      = data.terraform_remote_state.main.outputs.domain_name
//  environment      = data.terraform_remote_state.main.outputs.domain_name
//  local_ip         = data.terraform_remote_state.main.outputs.domain_name
//  cluster_fqdn     = data.terraform_remote_state.main.outputs.domain_name
//  cluster_endpoint = data.terraform_remote_state.main.outputs.domain_name
//}
//#################################################################
//
