provider "kubernetes" {
  host                   = local.cluster_endpoint
//  cluster_ca_certificate = local.cluster_ca_certificate
//  token                  = local.token
  load_config_file       = true
}
