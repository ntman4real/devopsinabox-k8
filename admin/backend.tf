provider "kubernetes" {
  host             = local.cluster_endpoint
  load_config_file = true
  config_path      = "../conf/kubeconfig"
}
data "terraform_remote_state" "base" {
  backend = "local"
  config = {
    path = "../base/terraform.tfstate"
  }
}