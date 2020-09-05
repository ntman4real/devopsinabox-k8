//output "caller" {
//  value = data.aws_caller_identity.current.user_id
//}
output "cluster_name" {
  value = local.cluster_name
}
output "cluster_endpoint" {
  value = local.cluster_endpoint
}
//output "cluster_ca_certificate" {
//  value = local.cluster_ca_certificate
//}
output "eks_zone" {
  value = local.eks_zone
}
//output "token" {
//  value = local.token
//}
output "app_name" {
  value = var.app_name
}
output "image" {
  value = var.image
}
output "fqdn" {
  value = local.fqdn
}
