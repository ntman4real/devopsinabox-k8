locals {
  domain_name      = "domainvar"
  cluster_name     = "clustername"
  email_addy       = "emailaddy"
  cluster_ver      = "clustervar"
  environment      = "thisenv"
  local_ip         = "LOCAL_IP_ADDY"
  cluster_fqdn     = "thiscluster_fqdn"
  cluster_endpoint = "https://${local.local_ip}:50${local.cluster_ver}"
}
