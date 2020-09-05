provider "acme" {
//  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory" #STAGING
  server_url = "https://acme-v02.api.letsencrypt.org/directory"           #PRODUCTION
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "ntman4real@gmail.com"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = local.eks_zone
  subject_alternative_names = ["*.${local.eks_zone}"]

  dns_challenge {
    provider = "route53"
  }
}
####################################################################################
resource "local_file" "pkpem" {
  filename = "./configs/key.pem"
  content = acme_certificate.certificate.private_key_pem
}
resource "local_file" "certpem" {
  filename = "./configs/certificate.pem"
  content = acme_certificate.certificate.certificate_pem
}
resource "local_file" "issuer_pem" {
  filename = "./configs/intermed.pem"
  content = acme_certificate.certificate.issuer_pem
}
resource "local_file" "certificate_p12" {
  filename = "./configs/p12.pem"
  content = acme_certificate.certificate.certificate_p12
}
####################################################################################
resource "kubernetes_secret" "wildcard-myapps" {
  metadata {
    name = "wildcard"
    namespace = "myapps"
    }
  data = {
    "tls.crt" = file("${path.module}/configs/certificate.pem")
    "tls.key" = file("${path.module}/configs/key.pem")
}
  type = "kubernetes.io/tls"
}
resource "kubernetes_secret" "wildcard-myutils" {
  metadata {
    name = "wildcard"
    namespace = "myutils"
    }
  data = {
    "tls.crt" = file("${path.module}/configs/certificate.pem")
    "tls.key" = file("${path.module}/configs/key.pem")
}
  type = "kubernetes.io/tls"
}
####################################################################################
output "id" {
  value = acme_certificate.certificate.id
}
output "certificate_url" {
  value = acme_certificate.certificate.certificate_url
}
output "certificate_domain" {
  value = acme_certificate.certificate.certificate_domain
}
output "private_key_pem" {
  value = acme_certificate.certificate.private_key_pem
}
output "certificate_pem" {
  value = acme_certificate.certificate.certificate_pem
}
output "issuer_pem" {
  value = acme_certificate.certificate.issuer_pem
}
output "certificate_p12" {
  value = acme_certificate.certificate.certificate_p12
}
//id - The full URL of the certificate within the ACME CA.
//certificate_url - The full URL of the certificate within the ACME CA. Same as id.
//certificate_domain - The common name of the certificate.
//private_key_pem - The certificate's private key, in PEM format, if the certificate was generated from scratch and not with certificate_request_pem. If certificate_request_pem was used, this will be blank.
//certificate_pem - The certificate in PEM format. This does not include the issuer_pem. This certificate can be concatenated with issuer_pem to form a full chain.
//issuer_pem - The intermediate certificate of the issuer.
//certificate_p12 - The certificate, intermediate, and the private key archived as a PFX file (PKCS12 format, generally used by Microsoft products). The data is base64 encoded (including padding), and its password is configurable via the certificate_p12_password argument. This field is empty if creating a certificate from a CSR.