provider "kubernetes" {
  host             = local.cluster_endpoint
  load_config_file = true
}
data "terraform_remote_state" "main" {
  backend = "local"

  config = {
    path = "..."
  }
}