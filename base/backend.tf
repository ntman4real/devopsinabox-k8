provider "kubernetes" {
  host             = local.cluster_endpoint
  load_config_file = true
//  config_path      = "../configs/kube_config.yaml"
}
data "terraform_remote_state" "main" {
  backend = "local"
  config = {
    path = "../remotestate.tf"
  }
}